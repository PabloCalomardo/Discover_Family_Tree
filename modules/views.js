import {
  eventTemplate,
  mediaTemplate,
  personTemplate,
  placeTemplate,
  sourceTemplate
} from "../models/schema.js";
import {
  eventFields,
  mediaFields,
  openEntityDialog,
  parseLinks,
  parseList,
  personFields,
  placeFields,
  sourceFields,
  stringifyLinks,
  stringifyList
} from "../components/forms.js";
import { importMediaFile, saveAudioRecording, saveCapturedPhoto } from "../services/media.js";
import { getProjectFileUrl } from "../services/fileSystem.js";
import { addMediaBlob, getMemoryFileUrl } from "../services/archiveStore.js";
import { mutateFamily, setMediaFiles, setSelectedPerson, setView, state } from "./state.js";
import { renderTree } from "./tree.js";

const app = document.querySelector("#app");
const title = document.querySelector("#view-title");

export function renderCurrentView() {
  if (!state.family) {
    title.textContent = "Dashboard";
    app.innerHTML = renderWelcome();
    return;
  }

  const renderers = {
    dashboard: renderDashboard,
    person: renderPerson,
    people: renderPeople,
    places: renderPlaces,
    events: renderEvents,
    tree: renderTreeView,
    timeline: renderTimeline,
    media: renderMedia,
    sources: renderSources
  };
  (renderers[state.view] || renderDashboard)();
}

function renderWelcome() {
  return `
    <section class="welcome">
      <div>
        <h2>Obre o crea un arxiu familiar</h2>
        <p>Tria una carpeta local. L'aplicacio creara data/family.json i les carpetes media necessaries.</p>
      </div>
    </section>
  `;
}

function renderDashboard() {
  title.textContent = "Dashboard";
  const { people, places, events, media, sources } = state.family;
  app.innerHTML = `
    <section class="stats-grid">
      ${stat("Persones", people.length)}
      ${stat("Llocs", places.length)}
      ${stat("Esdeveniments", events.length)}
      ${stat("Media", media.length)}
      ${stat("Fonts", sources.length)}
    </section>
    <section class="panel">
      <header><h2>Activitat rapida</h2></header>
      <div class="actions-row">
        <button data-action="new-person" class="primary">Nova persona</button>
        <button data-view-target="people">Obrir persones</button>
      </div>
    </section>
  `;
  wireSharedActions(app);
  wireViewTargets(app);
}

function renderPeople() {
  title.textContent = "Persones";
  app.innerHTML = `
    <section class="toolbar">
      <input id="people-search" type="search" placeholder="Cercar persona">
      <button data-action="new-person" class="primary">Nova persona</button>
    </section>
    <section id="people-list" class="list"></section>
  `;
  const search = app.querySelector("#people-search");
  const list = app.querySelector("#people-list");
  const paint = () => {
    const query = search.value.toLowerCase();
    const people = state.family.people.filter((person) =>
      `${person.nom} ${person.cognoms} ${person.tags?.join(" ")} ${person.fases?.map((phase) => phase.descripcio).join(" ")}`.toLowerCase().includes(query)
    );
    list.innerHTML = people.map(personCard).join("") || empty("No hi ha persones.");
    list.querySelectorAll("[data-edit]").forEach((button) => button.addEventListener("click", () => editPerson(button.dataset.edit)));
    list.querySelectorAll("[data-delete]").forEach((button) => button.addEventListener("click", () => deleteEntity("people", button.dataset.delete)));
    list.querySelectorAll("[data-select]").forEach((button) => button.addEventListener("click", () => {
      setSelectedPerson(button.dataset.select);
      setView("person");
    }));
  };
  search.addEventListener("input", paint);
  wireSharedActions(app);
  paint();
}

