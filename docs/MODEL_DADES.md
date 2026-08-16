# FamilyHistory — Model de Dades

## 1. Principis

- UUID com a identificador de domini.
- Foreign keys actives.
- Soft delete on sigui apropiat.
- Dates històriques amb incertesa.
- Relacions familiars primitives persistides.
- Relacions derivades calculades.
- Media fora d'SQLite.
- Fonts i claims separats de les dades acceptades.

## 2. Estat de l'schema SQLite

L'schema intern actual és la **versió 6**.

Taules implementades:

```text
projects
persons
person_names
parent_child_relationships
sibling_relationships
partnerships
places
place_relationships
residences
events
event_participants
sources
media
source_media
claims
claim_applications
duplicate_candidates
audit_entries
audit_targets
```

Evolució aplicada:

```text
Schema 1 → projects
Schema 2 → domini familiar, llocs, residències i esdeveniments
Schema 3 → índexs i restriccions idempotents per a bases migrades
Schema 4 → fonts, media, claims, duplicats, merge i auditoria
Schema 5 → aplicació idempotent de claims d'operacions de domini
Schema 6 → germanors explícites simètriques i auditables
```

Taules previstes per a les fases 7 i 8:

```text
transcripts
transcript_segments
import_sessions
candidate_changes
```

## 3. projects

```text
id UUID PK
name TEXT NOT NULL
created_at DATETIME NOT NULL
modified_at DATETIME NOT NULL
deleted_at DATETIME NULL
```

Un `.famhistory` representa un univers de coneixement familiar, no una única branca.

## 4. persons

```text
id UUID PK
sex TEXT NOT NULL
birth_date_* HistoricalDate NULL
death_date_* HistoricalDate NULL
biography TEXT NULL
notes TEXT NULL
created_at DATETIME NOT NULL
modified_at DATETIME NOT NULL
deleted_at DATETIME NULL
```

Valors inicials de `sex`:

```text
MALE
FEMALE
INTERSEX
UNKNOWN
UNSPECIFIED
```

## 5. person_names

```text
id UUID PK
person_id UUID FK -> persons.id
given_names TEXT NULL
family_names TEXT NULL
display_name TEXT NOT NULL
type TEXT NOT NULL
is_preferred BOOLEAN NOT NULL DEFAULT FALSE
created_at DATETIME NOT NULL
modified_at DATETIME NOT NULL
deleted_at DATETIME NULL
```

Tipus:

```text
BIRTH
MARRIED
ALIAS
NICKNAME
OTHER
```

Regla recomanada:

- només un `is_preferred = true` actiu per persona.

## 6. HistoricalDate — representació

Representació lògica:

```text
precision
start_date
end_date
display_text
```

Valors de `precision`:

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

Pot implementar-se inicialment amb columnes prefixades a cada taula o amb un Value Converter/estructura pròpia a Drift.

## 7. parent_child_relationships

```text
id UUID PK
parent_person_id UUID FK -> persons.id
child_person_id UUID FK -> persons.id
nature TEXT NOT NULL
start_date_* HistoricalDate NULL
end_date_* HistoricalDate NULL
notes TEXT NULL
created_at DATETIME NOT NULL
modified_at DATETIME NOT NULL
deleted_at DATETIME NULL
```

`nature`:

```text
BIOLOGICAL
ADOPTIVE
```

Constraints:

```text
parent_person_id != child_person_id
```

Unicitat lògica:

```text
(parent_person_id, child_person_id, nature)
```

considerant només registres actius.

## 8. partnerships

```text
id UUID PK
person_a_id UUID FK -> persons.id
person_b_id UUID FK -> persons.id
type TEXT NOT NULL
start_date_* HistoricalDate NULL
end_date_* HistoricalDate NULL
place_id UUID NULL FK -> places.id
notes TEXT NULL
created_at DATETIME NOT NULL
modified_at DATETIME NOT NULL
deleted_at DATETIME NULL
```

Tipus:

```text
MARRIAGE
PARTNERSHIP
UNKNOWN
```

Regles:

```text
person_a_id != person_b_id
```

## 9. places

```text
id UUID PK
preferred_name TEXT NOT NULL
type TEXT NOT NULL
latitude REAL NULL
longitude REAL NULL
description TEXT NULL
notes TEXT NULL
created_at DATETIME NOT NULL
modified_at DATETIME NOT NULL
deleted_at DATETIME NULL
```

Tipus inicials:

