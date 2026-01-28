import 'clef.dart';

class MusicNote {
  const MusicNote({
    required this.step,
    required this.octave,
    required this.sharp,
    required this.clef,
  });

  final String step; // A..G
  final int octave;
  final bool sharp;
  final ClefMode clef;

  static const _semitoneByStep = {
    'C': 0,
    'D': 2,
    'E': 4,
    'F': 5,
    'G': 7,
    'A': 9,
    'B': 11,
  };

  int get semitoneFromC => (_semitoneByStep[step] ?? 0) + (sharp ? 1 : 0);

  String get displayName => '$step${sharp ? '#' : ''}$octave';

  int get midiNoteNumber => 12 * (octave + 1) + semitoneFromC;

  @override
  String toString() => '${displayName}_$clef';
}