function renderPerson() {
  const person = selectedPerson();
  if (!person) {
    title.textContent = "Persona";
    app.innerHTML = `
      <section class="toolbar"><button data-action="new-person" class="primary">Nova persona</button></section>
      ${empty("Selecciona o crea una persona per comencar a relacionar informacio.")}
    `;
    wireSharedActions(app);
    return;
  }

  title.textContent = fullName(person);
  const related = getPersonRelations(person.id);
  app.innerHTML = `
    <section class="person-hero">
      <div>
        <p class="eyebrow">Fitxa central</p>
        <h2>${escapeHtml(fullName(person))}</h2>
        <p>${escapeHtml(dateRange(person.naixement, person.defuncio) || "Sense dates")}</p>
      </div>
      <div class="person-actions">
        <button data-edit-person="${person.id}">Editar persona</button>
        <button data-action="new-place-for-person">Afegir lloc</button>
        <button data-action="new-event-for-person">Afegir esdeveniment</button>
        <button data-action="import-media-for-person" class="primary">Afegir media</button>
      </div>
    </section>

    <section class="person-summary">
      ${stat("Llocs", related.places.length)}
      ${stat("Esdeveniments", related.events.length)}
      ${stat("Media", related.media.length)}
      ${stat("Fonts", related.sources.length)}
    </section>

    <section id="capture-zone"></section>

    <section class="person-grid">
      <article class="panel">
        <header><h2>Llocs</h2><button data-action="new-place-for-person">Afegir</button></header>
        <div class="mini-list">${related.places.map(placeMiniCard).join("") || empty("Encara no hi ha llocs associats.")}</div>
      </article>
      <article class="panel">
        <header><h2>Esdeveniments</h2><button data-action="new-event-for-person">Afegir</button></header>
        <div class="mini-list">${related.events.map(eventMiniCard).join("") || empty("Encara no hi ha esdeveniments associats.")}</div>
      </article>
      <article class="panel span-2">
        <header><h2>Fases de vida</h2></header>
        <div class="lifephase-cards">${(person.fases || []).map(lifePhaseCard).join("") || empty("Encara no hi ha fases de vida.")}</div>
      </article>
      <article class="panel span-2">
        <header><h2>Relacions</h2></header>
        <div class="relation-columns">
          ${relationGroup("Pares", related.parents)}
          ${relationGroup("Fills", related.children)}
          ${relationGroup("Amics", related.friends)}
        </div>
      </article>
      <article class="panel span-2">
        <header>
          <h2>Media</h2>
          <div class="actions-row">
            <button data-action="import-media-for-person">Importar</button>
            <button data-action="camera-for-person">Camera</button>
            <button data-action="audio-for-person">Gravar audio</button>
          </div>
        </header>
        <div class="gallery">${related.media.map(mediaCard).join("") || empty("Encara no hi ha media associada.")}</div>
      </article>
      <article class="panel span-2">
        <header><h2>Fonts relacionades</h2></header>
        <div class="mini-list">${related.sources.map(sourceCard).join("") || empty("Les fonts apareixeran aqui quan estiguin associades als esdeveniments d'aquesta persona.")}</div>
      </article>
    </section>
  `;

  app.querySelector("[data-edit-person]").addEventListener("click", () => editPerson(person.id));
  wirePersonActions(app, person.id);
  app.querySelectorAll("[data-edit]").forEach((button) => {
    const { type, edit } = button.dataset;
    if (type === "place") button.addEventListener("click", () => editPlace(edit, person.id));
    if (type === "event") button.addEventListener("click", () => editEvent(edit, person.id));
    if (type === "media") button.addEventListener("click", () => editMedia(edit, person.id));
  });
  app.querySelectorAll("[data-delete]").forEach((button) => {
    if (button.dataset.type === "media") button.addEventListener("click", () => deleteEntity("media", button.dataset.delete));
  });
  app.querySelectorAll("[data-open-person]").forEach((button) => {
    button.addEventListener("click", () => {
      setSelectedPerson(button.dataset.openPerson);
      setView("person");
    });
  });
  loadMediaPreviews();
}

function renderPlaces() {
  title.textContent = "Llocs";
  app.innerHTML = `
    <section class="toolbar"><button data-action="new-place" class="primary">Nou lloc</button></section>
    <section class="list">${state.family.places.map(placeCard).join("") || empty("No hi ha llocs.")}</section>
  `;
  app.querySelectorAll("[data-edit]").forEach((button) => button.addEventListener("click", () => editPlace(button.dataset.edit)));
  app.querySelectorAll("[data-delete]").forEach((button) => button.addEventListener("click", () => deleteEntity("places", button.dataset.delete)));
  wireSharedActions(app);
}

