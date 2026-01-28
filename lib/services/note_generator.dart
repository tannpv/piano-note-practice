import 'dart:math';

import '../models/app_settings.dart';
import '../models/clef.dart';
import '../models/music_note.dart';
import '../models/range_preset.dart';
import 'scale_generator.dart';

class NoteGenerator {
  NoteGenerator({Random? random}) : _random = random ?? Random();

  final Random _random;

  // Natural semitone indices relative to C.
  static const _naturalSteps = <int>{0, 2, 4, 5, 7, 9, 11};

  MusicNote generate(AppSettings settings, {MusicNote? lastNote}) {
    final clef = _selectClef(settings.clefMode);
    final scaleFilter = _scaleSet(settings);
    final pool = _buildPool(
      clef: clef,
      rangePreset: settings.rangePreset,
      includeAccidentals: settings.accidentalsEnabled,
      scaleFilter: scaleFilter,
    );

    if (pool.isEmpty) {
      throw StateError('No notes available for current settings');
    }

    // If a scale filter is active, step through the scale in order for clarity.
    if (scaleFilter != null) {
      final idx = lastNote == null
          ? 0
          : pool.indexWhere((n) =>
              n.displayName == lastNote.displayName && n.clef == lastNote.clef);
      final nextIdx = idx >= 0 ? (idx + 1) % pool.length : 0;
      return pool[nextIdx];
    }

    final ordered = settings.scaleOrdered && scaleFilter != null;
    if (ordered) {
      final idx = lastNote == null
          ? 0
          : pool.indexWhere((n) =>
              n.displayName == lastNote.displayName && n.clef == lastNote.clef);
      final nextIdx = idx >= 0 ? (idx + 1) % pool.length : 0;
      return pool[nextIdx];
    }

    MusicNote candidate = pool[_random.nextInt(pool.length)];
    if (!settings.avoidRepeats || lastNote == null) {
      return candidate;
    }
    for (int i = 0; i < pool.length * 2; i++) {
      if (candidate.displayName != lastNote.displayName ||
          candidate.clef != lastNote.clef) {
        return candidate;
      }
      candidate = pool[_random.nextInt(pool.length)];
    }
    return candidate;
  }

  ClefMode _selectClef(ClefMode mode) {
    if (mode == ClefMode.both) {
      return _random.nextBool() ? ClefMode.treble : ClefMode.bass;
    }
    return mode;
  }

  List<MusicNote> _buildPool({
    required ClefMode clef,
    required RangePreset rangePreset,
    required bool includeAccidentals,
    Set<int>? scaleFilter,
  }) {
    final range = _rangeFor(clef, rangePreset);
    final notes = <MusicNote>[];
    for (int midi = range.start; midi <= range.end; midi++) {
      final semitone = midi % 12;
      if (scaleFilter != null && !scaleFilter.contains(semitone)) {
        continue;
      }
      if (!includeAccidentals && !_naturalSteps.contains(semitone)) {
        continue;
      }
      notes.add(_noteFromMidi(midi, clef));
    }
    return notes;
  }

  _MidiRange _rangeFor(ClefMode clef, RangePreset preset) {
    switch (preset) {
      case RangePreset.beginner:
        return clef == ClefMode.treble
            ? _MidiRange(60, 81) // C4–A5
            : _MidiRange(40, 60); // E2–C4
      case RangePreset.intermediate:
        return clef == ClefMode.treble
            ? _MidiRange(57, 84) // A3–C6
            : _MidiRange(36, 64); // C2–E4
      case RangePreset.advanced:
        return clef == ClefMode.treble
            ? _MidiRange(52, 96) // E3–C7
            : _MidiRange(33, 67); // A1–G4
    }
  }

  MusicNote _noteFromMidi(int midi, ClefMode clef) {
    final semitone = midi % 12;
    final octave = midi ~/ 12 - 1;
    switch (semitone) {
      case 0:
        return MusicNote(step: 'C', octave: octave, sharp: false, clef: clef);
      case 1:
        return MusicNote(step: 'C', octave: octave, sharp: true, clef: clef);
      case 2:
        return MusicNote(step: 'D', octave: octave, sharp: false, clef: clef);
      case 3:
        return MusicNote(step: 'D', octave: octave, sharp: true, clef: clef);
      case 4:
        return MusicNote(step: 'E', octave: octave, sharp: false, clef: clef);
      case 5:
        return MusicNote(step: 'F', octave: octave, sharp: false, clef: clef);
      case 6:
        return MusicNote(step: 'F', octave: octave, sharp: true, clef: clef);
      case 7:
        return MusicNote(step: 'G', octave: octave, sharp: false, clef: clef);
      case 8:
        return MusicNote(step: 'G', octave: octave, sharp: true, clef: clef);
      case 9:
        return MusicNote(step: 'A', octave: octave, sharp: false, clef: clef);
      case 10:
        return MusicNote(step: 'A', octave: octave, sharp: true, clef: clef);
      case 11:
        return MusicNote(step: 'B', octave: octave, sharp: false, clef: clef);
      default:
        return MusicNote(step: 'C', octave: octave, sharp: false, clef: clef);
    }
  }

  Set<int>? _scaleSet(AppSettings settings) {
    final scale = ScaleGenerator.buildScale(settings.scaleRoot, settings.scaleMode);
    if (scale.isEmpty) return null;
    return scale.map((n) => _noteNameToSemitone(n)).whereType<int>().toSet();
  }

  int? _noteNameToSemitone(String name) {
    final key = name.trim().toUpperCase();
    switch (key) {
      case 'C':
        return 0;
      case 'C#':
      case 'DB':
        return 1;
      case 'D':
        return 2;
      case 'D#':
      case 'EB':
        return 3;
      case 'E':
        return 4;
      case 'F':
        return 5;
      case 'F#':
      case 'GB':
        return 6;
      case 'G':
        return 7;
      case 'G#':
      case 'AB':
        return 8;
      case 'A':
        return 9;
      case 'A#':
      case 'BB':
        return 10;
      case 'B':
        return 11;
      default:
        return null;
    }
  }
}

class _MidiRange {
  const _MidiRange(this.start, this.end);
  final int start;
  final int end;
}