```text
HOUSE
FARMHOUSE
APARTMENT
BUILDING
STREET
NEIGHBORHOOD
VILLAGE
TOWN
CITY
MUNICIPALITY
REGION
COUNTRY
CHURCH
CEMETERY
HOSPITAL
SCHOOL
WORKPLACE
OTHER
CUSTOM
```

## 10. place_relationships

```text
id UUID PK
source_place_id UUID FK -> places.id
target_place_id UUID FK -> places.id
type TEXT NOT NULL
created_at DATETIME NOT NULL
modified_at DATETIME NOT NULL
deleted_at DATETIME NULL
```

Tipus:

```text
LOCATED_IN
SAME_AS
PREVIOUSLY_KNOWN_AS
```

## 11. residences

```text
id UUID PK
person_id UUID FK -> persons.id
place_id UUID FK -> places.id
start_date_* HistoricalDate NULL
end_date_* HistoricalDate NULL
reason TEXT NULL
notes TEXT NULL
created_at DATETIME NOT NULL
modified_at DATETIME NOT NULL
deleted_at DATETIME NULL
```

Exemple:

```text
Jordi → Mas Puig
1912 → 1936
```

## 12. events

```text
id UUID PK
type TEXT NOT NULL
date_* HistoricalDate NULL
place_id UUID NULL FK -> places.id
title TEXT NULL
description TEXT NULL
created_at DATETIME NOT NULL
modified_at DATETIME NOT NULL
deleted_at DATETIME NULL
```

Tipus inicials:

```text
BIRTH
DEATH
MARRIAGE
SEPARATION
MOVE
BAPTISM
FUNERAL
EDUCATION
EMPLOYMENT
MILITARY
WAR
PURCHASE
SALE
INHERITANCE
TRAVEL
MIGRATION
CUSTOM
```

## 13. event_participants

```text
id UUID PK
event_id UUID FK -> events.id
person_id UUID FK -> persons.id
role TEXT NOT NULL
created_at DATETIME NOT NULL
modified_at DATETIME NOT NULL
deleted_at DATETIME NULL
```

Exemple de rols:

```text
SUBJECT
SPOUSE
WITNESS
PARENT
CHILD
OTHER
```

## 14. sources — implementat a l'schema 4

```text
id UUID PK
type TEXT NOT NULL
title TEXT NOT NULL
description TEXT NULL
source_date_* HistoricalDate NULL
creator TEXT NULL
repository_name TEXT NULL
reference_code TEXT NULL
original_location TEXT NULL
url TEXT NULL
accessed_at DATETIME NULL
notes TEXT NULL
created_at DATETIME NOT NULL
modified_at DATETIME NOT NULL
deleted_at DATETIME NULL
```

Tipus:

```text
INTERVIEW
DOCUMENT
PHOTO
LETTER
BOOK
REGISTRY
WEBSITE
PERSONAL_KNOWLEDGE
OTHER
```

## 15. media — implementat a l'schema 4

```text
id UUID PK
type TEXT NOT NULL
relative_path TEXT NOT NULL
mime_type TEXT NULL
original_filename TEXT NULL
checksum_sha256 TEXT NOT NULL
file_size INTEGER NOT NULL
created_at DATETIME NOT NULL
modified_at DATETIME NOT NULL
deleted_at DATETIME NULL
```

Tipus:

```text
AUDIO
IMAGE
DOCUMENT
OTHER
```

No desar el contingut binari a SQLite.

Els fitxers importats es copien a una ruta gestionada per UUID dins del
workspace. La combinació activa `checksum_sha256 + file_size` és única i
permet reutilitzar un mateix contingut sense duplicar-lo. Les miniatures són
fitxers derivats a `thumbnails/` i no BLOBs.

## 16. source_media — implementat a l'schema 4

```text
id UUID PK
source_id UUID FK -> sources.id
media_id UUID FK -> media.id
role TEXT NOT NULL
caption TEXT NULL
sort_order INTEGER NOT NULL DEFAULT 0
created_at DATETIME NOT NULL
modified_at DATETIME NOT NULL
deleted_at DATETIME NULL
```

`role`: `PRIMARY`, `ATTACHMENT` o `SUPPLEMENT`. La parella activa
`(source_id, media_id)` és única.

## 17. transcripts — previst per a la fase 8

```text
id UUID PK
source_id UUID FK -> sources.id
language TEXT NULL
text TEXT NOT NULL
transcription_provider TEXT NULL
provider_model TEXT NULL
created_at DATETIME NOT NULL
modified_at DATETIME NOT NULL
deleted_at DATETIME NULL
```

