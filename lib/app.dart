import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/app_settings.dart';
import 'screens/practice_screen.dart';
import 'screens/settings_screen.dart';
import 'services/note_generator.dart';
import 'services/practice_controller.dart';
import 'services/settings_store.dart';

class PinanoApp extends StatelessWidget {
  const PinanoApp({
    super.key,
    required this.settingsStore,
    required this.noteGenerator,
    required this.initialSettings,
  });

  final SettingsStore settingsStore;
  final NoteGenerator noteGenerator;
  final AppSettings initialSettings;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PracticeController(
            settingsStore: settingsStore,
            noteGenerator: noteGenerator,
            initialSettings: initialSettings,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Pinano Note Practice',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        ),
        home: const PracticeScreen(),
        routes: {
          SettingsScreen.routeName: (_) => const SettingsScreen(),
        },
      ),
    );
  }
}
