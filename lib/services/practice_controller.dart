import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/app_settings.dart';
import '../models/music_note.dart';
import '../services/tone_player.dart';
import 'note_generator.dart';
import 'settings_store.dart';

class PracticeController extends ChangeNotifier {
  PracticeController({
    required SettingsStore settingsStore,
    required NoteGenerator noteGenerator,
    required AppSettings initialSettings,
  })  : _settingsStore = settingsStore,
        _noteGenerator = noteGenerator,
        _settings = initialSettings {
    _tonePlayer = TonePlayer();
    _queue = _buildQueue();
    _remainingSeconds = _settings.displaySeconds;
  }

  final SettingsStore _settingsStore;
  final NoteGenerator _noteGenerator;
  late final TonePlayer _tonePlayer;

  AppSettings _settings;
  AppSettings get settings => _settings;

  late List<MusicNote> _queue;
  List<MusicNote> get queue => List.unmodifiable(_queue);
  int _highlightIndex = 0;
  int get highlightIndex => _highlightIndex;
  MusicNote? get currentNote =>
      _queue.isNotEmpty ? _queue[_highlightIndex] : null;

  bool _isRunning = false;
  bool get isRunning => _isRunning;

  double _remainingSeconds = 0;
  double get remainingSeconds => _remainingSeconds;

  Timer? _timer;

  void _playNote(MusicNote note) {
    _tonePlayer.playMidi(note.midiNoteNumber, seconds: 0.8, volume: 0.75);
  }

  void start() {
    if (_isRunning) return;
    _isRunning = true;
    _startTimer();
    notifyListeners();
  }

  void pause() {
    if (!_isRunning) return;
    _isRunning = false;
    _timer?.cancel();
    notifyListeners();
  }

  void toggleRunning() {
    _isRunning ? pause() : start();
  }

  void nextNote() {
    if (_queue.isEmpty) {
      _queue = _buildQueue();
      _highlightIndex = 0;
    } else {
      _highlightIndex++;
      if (_highlightIndex >= _queue.length) {
        _queue = _buildQueue(_queue.last);
        _highlightIndex = 0;
      }
    }

    _remainingSeconds = _settings.displaySeconds;
    if (currentNote != null && _settings.soundEnabled) {
      _playNote(currentNote!);
    }
    notifyListeners();
  }

  Future<void> updateSettings(AppSettings newSettings) async {
    _settings = newSettings;
    await _settingsStore.save(newSettings);
    _queue = _buildQueue();
    _highlightIndex = 0;
    _remainingSeconds = newSettings.displaySeconds;
    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    const tick = Duration(milliseconds: 100);
    _timer = Timer.periodic(tick, (timer) {
      _remainingSeconds -= tick.inMilliseconds / 1000.0;
      if (_remainingSeconds <= 0) {
        nextNote();
      }
      if (_isRunning) {
        notifyListeners();
      }
    });
  }

  List<MusicNote> _buildQueue([MusicNote? seed]) {
    final list = <MusicNote>[];
    MusicNote? last = seed;
    for (int i = 0; i < 7; i++) {
      final n = _noteGenerator.generate(_settings, lastNote: last);
      list.add(n);
      last = n;
    }
    return list;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
