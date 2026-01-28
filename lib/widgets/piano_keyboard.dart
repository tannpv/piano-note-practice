import 'package:flutter/material.dart';

import '../models/music_note.dart';

class PianoKeyboard extends StatelessWidget {
  const PianoKeyboard({super.key, required this.currentNote});

  final MusicNote? currentNote;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _KeyboardPainter(currentNote: currentNote),
    );
  }
}

/// Compact keyboard showing 7 keys centered around the current note.
class MiniSurroundKeyboard extends StatelessWidget {
  const MiniSurroundKeyboard({super.key, required this.currentNote});

  final MusicNote? currentNote;

  @override
  Widget build(BuildContext context) {
    if (currentNote == null) return const SizedBox.shrink();
    return CustomPaint(
      painter: _MiniSurroundPainter(note: currentNote!),
    );
  }
}

class _KeyboardPainter extends CustomPainter {
  _KeyboardPainter({required this.currentNote});

  final MusicNote? currentNote;

  static const _whitePattern = [0, 2, 4, 5, 7, 9, 11];
  static const _blackPattern = [1, 3, 6, 8, 10];

  @override
  void paint(Canvas canvas, Size size) {
    const startMidi = 21; // A0
    const endMidi = 108; // C8 inclusive
    final noteMidi = currentNote?.midiNoteNumber;

    // Build full 88-key white list
    final whiteKeys = <int>[];
    for (int m = startMidi; m <= endMidi; m++) {
      if (_whitePattern.contains(m % 12)) whiteKeys.add(m);
    }

    final whiteWidth = size.width / whiteKeys.length;
    final whiteHeight = size.height;

    // Solfege mapping for quick reference on white keys.
    const solfege = {
      0: 'Do',
      2: 'Re',
      4: 'Mi',
      5: 'Fa',
      7: 'Sol',
      9: 'La',
      11: 'Si',
    };

    // Alternating octave bands for visual grouping across full 88 keys.
    int bandStart = 0;
    int currentOct = whiteKeys.first ~/ 12 - 1;
    for (int i = 0; i < whiteKeys.length; i++) {
      final oct = whiteKeys[i] ~/ 12 - 1;
      final isLast = i == whiteKeys.length - 1;
      final boundary = oct != currentOct || isLast;
      if (boundary) {
        final int bandEnd = isLast ? i : i - 1;
        final x0 = bandStart * whiteWidth;
        final width = (bandEnd - bandStart + 1) * whiteWidth;
        final shade = (currentOct % 2 == 0)
            ? Colors.grey.shade100
            : Colors.grey.shade200;
        canvas.drawRect(
          Rect.fromLTWH(x0, 0, width, whiteHeight),
          Paint()..color = shade,
        );

        // Octave label at top.
        final label = 'Oct $currentOct';
        final tp = TextPainter(
          text: TextSpan(
            text: label,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: whiteWidth * 0.35,
              fontWeight: FontWeight.w600,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: width);
        tp.paint(canvas, Offset(x0 + (width - tp.width) / 2, 4));

        bandStart = i;
        currentOct = oct;
      }
    }

    // Draw white keys
    for (int i = 0; i < whiteKeys.length; i++) {
      final x = i * whiteWidth;
      final isActive = noteMidi != null && whiteKeys[i] == noteMidi;
      final rect = Rect.fromLTWH(x, 0, whiteWidth, whiteHeight);
      final paint = Paint()
        ..color = isActive ? Colors.orange.shade200 : Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawRect(rect, paint);
      canvas.drawRect(
        rect,
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke,
      );

      final midi = whiteKeys[i];
      final semitone = midi % 12;

      // Solfege label above key
      final sol = solfege[semitone];
      if (sol != null) {
        final tp = TextPainter(
          text: TextSpan(
            text: sol,
            style: TextStyle(
              color: Colors.grey.shade800,
              fontSize: whiteWidth * 0.28,
              fontWeight: FontWeight.w600,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: whiteWidth);
        tp.paint(canvas, Offset(x + (whiteWidth - tp.width) / 2, 6));
      }

      final label = _noteLabel(midi);
      final tp = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(
            color: Colors.grey.shade800,
            fontSize: whiteWidth * 0.28,
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: whiteWidth);
      tp.paint(
        canvas,
        Offset(x + (whiteWidth - tp.width) / 2, whiteHeight - tp.height - 6),
      );
    }

    // Black keys
    final blackWidth = whiteWidth * 0.6;
    final blackHeight = size.height * 0.65;
    for (int midi = startMidi; midi <= endMidi; midi++) {
      if (_blackPattern.contains(midi % 12)) {
        final whiteIndexBase = _leftWhiteIndex(whiteKeys, midi);
        final x = (whiteIndexBase + 1) * whiteWidth - blackWidth / 2;
        final rect = Rect.fromLTWH(x, 0, blackWidth, blackHeight);
        final isActive = noteMidi != null && midi == noteMidi;
        final paint = Paint()
          ..color = isActive ? Colors.orange.shade700 : Colors.black
          ..style = PaintingStyle.fill;
        canvas.drawRect(rect, paint);

        // Black key label
        final label = _noteLabel(midi);
        final tp = TextPainter(
          text: TextSpan(
            text: label,
            style: TextStyle(
              color: Colors.white,
              fontSize: blackWidth * 0.28,
              fontWeight: FontWeight.w600,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: blackWidth);
        tp.paint(
          canvas,
          Offset(x + (blackWidth - tp.width) / 2, blackHeight - tp.height - 3),
        );
      }
    }
  }

  int _leftWhiteIndex(List<int> whites, int midi) {
    for (int i = whites.length - 1; i >= 0; i--) {
      if (whites[i] < midi) return i;
    }
    return 0;
  }

  String _noteLabel(int midi) {
    const names = [
      'C',
      'C#',
      'D',
      'D#',
      'E',
      'F',
      'F#',
      'G',
      'G#',
      'A',
      'A#',
      'B'
    ];
    final name = names[midi % 12];
    final octave = midi ~/ 12 - 1;
    return '$name$octave';
  }

  @override
  bool shouldRepaint(covariant _KeyboardPainter oldDelegate) {
    return oldDelegate.currentNote != currentNote;
  }
}

class _MiniSurroundPainter extends CustomPainter {
  _MiniSurroundPainter({required this.note});

  final MusicNote note;

  static const _naturalSemitones = {0, 2, 4, 5, 7, 9, 11};
  static const _blackSemitones = {1, 3, 6, 8, 10};

  @override
  void paint(Canvas canvas, Size size) {
    final noteMidi = note.midiNoteNumber;
    final startWhite = _findStartWhite(noteMidi);
    final whiteKeys = <int>[];
    var m = startWhite;
    while (whiteKeys.length < 7) {
      if (_naturalSemitones.contains(m % 12)) whiteKeys.add(m);
      m++;
    }

    final whiteWidth = size.width / whiteKeys.length;
    final whiteHeight = size.height;
    final blackWidth = whiteWidth * 0.55;
    final blackHeight = size.height * 0.6;

    // White keys
    for (int i = 0; i < whiteKeys.length; i++) {
      final x = i * whiteWidth;
      final midi = whiteKeys[i];
      final isActive = midi == noteMidi;
      final rect = Rect.fromLTWH(x, 0, whiteWidth, whiteHeight);
      final paint = Paint()
        ..color = isActive ? Colors.orange.shade200 : Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawRect(rect, paint);
      canvas.drawRect(
        rect,
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke,
      );
    }

    // Black keys
    final blackKeys = <int>[];
    for (int midi = whiteKeys.first + 1; midi < whiteKeys.last; midi++) {
      if (_blackSemitones.contains(midi % 12)) {
        blackKeys.add(midi);
      }
    }

    for (final midi in blackKeys) {
      final leftWhiteIndex = _leftWhiteIndex(whiteKeys, midi);
      final x =
          (leftWhiteIndex + 1) * whiteWidth - blackWidth / 2; // center between
      final rect = Rect.fromLTWH(x, 0, blackWidth, blackHeight);
      final isActive = midi == noteMidi;
      final paint = Paint()
        ..color = isActive ? Colors.orange.shade700 : Colors.black
        ..style = PaintingStyle.fill;
      canvas.drawRect(rect, paint);
    }
  }

  int _findStartWhite(int noteMidi) {
    // Move back to the white key 3 naturals before the note's nearest white.
    int m = noteMidi;
    while (!_naturalSemitones.contains(m % 12)) {
      m--; // go to preceding white if on black
    }
    int whitesBack = 3;
    while (whitesBack > 0) {
      m--;
      if (_naturalSemitones.contains(m % 12)) {
        whitesBack--;
      }
    }
    return m;
  }

  int _leftWhiteIndex(List<int> whites, int blackMidi) {
    for (int i = whites.length - 1; i >= 0; i--) {
      if (whites[i] < blackMidi) return i;
    }
    return 0;
  }

  @override
  bool shouldRepaint(covariant _MiniSurroundPainter oldDelegate) {
    return oldDelegate.note != note;
  }
}