function renderEvents() {
  title.textContent = "Esdeveniments";
  app.innerHTML = `
    <section class="toolbar">
      <select id="event-filter"><option value="">Tots els tipus</option></select>
      <button data-action="new-event" class="primary">Nou esdeveniment</button>
    </section>
    <section id="events-list" class="list"></section>
  `;
  const filter = app.querySelector("#event-filter");
  [...new Set(state.family.events.map((event) => event.tipus))].forEach((type) => filter.add(new Option(type, type)));
  const list = app.querySelector("#events-list");
  const paint = () => {
    const events = state.family.events.filter((event) => !filter.value || event.tipus === filter.value);
    list.innerHTML = events.map(eventCard).join("") || empty("No hi ha esdeveniments.");
    list.querySelectorAll("[data-edit]").forEach((button) => button.addEventListener("click", () => editEvent(button.dataset.edit)));
    list.querySelectorAll("[data-delete]").forEach((button) => button.addEventListener("click", () => deleteEntity("events", button.dataset.delete)));
  };
  filter.addEventListener("change", paint);
  wireSharedActions(app);
  paint();
}

function renderTreeView() {
  title.textContent = "Arbre genealogic";
  app.innerHTML = `
    <section class="toolbar">
      <select id="tree-person"></select>
      <button id="center-person">Centrar persona</button>
    </section>
    <section id="tree-root" class="tree-wrap"></section>
  `;
  const select = app.querySelector("#tree-person");
  state.family.people.forEach((person) => select.add(new Option(fullName(person), person.id)));
  select.value = state.selectedPersonId || state.family.people[0]?.id || "";
  select.addEventListener("change", () => setSelectedPerson(select.value));
  app.querySelector("#center-person").addEventListener("click", () => renderCurrentView());
  renderTree(app.querySelector("#tree-root"), state.family, select.value, (id) => {
    setSelectedPerson(id);
    setView("person");
  });
}

function renderTimeline() {
  title.textContent = "Cronologia";
  const selected = state.family.people.find((person) => person.id === state.selectedPersonId) || state.family.people[0];
  const events = selected
    ? state.family.events.filter((event) => event.persones.includes(selected.id)).sort((a, b) => (a.inici || "").localeCompare(b.inici || ""))
    : [];
  app.innerHTML = `
    <section class="toolbar">
      <select id="timeline-person"></select>
    </section>
    <section class="timeline">
      ${events.map(timelineItem).join("") || empty("Selecciona una persona amb esdeveniments associats.")}
    </section>
  `;
  const select = app.querySelector("#timeline-person");
  state.family.people.forEach((person) => select.add(new Option(fullName(person), person.id)));
  select.value = selected?.id || "";
  select.addEventListener("change", () => setSelectedPerson(select.value));
}

function renderMedia() {
  title.textContent = "Galeria multimedia";
  app.innerHTML = `
    <section class="toolbar">
      <button data-action="import-media" class="primary">Importar fitxer</button>
      <button id="camera-button">Camera</button>
      <button id="audio-button">Gravar audio</button>
    </section>
    <section id="capture-zone"></section>
    <section class="gallery">${state.family.media.map(mediaCard).join("") || empty("No hi ha fitxers multimedia.")}</section>
  `;
  app.querySelector("#camera-button").addEventListener("click", openCamera);
  app.querySelector("#audio-button").addEventListener("click", openRecorder);
  app.querySelectorAll("[data-edit]").forEach((button) => button.addEventListener("click", () => editMedia(button.dataset.edit)));
  app.querySelectorAll("[data-delete]").forEach((button) => button.addEventListener("click", () => deleteEntity("media", button.dataset.delete)));
  wireSharedActions(app);
  loadMediaPreviews();
}

function renderSources() {
  title.textContent = "Fonts";
  app.innerHTML = `
    <section class="toolbar"><button data-action="new-source" class="primary">Nova font</button></section>
    <section class="list">${state.family.sources.map(sourceCard).join("") || empty("No hi ha fonts.")}</section>
  `;
  app.querySelectorAll("[data-edit]").forEach((button) => button.addEventListener("click", () => editSource(button.dataset.edit)));
  app.querySelectorAll("[data-delete]").forEach((button) => button.addEventListener("click", () => deleteEntity("sources", button.dataset.delete)));
  wireSharedActions(app);
}

function wireSharedActions(root) {
  root.querySelectorAll("[data-action='new-person']").forEach((button) => button.addEventListener("click", () => editPerson()));
  root.querySelectorAll("[data-action='new-place']").forEach((button) => button.addEventListener("click", () => editPlace()));
  root.querySelectorAll("[data-action='new-event']").forEach((button) => button.addEventListener("click", () => editEvent()));
  root.querySelectorAll("[data-action='new-source']").forEach((button) => button.addEventListener("click", () => editSource()));
  root.querySelectorAll("[data-action='import-media']").forEach((button) => button.addEventListener("click", () => importMedia()));
}

