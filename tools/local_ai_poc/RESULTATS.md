# Resultats de la prova local

**Estat:** comparativa executada — cap model provat és apte per integrar

**Data:** 2026-08-16

La prova s'ha executat exclusivament amb l'entrevista fictícia de `fixtures/`.
No s'ha processat cap dada personal real.

## Entorn

- Windows, Intel Core i5-9400F, 24 GB RAM.
- NVIDIA GeForce GTX 1650, 4 GB VRAM.
- `llama.cpp` b10453, commit `3cb7ffb1a`.
- Models GGUF locals de 0,6B a 4,63B, tots fora del repositori.

SHA-256:

- model: `7485FE6F11AF29433BC51CAB58009521F205840F5B4AE3A32FA7F92E8534FDF5`;
- runtime CPU: `70C07211D0027305F0BE09CD755D79641EBB0BB646590FF3D498C66B22DF29B0`;
- runtime CUDA 12.4: `84B863F70A8B4C2873E93385D0B208F24776ECD1B946A2CB6D5CDA863D143C3D`;
- dependències CUDA 12.4: `8C79A9B226DE4B3CACFD1F83D24F962D0773BE79F1E7B75C6AF4DED7E32AE1D6`.

## Privacitat verificada en aquesta prova

- servidor vinculat exclusivament a `127.0.0.1`;
- cap crida d'inferència a Internet ni fallback extern;
- logs del runtime desactivats;
- cap accés del model a SQLite o al projecte `.famhistory`;
- cap persistència de prompts o respostes;
- processos d'inferència tancats al final de la prova;
- runtime i model desats fora del repositori, a `%LOCALAPPDATA%`.

Les descàrregues inicials sí que han requerit Internet, però no han inclòs el
text de l'entrevista.

## Rendiment

Benchmark CUDA de `llama-bench`:

- processament de prompt (`pp128`): 124,04 tokens/s;
- generació (`tg32`): 31,87 tokens/s;
- el model va ocupar aproximadament 3.757 MiB dels 4.096 MiB de VRAM amb
  context 4.096.

### Correcció del primer harness

Les primeres proves CLI i servidor es van aturar després de 7–10 minuts. En la
segona ronda es va comprovar que hi havia dos problemes del harness:

- el CLI quedava en mode interactiu després de generar;
- `Invoke-RestMethod` esperava el tancament HTTP tot i que el servidor ja havia
  acabat la petició.

Per tant, aquells timeouts no són una mesura vàlida de la velocitat del 4B. El
client corregit usa `curl`, plantilla ChatML i `--reasoning off`. El 4B s'ha
tornat a provar amb aquest harness; els resultats vàlids són els de la secció
següent.

## Comparació de models petits

### Qwen3 0.6B Q8_0

- Mida: 639.446.688 bytes.
- SHA-256:
  `9465E63A22ADD5354D9BB4B99E90117043C7124007664907259BD16D043BB031`.
- Benchmark CUDA: 522,21 tokens/s de prompt i 75,49 tokens/s de generació.
- Extracció sense gramàtica: 29,2 s, 250 tokens.
- Extracció amb schema compacte estricte: 32,4 s, 700 tokens,
  `finish_reason=length` i JSON truncat.

Errors observats:

- no va seguir el format JSON sense gramàtica;
- va ometre entitats explícites;
- va invertir filiacions;
- va inventar una germandat Clara–Jordi;
- va atribuir dates i evidències incorrectes;
- no va conservar correctament la incertesa.

**Resultat 0.6B:** rendiment bo, qualitat insuficient i insegura.

### Qwen3 1.7B Q8_0

- Mida: 1.834.426.016 bytes.
- SHA-256:
  `061B54DAADE076B5D3362DAC252678D17DA8C68F07560BE70818CACE6590CB1A`.
- Benchmark CUDA: 286,33 tokens/s de prompt i 45,13 tokens/s de generació.
- Schema compacte en una passada: 42,0 s i JSON complet, però amb omissions i
  referències a llocs inexistents.
