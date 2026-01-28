import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:pinano_note_practice/models/app_settings.dart';
import 'package:pinano_note_practice/models/clef.dart';
import 'package:pinano_note_practice/models/music_note.dart';
import 'package:pinano_note_practice/services/note_generator.dart';

void main() {
  group('NoteGenerator', () {
    test('respects treble beginner range', () {
      final generator = NoteGenerator(random: Random(1));
      final settings =
          AppSettings.defaults.copyWith(clefMode: ClefMode.treble);
      final note = generator.generate(settings);
      expect(note.clef, ClefMode.treble);
      expect(note.midiNoteNumber, inInclusiveRange(60, 81));
    });

    test('avoids immediate repeats when enabled', () {
      final generator = NoteGenerator(random: Random(2));
      final settings = AppSettings.defaults;
      final first = generator.generate(settings);
      final second = generator.generate(settings, lastNote: first);
      expect(second.displayName, isNot(equals(first.displayName)));
    });

    test('generates sharps when accidentals enabled', () {
      final generator = NoteGenerator(random: Random(3));
      final settings = AppSettings.defaults.copyWith(
        accidentalsEnabled: true,
        scaleRoot: 'D',
        scaleMode: 'major',
      );
      bool sawSharp = false;
      MusicNote? last;
      for (int i = 0; i < 40; i++) {
        final note = generator.generate(settings, lastNote: last);
        if (note.sharp) sawSharp = true;
        last = note;
      }
      expect(sawSharp, isTrue);
    });

    test('both mode yields treble and bass notes', () {
      final generator = NoteGenerator(random: Random(4));
      final settings = AppSettings.defaults.copyWith(clefMode: ClefMode.both);
      bool sawTreble = false;
      bool sawBass = false;
      MusicNote? last;
      for (int i = 0; i < 50; i++) {
        final note = generator.generate(settings, lastNote: last);
        if (note.clef == ClefMode.treble) sawTreble = true;
        if (note.clef == ClefMode.bass) sawBass = true;
        last = note;
      }
      expect(sawTreble && sawBass, isTrue);
    });
  });
}
