import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_settings.dart';

class SettingsStore {
  static const _keyPrefix = 'pinano_settings_';

  Future<AppSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    final clefMode = prefs.getString('${_keyPrefix}clefMode');
    final rangePreset = prefs.getString('${_keyPrefix}rangePreset');
    final displaySeconds = prefs.getDouble('${_keyPrefix}displaySeconds');
    final accidentalsEnabled =
        prefs.getBool('${_keyPrefix}accidentalsEnabled');
    final avoidRepeats = prefs.getBool('${_keyPrefix}avoidRepeats');
    final showKeyboard = prefs.getBool('${_keyPrefix}showKeyboard');
    final soundEnabled = prefs.getBool('${_keyPrefix}soundEnabled');
    final scaleRoot = prefs.getString('${_keyPrefix}scaleRoot');
    final scaleMode = prefs.getString('${_keyPrefix}scaleMode');
    final scaleOrdered = prefs.getBool('${_keyPrefix}scaleOrdered');

    if (clefMode == null && rangePreset == null && displaySeconds == null) {
      return AppSettings.defaults;
    }

    return AppSettings.fromJson({
      'clefMode': clefMode,
      'rangePreset': rangePreset,
      'displaySeconds': displaySeconds,
      'accidentalsEnabled': accidentalsEnabled,
      'avoidRepeats': avoidRepeats,
      'showKeyboard': showKeyboard,
      'soundEnabled': soundEnabled,
      'scaleRoot': scaleRoot,
      'scaleMode': scaleMode,
      'scaleOrdered': scaleOrdered,
    });
  }

  Future<void> save(AppSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('${_keyPrefix}clefMode', settings.clefMode.name);
    await prefs.setString('${_keyPrefix}rangePreset', settings.rangePreset.name);
    await prefs.setDouble('${_keyPrefix}displaySeconds', settings.displaySeconds);
    await prefs.setBool(
        '${_keyPrefix}accidentalsEnabled', settings.accidentalsEnabled);
    await prefs.setBool('${_keyPrefix}avoidRepeats', settings.avoidRepeats);
    await prefs.setBool('${_keyPrefix}showKeyboard', settings.showKeyboard);
    await prefs.setBool('${_keyPrefix}soundEnabled', settings.soundEnabled);
    await prefs.setString('${_keyPrefix}scaleRoot', settings.scaleRoot);
    await prefs.setString('${_keyPrefix}scaleMode', settings.scaleMode);
    await prefs.setBool('${_keyPrefix}scaleOrdered', settings.scaleOrdered);
  }
}
