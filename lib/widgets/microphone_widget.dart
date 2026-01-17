import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import '../services/pitch_detector_service.dart';
import 'pitch_visualizer_widget.dart';

enum MicrophoneMode { recording, analyzing }

class MicrophoneWidget extends StatefulWidget {
  const MicrophoneWidget({Key? key}) : super(key: key);

  @override
  State<MicrophoneWidget> createState() => _MicrophoneWidgetState();
}

class _MicrophoneWidgetState extends State<MicrophoneWidget> {
  // Recording mode değişkenleri
  bool _isRecording = false;
  late final AudioRecorder _audioRecorder;
  Timer? _timer;
  String _recordDuration = '00:00';

  // Analyzing mode değişkenleri
  bool _isAnalyzing = false;
  final PitchDetectorService _pitchService = PitchDetectorService();
  PitchData? _currentPitchData;
  
  // Mod seçimi
  MicrophoneMode _currentMode = MicrophoneMode.recording;

  @override
  void initState() {
    super.initState();
    _audioRecorder = AudioRecorder();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioRecorder.dispose();
    _pitchService.dispose();
    super.dispose();
  }

  // ========== RECORDING MODE ==========
  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final path = await getTemporaryDirectory();
        final filePath =
            '${path.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

        await _audioRecorder.start(
          const RecordConfig(
            encoder: AudioEncoder.aacLc,
            bitRate: 128000,
            sampleRate: 44100,
          ),
          path: filePath,
        );

        setState(() {
          _isRecording = true;
        });

        _timer?.cancel();
        _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
          final duration = t.tick;
          final minutes = (duration / 60).floor().toString().padLeft(2, '0');
          final seconds = (duration % 60).toString().padLeft(2, '0');
          setState(() {
            _recordDuration = '$minutes:$seconds';
          });
        });
      }
    } catch (e) {
      debugPrint('Kayıt başlatılırken hata: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
        _recordDuration = '00:00';
      });

      _timer?.cancel();

      if (path != null) {
        debugPrint('Kayıt dosyası: $path');
        // Burada kaydedilen ses dosyasını API'ye gönderme işlemi yapılacak
      }
    } catch (e) {
      debugPrint('Kayıt durdurulurken hata: $e');
    }
  }

  // ========== ANALYZING MODE ==========
  Future<void> _startAnalyzing() async {
    try {
      // İzin kontrolü
      final hasPermission = await _pitchService.checkPermission();
      if (!hasPermission) {
        _showPermissionDialog();
        return;
      }

      // Pitch detection başlat
      await _pitchService.start(
        algorithm: PitchAlgorithm.yin,
        sampleRate: 22050,
        bufferSize: 1024,
      );

      // Stream dinle
      _pitchService.listen(
        (pitchData) {
          setState(() {
            _currentPitchData = pitchData;
          });
        },
        onError: (error) {
          debugPrint('Pitch detection hatası: $error');
          _stopAnalyzing();
        },
      );

      setState(() {
        _isAnalyzing = true;
      });
    } catch (e) {
      debugPrint('Analiz başlatılırken hata: $e');
      _showErrorDialog(e.toString());
    }
  }

  Future<void> _stopAnalyzing() async {
    try {
      await _pitchService.stop();
      setState(() {
        _isAnalyzing = false;
        _currentPitchData = null;
      });
    } catch (e) {
      debugPrint('Analiz durdurulurken hata: $e');
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mikrofon İzni Gerekli'),
        content: const Text(
          'Ses analizi için mikrofon iznine ihtiyaç var. Lütfen uygulama ayarlarından mikrofon iznini açın.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hata'),
        content: Text(error),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  // ========== UI ==========
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Mod seçici toggle
        _buildModeToggle(),
        const SizedBox(height: 20),

        // Aktif moda göre içerik
        if (_currentMode == MicrophoneMode.recording)
          _buildRecordingMode()
        else
          _buildAnalyzingMode(),
      ],
    );
  }

  Widget _buildModeToggle() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleButton(
            icon: Icons.fiber_manual_record,
            label: 'Kayıt',
            isSelected: _currentMode == MicrophoneMode.recording,
            onTap: () {
              if (!_isRecording && !_isAnalyzing) {
                setState(() {
                  _currentMode = MicrophoneMode.recording;
                });
              }
            },
          ),
          _buildToggleButton(
            icon: Icons.graphic_eq,
            label: 'Analiz',
            isSelected: _currentMode == MicrophoneMode.analyzing,
            onTap: () {
              if (!_isRecording && !_isAnalyzing) {
                setState(() {
                  _currentMode = MicrophoneMode.analyzing;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.black54,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black54,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordingMode() {
    return Column(
      children: [
        Text(
          _recordDuration,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                _isRecording ? Icons.stop_circle : Icons.mic,
                color: _isRecording ? Colors.red : Theme.of(context).primaryColor,
                size: 64,
              ),
              onPressed: () {
                if (_isRecording) {
                  _stopRecording();
                } else {
                  _startRecording();
                }
              },
            ),
            const SizedBox(width: 20),
            Container(
              height: 50,
              width: 200,
              decoration: BoxDecoration(
                border: Border.all(
                  color: _isRecording ? Colors.red : Colors.black,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  _isRecording ? 'Kayıt Yapılıyor...' : 'Ses Dalga Alanı',
                  style: TextStyle(
                    color: _isRecording ? Colors.red : Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAnalyzingMode() {
    return Column(
      children: [
        // Pitch visualizer
        PitchVisualizerWidget(
          pitchData: _currentPitchData,
          isAnalyzing: _isAnalyzing,
        ),
        const SizedBox(height: 20),
        
        // Start/Stop butonu
        ElevatedButton.icon(
          onPressed: () {
            if (_isAnalyzing) {
              _stopAnalyzing();
            } else {
              _startAnalyzing();
            }
          },
          icon: Icon(_isAnalyzing ? Icons.stop : Icons.play_arrow),
          label: Text(_isAnalyzing ? 'Analizi Durdur' : 'Analizi Başlat'),
          style: ElevatedButton.styleFrom(
            backgroundColor: _isAnalyzing ? Colors.red : Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
