# FamilyHistory

Aplicació local-first per capturar, estructurar, preservar i explorar història
familiar.

## Entorn de desenvolupament

- Flutter 3.47.0 (stable)
- Dart 3.13.0
- Target actiu de desenvolupament: Windows
- Target de validació final de l'MVP: macOS
- Persistència: SQLite mitjançant Drift
- Schema SQLite intern actual: 3

L'identificador provisional de l'organització és `com.familyhistory`.

## Comprovacions

```text
flutter pub get
dart run build_runner build
dart format --set-exit-if-changed .
flutter analyze
flutter test
```

Per compilar plugins a Windows cal tenir activat el Mode de desenvolupador del
sistema. L'adaptació i execució a macOS es validaran durant les proves finals,
quan l'aplicació estigui acabada o en fase final.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
