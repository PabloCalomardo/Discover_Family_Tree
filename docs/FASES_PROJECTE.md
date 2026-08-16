# FamilyHistory — Fases del Projecte

> Aquest document és viu i s'ha d'actualitzar sempre que el projecte avanci de fase o es completi una fita important.

## Estat actual

**Fase actual:** Fase 7 — IA: importació de text

**Estat:** EN CURS

**Fase anterior:** Fase 6 — Sources, Claims i Merge (completada)

**Última actualització:** 2026-08-16

---

## Fase 0 — Preparació i fonaments

**Estat:** COMPLETADA EL 2026-08-14

### Objectiu

Deixar el repositori preparat per desenvolupar sobre una arquitectura estable.

### Tasques

- [x] Crear repositori Git.
- [x] Crear projecte Flutter.
- [x] Confirmar execució a Windows.
- [x] Diferir la validació de macOS a les proves finals multiplataforma.
- [x] Afegir estructura inicial de carpetes.
- [x] Afegir documentació del projecte.
- [x] Configurar linter i format.
- [x] Configurar Drift + SQLite.
- [x] Crear base de dades inicial.
- [x] Activar `PRAGMA foreign_keys = ON`.
- [x] Configurar sistema de migracions.
- [x] Configurar tests.

### Seguiment

- 2026-08-14: creat l'esquelet Flutter 3.47.0 / Dart 3.13.0 per a Windows i
  macOS, amb identificador provisional `com.familyhistory`.
- 2026-08-14: creat l'schema 1 limitat a `projects`, configurades les
  migracions Drift i verificat `PRAGMA foreign_keys = ON` mitjançant tests.
- 2026-08-14: `flutter analyze` finalitza sense incidències i els 3 tests base
  passen.
- 2026-08-14: compilació Windows debug completada; aplicació arrencada i
  connexió SQLite local creada a `Documents/family_history.sqlite`.
- 2026-08-14: s'acorda desenvolupar i validar primer l'aplicació completa a
  Windows. L'adaptació, compilació i execució a macOS es traslladen a les
  proves finals multiplataforma, abans de distribuir l'MVP.

### Criteri de finalització

Durant el desenvolupament inicial, l'aplicació s'executa a Windows, pot obrir
una base SQLite local i els tests base passen correctament. La validació de
macOS forma part de les proves finals multiplataforma.

---

## Fase 1 — Domain Core

**Estat:** COMPLETADA EL 2026-08-15

### Objectiu

Implementar el model de domini independent de la UI.

### Tasques

- [x] Implementar identificadors UUID.
- [x] Implementar `HistoricalDate`.
- [x] Implementar `Person`.
- [x] Implementar `PersonName`.
- [x] Implementar `ParentChildRelationship`.
- [x] Implementar `Partnership`.
- [x] Implementar `KinshipService`.
- [x] Implementar validacions de cicles familiars impossibles.
- [x] Afegir tests de parentesc biològic.
- [x] Afegir tests de parentesc adoptiu.
- [x] Afegir test del cas Joan adopta el seu nebot.

### Seguiment

- 2026-08-14: implementats UUID tipats, dates històriques incertes i entitats
  familiars primitives com a domini pur, sense dependències de Flutter o Drift.
- 2026-08-14: el motor deriva camins biològics i adoptius simultanis fins a una
  profunditat configurable, amb profunditat 4 per defecte.
- 2026-08-14: verificats duplicats exactes, cicles biològics/adoptius, parentiu
  biològic, adoptiu, parelles, cosins germans i el cas Joan adopta el seu nebot.
- 2026-08-14: `flutter analyze` finalitza sense incidències i els 18 tests del
  projecte passen.
- 2026-08-15: fase completada amb confirmació explícita de l'usuari.

### Criteri de finalització

El motor de domini pot representar i derivar correctament parentescos complexos sense UI.

---

## Fase 2 — Places, residències i esdeveniments

**Estat:** COMPLETADA EL 2026-08-15

### Objectiu

Representar la dimensió geogràfica i temporal de la història familiar.

### Tasques

- [x] Implementar `Place`.
- [x] Implementar `PlaceRelationship`.
- [x] Implementar `Residence`.
- [x] Implementar `Event`.
- [x] Implementar `EventParticipant`.
- [x] Consultes de residents per lloc i període.
- [x] Consultes d'esdeveniments per persona.
- [x] Tests d'integritat temporal bàsica.
- [x] Afegir persistència Drift per a les entitats de les fases 1 i 2.
- [x] Afegir repositories com a frontera entre domini i persistència.
- [x] Afegir i verificar migracions sense pèrdua de dades des de schema 1.

