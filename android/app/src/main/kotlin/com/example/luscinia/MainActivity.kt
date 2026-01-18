package com.example.luscinia

import android.Manifest
import android.content.pm.PackageManager
import android.media.AudioFormat
import android.media.AudioRecord
import android.media.MediaRecorder
import android.os.Handler
import android.os.Looper
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import be.tarsos.dsp.AudioEvent
import be.tarsos.dsp.pitch.PitchDetectionHandler
import be.tarsos.dsp.pitch.PitchDetectionResult
import be.tarsos.dsp.pitch.PitchProcessor
import be.tarsos.dsp.pitch.PitchProcessor.PitchEstimationAlgorithm
import be.tarsos.dsp.io.TarsosDSPAudioFormat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import kotlin.concurrent.thread

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.luscinia/pitch_detector"
    private val EVENT_CHANNEL = "com.example.luscinia/pitch_stream"
    private val PERMISSION_REQUEST_CODE = 200
    
    private var audioRecord: AudioRecord? = null
    private var isRecording = false
    private var recordingThread: Thread? = null
    private var pitchStreamSink: EventChannel.EventSink? = null
    private val mainHandler = Handler(Looper.getMainLooper())
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // MethodChannel - Komutlar için (start/stop)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startPitchDetection" -> {
                    if (checkPermission()) {
                        val algorithm = call.argument<String>("algorithm") ?: "YIN"
                        val sampleRate = call.argument<Int>("sampleRate") ?: 22050
                        val bufferSize = call.argument<Int>("bufferSize") ?: 1024
                        
                        startPitchDetection(algorithm, sampleRate, bufferSize)
                        result.success("Pitch detection started")
                    } else {
                        requestPermission()
                        result.error("PERMISSION_DENIED", "Microphone permission required", null)
                    }
                }
                "stopPitchDetection" -> {
                    stopPitchDetection()
                    result.success("Pitch detection stopped")
                }
                "checkPermission" -> {
                    result.success(checkPermission())
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
        
        // EventChannel - Gerçek zamanlı pitch verisi için
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    pitchStreamSink = events
                }
                
                override fun onCancel(arguments: Any?) {
                    pitchStreamSink = null
                }
            }
        )
    }
    
    private fun startPitchDetection(algorithmName: String, sampleRate: Int, bufferSize: Int) {
        // Önceki kaydı durdur
        stopPitchDetection()
        
        try {
            // Algorithm seçimi
            val algorithm = when (algorithmName) {
                "YIN" -> PitchEstimationAlgorithm.YIN
                "MPM" -> PitchEstimationAlgorithm.MPM
                "FFT_YIN" -> PitchEstimationAlgorithm.FFT_YIN
                "DYNAMIC_WAVELET" -> PitchEstimationAlgorithm.DYNAMIC_WAVELET
                "AMDF" -> PitchEstimationAlgorithm.AMDF
                else -> PitchEstimationAlgorithm.YIN
            }
            
            // AudioRecord setup
            val minBufferSize = AudioRecord.getMinBufferSize(
                sampleRate,
                AudioFormat.CHANNEL_IN_MONO,
                AudioFormat.ENCODING_PCM_16BIT
            )
            
            if (minBufferSize == AudioRecord.ERROR || minBufferSize == AudioRecord.ERROR_BAD_VALUE) {
                mainHandler.post {
                    pitchStreamSink?.error("AUDIO_SETUP_ERROR", "AudioRecord.getMinBufferSize failed", null)
                }
                return
            }
            
            val audioBufferSize = maxOf(minBufferSize, bufferSize * 2)
            
            android.util.Log.d("PitchDetection", "Sample rate: $sampleRate, Buffer size: $bufferSize, Audio buffer: $audioBufferSize")
            
            if (ActivityCompat.checkSelfPermission(
                    this,
                    Manifest.permission.RECORD_AUDIO
                ) != PackageManager.PERMISSION_GRANTED
            ) {
                return
            }
            
            audioRecord = AudioRecord(
                MediaRecorder.AudioSource.MIC,
                sampleRate,
                AudioFormat.CHANNEL_IN_MONO,
                AudioFormat.ENCODING_PCM_16BIT,
                audioBufferSize
            )
            
            if (audioRecord?.state != AudioRecord.STATE_INITIALIZED) {
                mainHandler.post {
                    pitchStreamSink?.error("AUDIO_INIT_ERROR", "AudioRecord not initialized", null)
                }
                audioRecord?.release()
                audioRecord = null
                return
            }
            
            android.util.Log.d("PitchDetection", "AudioRecord initialized successfully")
            
            // PitchDetectionHandler tanımla
            val pitchDetectionHandler = PitchDetectionHandler { result: PitchDetectionResult, event: AudioEvent ->
                val pitchInHz = result.pitch
                val probability = result.probability
                val isPitched = result.isPitched
                val rms = event.rms * 100
                
                android.util.Log.d("PitchDetection", "Pitch: $pitchInHz Hz, Probability: $probability, IsPitched: $isPitched, RMS: %.5f".format(rms))
                
                // Pitch verisini Flutter'a gönder
                // Filtrele: -1.0 (pitch yok), 150 Hz altı (gürültü/elektriksel hum), 0.85 altındaki confidence
                if (pitchStreamSink != null && isPitched && pitchInHz >= 150.0 && probability >= 0.85) {
                    val pitchData = hashMapOf(
                        "pitch" to pitchInHz.toDouble(),
                        "probability" to probability.toDouble(),
                        "isPitched" to isPitched,
                        "timestamp" to System.currentTimeMillis()
                    )
                    
                    // UI thread'de gönder
                    mainHandler.post {
                        pitchStreamSink?.success(pitchData)
                    }
                }
            }
            
            // PitchProcessor oluştur
            val tarsosDSPFormat = TarsosDSPAudioFormat(
                sampleRate.toFloat(),
                16,
                1,
                true,
                false
            )
            
            val pitchProcessor = PitchProcessor(
                algorithm,
                sampleRate.toFloat(),
                bufferSize,
                pitchDetectionHandler
            )
            
            // AudioRecord'dan okuma thread'i
            isRecording = true
            audioRecord?.startRecording()
            
            if (audioRecord?.recordingState != AudioRecord.RECORDSTATE_RECORDING) {
                mainHandler.post {
                    pitchStreamSink?.error("RECORDING_ERROR", "Failed to start recording", null)
                }
                return
            }
            
            android.util.Log.d("PitchDetection", "Recording started")
            
            recordingThread = thread(start = true) {
                val audioBuffer = ShortArray(bufferSize)
                val floatBuffer = FloatArray(bufferSize)
                var readCount = 0
                
                while (isRecording) {
                    val read = audioRecord?.read(audioBuffer, 0, bufferSize) ?: 0
                    
                    if (read > 0) {
                        readCount++
                        
                        // Short'tan Float'a çevir
                        for (i in 0 until read) {
                            floatBuffer[i] = audioBuffer[i] / 32768.0f
                        }
                        
                        // RMS (Root Mean Square) hesapla - ses seviyesi
                        var sum = 0.0
                        for (i in 0 until read) {
                            sum += floatBuffer[i] * floatBuffer[i]
                        }
                        val rms = kotlin.math.sqrt(sum / read) * 100
                        
                        if (readCount % 50 == 0) {
                            android.util.Log.d("PitchDetection", "Read $read samples (buffer #$readCount), RMS: %.5f".format(rms))
                        }
                        
                        // AudioEvent oluştur ve process et
                        val audioEvent = AudioEvent(tarsosDSPFormat)
                        audioEvent.floatBuffer = floatBuffer
                        
                        pitchProcessor.process(audioEvent)
                    } else {
                        android.util.Log.e("PitchDetection", "AudioRecord.read returned: $read")
                    }
                }
            }
            
        } catch (e: Exception) {
            mainHandler.post {
                pitchStreamSink?.error("PITCH_DETECTION_ERROR", e.message, null)
            }
        }
    }
    
    private fun stopPitchDetection() {
        isRecording = false
        recordingThread?.join(1000)
        recordingThread = null
        
        audioRecord?.stop()
        audioRecord?.release()
        audioRecord = null
    }
    
    private fun checkPermission(): Boolean {
        return ContextCompat.checkSelfPermission(
            this,
            Manifest.permission.RECORD_AUDIO
        ) == PackageManager.PERMISSION_GRANTED
    }
    
    private fun requestPermission() {
        ActivityCompat.requestPermissions(
            this,
            arrayOf(Manifest.permission.RECORD_AUDIO),
            PERMISSION_REQUEST_CODE
        )
    }
    
    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        
        if (requestCode == PERMISSION_REQUEST_CODE) {
            if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                // İzin verildi - Flutter tarafında handle edilecek
            } else {
                // İzin reddedildi
                mainHandler.post {
                    pitchStreamSink?.error("PERMISSION_DENIED", "Microphone permission denied", null)
                }
            }
        }
    }
    
    override fun onDestroy() {
        super.onDestroy()
        stopPitchDetection()
    }
}
