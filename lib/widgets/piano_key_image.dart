import 'package:flutter/material.dart';

class PianoKeyImage extends StatelessWidget {
  const PianoKeyImage({
    super.key,
    required this.isBlack,
    required this.label,
  });

  final bool isBlack;
  final String label;

  @override
  Widget build(BuildContext context) {
    final height = 120.0;
    final width = isBlack ? 60.0 : 70.0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: width,
          height: height,
          child: CustomPaint(
            painter: _KeyPainter(isBlack: isBlack),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _KeyPainter extends CustomPainter {
  _KeyPainter({required this.isBlack});
  final bool isBlack;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(6));
    final bg = Paint()
      ..color = isBlack ? Colors.black87 : Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawRRect(rrect, bg);

    final stroke = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRRect(rrect, stroke);

    if (!isBlack) {
      final shadow = Paint()
        ..shader = LinearGradient(
          colors: [Colors.grey.shade200, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(rect);
      canvas.drawRRect(rrect.deflate(2), shadow);
    }
  }

  @override
  bool shouldRepaint(covariant _KeyPainter oldDelegate) => false;
}
