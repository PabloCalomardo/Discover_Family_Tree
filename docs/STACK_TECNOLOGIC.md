# FamilyHistory — Stack Tecnològic

## Stack principal

### Framework

**Flutter**

Llenguatge principal: **Dart**.

Targets inicials:

- Windows.
- macOS.

Windows és el target actiu durant el desenvolupament. El target macOS es genera
des de l'inici per mantenir la base multiplataforma, però la compilació,
adaptació nativa i validació s'ajornen fins a les proves finals de l'MVP.

Targets posteriors:

- iOS.
- Android.

## Persistència

### Base de dades

**SQLite local**.

No requereix:

- servidor de base de dades;
- backend;
- Docker;
- servei cloud;
- connexió a Internet.

La base de dades viu físicament al dispositiu de l'usuari.

### Capa Dart / SQLite

**Drift**.

Objectius:

- queries tipades;
- streams reactius;
- migracions;
- integració amb SQLite;
- mantenir SQL disponible quan sigui necessari.

## Identificadors

**UUID** per a totes les entitats de domini.

No s'han d'exposar IDs incrementals de base de dades com a identificadors globals.

## State management

**Riverpod**, sense generació de codi, és la solució adoptada per a l'estat
reactiu i la injecció de dependències de la UI.

Flux obligatori:

```text
Widget
  ↓
Controller / Notifier
  ↓
Service / Repository
  ↓
Drift
  ↓
SQLite
```

Els widgets no poden accedir directament a SQLite.

## Routing

**go_router** és la solució declarativa adoptada, compatible amb la navegació
desktop actual i una futura adaptació mobile.

## Fitxers de projecte

Format d'usuari:

```text
*.famhistory
```

Contingut intern previst:

```text
manifest.json
database.sqlite
media/
thumbnails/
```

El contenidor es pot implementar com un format comprimit compatible amb ZIP.

## Media

Els fitxers d'àudio, imatge i document no s'han de desar com BLOB a SQLite.

SQLite només conserva:

- ruta relativa;
- MIME type;
- nom original;
- checksum;
- mida;
- metadata.

## IA

Arquitectura per providers.

### Transcripció

```dart
abstract interface class TranscriptionProvider
```

Possibles implementacions futures:

- servei API extern;
- Whisper local;
- altres proveïdors.

### Extracció

```dart
abstract interface class ExtractionProvider
```

Possibles implementacions futures:

- OpenAI;
- Anthropic;
- Gemini;
- model local.

L'aplicació no ha de dependre del proveïdor concret a nivell de domini.

## Contracte IA

L'IA:

- rep text i context limitat;
- retorna JSON estructurat;
- no retorna SQL;
- no escriu a la DB;
- no executa merges.

## Geolocalització

`Place` desa:

```text
latitude
longitude
```

La llibreria concreta de mapes es decidirà en la fase corresponent.

## Family Tree

**graphview 1.5.1**, amb l'algoritme jeràrquic Sugiyama, és el motor de layout
adoptat per al Family Tree MVP. La projecció des del domini al graf visual es
manté en una capa pròpia per no acoblar les entitats de negoci a la llibreria.

Requisits mínims:

- zoom;
- pan;
- selecció;
- touch;
- desktop mouse;
- relacions biològiques/adoptives;
- múltiples camins de parentesc;
- branques complexes.

## Tests

Tipus previstos:

```text
unit/
integration/
widget/
```

Prioritat alta:

- `HistoricalDate`;
- `KinshipService`;
- validació de cicles;
- migracions;
- merges;
- importació IA.

## Backend

**No hi ha backend a l'MVP.**

Només serà necessari si en un futur s'afegeix:

- sincronització automàtica entre dispositius;
- multiusuari;
- col·laboració;
- autenticació cloud.

## Cost d'infraestructura MVP

Objectiu:

**0 €/mes**, sense comptar APIs externes opcionals.
