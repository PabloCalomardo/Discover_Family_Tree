# FamilyHistory — Projecte

## 1. Visió

FamilyHistory és una aplicació local-first per capturar, estructurar, preservar, explorar i editar història familiar.

L'objectiu principal és transformar coneixement oral, text, documents i dades introduïdes manualment en un model relacional navegable que permeti entendre persones, parentescos, llocs, habitatges, esdeveniments, fonts i afirmacions històriques.

L'aplicació està especialment pensada per preservar coneixement familiar oral abans que es perdi, mantenint sempre la capacitat de rastrejar d'on prové cada informació.

## 2. Objectius del producte

- Permetre introduir informació manualment.
- Permetre importar text lliure i transformar-lo en dades estructurades amb IA.
- Permetre importar àudio, transcriure'l i processar la transcripció amb IA.
- Representar persones, relacions familiars, adopcions, llocs, residències i esdeveniments.
- Mostrar un arbre familiar navegable.
- Mostrar habitatges familiars i els seus ocupants al llarg del temps.
- Permetre navegació temporal mitjançant timelines.
- Permetre geolocalitzar llocs.
- Permetre modificar tota la informació des de la UI sense accedir manualment a la base de dades.
- Mantenir el projecte transportable entre dispositius mitjançant un únic fitxer `.famhistory`.
- No requerir cap backend obligatori per al funcionament principal.

## 3. Principis del projecte

1. Local-first.
2. Offline-first, excepte funcionalitats que depenguin d'APIs externes.
3. Zero backend obligatori per a l'MVP.
4. Tota operació IA genera propostes; mai modifica dades definitives directament.
5. Les dades històriques poden tenir fonts i afirmacions contradictòries.
6. Les relacions familiars primitives es guarden; les derivables es calculen.
7. Les relacions adoptives i biològiques poden coexistir.
8. Les fusions de persones sempre requereixen validació humana.
9. Un projecte `.famhistory` pot contenir tantes branques i famílies connectades com sigui necessari.
10. L'aplicació no està concebuda per contenir dades sensibles; se centra en història, relacions i anècdotes familiars.

## 4. Plataformes objectiu

### MVP

- Windows
- macOS

El desenvolupament i la validació funcional es fan primer a Windows. macOS es
manté com a plataforma objectiu de l'MVP, però la seva adaptació i validació
natives es realitzaran durant les proves finals, quan l'aplicació estigui
acabada o en fase final.

### Post-MVP

- iOS
- Android

### Opcional futur

- Web

## 5. Format de projecte

Cada univers familiar es desa en un únic fitxer:

```text
familia-puig.famhistory
```

Internament aquest fitxer contindrà, com a mínim:

```text
manifest.json
database.sqlite
media/
  audio/
  images/
  documents/
thumbnails/
```

El fitxer `.famhistory` ha de ser transportable entre dispositius.

## 6. Abast funcional

### Persones

- Noms múltiples i sobrenoms.
- Data de naixement i defunció amb incertesa històrica.
- Biografia i notes.
- Relacions familiars.
- Residències.
- Esdeveniments.
- Fonts i afirmacions.

### Relacions familiars

Relacions primitives principals:

- Parent → Child, amb naturalesa `BIOLOGICAL` o `ADOPTIVE`.
- Partnership / Marriage.

Relacions com germà, tiet, avi, cosí, etc. es deriven a partir del graf quan sigui possible.

Les relacions adoptives i biològiques poden coexistir simultàniament entre les mateixes persones a través de camins diferents.

### Llocs

- Cases.
- Masos.
- Pisos.
- Pobles.
- Ciutats.
- Regions.
- Altres llocs històrics.
- Coordenades geogràfiques.
- Relacions jeràrquiques entre llocs.

### Residències

Una residència és una relació temporal entre una persona i un lloc.

Exemple:

```text
Jordi → Mas Puig
1912 → 1936
```

### Esdeveniments

Exemples:

- Naixement.
- Defunció.
- Matrimoni.
- Trasllat.
- Compra.
- Venda.
- Herència.
- Educació.
- Feina.
- Guerra.
- Migració.
- Altres.

### Fonts i evidència

Cal separar:

```text
Source → Claim → Domain Data
```

Una font pot ser una entrevista, document, fotografia, registre, carta, llibre o coneixement personal.

Una afirmació pot ser acceptada, disputada, rebutjada o pendent de revisió.

## 7. IA

La IA s'utilitzarà per:

- Transcripció d'àudio.
- Extracció de persones, llocs, relacions, residències i esdeveniments.
- Detecció de possibles duplicats.
- Resolució assistida d'entitats.

La IA no pot:

- Executar SQL.
- Escriure directament a la base de dades definitiva.
- Fusionar persones automàticament.

Pipeline:

```text
Audio/Text
  ↓
Transcription (si cal)
  ↓
Extraction
  ↓
Candidate Changes
  ↓
Entity Resolution
  ↓
Human Review
  ↓
Domain Services
  ↓
SQLite
```

## 8. Criteris de qualitat

- Integritat referencial.
- Tests per al motor de parentesc.
- Migracions de base de dades versionades.
- Separació entre UI, domini i persistència.
- Cap widget Flutter accedeix directament a SQLite.
- Operacions complexes auditables.
- Les dades no es perden silenciosament durant merges o conflictes.

## 9. Estat actual

El projecte es troba en **Fase 4 — Family Tree MVP**, amb desenvolupament i
validació funcional prioritaris a Windows. El nucli de domini, la persistència
i la UI CRUD de persones, relacions, llocs, residències i esdeveniments ja
estan implementats. La prioritat actual és visualitzar i navegar el graf
familiar; la IA i la resta de UI avançada continuen fora de l'abast de la fase.
