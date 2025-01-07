import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

class MicrophoneWidget extends StatefulWidget {
  const MicrophoneWidget({Key? key}) : super(key: key);

  @override
  State<MicrophoneWidget> createState() => _MicrophoneWidgetState();
}

class _MicrophoneWidgetState extends State<MicrophoneWidget> {
  bool _isRecording = false;
  late final AudioRecorder _audioRecorder;
  Timer? _timer;
  String _recordDuration = '00:00';

  @override
  void initState() {
    super.initState();
    _audioRecorder = AudioRecorder();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
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
                color:
                    _isRecording ? Colors.red : Theme.of(context).primaryColor,
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
}
