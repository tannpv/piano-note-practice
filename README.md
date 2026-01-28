# Pinano Note Practice

A Flutter app for sight-reading practice: it shows a single staff note (treble or bass), cycles on a timer, and highlights the matching piano key.

## Run it
1) Install Flutter (stable channel).
2) From project root:
```
flutter pub get
flutter run
```

## Features
- Practice screen with staff rendering (custom painter), note name, countdown bar, start/pause/next controls.
- Treble, bass, or random (both) clef selection per note (quick chips on practice screen, defaults to Both).
- Timing slider 0.5–10s applied immediately while running.
- Range presets (Beginner/Intermediate/Advanced) matching provided note spans.
- Optional accidentals (sharps) and repeat-avoidance.
- Simple 2-octave piano keyboard with highlighted key, auto-centers around the current note.
- Settings persist locally via SharedPreferences.

## Tests
```
flutter test
```
(covers note generator logic and settings model serialization.)

## Future enhancements
- MIDI input to grade correctness.
- Session scoring and streak tracking.
- More clefs/ranges and flat naming toggle.