### Seguiment

- 2026-08-15: implementats llocs, jerarquies, residències, esdeveniments i
  participants amb UUID tipats, soft delete i validacions de domini.
- 2026-08-15: les coordenades s'emmagatzemen per parelles i se'n validen els
  rangs; `LOCATED_IN` no permet cicles i `SAME_AS` és simètric.
- 2026-08-15: implementades consultes de possible solapament temporal per a
  residents i consultes cronològiques d'esdeveniments per persona.
- 2026-08-15: schema intern 2 afegeix les taules de les fases 1 i 2; schema 3
  garanteix de manera idempotent tots els índexs en bases ja migrades.
- 2026-08-15: verificada la migració de la base local real a schema 3, sense
  eliminar el projecte existent.
- 2026-08-15: `flutter analyze` finalitza sense incidències, els 33 tests passen
  i la compilació Windows debug es completa correctament.
- 2026-08-15: fase completada amb confirmació explícita de l'usuari.

### Criteri de finalització

Es poden representar persones, llocs, residències i esdeveniments de manera coherent.

---

## Fase 3 — UI CRUD MVP

**Estat:** COMPLETADA EL 2026-08-15

### Objectiu

Permetre gestionar manualment el nucli de dades sense tocar la base de dades.

### Tasques

- [x] Shell principal desktop.
- [x] Navegació lateral.
- [x] Llista de persones.
- [x] Crear persona.
- [x] Editar persona.
- [x] Eliminar persona amb soft delete.
- [x] Detall de persona.
- [x] Llista de llocs.
- [x] Crear i editar lloc.
- [x] Gestió de residències.
- [x] Gestió d'esdeveniments.
- [x] Gestió de relacions familiars.

### Seguiment

- 2026-08-15: implementats el shell desktop Material 3, la navegació amb
  `go_router` i l'estat reactiu amb Riverpod, mantenint els widgets separats de
  Drift mitjançant controllers, serveis i repositories.
- 2026-08-15: implementats llistats, formularis i detalls de persones i llocs,
  amb dates històriques estructurades i nom preferit obligatori.
- 2026-08-15: implementada la gestió manual de relacions familiars,
  residències i esdeveniments des del detall de persona.
- 2026-08-15: l'eliminació de persones usa soft delete i queda bloquejada
  mentre existeixin relacions, residències o participacions actives.
- 2026-08-15: `flutter analyze` finalitza sense incidències, els 36 tests
  passen i la compilació Windows debug es completa correctament.
- 2026-08-15: fase completada amb validació funcional i confirmació explícita
  de l'usuari.

### Criteri de finalització

Un usuari pot construir manualment una història familiar bàsica només des de la UI.

---

## Fase 4 — Family Tree MVP

**Estat:** COMPLETADA EL 2026-08-15

### Objectiu

Visualitzar i navegar el graf familiar.

### Tasques

- [x] Renderitzat de l'arbre familiar.
- [x] Zoom.
- [x] Pan.
- [x] Selecció de persona.
- [x] Accés al detall de persona.
- [x] Diferenciació visual biològic/adoptiu.
- [x] Mostrar múltiples etiquetes de parentesc quan coexisteixen.
- [x] Prototip de layout per branques complexes.

### Seguiment

- 2026-08-15: integrat `graphview` 1.5.1 amb layout jeràrquic Sugiyama i
  projecció visual separada del domini i de la persistència.
- 2026-08-15: la vista focal inclou tots els ascendents de la persona i tots
  els descendents d'aquests ascendents —també per filiació adoptiva—, i hi
  afegeix només les parelles directes; evita incorporar com a família la
  genealogia pròpia d'una parella política.
- 2026-08-15: implementats zoom, pan, ajust a finestra, selecció de persones,
  nodes d'unió visuals i accés a la fitxa des del panell lateral.
- 2026-08-15: les relacions biològiques, adoptives i de parella tenen estils
  diferenciats; els múltiples camins de parentesc es mostren simultàniament.
- 2026-08-15: verificats el filtratge generacional, les branques desconnectades
  i la coexistència de parentiu biològic, adoptiu i parella.
- 2026-08-15: alineats els cònjuges al mateix nivell amb connector horitzontal,
  eliminat el problema d'hover del node matrimonial i reformulada la creació
  de relacions com una frase explícita amb les dues persones implicades.
