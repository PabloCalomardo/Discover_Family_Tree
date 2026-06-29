import { getProjectFileBlob, isFileSystemSupported, pickProjectDirectory } from "./services/fileSystem.js";
import { exportArchiveZip, importArchiveFile, loadCachedArchive } from "./services/archiveStore.js";
import { cloneDefaultFamily } from "./models/schema.js";
import { renderCurrentView } from "./modules/views.js";
import { saveNow, setProject, setView, state, subscribe } from "./modules/state.js";

const openButton = document.querySelector("#open-project");
const newButton = document.querySelector("#new-archive");
const importButton = document.querySelector("#import-archive");
const exportButton = document.querySelector("#export-archive");
const saveButton = document.querySelector("#save-project");
const status = document.querySelector("#project-status");
const navButtons = document.querySelectorAll(".nav button");

openButton.addEventListener("click", async () => {
  try {
    openButton.disabled = true;
    status.textContent = "Obrint carpeta...";
    const project = await pickProjectDirectory();
    setProject(project.root, project.family);
  } catch (error) {
    status.textContent = error.message || "No s'ha pogut obrir la carpeta.";
  } finally {
    openButton.disabled = false;
  }
});

if (!isFileSystemSupported()) {
  openButton.disabled = true;
  openButton.title = "Aquest navegador no suporta File System Access API. Fes servir Crear des de 0 o Importar arxiu.";
}

newButton.addEventListener("click", async () => {
  try {
    setProject(null, cloneDefaultFamily(), new Map());
    await saveNow();
    setView("people");
  } catch (error) {
    status.textContent = error.message || "No s'ha pogut crear l'arxiu buit.";
  }
});

importButton.addEventListener("click", async () => {
  const input = document.createElement("input");
  input.type = "file";
  input.accept = ".json,.zip,application/json,application/zip";
  input.addEventListener("change", async () => {
    const [file] = input.files;
    if (!file) return;
    try {
      status.textContent = "Important arxiu...";
      const archive = await importArchiveFile(file);
      setProject(null, archive.family, archive.mediaFiles);
      await saveNow();
    } catch (error) {
      status.textContent = error.message || "No s'ha pogut importar l'arxiu.";
    }
  });
  input.click();
});

exportButton.addEventListener("click", async () => {
  if (!state.family) return;
  try {
    const mediaFiles = state.root ? await collectFolderMediaFiles() : state.mediaFiles;
    await exportArchiveZip(state.family, mediaFiles);
  } catch (error) {
    status.textContent = error.message || "No s'ha pogut exportar l'arxiu.";
  }
});

async function collectFolderMediaFiles() {
  const files = new Map();
  for (const item of state.family.media || []) {
    if (!item.fitxer) continue;
    try {
      files.set(item.fitxer, await getProjectFileBlob(state.root, item.fitxer));
    } catch {
      console.warn(`No s'ha pogut afegir al ZIP: ${item.fitxer}`);
    }
  }
  return files;
}

saveButton.addEventListener("click", () => {
  saveNow().catch((error) => {
    status.textContent = error.message || "No s'ha pogut desar.";
  });
});

navButtons.forEach((button) => {
  button.addEventListener("click", () => setView(button.dataset.view));
});

subscribe(() => {
  navButtons.forEach((button) => {
    const activeView = state.view === "person" ? "people" : state.view;
    button.classList.toggle("active", button.dataset.view === activeView);
  });
  saveButton.disabled = !state.family || state.saving;
  exportButton.disabled = !state.family;
  status.textContent = buildStatus();
  renderCurrentView();
});

if ("serviceWorker" in navigator) {
  navigator.serviceWorker.register("./sw.js").catch(console.warn);
}

loadCachedArchive().then((archive) => {
  if (archive) setProject(null, archive.family, archive.mediaFiles);
  else renderCurrentView();
}).catch(() => renderCurrentView());

function buildStatus() {
  if (!state.family) return "Crea un arxiu buit, importa un .json/.zip o selecciona una carpeta familiar.";
  if (state.saving) return state.root ? "Desant family.json..." : "Desant copia local...";
  if (state.dirty) return "Canvis pendents de desar.";
  if (state.lastSavedAt) return `Desat a ${state.lastSavedAt.toLocaleTimeString()}.`;
  return state.root
    ? "Projecte de carpeta carregat. Els canvis es desen automaticament."
    : "Projecte d'arxiu carregat. Exporta un ZIP per compartir o conservar fora del navegador.";
}
