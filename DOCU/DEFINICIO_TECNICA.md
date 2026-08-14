# FamilyHistory — Definició Tècnica

## 1. Arquitectura general

```text
┌─────────────────────────────────────────────┐
│                  Flutter UI                 │
│                                             │
│ Family Tree · People · Places · Timeline    │
│ Sources · Import · Review · Map             │
└─────────────────────┬───────────────────────┘
                      │
                Application Layer
                      │
┌─────────────────────▼───────────────────────┐
│                  Domain                     │
│                                             │
│ Person                                      │
│ Relationship                                │
│ Place                                       │
│ Residence                                   │
│ Event                                       │
│ Source                                      │
│ Claim                                       │
└─────────────────────┬───────────────────────┘
                      │
               Repository Layer
                      │
┌─────────────────────▼───────────────────────┐
│                  Drift                      │
│                    ↓                        │
│                  SQLite                     │
└─────────────────────────────────────────────┘
```

Pipeline IA independent:

```text
Audio
  ↓
TranscriptionProvider
  ↓
Transcript
  ↓
ExtractionProvider
  ↓
Candidate Changes
  ↓
Entity Resolution
  ↓
Human Review
  ↓
Domain Services
  ↓
Repositories
```

## 2. Regles arquitectòniques

- `domain/` no depèn de Flutter widgets.
- `domain/` no depèn del proveïdor d'IA.
- La UI no coneix detalls d'SQLite.
- Els repositories són la frontera entre domini/aplicació i persistència.
- Les operacions complexes passen per serveis de domini.
- Les migracions SQLite han d'estar versionades.
- Les dades de projecte no depenen de cap backend.

## 3. Estructura de carpetes

```text
lib/
│
├── app/
│   ├── app.dart
│   ├── router.dart
│   └── theme/
│
├── core/
│   ├── errors/
│   ├── ids/
│   ├── dates/
│   └── utils/
│
├── database/
│   ├── database.dart
│   ├── tables/
│   ├── daos/
│   └── migrations/
│
├── domain/
│   ├── person/
│   ├── relationship/
│   ├── place/
│   ├── event/
│   ├── source/
│   └── claim/
│
├── services/
│   ├── kinship/
│   ├── merge/
│   ├── import/
│   ├── extraction/
│   └── transcription/
│
└── features/
    ├── home/
    ├── people/
    ├── family_tree/
    ├── places/
    ├── map/
    ├── timeline/
    ├── sources/
    ├── import/
    ├── review/
    └── settings/
```

## 4. Repository Pattern

Exemple:

```dart
abstract interface class PersonRepository {
  Future<Person?> get(PersonId id);
  Stream<List<Person>> watchAll();
  Future<void> create(Person person);
  Future<void> update(Person person);
  Future<void> delete(PersonId id);
}
```

La implementació SQLite serà independent del contracte:

```text
PersonRepository
      ↑
DriftPersonRepository
```

## 5. HistoricalDate

No utilitzar `DateTime?` directament per representar dates històriques.

Tipus conceptuals:

```text
EXACT_DAY
MONTH
YEAR
RANGE
APPROXIMATE
BEFORE
AFTER
UNKNOWN
```

Ha de poder representar:

- 12/04/1912.
- abril de 1912.
- 1912.
- cap al 1912.
- entre 1910 i 1915.
- abans de 1932.
- després de 1900.
- data desconeguda.

## 6. Kinship Engine

Contracte conceptual:

```dart
class KinshipService {
  Future<List<KinshipPath>> getKinship(
    PersonId source,
    PersonId target,
  );
}
```

Una parella de persones pot tenir múltiples camins de parentesc simultanis.

Exemple:

```text
Joan → Marc

PARE ADOPTIU
TIET BIOLÒGIC
```

El motor ha de derivar parentescos a partir del graf de relacions primitives.

No s'han de persistir relacions derivables com `GRANDFATHER_OF` quan es poden calcular.

## 7. Adopcions

Una relació parent-child té naturalesa:

```text
BIOLOGICAL
ADOPTIVE
```

Poden coexistir diferents camins.

La UI ha de:

- mostrar totes les relacions rellevants;
- prioritzar visualment l'adoptiva quan sigui pertinent;
- diferenciar adoptiva i biològica amb estil visual diferent.

## 8. Validacions familiars

