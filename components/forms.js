import { EVENT_TYPES, MEDIA_TYPES } from "../models/schema.js";

const dialog = document.querySelector("#entity-dialog");
const title = document.querySelector("#dialog-title");
const body = document.querySelector("#dialog-body");
const submit = document.querySelector("#dialog-submit");

export function openEntityDialog({ heading, fields, value, onSave }) {
  title.textContent = heading;
  body.innerHTML = "";

  const form = document.createElement("div");
  form.className = "form-grid";
  for (const field of fields) {
    form.append(makeField(field, value));
  }
  body.append(form);

  submit.onclick = (event) => {
    event.preventDefault();
    onSave(readForm(fields, body));
    dialog.close();
  };

  dialog.showModal();
}

export function linkFields() {
  return [
    { name: "linksText", label: "Enllacos", type: "textarea", hint: "Un per linia: titol | https://..." }
  ];
}

export function parseLinks(text) {
  return splitLines(text).map((line) => {
    const [titol, url] = line.split("|").map((part) => part?.trim());
    return { titol: titol || url, url: url || titol };
  }).filter((link) => link.url);
}

export function stringifyLinks(links = []) {
  return links.map((link) => `${link.titol || link.url} | ${link.url}`).join("\n");
}

export function parseList(text) {
  return splitLines(text).flatMap((line) => line.split(",")).map((item) => item.trim()).filter(Boolean);
}

export function stringifyList(list = []) {
  return list.join(", ");
}

export function personFields(family, currentPersonId = null) {
  const people = family.people.filter((person) => person.id !== currentPersonId);
  return [
    { type: "section", label: "Dades principals" },
    { name: "nom", label: "Nom", required: true },
    { name: "cognoms", label: "Cognoms" },
    { name: "sexe", label: "Sexe", type: "select", options: ["", "F", "M", "X"] },
    { name: "naixement", label: "Naixement", type: "date" },
    { name: "defuncio", label: "Defuncio", type: "date" },
    { type: "section", label: "Relacions" },
    { name: "pares", label: "Pares", type: "multiselect", options: people.map(personOption) },
    { name: "fills", label: "Fills", type: "multiselect", options: people.map(personOption) },
    { name: "amics", label: "Amics", type: "multiselect", options: people.map(personOption) },
    { name: "tagsText", label: "Tags", hint: "Separats per coma" },
    { type: "section", label: "Fases de vida" },
    { name: "fases", label: "Fases", type: "lifephases", options: family.places.map(placeOption) },
    { type: "section", label: "Crear relacions noves" },
    { name: "newChildrenText", label: "Nous fills", type: "textarea", hint: "Un per linia: Nom Cognoms | naixement" },
    { name: "newFriendsText", label: "Nous amics", type: "textarea", hint: "Un per linia: Nom Cognoms | naixement" },
    { type: "section", label: "Llocs i esdeveniments" },
    { name: "llocs", label: "Llocs existents", type: "multiselect", options: family.places.map(placeOption) },
    { name: "newPlacesText", label: "Nous llocs", type: "textarea", hint: "Un per linia: Nom | tipus | adreca" },
    { name: "newEventsText", label: "Nous esdeveniments", type: "textarea", hint: "Un per linia: tipus | titol | data | descripcio" }
  ];
}

export function placeFields(family) {
  return [
    { name: "nom", label: "Nom", required: true },
    { name: "tipus", label: "Tipus" },
    { name: "adreca", label: "Adreca" },
    { name: "lat", label: "Latitud", type: "number", step: "any" },
    { name: "lon", label: "Longitud", type: "number", step: "any" },
    { name: "persones", label: "Persones", type: "multiselect", options: family.people.map(personOption) },
    { name: "descripcio", label: "Descripcio", type: "textarea" },
    ...linkFields()
  ];
}

export function eventFields(family) {
  return [
    { name: "tipus", label: "Tipus", type: "select", options: EVENT_TYPES },
    { name: "titol", label: "Titol", required: true },
    { name: "inici", label: "Inici", type: "date" },
    { name: "fi", label: "Fi", type: "date" },
    { name: "persones", label: "Persones", type: "multiselect", options: family.people.map(personOption) },
    { name: "llocs", label: "Llocs", type: "multiselect", options: family.places.map(placeOption) },
    { name: "media", label: "Media", type: "multiselect", options: family.media.map(mediaOption) },
    { name: "sources", label: "Fonts", type: "multiselect", options: family.sources.map(sourceOption) },
    { name: "descripcio", label: "Descripcio", type: "textarea" },
    ...linkFields()
  ];
}

