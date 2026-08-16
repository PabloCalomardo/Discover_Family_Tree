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

Estructura implementada fins a la fase 5:

```text
lib/
│
├── app/
├── components/
│
├── core/
│   ├── errors/
│   ├── ids/
│   ├── dates/
│   └── utils/
│
├── database/
│   ├── tables/
│   ├── mappers/
│   ├── repositories/
│   └── migrations/
│
├── domain/
│   ├── person/
│   ├── relationship/
│   ├── place/
│   └── event/
│
├── services/
│   ├── kinship/
│   ├── person/
│   ├── place/
│   ├── event/
│   └── project/
│
└── features/
    ├── home/
    ├── people/
    ├── family_tree/
    └── places/
```

La fase 6 afegeix `domain/source`, `domain/claim`, `domain/duplicate`,
`domain/audit`, `services/merge`, `services/source`, `services/claim`,
`services/duplicate` i les features `sources` i `review`. Importació,
extracció i transcripció continuen reservades a les fases 7 i 8.

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

Implementació de fase 6:

- `PersonMergeRepository.preview` detecta autorelacions i cicles abans del
  commit;
- l'usuari escull supervivent i resol cada camp amb A, B o un valor
  personalitzat;
- noms, residències, participants, claims i candidates es reassocien;
- relacions exactament duplicades o invàlides es retiren només després de
  convertir-les en claims;
- el commit comprova els `modifiedAt`, s'executa en una sola transacció i crea
  una entrada d'auditoria detallada.

## 10. Possible duplicates

Model implementat:

```text
DuplicateCandidate
- personAId
- personBId
- confidence
- reasonCodes
- detectorVersion
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
Les claims poden proposar tant valors escalars com operacions no destructives:
crear persones o llocs i crear filiacions, parelles, residències o
esdeveniments. L'acció explícita «Accepta i aplica» materialitza l'operació una
sola vegada i genera auditoria.

## 14. Media

Els fitxers físics es desen al contenidor del projecte.

SQLite només desa metadata i ruta relativa.

S'han de calcular checksums per detectar duplicats i corrupció.

## 15. Extracció i Candidate Changes

Cap sortida d'extracció es converteix directament en entitats definitives.

Tipus previstos:

```text
CandidatePerson
CandidatePlace
CandidateRelationship
CandidateResidence
CandidateEvent
```

Flux actiu de la fase 7:

```text
Text o transcripció enganxada
  ↓
Patrons catalans explícits
  ↓
Candidats tipats amb evidència i offsets
  ↓
Resolució exacta i única d'entitats
  ↓
Verificació visual del text ressaltat
  ↓
Revisió humana
  ↓
