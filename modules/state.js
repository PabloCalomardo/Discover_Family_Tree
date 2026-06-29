import { writeFamily } from "../services/fileSystem.js";
import { saveCachedArchive } from "../services/archiveStore.js";

const listeners = new Set();

export const state = {
  root: null,
  mode: "empty",
  family: null,
  mediaFiles: new Map(),
  view: "dashboard",
  selectedPersonId: null,
  dirty: false,
  saving: false,
  lastSavedAt: null
};

let saveTimer = null;

export function subscribe(listener) {
  listeners.add(listener);
  return () => listeners.delete(listener);
}

export function setProject(root, family, mediaFiles = new Map()) {
  state.root = root;
  state.mode = root ? "folder" : "archive";
  state.family = family;
  state.mediaFiles = mediaFiles;
  state.dirty = false;
  notify();
}

export function setMediaFiles(mediaFiles) {
  state.mediaFiles = mediaFiles;
  state.dirty = true;
  notify();
  scheduleSave();
}

export function setView(view) {
  state.view = view;
  notify();
}

export function setSelectedPerson(id) {
  state.selectedPersonId = id;
  notify();
}

export function mutateFamily(mutator, options = {}) {
  if (!state.family) return;
  mutator(state.family);
  state.dirty = true;
  notify();
  if (options.autosave !== false) scheduleSave();
}

export async function saveNow() {
  if (!state.family) return;
  state.saving = true;
  notify();
  if (state.root) {
    await writeFamily(state.root, state.family);
  } else {
    await saveCachedArchive(state.family, state.mediaFiles);
  }
  state.dirty = false;
  state.saving = false;
  state.lastSavedAt = new Date();
  notify();
}

function scheduleSave() {
  clearTimeout(saveTimer);
  saveTimer = setTimeout(() => saveNow().catch(console.error), 500);
}

function notify() {
  for (const listener of listeners) listener(state);
}
