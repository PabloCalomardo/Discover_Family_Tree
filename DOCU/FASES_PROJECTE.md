# FamilyHistory — Fases del Projecte

> Aquest document és viu i s'ha d'actualitzar sempre que el projecte avanci de fase o es completi una fita important.

## Estat actual

**Fase actual:** Fase 0 — Preparació i fonaments

**Estat:** EN CURS

**Última actualització:** 2026-08-14

---

## Fase 0 — Preparació i fonaments

### Objectiu

Deixar el repositori preparat per desenvolupar sobre una arquitectura estable.

### Tasques

- [ ] Crear repositori Git.
- [ ] Crear projecte Flutter.
- [ ] Confirmar execució a Windows.
- [ ] Confirmar execució a macOS.
- [ ] Afegir estructura inicial de carpetes.
- [ ] Afegir documentació del projecte.
- [ ] Configurar linter i format.
- [ ] Configurar Drift + SQLite.
- [ ] Crear base de dades inicial.
- [ ] Activar `PRAGMA foreign_keys = ON`.
- [ ] Configurar sistema de migracions.
- [ ] Configurar tests.

### Criteri de finalització

L'aplicació s'executa en desktop, pot obrir una base SQLite local i els tests base passen correctament.

---

## Fase 1 — Domain Core

### Objectiu

Implementar el model de domini independent de la UI.

### Tasques

- [ ] Implementar identificadors UUID.
- [ ] Implementar `HistoricalDate`.
- [ ] Implementar `Person`.
- [ ] Implementar `PersonName`.
- [ ] Implementar `ParentChildRelationship`.
- [ ] Implementar `Partnership`.
- [ ] Implementar `KinshipService`.
- [ ] Implementar validacions de cicles familiars impossibles.
- [ ] Afegir tests de parentesc biològic.
- [ ] Afegir tests de parentesc adoptiu.
- [ ] Afegir test del cas Joan adopta el seu nebot.

### Criteri de finalització

El motor de domini pot representar i derivar correctament parentescos complexos sense UI.

---

## Fase 2 — Places, residències i esdeveniments

### Objectiu

Representar la dimensió geogràfica i temporal de la història familiar.

### Tasques

- [ ] Implementar `Place`.
- [ ] Implementar `PlaceRelationship`.
- [ ] Implementar `Residence`.
- [ ] Implementar `Event`.
- [ ] Implementar `EventParticipant`.
- [ ] Consultes de residents per lloc i període.
- [ ] Consultes d'esdeveniments per persona.
- [ ] Tests d'integritat temporal bàsica.

### Criteri de finalització

Es poden representar persones, llocs, residències i esdeveniments de manera coherent.

---

## Fase 3 — UI CRUD MVP

### Objectiu

Permetre gestionar manualment el nucli de dades sense tocar la base de dades.

### Tasques

- [ ] Shell principal desktop.
- [ ] Navegació lateral.
- [ ] Llista de persones.
- [ ] Crear persona.
- [ ] Editar persona.
- [ ] Eliminar persona amb soft delete.
- [ ] Detall de persona.
- [ ] Llista de llocs.
- [ ] Crear i editar lloc.
- [ ] Gestió de residències.
- [ ] Gestió d'esdeveniments.
- [ ] Gestió de relacions familiars.

### Criteri de finalització

Un usuari pot construir manualment una història familiar bàsica només des de la UI.

---

## Fase 4 — Family Tree MVP

### Objectiu

Visualitzar i navegar el graf familiar.

### Tasques

- [ ] Renderitzat de l'arbre familiar.
- [ ] Zoom.
- [ ] Pan.
- [ ] Selecció de persona.
- [ ] Accés al detall de persona.
- [ ] Diferenciació visual biològic/adoptiu.
- [ ] Mostrar múltiples etiquetes de parentesc quan coexisteixen.
- [ ] Prototip de layout per branques complexes.

### Criteri de finalització