S'ha de prevenir:

- una persona com a propi pare/mare;
- duplicat exacte de la mateixa relació;
- cicles impossibles de parentatge.

Exemple prohibit:

```text
A parent of B
B parent of C
C parent of A
```

## 9. Merge de persones

Cap merge és automàtic.

Flux:

```text
Person A + Person B
  ↓
Comparació
  ↓
Resolució camp per camp
  ↓
Resolució de relacions
  ↓
Merge transaccional
  ↓
AuditEntry
```

Cal permetre:

- seleccionar valor A;
- seleccionar valor B;
- conservar múltiples valors quan tingui sentit;
- transformar discrepàncies en claims contradictòries;
- conservar totes les relacions no duplicades.

## 10. Possible duplicates

Model conceptual:

```text
DuplicateCandidate
- personAId
- personBId
- confidence
- reason
- status
```

Estats:

```text
PENDING
SAME_PERSON
DIFFERENT_PERSON
DISMISSED
```

La IA pot suggerir, però l'usuari decideix.

## 11. Soft delete

Les entitats principals han de suportar `deletedAt` quan sigui adequat.

Eliminar des de UI no implica necessàriament `DELETE FROM` immediat.

## 12. Audit

Model conceptual:

```text
AuditEntry
- id
- type
- timestamp
- payload
```

Operacions mínimes a registrar:

```text
PERSON_CREATED
PERSON_UPDATED
PERSON_MERGED
RELATIONSHIP_CREATED
RELATIONSHIP_DELETED
```

## 13. Fonts i Claims

Separació obligatòria entre:

```text
REALITAT ACCEPTADA
```

i

```text
EL QUE UNA FONT AFIRMA
```

Pipeline:

```text
Source
  ↓
Claim
  ↓
Accepted / Disputed Domain Data
```

Això permet mantenir contradiccions històriques sense sobreescriure informació.

## 14. Media

Els fitxers físics es desen al contenidor del projecte.

SQLite només desa metadata i ruta relativa.

S'han de calcular checksums per detectar duplicats i corrupció.

## 15. IA i Candidate Changes

La sortida IA mai es converteix directament en entitats definitives.

Tipus previstos:

```text
CandidatePerson
CandidatePlace
CandidateRelationship
CandidateResidence
CandidateEvent
CandidateClaim
```

Flux:

```text
LLM JSON
  ↓
Schema validation
  ↓
Domain validation
  ↓
Entity resolution
  ↓
Human review
  ↓
Transactional commit
```

## 16. Contractes de providers

### Transcripció

```dart
abstract interface class TranscriptionProvider {
  Future<Transcript> transcribe(AudioFile audio);
}
```

### Extracció

```dart
abstract interface class ExtractionProvider {
  Future<ExtractionResult> extract(
    ExtractionRequest request,
  );
}
```

## 17. Sortida LLM

Format conceptual:

```json
{
  "entities": [],
  "relationships": [],
  "events": [],
  "residences": [],
  "claims": [],
  "ambiguities": []
}
```

L'LLM no pot retornar instruccions SQL.

## 18. Fitxer `.famhistory`

`manifest.json` ha de contenir com a mínim:

```json
{
  "format": "famhistory",
  "formatVersion": 1,
  "projectId": "uuid",
  "name": "Nom del projecte",
  "createdAt": "ISO-8601",
  "modifiedAt": "ISO-8601"
}
```

Versions independents:

```text
App Version
Database Schema Version
FamilyHistory Format Version
```

## 19. Backup

S'ha de poder generar una còpia completa del projecte sense backend.

Exemple:

```text
familia-puig_2026-08-14.famhistory
```

## 20. UI desktop inicial

Navegació prevista:

```text
Inici
Arbre
Persones
Llocs
Història
Mapa
Fonts
Importar
Configuració
```

## 21. UI mobile

La UI mobile no ha de ser una sidebar comprimida.

S'ha de crear una navegació adaptada a pantalla petita mantenint domini i dades compartits.

## 22. Definition of Done tècnica

Una feature no es considera finalitzada si:

- no té validacions necessàries;
- viola fronteres arquitectòniques;
- no té tests en lògica de domini rellevant;
- introdueix canvis DB sense migració;
- permet a IA modificar dades directament;
- perd informació en merges o conflictes.