- 2026-08-15: el layout agrupa cada matrimoni com un bloc contigu dins la seva
  generació, impedint que una tercera persona quedi entre els cònjuges.
- 2026-08-15: substituïts els connectors pare-fill independents per troncs
  ortogonals: surten del centre de la parella, comparteixen una barra entre
  germans i baixen individualment amb estil biològic o adoptiu.
- 2026-08-15: verificat el cas d'una branca política ascendent: queda exclosa
  de la vista focal a un grau i apareix a la generació correcta en «Mostra tot».
- 2026-08-15: formalitzades les regles geomètriques del layout: només es
  dibuixen filiacions directes; una drecera generacional explícita s'oculta si
  ja existeix un camí intermedi; totes les persones d'una generació comparteixen
  alçada, amb 88 px entre files, colzes a 32 px i 48 px entre nodes.
- 2026-08-15: el canvi de persona focal reconstrueix completament generacions,
  blocs matrimonials i connectors; afegida una regressió automatitzada que
  recentra l'arbre en una parella política i verifica les mateixes distàncies.
- 2026-08-15: cada recentrat recrea també el llenç i el controlador de
  `GraphView`, sense interpolar posicions de l'arbre anterior; després del nou
  layout, la persona focal es col·loca al centre exacte del viewport.
- 2026-08-15: els nodes matrimonials invisibles ja no intervenen en el càlcul
  horitzontal; les files es compacten al voltant de la més ampla i no poden
  desplaçar-se lateralment més de 48 px respecte del centre del clúster.
- 2026-08-15: nodes, barres, colzes i punts matrimonials s'ajusten a píxels
  enters, amb traços ortogonals sense antialias i ordre de pintura estable als
  encreuaments; afegides regressions de compacitat i alineació de coordenades.
- 2026-08-15: les branques d'origen d'una parella creixen cap als seus costats
  exteriors: els germans del membre esquerre queden a l'esquerra i els del dret
  a la dreta, evitant que famílies parentals diferents comparteixin trams.
- 2026-08-15: `flutter analyze` finalitza sense incidències, els 41 tests
  passen i la compilació Windows debug es completa correctament.
- 2026-08-15: fase 4 validada funcionalment per l'usuari i declarada completa;
  la fase 5 queda pendent d'inici explícit.

### Criteri de finalització

L'arbre pot representar casos familiars normals i adopcions complexes de manera comprensible.

---

## Fase 5 — Format `.famhistory`

**Estat:** COMPLETADA EL 2026-08-16

### Objectiu

Fer el projecte transportable entre dispositius.

### Tasques

- [x] Definir `manifest.json` v1.
- [x] Crear projecte nou.
- [x] Obrir projecte existent.
- [x] Desar projecte.
- [x] Empaquetar SQLite + media.
- [x] Desempaquetar projecte temporalment.
- [x] Validar versió de format.
- [x] Crear backup manual.
- [x] Afegir checksums de media.

### Seguiment

- 2026-08-15: fase iniciada amb autorització explícita de l'usuari; revisats
  format mínim, arquitectura, persistència actual i decisions pendents.
- 2026-08-15: implementat el contenidor ZIP `.famhistory` amb manifest v1,
  instantània SQLite consistent, estructura de media i checksums SHA-256.
- 2026-08-15: implementats nou projecte, obrir, desar, desar com i backup des
  de la pantalla d'inici, amb selector de fitxers natiu de Windows.
- 2026-08-15: l'obertura valida format, versió, estructura, integritat dels
  media i rutes d'extracció abans d'activar el projecte.
- 2026-08-15: la base local anterior es copia de manera segura al primer espai
  de treball sense eliminar ni modificar l'original.
- 2026-08-15: `flutter analyze` finalitza sense incidències, els 47 tests passen
  i la compilació Windows release genera `family_history.exe` correctament.
- 2026-08-16: l'usuari valida el flux funcional i declara completada la fase 5.
- 2026-08-16: la fase 6 queda com a següent fase, pendent d'inici i de les
  decisions de disseny corresponents.

### Criteri de finalització

Un projecte es pot copiar a un altre ordinador i obrir sense servidor ni dependències externes.

---

## Fase 6 — Sources, Claims i Merge

**Estat:** COMPLETADA EL 2026-08-16

### Objectiu

Preservar evidència, conflictes històrics i resolució d'identitat.

### Tasques

