# Discover_Family_Tree
App to create your family tree interactively

## Run locally

Serve the folder over HTTP so ES modules, the PWA service worker, camera/audio
permissions, and the File System Access API work correctly:

```powershell
python -m http.server 8080
```

Open:

```text
http://localhost:8080/
```

Use a Chromium-based browser for the local folder picker, because the app stores
all data through the File System Access API in `data/family.json` and `media/`.

## Universal archive mode

Browsers without the File System Access API can use the archive flow:

- Create an empty archive from the top bar, or
- Import a `.json` or `.zip` file from the top bar.
- Work in the app; a temporary local copy is kept in IndexedDB.
- Export a `.zip` whenever you want to keep or share the archive.

The exported ZIP contains:

- `data/family.json`
- `media/people/`
- `media/places/`
- `media/events/`
- `media/documents/`
- `media/audio/`
