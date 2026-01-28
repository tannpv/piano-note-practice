import 'package:flutter_test/flutter_test.dart';
import 'package:pinano_note_practice/models/app_settings.dart';
import 'package:pinano_note_practice/models/clef.dart';
import 'package:pinano_note_practice/models/range_preset.dart';

void main() {
  test('serializes and deserializes correctly', () {
    const settings = AppSettings(
      clefMode: ClefMode.both,
      rangePreset: RangePreset.advanced,
      displaySeconds: 3.5,
      accidentalsEnabled: true,
      avoidRepeats: false,
      showKeyboard: false,
      soundEnabled: true,
      scaleRoot: 'D',
      scaleMode: 'minor',
      scaleOrdered: true,
    );

    final json = settings.toJson();
    final restored = AppSettings.fromJson(json);

    expect(restored.clefMode, settings.clefMode);
    expect(restored.rangePreset, settings.rangePreset);
    expect(restored.displaySeconds, settings.displaySeconds);
    expect(restored.accidentalsEnabled, settings.accidentalsEnabled);
    expect(restored.avoidRepeats, settings.avoidRepeats);
    expect(restored.showKeyboard, settings.showKeyboard);
    expect(restored.scaleRoot, settings.scaleRoot);
    expect(restored.scaleMode, settings.scaleMode);
    expect(restored.scaleOrdered, settings.scaleOrdered);
  });

  test('defaults are used when json missing values', () {
    final restored = AppSettings.fromJson({});
    expect(restored.clefMode, AppSettings.defaults.clefMode);
    expect(restored.displaySeconds, AppSettings.defaults.displaySeconds);
  });
}
