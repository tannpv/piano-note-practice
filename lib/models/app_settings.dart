import 'clef.dart';
import 'range_preset.dart';

class AppSettings {
  const AppSettings({
    required this.clefMode,
    required this.rangePreset,
    required this.displaySeconds,
    required this.accidentalsEnabled,
    required this.avoidRepeats,
    required this.showKeyboard,
    required this.showFingerHints,
    required this.soundEnabled,
  });

  final ClefMode clefMode;
  final RangePreset rangePreset;
  final double displaySeconds;
  final bool accidentalsEnabled;
  final bool avoidRepeats;
  final bool showKeyboard;
  final bool showFingerHints;
  final bool soundEnabled;

  static const AppSettings defaults = AppSettings(
    clefMode: ClefMode.both,
    rangePreset: RangePreset.beginner,
    displaySeconds: 2.0,
    accidentalsEnabled: false,
    avoidRepeats: true,
    showKeyboard: true,
    showFingerHints: true,
    soundEnabled: true,
  );

  AppSettings copyWith({
    ClefMode? clefMode,
    RangePreset? rangePreset,
    double? displaySeconds,
    bool? accidentalsEnabled,
    bool? avoidRepeats,
    bool? showKeyboard,
    bool? showFingerHints,
    bool? soundEnabled,
  }) {
    return AppSettings(
      clefMode: clefMode ?? this.clefMode,
      rangePreset: rangePreset ?? this.rangePreset,
      displaySeconds: displaySeconds ?? this.displaySeconds,
      accidentalsEnabled: accidentalsEnabled ?? this.accidentalsEnabled,
      avoidRepeats: avoidRepeats ?? this.avoidRepeats,
      showKeyboard: showKeyboard ?? this.showKeyboard,
      showFingerHints: showFingerHints ?? this.showFingerHints,
      soundEnabled: soundEnabled ?? this.soundEnabled,
    );
  }

  Map<String, dynamic> toJson() => {
        'clefMode': clefMode.name,
        'rangePreset': rangePreset.name,
        'displaySeconds': displaySeconds,
        'accidentalsEnabled': accidentalsEnabled,
        'avoidRepeats': avoidRepeats,
        'showKeyboard': showKeyboard,
        'showFingerHints': showFingerHints,
        'soundEnabled': soundEnabled,
      };

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      clefMode: ClefMode.values.firstWhere(
        (c) => c.name == json['clefMode'],
        orElse: () => AppSettings.defaults.clefMode,
      ),
      rangePreset: RangePreset.values.firstWhere(
        (r) => r.name == json['rangePreset'],
        orElse: () => AppSettings.defaults.rangePreset,
      ),
      displaySeconds: (json['displaySeconds'] as num?)?.toDouble() ??
          AppSettings.defaults.displaySeconds,
      accidentalsEnabled: json['accidentalsEnabled'] as bool? ??
          AppSettings.defaults.accidentalsEnabled,
      avoidRepeats:
          json['avoidRepeats'] as bool? ?? AppSettings.defaults.avoidRepeats,
      showKeyboard:
          json['showKeyboard'] as bool? ?? AppSettings.defaults.showKeyboard,
      showFingerHints: json['showFingerHints'] as bool? ??
          AppSettings.defaults.showFingerHints,
      soundEnabled:
          json['soundEnabled'] as bool? ?? AppSettings.defaults.soundEnabled,
    );
  }
}
