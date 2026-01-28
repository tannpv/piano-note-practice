import 'package:flutter/material.dart';

import '../models/clef.dart';
import '../models/music_note.dart';

class StaffPainter extends CustomPainter {
  StaffPainter({required this.note});

  final MusicNote? note;
  final double lineSpacing = 14;

  static const _stepIndex = {
    'C': 0,
    'D': 1,
    'E': 2,
    'F': 3,
    'G': 4,
    'A': 5,
    'B': 6,
  };

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.5;

    final bottomY = size.height * 0.65;
    final left = 20.0;
    final right = size.width - 16.0;

    // Staff lines (5 lines)
    for (int i = 0; i < 5; i++) {
      final y = bottomY - i * lineSpacing;
      canvas.drawLine(Offset(left, y), Offset(right, y), paint);
    }

    // Clef symbol
    final clef = note?.clef ?? ClefMode.treble;
    final clefText = _clefSymbol(clef);
    final clefPainter = TextPainter(
      text: TextSpan(
        text: clefText,
        style: TextStyle(
          color: Colors.black,
          fontSize: lineSpacing * (clef == ClefMode.bass ? 4.4 : 3.6),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    // Align clef: Treble on G line (2nd line), Bass on F line (4th line).
    final targetLineIndex = clef == ClefMode.bass ? 3 : 1;
    final targetY = bottomY - targetLineIndex * lineSpacing;

    // Bass clef anchor centers dots on F line; treble curl sits on G line.
    final anchorFactor = clef == ClefMode.bass ? 0.36 : 0.62;
    final clefOffset = Offset(
      left - 6, // small left shift to overlap staff nicely
      targetY - clefPainter.height * anchorFactor,
    );
    clefPainter.paint(canvas, clefOffset);

    if (note == null) return;

    final noteX = left + 70;
    final offset = _staffOffset(note!);
    final noteY = bottomY - offset * (lineSpacing / 2);
    final headWidth = lineSpacing * 1.2;
    final headHeight = lineSpacing * 0.9;

    // Ledger lines for out-of-staff notes
    _drawLedgerLines(
        canvas, paint, bottomY, noteX, headWidth, offset, left, right);

    // Note head
    final headRect = Rect.fromCenter(
      center: Offset(noteX, noteY),
      width: headWidth,
      height: headHeight,
    );
    canvas.drawOval(headRect, paint);

    // Stem direction: above middle line => stem down
    final stemUp = offset <= 4;
    final stemLength = lineSpacing * 3.5;
    if (stemUp) {
      final start = Offset(noteX + headWidth / 2, noteY);
      final end = Offset(start.dx, noteY - stemLength);
      canvas.drawLine(start, end, paint);
    } else {
      final start = Offset(noteX - headWidth / 2, noteY);
      final end = Offset(start.dx, noteY + stemLength);
      canvas.drawLine(start, end, paint);
    }
  }

  void _drawLedgerLines(Canvas canvas, Paint paint, double bottomY, double noteX,
      double headWidth, int offset, double left, double right) {
    final lineLength = headWidth * 1.8;
    final usableLeft = (noteX - lineLength / 2).clamp(left, right - lineLength);
    final usableRight = usableLeft + lineLength;
    if (offset > 8) {
      for (int o = 10; o <= offset; o += 2) {
        final y = bottomY - o * (lineSpacing / 2);
        canvas.drawLine(Offset(usableLeft, y), Offset(usableRight, y), paint);
      }
    }
    if (offset < 0) {
      for (int o = -2; o >= offset; o -= 2) {
        final y = bottomY - o * (lineSpacing / 2);
        canvas.drawLine(Offset(usableLeft, y), Offset(usableRight, y), paint);
      }
    }
  }

  int _staffOffset(MusicNote note) {
    final referenceIndex = note.clef == ClefMode.treble
        ? _diatonicIndex('E', 4) // Treble bottom line
        : _diatonicIndex('G', 2); // Bass bottom line
    final noteIndex = _diatonicIndex(note.step, note.octave);
    return noteIndex - referenceIndex;
  }

  int _diatonicIndex(String step, int octave) {
    final idx = _stepIndex[step] ?? 0;
    return octave * 7 + idx;
  }

  String _clefSymbol(ClefMode clef) {
    switch (clef) {
      case ClefMode.treble:
        return '𝄞';
      case ClefMode.bass:
        return '𝄢';
      case ClefMode.both:
        return '𝄞';
    }
  }

  @override
  bool shouldRepaint(covariant StaffPainter oldDelegate) {
    return oldDelegate.note != note;
  }
}