function wireViewTargets(root) {
  root.querySelectorAll("[data-view-target]").forEach((button) => {
    button.addEventListener("click", () => setView(button.dataset.viewTarget));
  });
}

function wirePersonActions(root, personId) {
  root.querySelectorAll("[data-action='new-place-for-person']").forEach((button) => button.addEventListener("click", () => editPlace(null, personId)));
  root.querySelectorAll("[data-action='new-event-for-person']").forEach((button) => button.addEventListener("click", () => editEvent(null, personId)));
  root.querySelectorAll("[data-action='import-media-for-person']").forEach((button) => button.addEventListener("click", () => importMedia(personId)));
  root.querySelectorAll("[data-action='camera-for-person']").forEach((button) => button.addEventListener("click", () => openCamera(personId)));
  root.querySelectorAll("[data-action='audio-for-person']").forEach((button) => button.addEventListener("click", () => openRecorder(personId)));
}

function editPerson(id) {
  const existing = state.family.people.find((person) => person.id === id);
  const directPlaces = existing ? state.family.places.filter((place) => place.persones?.includes(existing.id)).map((place) => place.id) : [];
  const directChildren = existing ? state.family.people.filter((person) => person.pares?.includes(existing.id)).map((person) => person.id) : [];
  const value = existing
    ? {
        ...existing,
        germans: existing.germans || [],
        amics: existing.amics || [],
        fills: directChildren,
        llocs: directPlaces,
        tagsText: stringifyList(existing.tags),
      }
    : { ...personTemplate(), fills: [], llocs: [] };
  openEntityDialog({
    heading: existing ? "Editar persona" : "Nova persona",
    fields: personFields(state.family, id),
    value,
    onSave: (data) => {
      const next = {
        ...value,
        ...data,
        germans: value.germans || [],
        amics: data.amics || [],
        notes: "",
        tags: parseList(data.tagsText),
        links: [],
        fases: data.fases || []
      };
      deletePersonFormOnlyFields(next);
      mutateFamily((family) => savePersonWithRelations(family, next, data));
      if (!existing) {
        setSelectedPerson(next.id);
        setView("person");
      }
    }
  });
}

function editPlace(id, personId = null) {
  const existing = state.family.places.find((place) => place.id === id);
  const value = existing
    ? { ...existing, lat: existing.coordenades?.lat || 0, lon: existing.coordenades?.lon || 0, linksText: stringifyLinks(existing.links) }
    : { ...placeTemplate(), persones: personId ? [personId] : [], lat: 0, lon: 0 };
  openEntityDialog({
    heading: existing ? "Editar lloc" : "Nou lloc",
    fields: placeFields(state.family),
    value,
    onSave: (data) => mutateFamily((family) => {
      const next = { ...value, ...data, coordenades: { lat: data.lat, lon: data.lon }, links: parseLinks(data.linksText) };
      delete next.lat;
      delete next.lon;
      delete next.linksText;
      upsert(family.places, next);
    })
  });
}

function editEvent(id, personId = null) {
  const existing = state.family.events.find((event) => event.id === id);
  const value = existing
    ? { ...existing, linksText: stringifyLinks(existing.links) }
    : { ...eventTemplate(), persones: personId ? [personId] : [] };
  openEntityDialog({
    heading: existing ? "Editar esdeveniment" : "Nou esdeveniment",
    fields: eventFields(state.family),
    value,
    onSave: (data) => mutateFamily((family) => {
      const next = { ...value, ...data, links: parseLinks(data.linksText) };
      delete next.linksText;
      upsert(family.events, next);
    })
  });
}

function editSource(id) {
  const existing = state.family.sources.find((source) => source.id === id);
  const value = existing || sourceTemplate();
  openEntityDialog({
    heading: existing ? "Editar font" : "Nova font",
    fields: sourceFields(),
    value,
    onSave: (data) => mutateFamily((family) => upsert(family.sources, { ...value, ...data }))
  });
}

function editMedia(id, personId = null) {
  const existing = state.family.media.find((item) => item.id === id);
  const value = existing
    ? { ...existing, tagsText: stringifyList(existing.tags) }
    : { ...mediaTemplate(), persones: personId ? [personId] : [] };
  openEntityDialog({
    heading: "Editar media",
    fields: mediaFields(state.family),
    value,
    onSave: (data) => mutateFamily((family) => {
      const next = { ...value, ...data, tags: parseList(data.tagsText) };
      delete next.tagsText;
      upsert(family.media, next);
    })
  });
}

