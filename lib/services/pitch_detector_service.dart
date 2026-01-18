import 'dart:async';
import 'dart:math';
import 'package:flutter/services.dart';

/// Pitch detection algoritmaları
enum PitchAlgorithm {
  yin('YIN'),
  mpm('MPM'),
  fftYin('FFT_YIN'),
  dynamicWavelet('DYNAMIC_WAVELET'),
  amdf('AMDF');

  final String value;
  const PitchAlgorithm(this.value);
}

/// Pitch verisi modeli
class PitchData {
  final double pitch;          // Hz cinsinden frekans
  final double probability;    // Güven skoru (0.0 - 1.0)
  final bool isPitched;        // Ses tespit edildi mi
  final int timestamp;         // Zaman damgası (milliseconds)

  PitchData({
    required this.pitch,
    required this.probability,
    required this.isPitched,
    required this.timestamp,
  });

  factory PitchData.fromMap(Map<dynamic, dynamic> map) {
    return PitchData(
      pitch: (map['pitch'] as num).toDouble(),
      probability: (map['probability'] as num).toDouble(),
      isPitched: map['isPitched'] as bool,
      timestamp: map['timestamp'] as int,
    );
  }

  /// Frekansı nota ismine çevirir (örn: 440Hz -> A4)
  String get noteName {
    if (pitch <= 0 || pitch.isNaN || pitch.isInfinite) return 'N/A';
    
    const noteNames = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'];
    
    // A4 = 440 Hz referans
    // MIDI note number = 69 + 12 * log2(freq/440)
    final noteNumber = 69 + 12 * (log(pitch / 440.0) / ln2);
    final octave = ((noteNumber / 12) - 1).floor();
    final noteIndex = noteNumber.round() % 12;
    final note = noteNames[noteIndex];
    
    return '$note$octave';
  }

  /// Frekansın notaya ne kadar yakın olduğunu cent cinsinden hesaplar
  double get centsOffPitch {
    if (pitch <= 0 || pitch.isNaN || pitch.isInfinite) return 0;
    
    // MIDI note number
    final noteNumber = 69 + 12 * (log(pitch / 440.0) / ln2);
    final nearestNote = noteNumber.round();
    return 100 * (noteNumber - nearestNote);
  }

  @override
  String toString() {
    return 'PitchData(pitch: ${pitch.toStringAsFixed(2)} Hz, '
           'note: $noteName, '
           'probability: ${(probability * 100).toStringAsFixed(1)}%, '
           'isPitched: $isPitched)';
  }
}

/// TarsosDSP tabanlı pitch detection servisi
class PitchDetectorService {
  static const MethodChannel _methodChannel = 
      MethodChannel('com.example.luscinia/pitch_detector');
  static const EventChannel _eventChannel = 
      EventChannel('com.example.luscinia/pitch_stream');

  Stream<PitchData>? _pitchStream;
  StreamSubscription<PitchData>? _subscription;

  /// Pitch detection stream'i
  Stream<PitchData> get pitchStream {
    _pitchStream ??= _eventChannel.receiveBroadcastStream().map((data) {
      final pitchData = PitchData.fromMap(data as Map<dynamic, dynamic>);
      print('📊 Flutter received pitch: ${pitchData.pitch.toStringAsFixed(2)} Hz, probability: ${(pitchData.probability * 100).toStringAsFixed(1)}%');
      return pitchData;
    });
    return _pitchStream!;
  }

  /// Pitch detection'ı başlat
  /// 
  /// [algorithm] - Kullanılacak algoritma (varsayılan: YIN)
  /// [sampleRate] - Örnekleme hızı Hz (varsayılan: 22050)
  /// [bufferSize] - Buffer boyutu (varsayılan: 1024)
  Future<void> start({
    PitchAlgorithm algorithm = PitchAlgorithm.yin,
    int sampleRate = 44100,  // Desktop örneğiyle aynı
    int bufferSize = 1024,
  }) async {
    try {
      await _methodChannel.invokeMethod('startPitchDetection', {
        'algorithm': algorithm.value,
        'sampleRate': sampleRate,
        'bufferSize': bufferSize,
      });
    } on PlatformException catch (e) {
      throw PitchDetectionException(
        'Failed to start pitch detection: ${e.message}',
        code: e.code,
      );
    }
  }

  /// Pitch detection'ı durdur
  Future<void> stop() async {
    try {
      await _methodChannel.invokeMethod('stopPitchDetection');
      await _subscription?.cancel();
      _subscription = null;
    } on PlatformException catch (e) {
      throw PitchDetectionException(
        'Failed to stop pitch detection: ${e.message}',
        code: e.code,
      );
    }
  }

  /// Mikrofon izni kontrolü
  Future<bool> checkPermission() async {
    try {
      final result = await _methodChannel.invokeMethod<bool>('checkPermission');
      return result ?? false;
    } on PlatformException catch (e) {
      print('Permission check failed: ${e.message}');
      return false;
    }
  }

  /// Stream'i dinle ve callback ile işle
  void listen(
    void Function(PitchData data) onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    _subscription = pitchStream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  /// Dinlemeyi iptal et
  void cancelListen() {
    _subscription?.cancel();
    _subscription = null;
  }

  /// Servisi temizle
  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    _pitchStream = null;
  }
}

/// Pitch detection hataları için özel exception
class PitchDetectionException implements Exception {
  final String message;
  final String? code;

  PitchDetectionException(this.message, {this.code});

  @override
  String toString() => 'PitchDetectionException: $message (code: $code)';
}