L'arbre pot representar casos familiars normals i adopcions complexes de manera comprensible.

---

## Fase 5 — Format `.famhistory`

### Objectiu

Fer el projecte transportable entre dispositius.

### Tasques

- [ ] Definir `manifest.json` v1.
- [ ] Crear projecte nou.
- [ ] Obrir projecte existent.
- [ ] Desar projecte.
- [ ] Empaquetar SQLite + media.
- [ ] Desempaquetar projecte temporalment.
- [ ] Validar versió de format.
- [ ] Crear backup manual.
- [ ] Afegir checksums de media.

### Criteri de finalització

Un projecte es pot copiar a un altre ordinador i obrir sense servidor ni dependències externes.

---

## Fase 6 — Sources, Claims i Merge

### Objectiu

Preservar evidència, conflictes històrics i resolució d'identitat.

### Tasques

- [ ] Implementar `Source`.
- [ ] Implementar `Media`.
- [ ] Implementar `Claim`.
- [ ] Implementar estats de claims.
- [ ] Detectar claims contradictòries.
- [ ] Implementar `DuplicateCandidate`.
- [ ] Pantalla de revisió de duplicats.
- [ ] Implementar merge manual de persones.
- [ ] Resolució de camps un per un.
- [ ] Conservar relacions durant merge.
- [ ] Afegir `AuditEntry`.

### Criteri de finalització

El sistema pot gestionar fonts, contradiccions i possibles persones duplicades sense pèrdua silenciosa d'informació.

---

## Fase 7 — IA: importació de text

### Objectiu

Transformar text lliure en propostes de dades estructurades.

### Tasques

- [ ] Definir `ExtractionProvider`.
- [ ] Definir JSON Schema de sortida.
- [ ] Definir `CandidatePerson`.
- [ ] Definir `CandidatePlace`.
- [ ] Definir `CandidateRelationship`.
- [ ] Definir `CandidateResidence`.
- [ ] Definir `CandidateEvent`.
- [ ] Implementar validació de schema.
- [ ] Implementar `EntityResolutionService`.
- [ ] Implementar review UI.
- [ ] Commit transaccional de canvis acceptats.

### Criteri de finalització

Un text pot ser analitzat per IA, revisat per l'usuari i incorporat de manera segura al projecte.

---

## Fase 8 — IA: àudio i història oral

### Objectiu

Convertir entrevistes en informació estructurada mantenint la font original.

### Tasques

- [ ] Definir `TranscriptionProvider`.
- [ ] Importar MP3/M4A/WAV.
- [ ] Crear `Transcript`.
- [ ] Crear `TranscriptSegment`.
- [ ] Enllaçar fragments amb claims.
- [ ] Permetre saltar d'una dada al moment de l'àudio.
- [ ] Reutilitzar pipeline d'extracció de text.

### Criteri de finalització

Una entrevista pot convertir-se en dades revisables sense perdre el vincle amb l'àudio original.

---

## Fase 9 — Exploració històrica

### Objectiu

Fer que les dades siguin explorables visualment.

### Tasques

- [ ] Timeline familiar global.
- [ ] Timeline per persona.
- [ ] Història d'un habitatge.
- [ ] Mapa global de llocs.
- [ ] Filtres temporals.
- [ ] Visualització d'incertesa de dates.

---

## Fase 10 — Mobile

### Objectiu

Adaptar la mateixa base de codi a iOS i Android.

### Tasques

- [ ] Layout responsive.
- [ ] Navegació mobile.
- [ ] Gestos touch per arbre.
- [ ] File picker mobile.
- [ ] Proves iOS.
- [ ] Proves Android.
- [ ] Distribució iOS via TestFlight.

---

## Fase 11 — Futures opcions

No formen part del compromís inicial:

- Sincronització cloud.
- Multiusuari.
- Web app.
- IA completament local.
- Comparació o merge entre projectes `.famhistory`.
- Control de versions complet.
- Col·laboració en temps real.
