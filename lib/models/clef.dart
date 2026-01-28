enum ClefMode { treble, bass, both }

extension ClefModeLabel on ClefMode {
  String get label {
    switch (this) {
      case ClefMode.treble:
        return 'Treble';
      case ClefMode.bass:
        return 'Bass';
      case ClefMode.both:
        return 'Both';
    }
  }
}