Creació transaccional de claims pendents
```

`DeterministicExtractionProvider` no usa xarxa, models, memòria ni
persistència. Els patrons només reconeixen construccions explícites; una dada
no reconeguda s'omet en lloc d'inferir-la. `EvidenceSpan` conserva offsets
`[start, end)` sobre el text original i una categoria de color.

`ExtractionRequest.narratorName` permet identificar explícitament la persona
quan el text usa «jo», «els meus» o construccions equivalents sense dir-ne el
nom. Si falta, es crea un candidat contextual `requiresName` que permet mostrar
l'estructura detectada però bloqueja el mapatge de claims dependents.

El catàleg inicial cobreix noms de narrador, mare/pare individuals, parelles de
pares, llistes de germans, avis per branca, besavis, matrimonis, naixements,
residències i mencions de fills o nets sense nom. Aquestes últimes només generen
ambigüitats. Cada persona obté un color HSL estable i diferent dins del resultat.

Les germanors explícites no requereixen progenitors coneguts. Es materialitzen
com `SiblingRelationship`, una relació simètrica canonitzada, i conviuen amb la
germanor derivada de progenitors compartits. L'extractor genera
`ClaimProperty.siblingRelationship`; queda prohibit crear progenitors ficticis
per satisfer una limitació del graf.

L'eliminació múltiple de persones és una única operació transaccional i
auditada. Fa soft-delete dels noms i de totes les dependències relacionals
actives: filiacions, germanors, parelles, residències i participacions en
esdeveniments. Un esdeveniment compartit es conserva; només es marca eliminat
si queda sense cap participant actiu. Les claims, aplicacions de claims i
entrades d'auditoria no s'esborren, perquè formen part de la traçabilitat. Els
candidats de duplicat que apunten a persones eliminades passen a `dismissed`.

Els controllers de text de diàlegs amb animació de ruta pertanyen a l'estat del
mateix diàleg. No es destrueixen immediatament després que `showDialog` retorni,
ja que la ruta encara es pot reconstruir mentre finalitza la seva animació.

El subjecte principal també es pot identificar en tercera persona a partir
d'una presentació explícita (`La Maria Soler Puig és...`). Els possessius
posteriors (`els seus pares`), les repeticions del nom, `la parella` i les
llistes de fills es resolen contra aquest subjecte. Els articles catalans només
es retiren quan són tokens independents o elidits; per tant, noms com `Laura`
no es trunquen i formes com `l’Anna` es reconeixen correctament.

Una edat explícita (`78 anys`) genera un `CandidateEvent` de naixement incert.
La data de referència forma part d'`ExtractionRequest`; si no s'indica, és la
data UTC de l'anàlisi. El rang compatible va des de l'endemà de restar
`edat + 1` anys fins al dia de restar `edat` anys. Així, el 16/08/2026, 78 anys
produeix 17/08/1947–16/08/1948 i es presenta com `1947–1948 (inferit de 78
anys)`. El fragment numèric queda marcat com a evidència temporal.

`EntityResolutionService` només resol una coincidència textual exacta quan és
única. Zero coincidències implica una proposta de creació; més d'una
coincidència bloqueja el candidat i les seves dependències.

La navegació de formularis usa `popOrGo`: torna amb `pop` si existeix una pila
de navegació i, si la ruta s'ha obert amb `go`, navega a un fallback explícit.
Els diàlegs continuen tancant-se amb `Navigator.pop` perquè disposen de ruta
modal pròpia.

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

## 17. Sortida d'extracció

Contracte tipat actual:

```text
ExtractionResult
  text
  people[]
  places[]
  relationships[]
  residences[]
  events[]
  evidenceSpans[]
  ambiguities[]
```

La UI consumeix aquest contracte mitjançant `TextExtractionController`; cap
widget accedeix a Drift. `ExtractionClaimMapper` ordena primer les dependències
de persona i lloc i després les relacions, residències i esdeveniments.

## 18. Fitxer `.famhistory`

`manifest.json` ha de contenir com a mínim:

```json
{
  "format": "famhistory",
  "formatVersion": 1,
  "projectId": "uuid",
  "name": "Nom del projecte",
  "createdAt": "ISO-8601",
  "modifiedAt": "ISO-8601",
  "appVersion": "1.0.0+1",
  "databaseSchemaVersion": 6,
  "media": [
    {
      "path": "media/images/retrat.jpg",
      "sha256": "hexadecimal SHA-256",
      "size": 12345
    }
  ]
}
```

La versió 1 usa un contenidor ZIP. En desar es crea una instantània consistent
de SQLite amb `VACUUM INTO`, es calculen tots els checksums i se substitueix la
destinació mitjançant un fitxer temporal. En obrir es rebutgen versions futures,
rutes insegures, fitxers obligatoris absents i media amb checksum o mida
incorrectes abans de desempaquetar el projecte al seu espai de treball local.

Flux implementat:

```text
Nou / Obrir
  ↓
Validar i preparar espai de treball local
  ↓
Obrir database.sqlite amb Drift
  ↓
Editar localment
  ↓
Desar / Desar com / Backup
  ↓
Instantània SQLite + manifest + media → .famhistory
```

L'obertura no activa el nou projecte fins que manifest, versió, estructura i
checksums són vàlids. El fitxer històric anterior es conserva durant la
migració inicial.

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

El backup manual crea un contenidor complet sense canviar la ruta principal de
desament del projecte actiu.

## 20. UI desktop

Navegació implementada:

```text
Inici
Arbre
Persones
Llocs
Fonts
Revisió
```

La pantalla d'inici inclou resum de dades i les operacions `Nou projecte`,
`Obrir`, `Desar`, `Desar com` i `Crear backup`.

Navegació prevista per a fases posteriors:

```text
Història
Mapa
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
