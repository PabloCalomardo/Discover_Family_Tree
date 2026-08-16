# PROVA EXPERIMENTAL — LLM local

> Aquesta carpeta és una prova de concepte de la fase 7. No forma part encara
> de l'arquitectura productiva i probablement s'haurà d'ajustar o eliminar.

## Punt de retorn

- Tag Git: `phase-7-local-llm-experiment-start`
- Commit: `5904e8098d05846c0641f3c7b2938e79d8c674fa`
- Missatge: `Checkpoint abans de iniciar procés IA`

El tag identifica l'estat estable anterior a la prova. Per inspeccionar què ha
introduït l'experiment es pot usar:

```powershell
git diff phase-7-local-llm-experiment-start
```

No s'ha d'eliminar ni restaurar cap canvi automàticament: abans de retirar la
prova cal revisar el diff i preservar qualsevol feina posterior no relacionada.

## Propòsit

Comprovar si un model petit executat íntegrament a l'ordinador pot transformar
una entrevista en català en candidats estructurats, sense enviar dades a cap
servei extern i sense modificar dades definitives.

La primera prova usa exclusivament el text fictici de `fixtures/`. No s'hi han
d'introduir dades personals reals fins que s'hagin verificat l'aïllament, els
logs i el cicle de vida dels temporals.

## Límits de privacitat de la prova

- inferència local amb `llama.cpp`;
- escolta només a `127.0.0.1`, si es fa servir el servidor;
- cap API ni fallback al núvol;
- cap entrenament, fine-tuning ni memòria entre execucions;
- prompts i respostes reals no s'han de registrar;
- models, runtime i sortides fora del control de versions;
- la IA només genera candidats: no accedeix a SQLite ni aplica canvis.

"No entrenar" no és suficient per si sol: la garantia principal és que el text
no surt del dispositiu i que el procés local no conserva la conversa.

## Candidat inicial

- Runtime: `llama.cpp`, binari CPU per Windows.
- Model: `Qwen3-4B-GGUF`, quantització `Q4_K_M` (~2,5 GB).
- Sortida: JSON restringit per `extraction.schema.json`.

Després del resultat lent del primer assaig, `extraction.compact.schema.json`
prova un contracte experimental alternatiu amb entitats i fets plans. No
substitueix el model de domini: requeriria un mapper determinista i validat cap
als candidats tipats abans de poder integrar-se.

El model no es distribueix amb el repositori. Durant la prova es desa sota
`%LOCALAPPDATA%\FamilyHistory\experimental-ai`.

## Criteris per continuar

- JSON vàlid i conforme a l'schema en totes les mostres sintètiques;
- cap fet no sustentat pel text;
- evidència traçable per a cada candidat;
- temps i memòria acceptables en l'equip de prova;
- funcionament sense xarxa un cop instal·lats runtime i model;
- procés sense persistència de prompts o respostes.

Si aquests criteris no es compleixen, l'experiment no s'integra i s'avalua un
model diferent, una extracció híbrida determinista o la retirada de la prova.
