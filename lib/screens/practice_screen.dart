import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/clef.dart';
import '../models/music_note.dart';
import '../services/practice_controller.dart';
import '../widgets/duration_progress.dart';
import '../widgets/piano_keyboard.dart';
import '../widgets/staff_view.dart';
import 'settings_screen.dart';

class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  String _solfege(MusicNote note) {
    const map = {
      'C': 'Do',
      'D': 'Re',
      'E': 'Mi',
      'F': 'Fa',
      'G': 'Sol',
      'A': 'La',
      'B': 'Ti',
    };
    final base = map[note.step] ?? note.step;
    return note.sharp ? '$base#' : base;
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PracticeController>();
    final note = controller.currentNote;
    final notes = controller.queue;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pinano Note Practice'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.of(context).pushNamed(SettingsScreen.routeName),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _ClefChips(),
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 4 / 3,
                  child: StaffView(
                    notes: notes,
                    highlightIndex: controller.highlightIndex,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (note != null)
              Text(
                note.displayName,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 12),
            DurationProgress(
              remainingSeconds: controller.remainingSeconds,
              totalSeconds: controller.settings.displaySeconds,
            ),
            const SizedBox(height: 12),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: controller.toggleRunning,
                  icon:
                      Icon(controller.isRunning ? Icons.pause : Icons.play_arrow),
                  label: Text(controller.isRunning ? 'Pause' : 'Start'),
                ),
                OutlinedButton.icon(
                  onPressed: controller.nextNote,
                  icon: const Icon(Icons.skip_next),
                  label: const Text('Next'),
                ),
                OutlinedButton.icon(
                  onPressed: () => Navigator.of(context)
                      .pushNamed(SettingsScreen.routeName),
                  icon: const Icon(Icons.settings),
                  label: const Text('Settings'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (controller.settings.showKeyboard)
              SizedBox(
                height: 160,
                width: double.infinity,
                child: PianoKeyboard(
                  currentNote: note,
                  showFingerHints: controller.settings.showFingerHints,
                ),
              ),
            if (note != null) ...[
              const SizedBox(height: 8),
              Text(
                'Key shown: ${note.displayName}  •  Solfège: ${_solfege(note)}  •  MIDI ${note.midiNoteNumber}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ClefChips extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PracticeController>();
    return Wrap(
      spacing: 8,
      children: [
        ChoiceChip(
          label: const Text('Treble (𝄞)'),
          selected: controller.settings.clefMode == ClefMode.treble,
          onSelected: (_) => controller.updateSettings(
            controller.settings.copyWith(clefMode: ClefMode.treble),
          ),
        ),
        ChoiceChip(
          label: const Text('Bass (𝄢)'),
          selected: controller.settings.clefMode == ClefMode.bass,
          onSelected: (_) => controller.updateSettings(
            controller.settings.copyWith(clefMode: ClefMode.bass),
          ),
        ),
        ChoiceChip(
          label: const Text('Both'),
          selected: controller.settings.clefMode == ClefMode.both,
          onSelected: (_) => controller.updateSettings(
            controller.settings.copyWith(clefMode: ClefMode.both),
          ),
        ),
      ],
    );
  }
}