async function importMedia(personId = null) {
  const file = await pickBrowserFile();
  const item = await importMediaFile(state.root, file, { persones: personId ? [personId] : [] });
  if (!state.root) setMediaFiles(addMediaBlob(state.mediaFiles, item.fitxer, file));
  mutateFamily((family) => family.media.push(item));
}

function pickBrowserFile() {
  if (window.showOpenFilePicker) {
    return window.showOpenFilePicker({ multiple: false })
      .then((handles) => handles[0].getFile());
  }

  return new Promise((resolve, reject) => {
    const input = document.createElement("input");
    input.type = "file";
    input.addEventListener("change", () => {
      const [file] = input.files;
      if (file) resolve(file);
      else reject(new Error("No s'ha seleccionat cap fitxer."));
    });
    input.click();
  });
}

async function openCamera(personId = null) {
  const zone = app.querySelector("#capture-zone");
  zone.innerHTML = `<section class="capture"><video autoplay playsinline></video><button id="take-photo" class="primary">Fer foto</button></section>`;
  const stream = await navigator.mediaDevices.getUserMedia({ video: true });
  const video = zone.querySelector("video");
  video.srcObject = stream;
  zone.querySelector("#take-photo").addEventListener("click", async () => {
    const canvas = document.createElement("canvas");
    canvas.width = video.videoWidth;
    canvas.height = video.videoHeight;
    canvas.getContext("2d").drawImage(video, 0, 0);
    const blob = await new Promise((resolve) => canvas.toBlob(resolve, "image/jpeg", 0.92));
    stream.getTracks().forEach((track) => track.stop());
    const item = await saveCapturedPhoto(state.root, blob, { persones: personId ? [personId] : [] });
    if (!state.root) setMediaFiles(addMediaBlob(state.mediaFiles, item.fitxer, blob));
    mutateFamily((family) => family.media.push(item));
  });
}

async function openRecorder(personId = null) {
  const zone = app.querySelector("#capture-zone");
  zone.innerHTML = `<section class="capture"><p id="record-status">Preparat per gravar.</p><button id="start-record" class="primary">Iniciar</button><button id="stop-record" disabled>Aturar</button></section>`;
  const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
  const chunks = [];
  const recorder = new MediaRecorder(stream);
  recorder.ondataavailable = (event) => chunks.push(event.data);
  recorder.onstop = async () => {
    stream.getTracks().forEach((track) => track.stop());
    const blob = new Blob(chunks, { type: "audio/webm" });
    const item = await saveAudioRecording(state.root, blob, { persones: personId ? [personId] : [] });
    if (!state.root) setMediaFiles(addMediaBlob(state.mediaFiles, item.fitxer, blob));
    mutateFamily((family) => family.media.push(item));
  };
  zone.querySelector("#start-record").addEventListener("click", () => {
    recorder.start();
    zone.querySelector("#record-status").textContent = "Gravant...";
    zone.querySelector("#start-record").disabled = true;
    zone.querySelector("#stop-record").disabled = false;
  });
  zone.querySelector("#stop-record").addEventListener("click", () => recorder.stop());
}

function deleteEntity(collection, id) {
  if (!confirm("Vols eliminar aquest registre?")) return;
  mutateFamily((family) => {
    family[collection] = family[collection].filter((item) => item.id !== id);
  });
}

function upsert(list, item) {
  const index = list.findIndex((candidate) => candidate.id === item.id);
  if (index >= 0) list[index] = item;
  else list.push(item);
}

function savePersonWithRelations(family, person, formData) {
  upsert(family.people, ensurePersonArrays(person));

  const phasePlaces = materializePhasePlaces(family, person, formData.fases || []);
  person.fases = phasePlaces.fases;

  const selectedPlaceIds = [...(formData.llocs || []), ...phasePlaces.placeIds];
  const newPlaces = parseNewPlaces(formData.newPlacesText).map((place) => ({
    ...placeTemplate(),
    ...place,
    persones: [person.id]
  }));
  family.places.push(...newPlaces);
  selectedPlaceIds.push(...newPlaces.map((place) => place.id));
  syncPersonPlaces(family, person.id, selectedPlaceIds);

  const selectedChildren = [...(formData.fills || [])];
  const createdChildren = parseRelatedPeople(formData.newChildrenText, person.cognoms).map((child) => ({
    ...personTemplate(),
    ...child,
    pares: [person.id]
  }));
  family.people.push(...createdChildren.map(ensurePersonArrays));
  selectedChildren.push(...createdChildren.map((child) => child.id));
  syncChildren(family, person.id, selectedChildren);

  const createdFriends = parseRelatedPeople(formData.newFriendsText).map((friend) => ({
    ...personTemplate(),
    ...friend,
    amics: [person.id]
  }));
  family.people.push(...createdFriends.map(ensurePersonArrays));
  syncMutualRelation(family, person.id, "amics", [...(formData.amics || []), ...createdFriends.map((friend) => friend.id)]);

  const relatedPlaceIds = [...new Set(selectedPlaceIds)];
  const newEvents = parseNewEvents(formData.newEventsText).map((event) => ({
    ...eventTemplate(),
    ...event,
    persones: [person.id],
    llocs: relatedPlaceIds
  }));
  family.events.push(...newEvents);
}

