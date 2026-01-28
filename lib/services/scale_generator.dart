import 'dart:math';

class ScaleGenerator {
  static const Map<String, int> _noteToSemitone = {
    'C': 0,
    'C#': 1,
    'DB': 1,
    'D': 2,
    'D#': 3,
    'EB': 3,
    'E': 4,
    'F': 5,
    'F#': 6,
    'GB': 6,
    'G': 7,
    'G#': 8,
    'AB': 8,
    'A': 9,
    'A#': 10,
    'BB': 10,
    'B': 11,
  };

  static const List<int> majorIntervals = [2, 2, 1, 2, 2, 2, 1];
  static const List<int> minorIntervals = [2, 1, 2, 2, 1, 2, 2];

  /// Returns a list of note names (no octaves) for the given scale.
  static List<String> buildScale(String root, String mode) {
    final rootKey = root.trim().toUpperCase();
    final rootSemitone = _noteToSemitone[rootKey];
    if (rootSemitone == null) return [];
    final useFlats = rootKey.contains('B');
    final intervals = mode.toLowerCase() == 'minor'
        ? minorIntervals
        : majorIntervals;
    final semis = <int>[rootSemitone];
    int current = rootSemitone;
    for (final step in intervals.take(6)) {
      current = (current + step) % 12;
      semis.add(current);
    }
    return semis.map((s) => _semitoneToName(s, preferFlat: useFlats)).toList();
  }

  /// Randomly picks [count] notes from the specified scale (with repetition).
  static List<String> generateRandomPracticeNotes(
      String scaleMode, String root, int count) {
    final scale = buildScale(root, scaleMode);
    if (scale.isEmpty || count <= 0) return [];
    final rand = Random();
    return List<String>.generate(count, (_) => scale[rand.nextInt(scale.length)]);
  }

  static String _semitoneToName(int value, {bool preferFlat = false}) {
    value = value % 12;
    const sharpNames = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'];
    const flatNames = ['C', 'Db', 'D', 'Eb', 'E', 'F', 'Gb', 'G', 'Ab', 'A', 'Bb', 'B'];
    return preferFlat ? flatNames[value] : sharpNames[value];
  }
}
