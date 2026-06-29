import { cloneDefaultFamily, normalizeFamily } from "../models/schema.js";

const REQUIRED_DIRS = [
  ["data"],
  ["media"],
  ["media", "people"],
  ["media", "places"],
  ["media", "events"],
  ["media", "documents"],
  ["media", "audio"]
];

export function isFileSystemSupported() {
  return "showDirectoryPicker" in window;
}

export async function pickProjectDirectory() {
  if (!isFileSystemSupported()) {
    throw new Error("Aquest navegador no suporta File System Access API.");
  }

  const root = await window.showDirectoryPicker({ mode: "readwrite" });
  await ensureProjectStructure(root);
  const family = await readFamily(root);
  return { root, family };
}

export async function ensureProjectStructure(root) {
  for (const path of REQUIRED_DIRS) {
    await getDirectory(root, path, true);
  }

  try {
    await getFile(root, ["data", "family.json"], false);
  } catch {
    await writeFamily(root, cloneDefaultFamily());
  }
}

export async function readFamily(root) {
  const fileHandle = await getFile(root, ["data", "family.json"], false);
  const text = await (await fileHandle.getFile()).text();
  return normalizeFamily(JSON.parse(text || "{}"));
}

export async function writeFamily(root, family) {
  const fileHandle = await getFile(root, ["data", "family.json"], true);
  const writable = await fileHandle.createWritable();
  await writable.write(JSON.stringify(normalizeFamily(family), null, 2));
  await writable.close();
}

export async function copyFileToProject(root, file, folderParts) {
  const dir = await getDirectory(root, folderParts, true);
  const safeName = buildSafeFileName(file.name);
  const handle = await dir.getFileHandle(safeName, { create: true });
  const writable = await handle.createWritable();
  await writable.write(file);
  await writable.close();
  return [...folderParts, safeName].join("/");
}

export async function writeBlobToProject(root, blob, folderParts, fileName) {
  const dir = await getDirectory(root, folderParts, true);
  const safeName = buildSafeFileName(fileName);
  const handle = await dir.getFileHandle(safeName, { create: true });
  const writable = await handle.createWritable();
  await writable.write(blob);
  await writable.close();
  return [...folderParts, safeName].join("/");
}

export async function getProjectFileUrl(root, relativePath) {
  const file = await getProjectFileBlob(root, relativePath);
  return URL.createObjectURL(file);
}

export async function getProjectFileBlob(root, relativePath) {
  const parts = relativePath.split("/").filter(Boolean);
  const fileHandle = await getFile(root, parts, false);
  return fileHandle.getFile();
}

async function getDirectory(root, parts, create) {
  let dir = root;
  for (const part of parts) {
    dir = await dir.getDirectoryHandle(part, { create });
  }
  return dir;
}

async function getFile(root, parts, create) {
  const fileName = parts.at(-1);
  const dir = await getDirectory(root, parts.slice(0, -1), create);
  return dir.getFileHandle(fileName, { create });
}

function buildSafeFileName(name) {
  const cleaned = name
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/[^a-zA-Z0-9._-]+/g, "-")
    .replace(/^-+|-+$/g, "")
    .toLowerCase();
  return `${Date.now()}-${cleaned || "fitxer"}`;
}
