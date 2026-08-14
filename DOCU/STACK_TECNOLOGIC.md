# FamilyHistory — Stack Tecnològic

## Stack principal

### Framework

**Flutter**

Llenguatge principal: **Dart**.

Targets inicials:

- Windows.
- macOS.

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

Preferència inicial: **Riverpod**.

Aquesta decisió no és estructural i pot revisar-se abans d'implementar la UI.

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

Es recomana utilitzar una solució declarativa compatible amb desktop i mobile.

La selecció final es farà quan comenci la fase UI.

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

La llibreria o motor de layout no queda fixat encara.

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
