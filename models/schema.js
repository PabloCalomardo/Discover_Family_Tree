export const FAMILY_VERSION = "1.0";

export const EMPTY_FAMILY = {
  version: FAMILY_VERSION,
  people: [],
  places: [],
  events: [],
  media: [],
  sources: [],
  tags: []
};

export const EVENT_TYPES = [
  "naixement",
  "defuncio",
  "casament",
  "divorci",
  "enviudetat",
  "residencia",
  "etapa",
  "feina",
  "estudi",
  "migracio",
  "record",
  "entrevista",
  "altre"
];

export const MEDIA_TYPES = ["foto", "document", "audio", "video"];

export const DEFAULT_LIFE_PHASES = ["Inici de vida", "Independencia", "Final de vida"];

export function cloneDefaultFamily() {
  return structuredClone(EMPTY_FAMILY);
}

export function normalizeFamily(value) {
  const base = cloneDefaultFamily();
  if (!value || typeof value !== "object") return base;

  return {
    ...base,
    ...value,
    people: Array.isArray(value.people) ? value.people.map(normalizePerson) : [],
    places: Array.isArray(value.places) ? value.places.map(normalizePlace) : [],
    events: Array.isArray(value.events) ? value.events : [],
    media: Array.isArray(value.media) ? value.media : [],
    sources: Array.isArray(value.sources) ? value.sources : [],
    tags: Array.isArray(value.tags) ? value.tags : []
  };
}

function normalizePerson(person) {
  return {
    ...person,
    pares: Array.isArray(person.pares) ? person.pares : [],
    germans: Array.isArray(person.germans) ? person.germans : [],
    amics: Array.isArray(person.amics) ? person.amics : [],
    fases: normalizeLifePhases(person),
    tags: Array.isArray(person.tags) ? person.tags : [],
    links: Array.isArray(person.links) ? person.links : []
  };
}

function normalizeLifePhases(person) {
  if (Array.isArray(person.fases) && person.fases.length) {
    return person.fases.map((phase, index) => ({
      id: phase.id || `phase_${index + 1}`,
      titol: phase.titol || DEFAULT_LIFE_PHASES[index] || "Fase de vida",
      llocResidencia: phase.llocResidencia || "",
      descripcio: phase.descripcio || "",
      links: Array.isArray(phase.links) ? phase.links : []
    }));
  }

  const legacyDescription = person.notes || "";
  const legacyLinks = Array.isArray(person.links) ? person.links : [];
  return DEFAULT_LIFE_PHASES.map((titol, index) => ({
    id: `phase_${index + 1}`,
    titol,
    llocResidencia: "",
    descripcio: index === 0 ? legacyDescription : "",
    links: index === 0 ? legacyLinks : []
  }));
}

function normalizePlace(place) {
  return {
    ...place,
    persones: Array.isArray(place.persones) ? place.persones : [],
    links: Array.isArray(place.links) ? place.links : []
  };
}

export function makeId(prefix) {
  const stamp = Date.now().toString(36);
  const random = crypto.getRandomValues(new Uint32Array(1))[0].toString(36);
  return `${prefix}_${stamp}_${random}`;
}

export function personTemplate() {
  return {
    id: makeId("person"),
    nom: "",
    cognoms: "",
    sexe: "",
    naixement: "",
    defuncio: "",
    pares: [],
    germans: [],
    amics: [],
    fases: DEFAULT_LIFE_PHASES.map((titol, index) => ({
      id: `phase_${index + 1}`,
      titol,
      llocResidencia: "",
      descripcio: "",
      links: []
    })),
    notes: "",
    tags: [],
    links: []
  };
}

export function placeTemplate() {
  return {
    id: makeId("place"),
    nom: "",
    tipus: "",
    adreca: "",
    coordenades: { lat: 0, lon: 0 },
    persones: [],
    descripcio: "",
    links: []
  };
}

export function eventTemplate() {
  return {
    id: makeId("event"),
    tipus: "altre",
    titol: "",
    inici: "",
    fi: "",
    persones: [],
    llocs: [],
    descripcio: "",
    links: [],
    sources: [],
    media: []
  };
}

export function mediaTemplate() {
  return {
    id: makeId("media"),
    tipus: "foto",
    titol: "",
    fitxer: "",
    data: "",
    persones: [],
    llocs: [],
    events: [],
    descripcio: "",
    tags: []
  };
}

export function sourceTemplate() {
  return {
    id: makeId("source"),
    tipus: "registre",
    titol: "",
    data: "",
    url: "",
    notes: ""
  };
}
