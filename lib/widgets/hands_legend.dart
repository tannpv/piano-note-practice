import 'package:flutter/material.dart';

class HandsLegend extends StatelessWidget {
  const HandsLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        _HandLegend(
          label: 'Left hand',
          color: Colors.green,
          fingerOrder: '5 4 3 2 1',
        ),
        SizedBox(width: 16),
        _HandLegend(
          label: 'Right hand',
          color: Colors.blueAccent,
          fingerOrder: '1 2 3 4 5',
        ),
      ],
    );
  }
}

class _HandLegend extends StatelessWidget {
  const _HandLegend({
    required this.label,
    required this.color,
    required this.fingerOrder,
  });

  final String label;
  final Color color;
  final String fingerOrder;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withValues(alpha: 0.6)),
          ),
          child: Text(
            fingerOrder,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: color, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}