- Segon intent monolític: 25,6 s, 1.000 tokens i JSON truncat.
- Etapa només d'entitats: 11,7 s i JSON complet.
- Etapa només de fets amb catàleg validat: 11,6 s i JSON complet.

La divisió per etapes millora molt la latència i la forma, però no resol la
semàntica:

- l'etapa d'entitats va ometre Marta i l'adreça com a lloc diferenciat;
- va classificar ambiguïtats amb referències sense explicació;
- l'etapa de fets va invertir les dues filiacions;
- va confondre `objectRef` i `placeRef`;
- va transformar `1955` i `1981` en dates exactes inventades;
- va ometre el naixement de Rosa, residències dels pares i la relació incerta
  Àlex–Marta.

**Resultat 1.7B:** millor que 0.6B i amb latència acceptable per etapes, però
encara massa poc fiable per proposar claims genealògiques.

### Qwen3 4B Q4_K_M — repetició amb harness corregit

- Mida: 2.497.280.256 bytes.
- SHA-256:
  `7485FE6F11AF29433BC51CAB58009521F205840F5B4AE3A32FA7F92E8534FDF5`.
- Benchmark CUDA: 114,34 tokens/s de prompt i 32,79 tokens/s de generació.
- Schema compacte en una passada: 69,6 s, 756 tokens i JSON complet.
- Etapa només d'entitats: 19,8 s, 541 tokens i JSON complet.
- Etapa només de fets amb catàleg validat: 28,4 s, 746 tokens i JSON complet.

L'etapa d'entitats és el primer resultat qualitativament bo de l'experiment:

- detecta Clara, Rosa, Jordi, Àlex i Marta;
- detecta Manresa, Berga, Barcelona i el carrer Nou 18;
- conserva evidències literals correctes;
- identifica Marta com a menció ambigua, encara que la descripció és massa
  concisa.

La passada monolítica i l'etapa de fets continuen sent insegures:

- inverteixen les filiacions de Rosa i Jordi respecte de Clara;
- omplen `objectRef` i `placeRef` quan haurien de ser `null`;
- inventen l'any 1958 per al naixement de Rosa;
- converteixen la germandat incerta Àlex–Marta en un fet segur;
- inventen dues germandats Clara–Marta duplicades;
- ometen residències dels pares i altres fets explícits.

**Resultat 4B:** millor model per a reconeixement d'entitats, però encara no és
apte per generar relacions, residències o esdeveniments sense una revisió i
correcció humana gairebé completa.

### Qwen2.5 3B Instruct Q4_K_M

- Mida: 2.104.932.768 bytes.
- SHA-256:
  `626B4A6678B86442240E33DF819E00132D3BA7DDDFE1CDC4FBB18E0A9615C62D`.
- Benchmark CUDA: 180,75 tokens/s de prompt i 41,76 tokens/s de generació.
- Primera passada descartada: el fixture contenia `/no_think`, específic de
  Qwen3, i Qwen2.5 el va copiar com a evidència.
- Schema compacte corregit: 15,3 s, 588 tokens i JSON complet.
- Etapa només d'entitats: 10,3 s, 374 tokens i JSON complet.
- Etapa només de fets amb catàleg validat: 13,2 s, 447 tokens i JSON complet.

És el model més ràpid en la prova estructurada, però no supera la qualitat dels
Qwen3:

- la passada única reutilitza la mateixa referència per a totes les persones;
- omet les entitats de lloc i barreja persones amb llocs;
- l'etapa d'entitats omet l'adreça i dona refs de lloc a Àlex i Marta;
- l'etapa de fets inverteix filiacions i associa una evidència de Jordi a Rosa;
- usa Barcelona com a lloc de residència del carrer Nou;
- inventa una germandat Clara–Àlex;
- omet el naixement de Rosa, residències dels pares i altres fets explícits.

La llicència és `Qwen Research License`: limita l'ús a finalitats no comercials
i exigeix demanar una llicència per a ús comercial. Això la fa inadequada per
distribuir-la amb FamilyHistory sense un acord addicional, fins i tot si la
qualitat hagués estat suficient.

**Resultat Qwen2.5 3B:** descartat per qualitat i per risc de llicència.

### Ministral 3 3B Instruct 2512

