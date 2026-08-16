# FamilyHistory — Stack Tecnològic

## Stack principal

### Framework

**Flutter 3.47.0 (stable)**

Llenguatge principal: **Dart 3.13.0**.

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

**Drift 2.34.3** amb **drift_flutter 0.3.1**.

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

**Riverpod 3.4.2**, sense generació de codi, és la solució adoptada per a l'estat
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

**go_router 17.5.0** és la solució declarativa adoptada, compatible amb la navegació
desktop actual i una futura adaptació mobile.

## Fitxers de projecte

Format d'usuari:

```text
*.famhistory
```

Contingut intern implementat:

```text
manifest.json
database.sqlite
media/
  audio/
  images/
  documents/
thumbnails/
```

El contenidor està implementat com a ZIP mitjançant `archive`. `file_selector`
proporciona els diàlegs natius d'obrir i desar, i `crypto` calcula els checksums
SHA-256 dels fitxers multimèdia.

El projecte actiu s'extrau a un espai de treball dins del directori de suport de
l'aplicació. Drift obre el `database.sqlite` d'aquell espai. En canviar de
projecte es reconstrueixen els providers i repositories sobre la nova base.

En desar, `VACUUM INTO` produeix una instantània SQLite consistent. El ZIP es
genera primer en un fitxer temporal i només després substitueix la destinació.
La primera execució copia la base històrica de `Documents` sense eliminar-la.

## Media

Els fitxers d'àudio, imatge i document no s'han de desar com BLOB a SQLite.

SQLite només conserva:

- ruta relativa;
- MIME type;
- nom original;
- checksum;
- mida;
- metadata.

Des de l'schema 4, la metadata es cataloga a `media`, els fitxers importats es
copien amb una ruta gestionada per UUID i la relació amb fonts es conserva a
`source_media`. Les imatges poden generar una miniatura derivada dins
`thumbnails/`. El checksum i la mida permeten reutilitzar contingut idèntic.

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

**graphview 1.5.1**, amb una projecció i un layout genealògic ortogonal propis
sobre les primitives de GraphView, és el motor de renderitzat
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

Cobertura implementada:

```text
Unitària → domini, dates, parentesc i validacions
Integració → Drift, migracions, repositories i format .famhistory
Widgets → fluxos CRUD i arbre familiar
```

Prioritat alta:

- `HistoricalDate`;
- `KinshipService`;
- validació de cicles;
- migracions;
- merges;
- importació IA.

Cobertura afegida durant la fase 6:

- migracions 1, 2, 3 i 4 cap a schema 5;
- models i repositories de fonts, media, claims, duplicats i auditoria;
- detecció de contradiccions;
- detector determinista de duplicats;
- merge transaccional, relacions bloquejants i claims de preservació;
- rebuig de projectes amb schemas SQLite futurs;
- creació de fonts des de la UI.

Estat verificat en tancar la fase 5:

- `flutter analyze` sense incidències;
- 47 proves superades;
- compilació Windows release correcta;
- proves específiques de manifest, ZIP, checksums, extracció segura, migració,
  canvi de projecte i backup.

Estat verificat durant la fase 6 el 2026-08-16:

- `flutter analyze` sense incidències;
- 73 proves superades;
- compilació Windows release correcta;
- schema intern 5 i format `.famhistory` v1;
- la fase continua en curs pendent de validació funcional de l'usuari.

## Dependències d'infraestructura local

- `path_provider 2.1.6`: directoris de dades i suport de l'aplicació.
- `path 1.9.1`: composició portable de rutes.
- `uuid 4.6.0`: identificadors globals.
- `archive 4.0.9`: contenidor ZIP `.famhistory`.
- `crypto 3.0.7`: SHA-256.
- `file_selector 1.1.0`: diàlegs natius d'obrir i desar.

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
