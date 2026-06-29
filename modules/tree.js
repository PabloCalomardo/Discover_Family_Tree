export function renderTree(container, family, selectedPersonId, onSelect) {
  container.innerHTML = "";
  if (!window.d3) {
    container.innerHTML = `<section class="empty">D3.js encara no s'ha carregat.</section>`;
    return;
  }
  if (!family.people.length) {
    container.innerHTML = `<section class="empty">Afegeix persones per veure l'arbre genealogic.</section>`;
    return;
  }

  const width = container.clientWidth || 900;
  const height = 620;
  const svg = window.d3.select(container).append("svg")
    .attr("viewBox", [0, 0, width, height])
    .attr("class", "tree-canvas");

  const group = svg.append("g");
  svg.call(window.d3.zoom().scaleExtent([0.35, 2.5]).on("zoom", (event) => {
    group.attr("transform", event.transform);
  }));

  const rootPerson = family.people.find((person) => person.id === selectedPersonId) || family.people[0];
  const hierarchy = buildHierarchy(rootPerson, family, new Set());
  const root = window.d3.hierarchy(hierarchy);
  window.d3.tree().nodeSize([160, 110])(root);

  const xValues = root.descendants().map((node) => node.x);
  const yValues = root.descendants().map((node) => node.y);
  const offsetX = width / 2 - (Math.min(...xValues) + Math.max(...xValues)) / 2;
  const offsetY = 90 - Math.min(...yValues);
  group.attr("transform", `translate(${offsetX},${offsetY})`);

  group.selectAll("path")
    .data(root.links())
    .join("path")
    .attr("class", "tree-link")
    .attr("d", window.d3.linkVertical().x((d) => d.x).y((d) => d.y));

  const nodes = group.selectAll("g.node")
    .data(root.descendants())
    .join("g")
    .attr("class", (d) => `tree-node ${d.data.id === selectedPersonId ? "selected" : ""}`)
    .attr("transform", (d) => `translate(${d.x},${d.y})`)
    .on("click", (_event, d) => onSelect(d.data.id));

  nodes.append("rect")
    .attr("x", -62)
    .attr("y", -24)
    .attr("width", 124)
    .attr("height", 48)
    .attr("rx", 8);

  nodes.append("text")
    .attr("text-anchor", "middle")
    .attr("dy", -2)
    .text((d) => d.data.name);

  nodes.append("text")
    .attr("text-anchor", "middle")
    .attr("dy", 14)
    .attr("class", "muted-text")
    .text((d) => d.data.dates);
}

function buildHierarchy(person, family, seen) {
  if (!person || seen.has(person.id)) return null;
  seen.add(person.id);
  return {
    id: person.id,
    name: `${person.nom} ${person.cognoms}`.trim() || "Sense nom",
    dates: [person.naixement, person.defuncio].filter(Boolean).join(" - "),
    children: (person.pares || [])
      .map((id) => family.people.find((candidate) => candidate.id === id))
      .map((parent) => buildHierarchy(parent, family, seen))
      .filter(Boolean)
  };
}
