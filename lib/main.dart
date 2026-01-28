import 'package:flutter/material.dart';
import 'app.dart';
import 'services/note_generator.dart';
import 'services/settings_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final settingsStore = SettingsStore();
  final initialSettings = await settingsStore.load();
  final noteGenerator = NoteGenerator();

  runApp(PinanoApp(
    settingsStore: settingsStore,
    noteGenerator: noteGenerator,
    initialSettings: initialSettings,
  ));
}
