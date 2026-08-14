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

## 2. Taules previstes — Schema v1

```text
projects
persons
person_names
parent_child_relationships
partnerships
places
place_relationships
residences
events
event_participants
sources
media
source_media
transcripts
transcript_segments
claims
duplicate_candidates
audit_entries
```

Fases posteriors:

```text
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

## 14. sources

```text
id UUID PK
type TEXT NOT NULL
title TEXT NOT NULL
description TEXT NULL
date_* HistoricalDate NULL
author TEXT NULL
location TEXT NULL
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

## 15. media

```text
id UUID PK
type TEXT NOT NULL
relative_path TEXT NOT NULL
mime_type TEXT NULL
original_filename TEXT NULL
checksum TEXT NOT NULL
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

## 16. source_media

```text
id UUID PK
source_id UUID FK -> sources.id
media_id UUID FK -> media.id
created_at DATETIME NOT NULL
```

## 17. transcripts

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

## 18. transcript_segments

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

## 19. claims

Model flexible per representar afirmacions de fonts.

```text
id UUID PK
subject_type TEXT NOT NULL
subject_id UUID NOT NULL
property TEXT NOT NULL
value_type TEXT NOT NULL
value_json TEXT NOT NULL
source_id UUID NULL FK -> sources.id
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

La referència `subject_id` és polimòrfica a nivell de domini i ha de validar-se des de serveis d'aplicació.

## 20. duplicate_candidates

```text
id UUID PK
person_a_id UUID FK -> persons.id
person_b_id UUID FK -> persons.id
confidence REAL NULL
reason TEXT NULL
status TEXT NOT NULL
created_at DATETIME NOT NULL
modified_at DATETIME NOT NULL
```

Estats:

```text
PENDING
SAME_PERSON
DIFFERENT_PERSON
DISMISSED
```

Regla:

```text
person_a_id != person_b_id
```

## 21. audit_entries

```text
id UUID PK
type TEXT NOT NULL
timestamp DATETIME NOT NULL
payload_json TEXT NOT NULL
```

Tipus inicials:

```text
PERSON_CREATED
PERSON_UPDATED
PERSON_MERGED
RELATIONSHIP_CREATED
RELATIONSHIP_DELETED
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

## 24. Índexs mínims previstos

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
claims(subject_type, subject_id)
claims(source_id)
duplicate_candidates(person_a_id)
duplicate_candidates(person_b_id)
transcript_segments(transcript_id)
```

## 25. Foreign keys

Cada connexió SQLite ha d'executar:

```sql
PRAGMA foreign_keys = ON;
```

## 26. Parentescos derivats

No hi haurà taula de:

```text
grandparents
siblings
uncles
cousins
```

Aquests conceptes es calculen des de `parent_child_relationships`.

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
- discrepàncies històriques poden convertir-se en claims;
- es crea `AuditEntry`.
