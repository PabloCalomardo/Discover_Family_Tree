import { mediaTemplate } from "../models/schema.js";
import { copyFileToProject, writeBlobToProject } from "./fileSystem.js";

export function folderForMediaType(type) {
  if (type === "audio") return ["media", "audio"];
  if (type === "document") return ["media", "documents"];
  if (type === "video") return ["media", "events"];
  return ["media", "people"];
}

export async function importMediaFile(root, file, extra = {}) {
  const type = inferMediaType(file);
  const folder = folderForMediaType(type);
  const relativePath = root
    ? await copyFileToProject(root, file, folder)
    : [...folder, buildSafeFileName(file.name)].join("/");
  return {
    ...mediaTemplate(),
    tipus: type,
    titol: extra.titol || file.name.replace(/\.[^.]+$/, ""),
    fitxer: relativePath,
    data: new Date().toISOString().slice(0, 10),
    ...extra
  };
}

export async function saveCapturedPhoto(root, blob, extra = {}) {
  const fileName = `foto-${new Date().toISOString().replace(/[:.]/g, "-")}.jpg`;
  const relativePath = root
    ? await writeBlobToProject(root, blob, ["media", "people"], fileName)
    : ["media", "people", fileName].join("/");
  return {
    ...mediaTemplate(),
    tipus: "foto",
    titol: extra.titol || "Foto capturada",
    fitxer: relativePath,
    data: new Date().toISOString().slice(0, 10),
    ...extra
  };
}

export async function saveAudioRecording(root, blob, extra = {}) {
  const fileName = `entrevista-${new Date().toISOString().replace(/[:.]/g, "-")}.webm`;
  const relativePath = root
    ? await writeBlobToProject(root, blob, ["media", "audio"], fileName)
    : ["media", "audio", fileName].join("/");
  return {
    ...mediaTemplate(),
    tipus: "audio",
    titol: extra.titol || "Entrevista gravada",
    fitxer: relativePath,
    data: new Date().toISOString().slice(0, 10),
    ...extra
  };
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

function inferMediaType(file) {
  if (file.type.startsWith("image/")) return "foto";
  if (file.type.startsWith("audio/")) return "audio";
  if (file.type.startsWith("video/")) return "video";
  return "document";
}
