package com.example.luscinia

import android.Manifest
import android.content.pm.PackageManager
import android.os.Handler
import android.os.Looper
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import be.tarsos.dsp.AudioDispatcher
import be.tarsos.dsp.AudioEvent
import be.tarsos.dsp.io.android.AudioDispatcherFactory
import be.tarsos.dsp.pitch.PitchDetectionHandler
import be.tarsos.dsp.pitch.PitchDetectionResult
import be.tarsos.dsp.pitch.PitchProcessor
import be.tarsos.dsp.pitch.PitchProcessor.PitchEstimationAlgorithm
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.luscinia/pitch_detector"
    private val EVENT_CHANNEL = "com.example.luscinia/pitch_stream"
    private val PERMISSION_REQUEST_CODE = 200
    
    private var audioDispatcher: AudioDispatcher? = null
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
        // Önceki dispatcher'ı durdur
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
            
            // AudioDispatcher oluştur
            audioDispatcher = AudioDispatcherFactory.fromDefaultMicrophone(sampleRate, bufferSize, 0)
            
            // PitchDetectionHandler tanımla
            val pitchDetectionHandler = PitchDetectionHandler { result: PitchDetectionResult, event: AudioEvent ->
                val pitchInHz = result.pitch
                val probability = result.probability
                val isSilence = result.isPitched
                
                // Pitch verisini Flutter'a gönder
                if (pitchStreamSink != null) {
                    val pitchData = hashMapOf(
                        "pitch" to pitchInHz.toDouble(),
                        "probability" to probability.toDouble(),
                        "isPitched" to isSilence,
                        "timestamp" to System.currentTimeMillis()
                    )
                    
                    // UI thread'de gönder
                    mainHandler.post {
                        pitchStreamSink?.success(pitchData)
                    }
                }
            }
            
            // PitchProcessor ekle
            val pitchProcessor = PitchProcessor(algorithm, sampleRate.toFloat(), bufferSize, pitchDetectionHandler)
            audioDispatcher?.addAudioProcessor(pitchProcessor)
            
            // Arka planda çalıştır
            Thread {
                audioDispatcher?.run()
            }.start()
            
        } catch (e: Exception) {
            mainHandler.post {
                pitchStreamSink?.error("PITCH_DETECTION_ERROR", e.message, null)
            }
        }
    }
    
    private fun stopPitchDetection() {
        audioDispatcher?.stop()
        audioDispatcher = null
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