export function sourceFields() {
  return [
    { name: "tipus", label: "Tipus" },
    { name: "titol", label: "Titol", required: true },
    { name: "data", label: "Data", type: "date" },
    { name: "url", label: "URL", type: "url" },
    { name: "notes", label: "Notes", type: "textarea" }
  ];
}

export function mediaFields(family) {
  return [
    { name: "tipus", label: "Tipus", type: "select", options: MEDIA_TYPES },
    { name: "titol", label: "Titol" },
    { name: "data", label: "Data", type: "date" },
    { name: "persones", label: "Persones", type: "multiselect", options: family.people.map(personOption) },
    { name: "llocs", label: "Llocs", type: "multiselect", options: family.places.map(placeOption) },
    { name: "events", label: "Esdeveniments", type: "multiselect", options: family.events.map(eventOption) },
    { name: "tagsText", label: "Tags", hint: "Separats per coma" },
    { name: "descripcio", label: "Descripcio", type: "textarea" }
  ];
}

function makeField(field, value) {
  if (field.type === "section") {
    const section = document.createElement("h3");
    section.className = "form-section span-2";
    section.textContent = field.label;
    return section;
  }

  if (field.type === "lifephases") {
    return makeLifePhasesField(field, value[field.name] || []);
  }

  const wrapper = document.createElement("label");
  wrapper.className = field.type === "textarea" || field.type === "multiselect" ? "span-2" : "";
  const caption = document.createElement("span");
  caption.textContent = field.label;
  wrapper.append(caption);

  const current = value[field.name] ?? "";
  let input;
  if (field.type === "textarea") {
    input = document.createElement("textarea");
    input.rows = 4;
    input.value = current;
  } else if (field.type === "select") {
    input = document.createElement("select");
    for (const option of field.options) input.add(new Option(option || "Sense especificar", option));
    input.value = current;
  } else if (field.type === "multiselect") {
    input = document.createElement("select");
    input.multiple = true;
    input.size = Math.min(Math.max(field.options.length, 3), 7);
    for (const option of field.options) input.add(new Option(option.label, option.value));
    const selected = new Set(Array.isArray(current) ? current : []);
    for (const option of input.options) option.selected = selected.has(option.value);
  } else {
    input = document.createElement("input");
    input.type = field.type || "text";
    if (field.step) input.step = field.step;
    input.value = current;
  }

  input.name = field.name;
  input.required = Boolean(field.required);
  wrapper.append(input);
  if (field.hint) {
    const hint = document.createElement("small");
    hint.textContent = field.hint;
    wrapper.append(hint);
  }
  return wrapper;
}

function readForm(fields, root) {
  const data = {};
  for (const field of fields) {
    if (field.type === "section") continue;
    if (field.type === "lifephases") {
      data[field.name] = readLifePhases(root);
      continue;
    }
    const input = root.querySelector(`[name="${field.name}"]`);
    if (!input) continue;
    if (field.type === "multiselect") {
      data[field.name] = Array.from(input.selectedOptions).map((option) => option.value);
    } else if (field.type === "number") {
      data[field.name] = Number(input.value || 0);
    } else {
      data[field.name] = input.value.trim();
    }
  }
  return data;
}

function makeLifePhasesField(field, phases) {
  const wrapper = document.createElement("div");
  wrapper.className = "lifephases-field span-2";
  wrapper.dataset.field = field.name;

  const header = document.createElement("div");
  header.className = "lifephases-header";
  const caption = document.createElement("span");
  caption.textContent = field.label;
  const addButton = document.createElement("button");
  addButton.type = "button";
  addButton.textContent = "Afegir fase";
  header.append(caption, addButton);

  const list = document.createElement("div");
  list.className = "lifephases-list";
  wrapper.append(header, list);

  const phaseValues = phases.length ? phases : defaultLifePhases();
  phaseValues.forEach((phase) => addLifePhaseRow(list, field.options, phase));
  addButton.addEventListener("click", () => addLifePhaseRow(list, field.options, {
    id: `phase_${Date.now()}`,
    titol: "Nova fase",
    llocResidencia: "",
    descripcio: "",
    links: []
  }));

  return wrapper;
}

