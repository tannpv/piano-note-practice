import 'package:flutter/material.dart';

class DurationProgress extends StatelessWidget {
  const DurationProgress({
    super.key,
    required this.remainingSeconds,
    required this.totalSeconds,
  });

  final double remainingSeconds;
  final double totalSeconds;

  @override
  Widget build(BuildContext context) {
    final value = totalSeconds == 0
        ? 0.0
        : (remainingSeconds.clamp(0, totalSeconds)) / totalSeconds;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LinearProgressIndicator(value: value),
        const SizedBox(height: 4),
        Text(
          'Time remaining: ${remainingSeconds.clamp(0, totalSeconds).toStringAsFixed(1)}s',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
