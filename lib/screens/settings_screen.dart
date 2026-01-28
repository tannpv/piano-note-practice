import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_settings.dart';
import '../models/clef.dart';
import '../models/range_preset.dart';
import '../services/practice_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PracticeController>();
    final settings = controller.settings;

    void update(AppSettings updated) {
      controller.updateSettings(updated);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Section(
            title: 'Clef Mode',
            subtitle:
                'Both selects treble or bass randomly for each new note.',
            child: DropdownButton<ClefMode>(
              value: settings.clefMode,
              isExpanded: true,
              onChanged: (mode) {
                if (mode != null) {
                  update(settings.copyWith(clefMode: mode));
                }
              },
              items: ClefMode.values
                  .map((c) => DropdownMenuItem(
                        value: c,
                        child: Text(c.label),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 12),
          _Section(
            title: 'Range Preset',
            child: DropdownButton<RangePreset>(
              value: settings.rangePreset,
              isExpanded: true,
              onChanged: (preset) {
                if (preset != null) {
                  update(settings.copyWith(rangePreset: preset));
                }
              },
              items: RangePreset.values
                  .map((r) => DropdownMenuItem(
                        value: r,
                        child: Text(r.label),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 12),
          _Section(
            title: 'Display Duration (${settings.displaySeconds.toStringAsFixed(1)}s)',
            child: Slider(
              value: settings.displaySeconds,
              min: 0.5,
              max: 10,
              divisions: 19,
              label: settings.displaySeconds.toStringAsFixed(1),
              onChanged: (v) => update(settings.copyWith(displaySeconds: v)),
            ),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            title: const Text('Accidentals (sharps) ON'),
            value: settings.accidentalsEnabled,
            onChanged: (v) => update(settings.copyWith(accidentalsEnabled: v)),
          ),
          SwitchListTile(
            title: const Text('Sound on'),
            value: settings.soundEnabled,
            onChanged: (v) => update(settings.copyWith(soundEnabled: v)),
          ),
          SwitchListTile(
            title: const Text('Avoid immediate repeats'),
            value: settings.avoidRepeats,
            onChanged: (v) => update(settings.copyWith(avoidRepeats: v)),
          ),
          SwitchListTile(
            title: const Text('Show piano keyboard highlight'),
            value: settings.showKeyboard,
            onChanged: (v) => update(settings.copyWith(showKeyboard: v)),
          ),
          const SizedBox(height: 12),
          const Text(
            'Ranges:\n- Beginner: Treble C4–A5, Bass E2–C4\n- Intermediate: Treble A3–C6, Bass C2–E4\n- Advanced: Treble E3–C7, Bass A1–G4',
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.child,
    this.subtitle,
  });

  final String title;
  final Widget child;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
        ],
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