El GGUF Q4_K_M publicat per Mistral (2.147.023.008 bytes, SHA-256
`9ED150D4367E68DF0AC8E1540F6DDC65B42D0EE26378329D1ECBCA60F93FC5F8`)
no carrega amb `llama.cpp` b10453: `tokenizer.ggml.scores` està codificat com
`INT32` i el runtime el rebutja. No és un resultat de qualitat del model.

Per poder completar la prova s'ha usat la conversió Q8_0 publicada per
`ggml-org`, mantenidors de `llama.cpp`:

- Mida: 3.651.679.744 bytes.
- SHA-256:
  `70C6E5B77435062A46BFA3F0B9FA21744A10161ED23EABE9FDC47B3FB6711AD3`.
- Llicència: Apache 2.0.
- Benchmark CUDA: 160,41 tokens/s de prompt i 24,56 tokens/s de generació.
- Schema compacte en una passada: 100,53 s, 830 tokens i JSON complet.
- Etapa només d'entitats: 38,11 s i JSON complet.
- Etapa només de fets: 48,23 s, 512 tokens i JSON complet.

Errors observats:

- la passada monolítica inventa el cognom `Serra` per a Marta;
- inverteix les filiacions de Rosa i Jordi respecte de Clara;
- omet residències explícites dels pares;
- l'etapa d'entitats omet tots els llocs;
- l'etapa de fets converteix la germandat incerta Àlex–Marta en un fet;
- barreja llocs i relacions i no conserva tota la incertesa.

**Resultat Ministral 3 3B:** descartat per qualitat i latència. El Q4 oficial,
a més, presenta una incompatibilitat de metadades amb el runtime provat.

### Gemma 4 E2B Instruct Q4_0 QAT

- Artefacte GGUF oficial de Google.
- Mida: 3.349.516.256 bytes.
- SHA-256 oficial verificat:
  `FA401B55B07EE70A54C6DAE3903C783A6E65064312529EA57175CB5F8DEC6634`.
- Llicència: Apache 2.0.
- Benchmark CUDA: 217,40 tokens/s de prompt i 50,81 tokens/s de generació.
- Schema compacte en una passada: 52,98 s, 1.000 tokens, JSON truncat.
- Etapa només d'entitats: 8,03 s, 322 tokens i JSON complet.
- Etapa només de fets: 12,40 s, 562 tokens i JSON complet.

És el model mitjà més ràpid de la comparativa i reconeix correctament les cinc
persones. La qualitat semàntica continua sent insuficient:

- l'etapa d'entitats omet tots els llocs;
- les filiacions queden invertides;
- associa Berga a la relació de filiació en lloc del naixement de Rosa;
- crea només la residència de Clara i omet les dels pares;
- converteix la germandat incerta Àlex–Marta en un fet;
- la passada única excedeix el límit de sortida i no produeix JSON vàlid.

**Resultat Gemma 4 E2B:** millor rendiment global, però descartat per a
extracció genealògica automàtica amb aquest prompt i aquesta arquitectura.

## Conclusió

La inferència completament local és viable quant a privacitat, memòria i
velocitat bruta. Cap dels models provats compleix, però, el requisit de fidelitat
necessari per a dades personals i genealògiques. Un JSON vàlid no garanteix que
les referències, relacions, dates o evidències siguin correctes.

El 0.6B queda descartat. El 1.7B millora el format però no la fiabilitat
relacional. El 4B és útil per proposar entitats, però no supera el llindar per
crear claims de relacions o dates.

La família Qwen3 no publica cap model dens entre 1.7B i 4B. Qwen2.5 3B ocupa
aquest espai en mida i velocitat, però no millora la fidelitat i té una llicència
no comercial.

Ministral 3 3B i Gemma 4 E2B tampoc resolen els errors semàntics. Gemma és prou
ràpid, però la seva sortida continua sent insegura per crear claims sense una
correcció humana extensa.

**Decisió pendent d'aprovació:** conservar el checkpoint i el harness, no
integrar cap model provat i decidir si té sentit provar un model local més
generalista. L'aplicació continua intacta i sense dependència d'IA.