## 18. transcript_segments — previst per a la fase 8

```text
id UUID PK
transcript_id UUID FK -> transcripts.id
start_ms INTEGER NOT NULL
end_ms INTEGER NOT NULL
speaker TEXT NULL
text TEXT NOT NULL
created_at DATETIME NOT NULL
```

Regla:

```text
start_ms <= end_ms
```

## 19. claims — implementat a l'schema 4

Model flexible per representar afirmacions de fonts.

```text
id UUID PK
subject_type TEXT NOT NULL
subject_id UUID NOT NULL
property TEXT NOT NULL
value_type TEXT NOT NULL
value_json TEXT NOT NULL
payload_version INTEGER NOT NULL DEFAULT 1
source_id UUID NULL FK -> sources.id
source_locator TEXT NULL
confidence REAL NULL
status TEXT NOT NULL
created_at DATETIME NOT NULL
modified_at DATETIME NOT NULL
deleted_at DATETIME NULL
```

Estats:

```text
ACCEPTED
DISPUTED
REJECTED
UNREVIEWED
```

La persistència és polimòrfica, però el domini només admet combinacions
registrades de `ClaimSubjectType`, `ClaimProperty` i `ClaimValue`. A més dels
valors escalars, hi ha payloads tipats per crear persones i llocs, filiacions,
parelles, residències i esdeveniments. Acceptar i aplicar una claim materialitza
l'operació de domini; les eliminacions no s'apliquen automàticament des d'una
font.
`source_locator` conserva pàgina, foli, minut o una altra localització concreta.

La contradicció no és un estat persistit. Es deriva entre claims actives i no
rebutjades amb el mateix subjecte i propietat singular. Dates amb intervals
solapats són compatibles; intervals disjunts són contradictoris.

### 19.1. claim_applications — implementat a l'schema 5

```text
claim_id UUID PK FK -> claims.id
operation_type TEXT NOT NULL
result_entity_type TEXT NOT NULL
result_entity_id UUID NOT NULL
applied_at DATETIME NOT NULL
payload_json TEXT NOT NULL
```

El registre separa l'estat editorial de la claim de la seva materialització.
La clau primària garanteix aplicació exactament una vegada, i permet repetir
l'ordre de forma idempotent sense duplicar entitats ni relacions.

## 20. duplicate_candidates — implementat a l'schema 4

```text
id UUID PK
person_a_id UUID FK -> persons.id
person_b_id UUID FK -> persons.id
score INTEGER NOT NULL
reason_codes_json TEXT NOT NULL
detector_version INTEGER NOT NULL
status TEXT NOT NULL
last_evaluated_at DATETIME NOT NULL
resolved_at DATETIME NULL
merged_into_person_id UUID NULL FK -> persons.id
created_at DATETIME NOT NULL
modified_at DATETIME NOT NULL
```

Estats:

```text
PENDING
CONFIRMED_SAME
DIFFERENT_PERSON
DISMISSED
MERGED
```

Regla:

```text
person_a_id != person_b_id
person_a_id < person_b_id
score BETWEEN 0 AND 100
```

La detecció v1 normalitza accents, majúscules i puntuació, bloqueja per tokens
de nom i puntua noms, dates, sexe i relacions compartides. El llindar inicial
és 60. Només crea candidates; mai fusiona automàticament.

## 21. audit_entries i audit_targets — implementat a l'schema 4

```text
id UUID PK
type TEXT NOT NULL
origin TEXT NOT NULL
occurred_at DATETIME NOT NULL
payload_version INTEGER NOT NULL DEFAULT 1
payload_json TEXT NOT NULL
```

```text
audit_targets
- id INTEGER PK
- audit_entry_id UUID FK -> audit_entries.id
- entity_type TEXT NOT NULL
- entity_id UUID NOT NULL
- role TEXT NOT NULL
```

Cada ordre d'usuari genera una entrada append-only. `audit_targets` permet
consultar-la des de totes les entitats afectades. No s'ha reconstruït historial
anterior a l'schema 4.

Tipus inicials:

```text
PERSON_CREATED
PERSON_UPDATED
PERSON_DELETED
PERSON_MERGED
RELATIONSHIP_CREATED
RELATIONSHIP_DELETED
PLACE_CREATED
PLACE_UPDATED
RESIDENCE_CREATED
RESIDENCE_DELETED
EVENT_CREATED
EVENT_DELETED
SOURCE_CREATED
SOURCE_UPDATED
SOURCE_DELETED
MEDIA_ATTACHED
MEDIA_DETACHED
CLAIM_CREATED
CLAIM_UPDATED
CLAIM_DELETED
DUPLICATE_REVIEWED
```

