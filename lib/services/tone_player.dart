import 'dart:math';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';

/// Lightweight tone player using generated WAV buffers for clarity.
class TonePlayer {
  TonePlayer({AudioPlayer? player}) : _player = player ?? AudioPlayer();

  final AudioPlayer _player;
  final Map<int, Uint8List> _cache = {};

  Future<void> playMidi(int midi,
      {double seconds = 0.8, double volume = 0.7}) async {
    final buffer = _cache.putIfAbsent(midi, () => _buildWave(midi, seconds));
    await _player.stop();
    await _player.play(BytesSource(buffer), volume: volume);
  }

  Uint8List _buildWave(int midi, double seconds) {
    const sampleRate = 44100;
    final totalSamples = (seconds * sampleRate).round();
    final freq = 440.0 * pow(2, (midi - 69) / 12);
    const baseAmp = 0.9; // prevent clipping
    final bytes = BytesBuilder();

    // WAV header
    final dataSize = totalSamples * 2; // 16-bit mono
    final fileSize = 36 + dataSize;
    bytes.add(_ascii('RIFF'));
    bytes.add(_uint32(fileSize));
    bytes.add(_ascii('WAVE'));
    bytes.add(_ascii('fmt '));
    bytes.add(_uint32(16)); // PCM chunk size
    bytes.add(_uint16(1)); // PCM format
    bytes.add(_uint16(1)); // channels
    bytes.add(_uint32(sampleRate));
    bytes.add(_uint32(sampleRate * 2)); // byte rate
    bytes.add(_uint16(2)); // block align
    bytes.add(_uint16(16)); // bits per sample
    bytes.add(_ascii('data'));
    bytes.add(_uint32(dataSize));

    // Samples: additive harmonics with piano-like percussive envelope
    for (int n = 0; n < totalSamples; n++) {
      final t = n / sampleRate;
      final env = _envelope(t, seconds);
      final fundamental = sin(2 * pi * freq * t);
      final h2 = sin(2 * pi * freq * 2 * t) * exp(-t / 0.35);
      final h3 = sin(2 * pi * freq * 3 * t) * exp(-t / 0.25);
      final h4 = sin(2 * pi * freq * 4 * t) * exp(-t / 0.18);
      final mixed = (fundamental +
              0.5 * h2 +
              0.32 * h3 +
              0.2 * h4) /
          2.02; // normalize
      final sample = (baseAmp * env * mixed * 32767).round();
      bytes.add(_int16(sample));
    }

    return bytes.toBytes();
  }

  double _envelope(double t, double totalSeconds) {
    // Quick attack (~5ms) then exponential decay
    const attack = 0.005;
    final attackEnv = t < attack ? (t / attack) : 1.0;
    final decayEnv = exp(-t / (totalSeconds * 0.45));
    return attackEnv * decayEnv;
  }

  List<int> _ascii(String s) => s.codeUnits;
  List<int> _uint16(int v) => Uint8List(2)..buffer.asByteData().setUint16(0, v, Endian.little);
  List<int> _uint32(int v) => Uint8List(4)..buffer.asByteData().setUint32(0, v, Endian.little);
  List<int> _int16(int v) => Uint8List(2)..buffer.asByteData().setInt16(0, v, Endian.little);
}