function deletePersonFormOnlyFields(person) {
  delete person.fills;
  delete person.llocs;
  delete person.tagsText;
  delete person.newChildrenText;
  delete person.newFriendsText;
  delete person.newPlacesText;
  delete person.newEventsText;
}

function ensurePersonArrays(person) {
  person.pares = Array.isArray(person.pares) ? person.pares : [];
  person.germans = Array.isArray(person.germans) ? person.germans : [];
  person.amics = Array.isArray(person.amics) ? person.amics : [];
  person.fases = Array.isArray(person.fases) ? person.fases : [];
  person.tags = Array.isArray(person.tags) ? person.tags : [];
  person.links = Array.isArray(person.links) ? person.links : [];
  return person;
}

function materializePhasePlaces(family, person, phases) {
  const placeIds = [];
  const cleanPhases = phases.map((phase, index) => {
    let placeId = phase.llocResidencia || "";
    if (phase.nouLloc?.nom) {
      const place = {
        ...placeTemplate(),
        nom: phase.nouLloc.nom,
        tipus: phase.nouLloc.tipus || "residencia",
        adreca: phase.nouLloc.adreca || "",
        coordenades: {
          lat: phase.nouLloc.lat || 0,
          lon: phase.nouLloc.lon || 0
        },
        descripcio: phase.nouLloc.descripcio || "",
        links: Array.isArray(phase.nouLloc.links) ? phase.nouLloc.links : [],
        persones: [person.id]
      };
      family.places.push(place);
      placeId = place.id;
    }
    if (placeId) placeIds.push(placeId);
    return {
      id: phase.id || `phase_${index + 1}`,
      titol: phase.titol || `Fase ${index + 1}`,
      llocResidencia: placeId,
      descripcio: phase.descripcio || "",
      links: Array.isArray(phase.links) ? phase.links : []
    };
  });
  return { fases: cleanPhases, placeIds };
}

function syncPersonPlaces(family, personId, selectedPlaceIds) {
  const selected = new Set(selectedPlaceIds);
  for (const place of family.places) {
    place.persones = Array.isArray(place.persones) ? place.persones : [];
    place.persones = place.persones.filter((id) => id !== personId);
    if (selected.has(place.id)) place.persones.push(personId);
  }
}

function syncChildren(family, parentId, childIds) {
  const selected = new Set(childIds);
  for (const person of family.people) {
    person.pares = Array.isArray(person.pares) ? person.pares : [];
    person.pares = person.pares.filter((id) => id !== parentId);
    if (selected.has(person.id)) person.pares.push(parentId);
  }
}

function syncMutualRelation(family, personId, field, relatedIds) {
  const selected = new Set(relatedIds.filter((id) => id && id !== personId));
  const person = family.people.find((candidate) => candidate.id === personId);
  if (!person) return;

  person[field] = [...selected];
  for (const other of family.people) {
    other[field] = Array.isArray(other[field]) ? other[field] : [];
    other[field] = other[field].filter((id) => id !== personId);
    if (selected.has(other.id)) other[field].push(personId);
  }
}

function parseRelatedPeople(text = "", fallbackSurname = "") {
  return splitFormLines(text).map((line) => {
    const [namePart, datePart] = line.split("|").map((part) => part?.trim() || "");
    const words = namePart.split(/\s+/).filter(Boolean);
    const nom = words.shift() || "";
    const cognoms = words.join(" ") || fallbackSurname || "";
    return { nom, cognoms, naixement: datePart };
  }).filter((person) => person.nom);
}

function parseNewPlaces(text = "") {
  return splitFormLines(text).map((line) => {
    const [nom, tipus, adreca] = line.split("|").map((part) => part?.trim() || "");
    return { nom, tipus, adreca };
  }).filter((place) => place.nom);
}

