# Alternatives locals — revisió experimental

**Data:** 2026-08-16

Criteris: execució íntegrament local, 4 GB de VRAM, GGUF verificable, català o
bon suport multilingüe, sortida estructurada i llicència apta per distribució.

## Provat — Ministral 3 3B Instruct 2512

- 3,4B de llenguatge; Q4_K_M oficial d'uns 2,15 GB.
- El GGUF Q4_K_M oficial no carrega amb `llama.cpp` b10453 per una metadada de
  tokenizer amb tipus invàlid. La conversió Q8_0 de `ggml-org` sí carrega.
- Apache 2.0.
- Dissenyat per a edge, system prompts, function calling i JSON natiu.
- Multilingüe; espanyol, francès, italià i portuguès entre els idiomes
  declarats, però català no confirmat explícitament.

Prova completada. Omet llocs, inverteix filiacions, transforma incertesa en fets
i és lent. No s'integra.

Font: https://huggingface.co/mistralai/Ministral-3-3B-Instruct-2512-GGUF

## Provat — Gemma 4 E2B Instruct

- 2,3B paràmetres efectius i 5,1B incloent embeddings.
- GGUF Q4_0 oficial verificat i executable amb 4 GB de VRAM.
- Apache 2.0.
- Preentrenat en més de 140 idiomes i suport directe de més de 35.
- System prompts i function calling natius.
- Model molt recent i multimodal: més complexitat de runtime que un model només
  de text.

Prova completada. És el model mitjà més ràpid, però omet llocs, inverteix
filiacions, barreja dades de naixement amb relacions i tracta una germandat
incerta com a fet. No s'integra.

Fonts:

- https://ai.google.dev/gemma/docs/core/model_card_4
- https://huggingface.co/google/gemma-4-E2B-it-qat-q4_0-gguf

## Prioritat 3 — Phi-4 Mini Instruct

- 3,8B, MIT, bon seguiment d'instruccions i function calling.
- Microsoft declara 24 idiomes, però no inclou català.
- No s'ha localitzat un GGUF publicat directament per Microsoft per a la versió
  mini; caldria conversió pròpia o confiar en una quantització de tercers.

La llicència és favorable, però llengua i cadena de subministrament la deixen
per darrere de Ministral i Gemma.

Font: https://huggingface.co/microsoft/Phi-4-mini-instruct

## Prioritat 4 — IBM Granite 3.3 2B Instruct

- GGUF Q4_K_M oficial d'uns 1,55 GB.
- Apache 2.0 i integració directa amb `llama.cpp`.
- Suporta 12 idiomes; català no està inclòs.
- Mida menor, amb risc de repetir els errors semàntics dels models 0.6B/1.7B.

És una alternativa lleugera i distribuïble, però no la primera opció per
qualitat lingüística en català.

Font: https://huggingface.co/ibm-granite/granite-3.3-2b-instruct-GGUF

## Alternatives descartades inicialment

- `SmolLM3 3B`: Apache 2.0 i lleuger, però només sis idiomes natius i sense
  català.
- `Llama 3.2 3B`: llicència pròpia de Meta i català no declarat oficialment.
- `Qwen2.5 3B Instruct`: errors semàntics en la prova i llicència no comercial.

## Recomanació actual

Aturar les proves de models petits: Qwen3, Qwen2.5, Ministral 3 3B i Gemma 4 E2B
fallen en la semàntica genealògica bàsica. Abans de continuar cal decidir si es
prova un model local més generalista, amb més cost de memòria i distribució, o
si la fase 7 continua amb extracció determinista i revisió manual sense LLM.
