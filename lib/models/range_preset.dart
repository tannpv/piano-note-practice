enum RangePreset { beginner, intermediate, advanced }

extension RangePresetLabel on RangePreset {
  String get label {
    switch (this) {
      case RangePreset.beginner:
        return 'Beginner';
      case RangePreset.intermediate:
        return 'Intermediate';
      case RangePreset.advanced:
        return 'Advanced';
    }
  }
}