function parseNewEvents(text = "") {
  return splitFormLines(text).map((line) => {
    const [tipus, titol, inici, descripcio] = line.split("|").map((part) => part?.trim() || "");
    return { tipus: tipus || "altre", titol: titol || tipus || "Esdeveniment", inici, descripcio };
  }).filter((event) => event.titol);
}

function splitFormLines(text = "") {
  return text.split(/\r?\n/).map((line) => line.trim()).filter(Boolean);
}

function stat(label, value) {
  return `<article class="stat"><span>${label}</span><strong>${value}</strong></article>`;
}

function personCard(person) {
  return `
    <article class="item-card">
      <div><h3>${escapeHtml(fullName(person))}</h3><p>${dateRange(person.naixement, person.defuncio) || "Sense dates"}</p></div>
      <div class="card-actions">
        <button data-select="${person.id}" class="primary">Obrir fitxa</button>
        <button data-edit="${person.id}">Editar</button>
        <button data-delete="${person.id}">Eliminar</button>
      </div>
    </article>`;
}

function placeCard(place) {
  return `
    <article class="item-card">
      <div><h3>${escapeHtml(place.nom || "Sense nom")}</h3><p>${escapeHtml(place.tipus || "")} ${escapeHtml(place.adreca || "")}</p>${renderLinks(place.links)}</div>
      <div class="card-actions"><button data-edit="${place.id}">Editar</button><button data-delete="${place.id}">Eliminar</button></div>
    </article>`;
}

function placeMiniCard(place) {
  return `
    <div class="mini-card">
      <div><strong>${escapeHtml(place.nom || "Sense nom")}</strong><span>${escapeHtml(place.tipus || place.adreca || "")}</span></div>
      <button data-type="place" data-edit="${place.id}">Editar</button>
    </div>`;
}

function eventCard(event) {
  return `
    <article class="item-card">
      <div><h3>${escapeHtml(event.titol || event.tipus)}</h3><p>${escapeHtml(event.tipus)} &middot; ${dateRange(event.inici, event.fi)}</p><p>${escapeHtml(event.descripcio || "")}</p>${renderLinks(event.links)}</div>
      <div class="card-actions"><button data-edit="${event.id}">Editar</button><button data-delete="${event.id}">Eliminar</button></div>
    </article>`;
}

function eventMiniCard(event) {
  return `
    <div class="mini-card">
      <div><strong>${escapeHtml(event.titol || event.tipus)}</strong><span>${escapeHtml(dateRange(event.inici, event.fi) || event.tipus)}</span></div>
      <button data-type="event" data-edit="${event.id}">Editar</button>
    </div>`;
}

function relationGroup(label, people) {
  return `
    <div class="relation-group">
      <h3>${escapeHtml(label)}</h3>
      <div class="mini-list">${people.map(relationPersonCard).join("") || `<p class="muted">${label}: cap relacio.</p>`}</div>
    </div>`;
}

function relationPersonCard(person) {
  return `
    <button class="relation-person" data-open-person="${person.id}">
      <strong>${escapeHtml(fullName(person))}</strong>
      <span>${escapeHtml(dateRange(person.naixement, person.defuncio) || "Obrir fitxa")}</span>
    </button>`;
}

function lifePhaseCard(phase) {
  const place = state.family.places.find((candidate) => candidate.id === phase.llocResidencia);
  return `
    <article class="lifephase-card">
      <h3>${escapeHtml(phase.titol || "Fase de vida")}</h3>
      ${place ? `<p><strong>Residencia:</strong> ${escapeHtml(place.nom || place.adreca || "Lloc")}</p>` : ""}
      ${phase.descripcio ? `<p>${escapeHtml(phase.descripcio)}</p>` : ""}
      ${renderLinks(phase.links || [])}
    </article>`;
}

function sourceCard(source) {
  const url = source.url ? `<a href="${escapeAttr(source.url)}" target="_blank" rel="noreferrer">${escapeHtml(source.url)}</a>` : "";
  return `
    <article class="item-card">
      <div><h3>${escapeHtml(source.titol || "Sense titol")}</h3><p>${escapeHtml(source.tipus || "")} ${escapeHtml(source.data || "")}</p>${url}<p>${escapeHtml(source.notes || "")}</p></div>
      <div class="card-actions"><button data-edit="${source.id}">Editar</button><button data-delete="${source.id}">Eliminar</button></div>
    </article>`;
}