- [x] Implementar `Source`.
- [x] Implementar `Media`.
- [x] Implementar `Claim`.
- [x] Aplicar claims d'operacions de domini de forma idempotent.
- [x] Implementar estats de claims.
- [x] Detectar claims contradictòries.
- [x] Implementar `DuplicateCandidate`.
- [x] Pantalla de revisió de duplicats.
- [x] Implementar merge manual de persones.
- [x] Resolució de camps un per un.
- [x] Conservar relacions durant merge.
- [x] Afegir `AuditEntry`.

### Seguiment

- 2026-08-16: fase iniciada amb aprovació explícita de l'usuari després de
  l'auditoria dels models de fonts, media, claims, contradiccions, duplicats,
  merge, auditoria, migració i UX inicial.
- 2026-08-16: aprovades les decisions D1–D12: model bibliogràfic pla de
  `Source`, media gestionada dins del workspace, claims híbrides tipades,
  conflictes derivats, detecció determinista de duplicats, merge transaccional
  camp per camp, auditoria per operació i evolució additiva a schema 4.
- 2026-08-16: implementat l'schema 4 additiu amb `sources`, `media`,
  `source_media`, `claims`, `duplicate_candidates`, `audit_entries` i
  `audit_targets`, incloent índexs, constraints i migracions des dels schemas
  1, 2 i 3 sense pèrdua de dades.
- 2026-08-16: implementats models de domini i repositories separats de la UI,
  media gestionada al workspace amb SHA-256 i miniatures derivades, claims
  tipades, conflictes derivats i detector determinista de duplicats v1.
- 2026-08-16: implementats revisió de contradiccions i duplicats, merge manual
  A/B/personalitzat, conversió explícita de relacions bloquejants a claims,
  reassociació de relacions i auditoria append-only per operació.
- 2026-08-16: afegides les seccions `Fonts`, `Revisió` i `Evidència`, i rebuig
  preventiu de projectes `.famhistory` amb un schema SQLite futur.
- 2026-08-16: totes les tasques planificades de la fase estan implementades;
  la fase continua **EN CURS** pendent de verificació tècnica final i validació
  funcional explícita de l'usuari.
- 2026-08-16: `flutter analyze` finalitza sense incidències, les 68 proves
  passen i la compilació Windows release genera `family_history.exe`
  correctament. La fase no es declara completada: resta pendent la validació
  funcional explícita de l'usuari.
- 2026-08-16: ampliades les claims perquè puguin crear persones i llocs,
  modificar-ne camps i crear filiacions, parelles, residències i esdeveniments.
  L'schema 5 afegeix `claim_applications`; «Accepta i aplica» és transaccional,
  idempotent i auditat. Les eliminacions continuen requerint una ordre directa.
- 2026-08-16: verificació ampliada completada amb `flutter analyze` sense
  incidències, 73 proves superades i build Windows release correcte. La fase
  continua **EN CURS** pendent de validació funcional explícita de l'usuari.
- 2026-08-16: el formulari de claims deixa de dependre de l'activació prèvia
  dels providers de la pantalla `Persones`: carrega instantànies mitjançant els
  repositories i es pot obrir directament des de `Fonts`. La UX usa «Crear
  parentesc» en lloc de «Crear filiació».
- 2026-08-16: traduïts al català els enums visibles del formulari de claims i
  fixada explícitament la política d'UI en català durant l'MVP. L'edició de
  llocs permet assignar i desassignar residents amb sincronització
  transaccional, soft-delete i auditoria de les residències afectades.
- 2026-08-16: fase completada amb confirmació funcional explícita de l'usuari.

### Criteri de finalització

El sistema pot gestionar fonts, contradiccions i possibles persones duplicades sense pèrdua silenciosa d'informació.

---

## Fase 7 — IA: importació de text

**Estat:** EN CURS DES DEL 2026-08-16

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

### Seguiment

- 2026-08-16: fase iniciada després de la confirmació explícita de la fase 6.
- 2026-08-16: auditoria inicial de decisions d'arquitectura, proveïdor,
  privacitat, persistència, resolució d'entitats i UX pendent d'aprovació abans
  d'implementar.

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

## Proves finals multiplataforma desktop

Es realitzaran quan l'aplicació estigui acabada o en fase final, abans de
distribuir l'MVP:

- [ ] Adaptar i revisar la integració nativa de macOS.
- [ ] Compilar i executar l'aplicació en un equip macOS.
- [ ] Verificar l'obertura i persistència SQLite a macOS.
- [ ] Executar `flutter analyze` i `flutter test` a macOS.
- [ ] Executar les proves funcionals finals a Windows i macOS.

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
