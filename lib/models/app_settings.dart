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
    required this.soundEnabled,
    required this.scaleRoot,
    required this.scaleMode,
    required this.scaleOrdered,
  });

  final ClefMode clefMode;
  final RangePreset rangePreset;
  final double displaySeconds;
  final bool accidentalsEnabled;
  final bool avoidRepeats;
  final bool showKeyboard;
  final bool soundEnabled;
  final String scaleRoot;
  final String scaleMode;
  final bool scaleOrdered;

  static const AppSettings defaults = AppSettings(
    clefMode: ClefMode.both,
    rangePreset: RangePreset.beginner,
    displaySeconds: 2.0,
    accidentalsEnabled: false,
    avoidRepeats: true,
    showKeyboard: true,
    soundEnabled: true,
    scaleRoot: 'C',
    scaleMode: 'major',
    scaleOrdered: false,
  );

  AppSettings copyWith({
    ClefMode? clefMode,
    RangePreset? rangePreset,
    double? displaySeconds,
    bool? accidentalsEnabled,
    bool? avoidRepeats,
    bool? showKeyboard,
    bool? soundEnabled,
    String? scaleRoot,
    String? scaleMode,
    bool? scaleOrdered,
  }) {
    return AppSettings(
      clefMode: clefMode ?? this.clefMode,
      rangePreset: rangePreset ?? this.rangePreset,
      displaySeconds: displaySeconds ?? this.displaySeconds,
      accidentalsEnabled: accidentalsEnabled ?? this.accidentalsEnabled,
      avoidRepeats: avoidRepeats ?? this.avoidRepeats,
      showKeyboard: showKeyboard ?? this.showKeyboard,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      scaleRoot: scaleRoot ?? this.scaleRoot,
      scaleMode: scaleMode ?? this.scaleMode,
      scaleOrdered: scaleOrdered ?? this.scaleOrdered,
    );
  }

  Map<String, dynamic> toJson() => {
    'clefMode': clefMode.name,
    'rangePreset': rangePreset.name,
    'displaySeconds': displaySeconds,
    'accidentalsEnabled': accidentalsEnabled,
    'avoidRepeats': avoidRepeats,
    'showKeyboard': showKeyboard,
    'soundEnabled': soundEnabled,
    'scaleRoot': scaleRoot,
    'scaleMode': scaleMode,
    'scaleOrdered': scaleOrdered,
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
      displaySeconds:
          (json['displaySeconds'] as num?)?.toDouble() ??
          AppSettings.defaults.displaySeconds,
      accidentalsEnabled:
          json['accidentalsEnabled'] as bool? ??
          AppSettings.defaults.accidentalsEnabled,
      avoidRepeats:
          json['avoidRepeats'] as bool? ?? AppSettings.defaults.avoidRepeats,
      showKeyboard:
          json['showKeyboard'] as bool? ?? AppSettings.defaults.showKeyboard,
      soundEnabled:
          json['soundEnabled'] as bool? ?? AppSettings.defaults.soundEnabled,
      scaleRoot: json['scaleRoot'] as String? ?? AppSettings.defaults.scaleRoot,
      scaleMode: json['scaleMode'] as String? ?? AppSettings.defaults.scaleMode,
      scaleOrdered:
          json['scaleOrdered'] as bool? ?? AppSettings.defaults.scaleOrdered,
    );
  }
}
