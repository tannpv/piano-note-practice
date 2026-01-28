import 'package:flutter/material.dart';

import '../models/music_note.dart';
import 'staff_painter.dart';

class StaffView extends StatelessWidget {
  const StaffView({super.key, required this.note});

  final MusicNote? note;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: CustomPaint(
        painter: StaffPainter(note: note),
      ),
    );
  }
}
