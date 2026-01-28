import 'package:flutter/material.dart';

import '../models/music_note.dart';
import 'staff_painter.dart';

class StaffView extends StatelessWidget {
  const StaffView({super.key, required this.notes, this.highlightIndex = 0});

  final List<MusicNote> notes;
  final int highlightIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: CustomPaint(
        painter: StaffPainter(notes: notes, highlightIndex: highlightIndex),
      ),
    );
  }
}
