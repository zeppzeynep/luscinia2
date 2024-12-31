import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class PlayButtonWidget extends StatefulWidget {
  @override
  _PlayButtonWidgetState createState() => _PlayButtonWidgetState();
}

class _PlayButtonWidgetState extends State<PlayButtonWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  // Ses çalma fonksiyonu
  Future<void> _playAudio() async {
    await _audioPlayer.play(AssetSource(
        'sounds/kumgibi3310.mp3')); // play fonksiyonu await ile kullanılıyor
    setState(() {
      _isPlaying = true;
    });
  }

  // Ses durdurma fonksiyonu
  void _stopAudio() async {
    await _audioPlayer.stop();
    setState(() {
      _isPlaying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (_isPlaying) {
          _stopAudio(); // Çalmayı durdur
        } else {
          _playAudio(); // Çalmaya başla
        }
      },
      child: Text(_isPlaying ? 'Dur' : 'Oynat'),
    );
  }
}