function addLifePhaseRow(list, placeOptions, phase) {
  const row = document.createElement("section");
  row.className = "lifephase-row";
  row.dataset.phaseId = phase.id || `phase_${Date.now()}`;
  row.innerHTML = `
    <div class="lifephase-title-row">
      <label><span>Nom de la fase</span><input data-phase-field="titol" value="${escapeAttr(phase.titol || "")}"></label>
      <button type="button" data-remove-phase>Eliminar</button>
    </div>
    <label><span>Lloc de residencia existent</span><select data-phase-field="llocResidencia"></select></label>
    <div class="phase-place-grid">
      <label><span>Nou lloc: nom</span><input data-phase-field="nouLlocNom" value=""></label>
      <label><span>Tipus</span><input data-phase-field="nouLlocTipus" value=""></label>
      <label class="span-2"><span>Adreca</span><input data-phase-field="nouLlocAdreca" value=""></label>
      <label><span>Latitud</span><input type="number" step="any" data-phase-field="nouLlocLat" value=""></label>
      <label><span>Longitud</span><input type="number" step="any" data-phase-field="nouLlocLon" value=""></label>
      <label class="span-2"><span>Descripcio del lloc</span><textarea data-phase-field="nouLlocDescripcio" rows="2"></textarea></label>
      <label class="span-2"><span>Enllacos del lloc</span><textarea data-phase-field="nouLlocLinksText" rows="2"></textarea><small>Un per linia: titol | https://...</small></label>
    </div>
    <label><span>Breu descripcio</span><textarea data-phase-field="descripcio" rows="3">${escapeHtml(phase.descripcio || "")}</textarea></label>
    <label><span>Enllacos</span><textarea data-phase-field="linksText" rows="2">${escapeHtml(stringifyLinks(phase.links || []))}</textarea><small>Un per linia: titol | https://...</small></label>
  `;

  const select = row.querySelector('[data-phase-field="llocResidencia"]');
  select.add(new Option("Sense lloc", ""));
  for (const option of placeOptions) select.add(new Option(option.label, option.value));
  select.value = phase.llocResidencia || "";

  row.querySelector("[data-remove-phase]").addEventListener("click", () => row.remove());
  list.append(row);
}

function readLifePhases(root) {
  return Array.from(root.querySelectorAll(".lifephase-row")).map((row, index) => ({
    id: row.dataset.phaseId || `phase_${index + 1}`,
    titol: readPhaseField(row, "titol") || `Fase ${index + 1}`,
    llocResidencia: readPhaseField(row, "llocResidencia"),
    nouLloc: {
      nom: readPhaseField(row, "nouLlocNom"),
      tipus: readPhaseField(row, "nouLlocTipus"),
      adreca: readPhaseField(row, "nouLlocAdreca"),
      lat: Number(readPhaseField(row, "nouLlocLat") || 0),
      lon: Number(readPhaseField(row, "nouLlocLon") || 0),
      descripcio: readPhaseField(row, "nouLlocDescripcio"),
      links: parseLinks(readPhaseField(row, "nouLlocLinksText"))
    },
    descripcio: readPhaseField(row, "descripcio"),
    links: parseLinks(readPhaseField(row, "linksText"))
  })).filter((phase) => phase.titol || phase.descripcio || phase.llocResidencia || phase.nouLloc.nom);
}

function readPhaseField(row, name) {
  return row.querySelector(`[data-phase-field="${name}"]`)?.value.trim() || "";
}

function defaultLifePhases() {
  return ["Inici de vida", "Independencia", "Final de vida"].map((titol, index) => ({
    id: `phase_${index + 1}`,
    titol,
    llocResidencia: "",
    descripcio: "",
    links: []
  }));
}

function splitLines(text = "") {
  return text.split(/\r?\n/).map((line) => line.trim()).filter(Boolean);
}

function personOption(person) {
  return { value: person.id, label: `${person.nom} ${person.cognoms}`.trim() || person.id };
}

function placeOption(place) {
  return { value: place.id, label: place.nom || place.id };
}

function eventOption(event) {
  return { value: event.id, label: event.titol || event.tipus || event.id };
}

function mediaOption(item) {
  return { value: item.id, label: item.titol || item.fitxer || item.id };
}

function sourceOption(source) {
  return { value: source.id, label: source.titol || source.url || source.id };
}

function escapeHtml(value = "") {
  return String(value).replace(/[&<>"']/g, (char) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" })[char]);
}

function escapeAttr(value = "") {
  return escapeHtml(value).replace(/"/g, "&quot;");
}