function mediaCard(item) {
  return `
    <article class="media-card">
      <div class="media-preview">${mediaPreview(item)}</div>
      <h3>${escapeHtml(item.titol || item.fitxer || "Media")}</h3>
      <p>${escapeHtml(item.tipus)} &middot; ${escapeHtml(item.data || "")}</p>
      <div class="card-actions"><button data-type="media" data-edit="${item.id}">Editar</button><button data-type="media" data-delete="${item.id}">Eliminar</button></div>
    </article>`;
}

function timelineItem(event) {
  return `<article class="timeline-item"><time>${escapeHtml(event.inici || "Sense data")}</time><div><h3>${escapeHtml(event.titol || event.tipus)}</h3><p>${escapeHtml(event.descripcio || "")}</p></div></article>`;
}

function mediaPreview(item) {
  return `<span data-preview="${escapeAttr(item.id)}">${escapeHtml(item.tipus || "Media")}</span>`;
}

async function loadMediaPreviews() {
  const cards = app.querySelectorAll("[data-preview]");
  for (const preview of cards) {
    const item = state.family.media.find((candidate) => candidate.id === preview.dataset.preview);
    if (!item?.fitxer) continue;
    try {
      const url = state.root
        ? await getProjectFileUrl(state.root, item.fitxer)
        : getMemoryFileUrl(state.mediaFiles, item.fitxer);
      if (!url) throw new Error("Fitxer no disponible");
      if (item.tipus === "foto") {
        preview.outerHTML = `<img src="${url}" alt="${escapeAttr(item.titol || "Foto")}">`;
      } else if (item.tipus === "audio") {
        preview.outerHTML = `<audio controls src="${url}"></audio>`;
      } else if (item.tipus === "video") {
        preview.outerHTML = `<video controls src="${url}"></video>`;
      } else {
        preview.outerHTML = `<a href="${url}" target="_blank" rel="noreferrer">Obrir document</a>`;
      }
    } catch {
      preview.textContent = "No s'ha pogut carregar";
    }
  }
}

function renderLinks(links = []) {
  if (!links.length) return "";
  return `<div class="links">${links.map((link) => `<a href="${escapeAttr(link.url)}" target="_blank" rel="noreferrer">${escapeHtml(link.titol || link.url)}</a>`).join("")}</div>`;
}

function selectedPerson() {
  return state.family.people.find((person) => person.id === state.selectedPersonId) || state.family.people[0] || null;
}

function getPersonRelations(personId) {
  const person = state.family.people.find((candidate) => candidate.id === personId);
  const events = state.family.events
    .filter((event) => event.persones?.includes(personId))
    .sort((a, b) => (a.inici || "").localeCompare(b.inici || ""));
  const eventIds = new Set(events.map((event) => event.id));
  const placeIds = new Set(events.flatMap((event) => event.llocs || []));
  const mediaIds = new Set(events.flatMap((event) => event.media || []));
  const sourceIds = new Set(events.flatMap((event) => event.sources || []));

  const media = state.family.media.filter((item) => {
    const direct = item.persones?.includes(personId);
    const fromEvent = (item.events || []).some((id) => eventIds.has(id)) || mediaIds.has(item.id);
    if (direct || fromEvent) {
      (item.llocs || []).forEach((id) => placeIds.add(id));
      return true;
    }
    return false;
  });

  const places = state.family.places.filter((place) => place.persones?.includes(personId) || placeIds.has(place.id));
  const sources = state.family.sources.filter((source) => sourceIds.has(source.id));
  const parents = state.family.people.filter((candidate) => person?.pares?.includes(candidate.id));
  const children = state.family.people.filter((candidate) => candidate.pares?.includes(personId));
  const siblings = state.family.people.filter((candidate) => person?.germans?.includes(candidate.id) || candidate.germans?.includes(personId));
  const friends = state.family.people.filter((candidate) => person?.amics?.includes(candidate.id) || candidate.amics?.includes(personId));
  return { events, media, places, sources, parents, children, siblings, friends };
}

function fullName(person) {
  return `${person.nom || ""} ${person.cognoms || ""}`.trim() || "Sense nom";
}

function dateRange(start, end) {
  return [start, end].filter(Boolean).join(" - ");
}

function empty(message) {
  return `<div class="empty">${message}</div>`;
}

function escapeHtml(value = "") {
  return String(value).replace(/[&<>"']/g, (char) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" })[char]);
}

function escapeAttr(value = "") {
  return escapeHtml(value).replace(/"/g, "&quot;");
}