## 22. import_sessions — futur

```text
id UUID PK
source_id UUID NULL
status TEXT NOT NULL
created_at DATETIME NOT NULL
completed_at DATETIME NULL
```

## 23. candidate_changes — futur

Representació temporal de canvis proposats per IA abans del commit definitiu.

Ha de contenir:

```text
session_id
candidate_type
payload_json
review_status
resolved_entity_id
```

## 24. Índexs

Índexs implementats a l'schema 3:

```text
person_names(person_id)
parent_child_relationships(parent_person_id)
parent_child_relationships(child_person_id)
partnerships(person_a_id)
partnerships(person_b_id)
residences(person_id)
residences(place_id)
events(place_id)
event_participants(event_id)
event_participants(person_id)
```

Índexs implementats a l'schema 4:

```text
claims(subject_type, subject_id)
claims(source_id)
media(relative_path) UNIQUE actiu
media(checksum_sha256, file_size) UNIQUE actiu
source_media(source_id)
source_media(media_id)
source_media(source_id, media_id) UNIQUE actiu
claims(subject_type, subject_id, property)
claims(status)
duplicate_candidates(person_a_id, person_b_id) UNIQUE
audit_entries(occurred_at)
audit_targets(entity_type, entity_id)
```

Índexs previstos per a les fases 7 i 8:

```text
transcript_segments(transcript_id)
```

## 25. Foreign keys

Cada connexió SQLite ha d'executar:

```sql
PRAGMA foreign_keys = ON;
```

## 26. Parentescos explícits i derivats

No hi haurà taules específiques de:

```text
grandparents
uncles
cousins
```

Aquests conceptes es calculen des de `parent_child_relationships`.

La germanor és l'excepció deliberada: pot derivar-se de progenitors compartits,
però també es pot afirmar directament quan la font coneix els germans i no els
progenitors. No es creen persones progenitores fictícies.

### 26.1. sibling_relationships — schema 6

```text
id UUID PK
person_a_id UUID FK -> persons.id
person_b_id UUID FK -> persons.id
kind ENUM(UNSPECIFIED, FULL, HALF, ADOPTIVE, STEP)
notes TEXT NULL
created_at DATETIME NOT NULL
modified_at DATETIME NOT NULL
deleted_at DATETIME NULL
```

Regles:

- relació simètrica amb parella canonitzada (`person_a_id < person_b_id`);
- una persona no pot ser germana d'ella mateixa;
- unicitat activa per parella; les discrepàncies de tipus es conserven com a
  claims fins que es resolen;
- `UNSPECIFIED` és el valor segur quan la font només diu «germans»;
- si també existeix una germanor derivada, el servei conserva les dues vies
  d'evidència sense eliminar la relació explícita;
- el merge recanonitza, deduplica i conserva discrepàncies com a claims.

## 27. Exemple complex d'adopció

Dades primitives:

```text
Avi → Pere       BIOLOGICAL
Avi → Joan       BIOLOGICAL
Pere → Marc      BIOLOGICAL
Joan → Marc      ADOPTIVE
```

Resultats derivats Joan → Marc:

```text
PARE ADOPTIU
TIET BIOLÒGIC
```

Resultats derivats Avi → Marc:

```text
AVI BIOLÒGIC
AVI ADOPTIU
```

El motor ha de retornar múltiples `KinshipPath` quan sigui necessari.

## 28. Regla de merge

Quan dues persones es fusionen:

- cap camp es descarta silenciosament;
- l'usuari resol conflictes;
- relacions no duplicades es conserven;
- germanors explícites es recanonitzen sense crear progenitors;
- discrepàncies històriques poden convertir-se en claims;
- es crea `AuditEntry`.

## 29. Eliminació múltiple de persones

L'eliminació en cascada és lògica i transaccional. Marca `deleted_at` a les
persones seleccionades i als seus noms, filiacions, germanors, parelles,
residències i participacions. Els esdeveniments amb altres participants actius
es conserven; els que queden orfes també reben soft-delete. Claims i auditoria
es mantenen intactes per no perdre la procedència ni l'historial. Els candidats
de duplicat afectats es resolen amb estat `DISMISSED`.
