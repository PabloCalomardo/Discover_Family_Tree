# FamilyHistory

Aplicació local-first per capturar, estructurar, preservar i explorar història
familiar.

## Entorn de desenvolupament

- Flutter 3.47.0 (stable)
- Dart 3.13.0
- Target actiu de desenvolupament: Windows
- Target de validació final de l'MVP: macOS
- Persistència: SQLite mitjançant Drift
- Schema SQLite intern actual: 5
- Format de projecte: `.famhistory` v1 compatible amb ZIP
- Fases 0–6: completades
- Fase 7 — IA: importació de text: en curs

L'identificador provisional de l'organització és `com.familyhistory`.

> **Idioma de la UI durant l'MVP:** català. Cap formulari ha de mostrar noms
> interns d'enums ni etiquetes en anglès; la internacionalització queda per a
> una fase posterior.

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

## Executar a Windows

```text
flutter run -d windows
```

La pantalla d'inici permet crear, obrir, desar i fer backups de projectes
`.famhistory`. En la primera execució, la base local anterior es copia al nou
espai de treball i es conserva intacta com a mesura de seguretat.

## Projectes transportables

Cada `.famhistory` és un ZIP autocontingut amb `manifest.json`, una instantània
`database.sqlite`, media i miniatures. No necessita backend ni connexió a
Internet per copiar-se i obrir-se en una altra instal·lació compatible.

El manifest conserva separadament les versions del format, de l'aplicació i de
l'schema SQLite. Els fitxers multimèdia i les miniatures es verifiquen amb
SHA-256 abans d'activar un projecte obert.

La fase 6 incorpora fonts bibliogràfiques, media catalogada fora d'SQLite,
claims d'operacions tipades i contradictòries, aplicació idempotent de canvis,
detecció determinista de duplicats, merge
manual camp per camp i auditoria append-only. La UI disposa de les seccions
`Fonts` i `Revisió`.

## Estat verificat

- `flutter analyze`: cap incidència.
- 99 proves superades.
- Build Windows release generat correctament amb schema 6.
- Fase 6 completada amb validació funcional explícita el 2026-08-16.
- Fase 7 iniciada. Prova reversible d'LLM local en curs: privacitat i rendiment
  local viables. Qwen3 0.6B, 1.7B i 4B no s'integren perquè cometen errors
  semàntics en filiacions, llocs i dates; el 4B només dona bon resultat en
  detecció d'entitats. Qwen2.5 3B també queda descartat per qualitat i llicència
  no comercial. Ministral 3 3B i Gemma 4 E2B també queden descartats: tots dos
  inverteixen filiacions, ometen llocs o residències i converteixen incertesa en
  fets. Cap model s'ha integrat. La implementació activa és un extractor
  determinista local amb patrons catalans explícits, evidència amb offsets,
  resolució exacta única i verificació visual del text abans de revisar les
  propostes. Checkpoint de l'experiment LLM:
  `phase-7-local-llm-experiment-start`.
