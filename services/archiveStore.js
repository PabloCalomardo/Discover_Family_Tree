import { normalizeFamily } from "../models/schema.js";

const DB_NAME = "family-archive-local";
const DB_VERSION = 1;
const PROJECT_ID = "current";

export async function loadCachedArchive() {
  const db = await openDb();
  const tx = db.transaction(["meta", "files"], "readonly");
  const meta = await requestToPromise(tx.objectStore("meta").get(PROJECT_ID));
  if (!meta?.family) return null;
  const files = await requestToPromise(tx.objectStore("files").getAll());
  await txDone(tx);
  return {
    family: normalizeFamily(meta.family),
    mediaFiles: new Map(files.map((entry) => [entry.path, entry.blob])),
    loadedAt: meta.updatedAt ? new Date(meta.updatedAt) : null
  };
}

export async function saveCachedArchive(family, mediaFiles = new Map()) {
  const db = await openDb();
  const tx = db.transaction(["meta", "files"], "readwrite");
  tx.objectStore("meta").put({
    id: PROJECT_ID,
    family: normalizeFamily(family),
    updatedAt: new Date().toISOString()
  });

  const filesStore = tx.objectStore("files");
  await requestToPromise(filesStore.clear());
  for (const [path, blob] of mediaFiles.entries()) {
    filesStore.put({ path, blob });
  }
  await txDone(tx);
}

export async function importArchiveFile(file) {
  if (file.name.toLowerCase().endsWith(".json")) {
    const family = normalizeFamily(JSON.parse(await file.text()));
    return { family, mediaFiles: new Map() };
  }

  if (!file.name.toLowerCase().endsWith(".zip")) {
    throw new Error("Selecciona un fitxer .json o .zip.");
  }
  if (!window.JSZip) {
    throw new Error("No s'ha pogut carregar JSZip per llegir l'arxiu.");
  }

  const zip = await window.JSZip.loadAsync(file);
  const familyEntry = zip.file("data/family.json") || zip.file("family.json");
  if (!familyEntry) {
    throw new Error("El ZIP ha de contenir data/family.json.");
  }

  const family = normalizeFamily(JSON.parse(await familyEntry.async("string")));
  const mediaFiles = new Map();
  const entries = Object.values(zip.files).filter((entry) => !entry.dir && entry.name.startsWith("media/"));
  for (const entry of entries) {
    mediaFiles.set(entry.name, await entry.async("blob"));
  }

  return { family, mediaFiles };
}

export async function exportArchiveZip(family, mediaFiles = new Map()) {
  if (!window.JSZip) {
    throw new Error("No s'ha pogut carregar JSZip per crear l'arxiu.");
  }

  const zip = new window.JSZip();
  zip.file("data/family.json", JSON.stringify(normalizeFamily(family), null, 2));
  ensureZipFolders(zip);
  for (const [path, blob] of mediaFiles.entries()) {
    zip.file(path, blob);
  }

  const archive = await zip.generateAsync({ type: "blob" });
  downloadBlob(archive, `family-archive-${new Date().toISOString().slice(0, 10)}.zip`);
}

export function exportFamilyJson(family) {
  const blob = new Blob([JSON.stringify(normalizeFamily(family), null, 2)], { type: "application/json" });
  downloadBlob(blob, "family.json");
}

export function addMediaBlob(mediaFiles, path, blob) {
  const next = new Map(mediaFiles || []);
  next.set(path, blob);
  return next;
}

export function getMemoryFileUrl(mediaFiles, relativePath) {
  const blob = mediaFiles?.get(relativePath);
  return blob ? URL.createObjectURL(blob) : "";
}

function ensureZipFolders(zip) {
  ["data/", "media/", "media/people/", "media/places/", "media/events/", "media/documents/", "media/audio/"]
    .forEach((folder) => zip.folder(folder));
}

function downloadBlob(blob, fileName) {
  const url = URL.createObjectURL(blob);
  const link = document.createElement("a");
  link.href = url;
  link.download = fileName;
  document.body.append(link);
  link.click();
  link.remove();
  setTimeout(() => URL.revokeObjectURL(url), 500);
}

function openDb() {
  return new Promise((resolve, reject) => {
    const request = indexedDB.open(DB_NAME, DB_VERSION);
    request.onupgradeneeded = () => {
      const db = request.result;
      if (!db.objectStoreNames.contains("meta")) db.createObjectStore("meta", { keyPath: "id" });
      if (!db.objectStoreNames.contains("files")) db.createObjectStore("files", { keyPath: "path" });
    };
    request.onsuccess = () => resolve(request.result);
    request.onerror = () => reject(request.error);
  });
}

function requestToPromise(request) {
  return new Promise((resolve, reject) => {
    request.onsuccess = () => resolve(request.result);
    request.onerror = () => reject(request.error);
  });
}

function txDone(tx) {
  return new Promise((resolve, reject) => {
    tx.oncomplete = () => resolve();
    tx.onerror = () => reject(tx.error);
    tx.onabort = () => reject(tx.error);
  });
}
