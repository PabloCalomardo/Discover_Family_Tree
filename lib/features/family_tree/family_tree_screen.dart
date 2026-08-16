import 'package:family_history/app/app_strings.dart';
import 'package:family_history/app/providers.dart';
import 'package:family_history/components/historical_date_field.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/domain/person/person.dart';
import 'package:family_history/domain/person/person_name.dart';
import 'package:family_history/domain/relationship/parent_child_relationship.dart';
import 'package:family_history/domain/relationship/partnership.dart';
import 'package:family_history/features/family_tree/family_tree_projection.dart';
import 'package:family_history/services/kinship/kinship_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:graphview/GraphView.dart';

const _biologicalColor = Color(0xFF4D6B45);
const _adoptiveColor = Color(0xFFD17A22);
const _partnershipColor = Color(0xFF8E4D7C);
const _familyStructureColor = Color(0xFF667069);
const _treeNodeSeparation = 48;
const _treeGenerationSeparation = 88;
const _treeConnectorOffset = 32.0;

class FamilyTreeScreen extends ConsumerStatefulWidget {
  const FamilyTreeScreen({super.key});

  @override
  ConsumerState<FamilyTreeScreen> createState() => _FamilyTreeScreenState();
}

class _FamilyTreeScreenState extends ConsumerState<FamilyTreeScreen> {
  static const _projector = FamilyTreeProjector();

  late TransformationController _transformationController;
  late GraphViewController _graphController;
  var _graphRevision = 0;
  PersonId? _focus;
  PersonId? _selected;
  bool _showAll = false;

  @override
  void initState() {
    super.initState();
    _createGraphController();
  }

  void _createGraphController() {
    _transformationController = TransformationController();
    _graphController = GraphViewController(
      transformationController: _transformationController,
    );
  }

  void _zoom(double factor) {
    _transformationController.value = _transformationController.value
        .scaledByDouble(factor, factor, 1, 1);
  }

  void _rebuildAround(VoidCallback update, PersonId center) {
    setState(() {
      update();
      _graphRevision++;
      _createGraphController();
    });
    final revision = _graphRevision;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || revision != _graphRevision) return;
      _graphController.zoomToFit();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || revision != _graphRevision) return;
        _graphController.jumpToNode(ValueKey('person:${center.value}'));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final peopleAsync = ref.watch(peopleProvider);
    final namesAsync = ref.watch(allPersonNamesProvider);
    final parentChildAsync = ref.watch(parentChildRelationshipsProvider);
    final partnershipsAsync = ref.watch(partnershipsProvider);

    final error =
        peopleAsync.error ??
        namesAsync.error ??
        parentChildAsync.error ??
        partnershipsAsync.error;
    if (error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text(AppStrings.familyTree)),
        body: Center(child: Text(error.toString())),
      );
    }
    final people = peopleAsync.value;
    final names = namesAsync.value;
    final parentChild = parentChildAsync.value;
    final partnerships = partnershipsAsync.value;
    if (people == null ||
        names == null ||
        parentChild == null ||
        partnerships == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (people.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text(AppStrings.familyTree)),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.account_tree_outlined, size: 64),
              const SizedBox(height: 16),
              const Text('Crea una persona per començar l’arbre familiar.'),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => context.go('/people/new'),
                icon: const Icon(Icons.person_add),
                label: const Text(AppStrings.newPerson),
              ),
            ],
          ),
        ),
      );
    }

    final namesByPerson = _namesByPerson(names);
    final effectiveFocus = people.any((person) => person.id == _focus)
        ? _focus!
        : people.first.id;
    final effectiveSelected = people.any((person) => person.id == _selected)
        ? _selected
        : effectiveFocus;
    final projection = _projector.project(
      people: people,
      names: names,
      parentChildRelationships: parentChild,
      partnerships: partnerships,
      focus: effectiveFocus,
      showAll: _showAll,
    );
    final graphBundle = _buildGraph(projection);
    final selectedPerson = people
        .where((person) => person.id == effectiveSelected)
        .firstOrNull;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Arbre familiar'),
        actions: [
          IconButton(
            tooltip: 'Allunyar',
            onPressed: () => _zoom(0.8),
            icon: const Icon(Icons.remove),
          ),
          IconButton(
            tooltip: 'Apropar',
            onPressed: () => _zoom(1.25),
            icon: const Icon(Icons.add),
          ),
          IconButton(
            tooltip: 'Ajustar a la finestra',
            onPressed: _graphController.zoomToFit,
            icon: const Icon(Icons.fit_screen),
          ),
          IconButton(
            tooltip: 'Restablir vista',
            onPressed: _graphController.resetView,
            icon: const Icon(Icons.center_focus_strong),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          _TreeToolbar(
            people: people,
            namesByPerson: namesByPerson,
            focus: effectiveFocus,
            showAll: _showAll,
            visibleCount: projection.visiblePersonIds.length,
            onFocusChanged: (personId) => _rebuildAround(() {
              _focus = personId;
              _selected = personId;
              _showAll = false;
            }, personId),
            onShowAllChanged: (value) =>
                _rebuildAround(() => _showAll = value, effectiveFocus),
          ),
          const Divider(height: 1),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: ColoredBox(
                    color: Theme.of(context).colorScheme.surfaceContainerLowest,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: GraphView.builder(
                            key: ValueKey(_graphRevision),
                            graph: graphBundle.graph,
                            algorithm: graphBundle.algorithm,
                            controller: _graphController,
                            autoZoomToFit: true,
                            animated: false,
                            panAnimationDuration: Duration.zero,
                            builder: (node) {
                              final model = graphBundle.nodes[node.key!.value];
                              return switch (model) {
                                FamilyTreePersonNode personNode =>
                                  _PersonTreeCard(
                                    node: personNode,
                                    selected:
                                        personNode.person.id ==
                                        effectiveSelected,
                                    focused:
                                        personNode.person.id == effectiveFocus,
                                    onTap: () => setState(
                                      () => _selected = personNode.person.id,
                                    ),
                                  ),
                                FamilyTreeUnionNode _ => const SizedBox.square(
                                  dimension: 1,
                                ),
                                _ => const SizedBox.shrink(),
                              };
                            },
                          ),
                        ),
                        const Positioned(
                          left: 16,
                          bottom: 16,
                          child: _TreeLegend(),
                        ),
                      ],
                    ),
                  ),
                ),
                const VerticalDivider(width: 1),
                SizedBox(
                  width: 320,
                  child: selectedPerson == null
                      ? const Center(child: Text('Selecciona una persona.'))
                      : _PersonInspector(
                          person: selectedPerson,
                          displayName:
                              namesByPerson[selectedPerson.id] ??
                              'Persona sense nom',
                          focus: effectiveFocus,
                          parentChildRelationships: parentChild,
                          partnerships: partnerships,
                          onMakeFocus: () => _rebuildAround(() {
                            _focus = selectedPerson.id;
                            _selected = selectedPerson.id;
                            _showAll = false;
                          }, selectedPerson.id),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Map<PersonId, String> _namesByPerson(List<PersonName> names) {
    final grouped = <PersonId, List<PersonName>>{};
    for (final name in names) {
      grouped.putIfAbsent(name.personId, () => []).add(name);
    }
    return {
      for (final entry in grouped.entries)
        entry.key:
            entry.value
                .where((name) => name.isPreferred)
                .firstOrNull
                ?.displayName ??
            entry.value.first.displayName,
    };
  }

  _GraphBundle _buildGraph(FamilyTreeProjection projection) {
    final graph = Graph();
    final graphNodes = <String, Node>{};
    final modelNodes = <Object?, FamilyTreeNode>{};
    for (final model in projection.nodes) {
      final node = Node.Id(model.key);
      graph.addNode(node);
      graphNodes[model.key] = node;
      modelNodes[model.key] = model;
    }
    for (final edge in projection.edges) {
      final source = graphNodes[edge.sourceKey];
      final destination = graphNodes[edge.destinationKey];
      if (source == null || destination == null) continue;
      graph.addEdgeS(
        Edge(
          source,
          destination,
          key: ValueKey(edge.key),
          paint: Paint()
            ..color = _edgeColor(edge.kind)
            ..strokeWidth = edge.kind == FamilyTreeEdgeKind.adoptive ? 2.5 : 2
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.butt
            ..isAntiAlias = false,
        ),
      );
    }
    final partnershipPairs = <String, (Node, Node)>{};
    for (final model in projection.nodes.whereType<FamilyTreeUnionNode>()) {
      final first = graphNodes['person:${model.partnership.personAId.value}'];
      final second = graphNodes['person:${model.partnership.personBId.value}'];
      if (first != null && second != null) {
        partnershipPairs[model.key] = (first, second);
      }
    }
    final familyConnectors = _buildFamilyConnectors(
      projection,
      graphNodes,
      partnershipPairs,
    );
    final generationEdges = <(Node, Node)>{
      for (final edge in projection.edges)
        if (edge.kind != FamilyTreeEdgeKind.partnership &&
            graphNodes[edge.sourceKey] != null &&
            graphNodes[edge.destinationKey] != null)
          (graphNodes[edge.sourceKey]!, graphNodes[edge.destinationKey]!),
    }.toList(growable: false);
    final layoutGraph = Graph()
      ..addNodes([
        for (final entry in graphNodes.entries)
          if (entry.key.startsWith('person:')) entry.value,
      ]);
    for (final edge in generationEdges) {
      layoutGraph.addEdge(edge.$1, edge.$2);
    }
    final configuration = SugiyamaConfiguration()
      ..orientation = SugiyamaConfiguration.ORIENTATION_TOP_BOTTOM
      ..nodeSeparation = _treeNodeSeparation
      ..levelSeparation = _treeGenerationSeparation
      ..addTriangleToEdge = false;
    final algorithm = _FamilyTreeLayoutAlgorithm(
      configuration,
      partnershipPairs,
      {
        for (final entry in graphNodes.entries)
          if (entry.key.startsWith('person:')) entry.value,
      },
      familyConnectors,
      generationEdges,
      layoutGraph,
    );
    return _GraphBundle(graph: graph, algorithm: algorithm, nodes: modelNodes);
  }

  Color _edgeColor(FamilyTreeEdgeKind kind) => switch (kind) {
    FamilyTreeEdgeKind.biological => _biologicalColor,
    FamilyTreeEdgeKind.adoptive => _adoptiveColor,
    FamilyTreeEdgeKind.partnership => _partnershipColor,
  };

  List<_FamilyConnectorGroup> _buildFamilyConnectors(
    FamilyTreeProjection projection,
    Map<String, Node> graphNodes,
    Map<String, (Node, Node)> partnershipPairs,
  ) {
    final relationshipsByChild = <String, List<FamilyTreeEdge>>{};
    for (final edge in projection.edges.where(
      (edge) => edge.kind != FamilyTreeEdgeKind.partnership,
    )) {
      relationshipsByChild.putIfAbsent(edge.destinationKey, () => []).add(edge);
    }
    final partnershipPeople = <String, (String, String)>{};
    for (final union in projection.nodes.whereType<FamilyTreeUnionNode>()) {
      partnershipPeople[union.key] = (
        'person:${union.partnership.personAId.value}',
        'person:${union.partnership.personBId.value}',
      );
    }

    final groups = <String, _FamilyConnectorGroup>{};
    void addConnection({
      required String groupKey,
      required Node child,
      required Iterable<FamilyTreeEdge> edges,
      Node? parent,
      (Node, Node)? partners,
    }) {
      final orderedEdges = edges.toList()
        ..sort((first, second) => first.key.compareTo(second.key));
      final group = groups.putIfAbsent(
        groupKey,
        () => _FamilyConnectorGroup(
          representativeEdgeKey: orderedEdges.first.key,
          parent: parent,
          partners: partners,
        ),
      );
      group.addChild(child, orderedEdges.map((edge) => edge.kind).toSet());
    }

    for (final childEntry in relationshipsByChild.entries) {
      final child = graphNodes[childEntry.key];
      if (child == null) continue;
      final byParent = <String, List<FamilyTreeEdge>>{};
      for (final edge in childEntry.value) {
        byParent.putIfAbsent(edge.sourceKey, () => []).add(edge);
      }
      final unmatchedParents = byParent.keys.toSet();
      final orderedPartnerships = partnershipPeople.entries.toList()
        ..sort((first, second) => first.key.compareTo(second.key));
      for (final partnership in orderedPartnerships) {
        final firstKey = partnership.value.$1;
        final secondKey = partnership.value.$2;
        if (!unmatchedParents.contains(firstKey) ||
            !unmatchedParents.contains(secondKey)) {
          continue;
        }
        final pair = partnershipPairs[partnership.key];
        if (pair == null) continue;
        addConnection(
          groupKey: partnership.key,
          child: child,
          edges: [...byParent[firstKey]!, ...byParent[secondKey]!],
          partners: pair,
        );
        unmatchedParents
          ..remove(firstKey)
          ..remove(secondKey);
      }
      for (final parentKey in unmatchedParents) {
        final parent = graphNodes[parentKey];
        if (parent == null) continue;
        addConnection(
          groupKey: parentKey,
          child: child,
          edges: byParent[parentKey]!,
          parent: parent,
        );
      }
    }
    return groups.values.toList(growable: false);
  }
}

final class _FamilyChildConnector {
  _FamilyChildConnector(this.node, Set<FamilyTreeEdgeKind> kinds)
    : kinds = {...kinds};

  final Node node;
  final Set<FamilyTreeEdgeKind> kinds;
}

final class _FamilyConnectorGroup {
  _FamilyConnectorGroup({
    required this.representativeEdgeKey,
    this.parent,
    this.partners,
  }) : assert((parent == null) != (partners == null));

  final String representativeEdgeKey;
  final Node? parent;
  final (Node, Node)? partners;
  final List<_FamilyChildConnector> children = [];
  double busY = 0;

  void addChild(Node child, Set<FamilyTreeEdgeKind> kinds) {
    final existing = children.where((item) => item.node == child).firstOrNull;
    if (existing == null) {
      children.add(_FamilyChildConnector(child, kinds));
    } else {
      existing.kinds.addAll(kinds);
    }
  }
}

final class _GraphBundle {
  const _GraphBundle({
    required this.graph,
    required this.algorithm,
    required this.nodes,
  });

  final Graph graph;
  final SugiyamaAlgorithm algorithm;
  final Map<Object?, FamilyTreeNode> nodes;
}

final class _FamilyTreeLayoutAlgorithm extends SugiyamaAlgorithm {
  _FamilyTreeLayoutAlgorithm(
    super.configuration,
    this.partnershipPairs,
    this.personNodes,
    this.familyConnectors,
    this.generationEdges,
    this.layoutGraph,
  ) {
    renderer = _FamilyEdgeRenderer(partnershipPairs, familyConnectors);
  }

  final Map<String, (Node, Node)> partnershipPairs;
  final Set<Node> personNodes;
  final List<_FamilyConnectorGroup> familyConnectors;
  final List<(Node, Node)> generationEdges;
  final Graph layoutGraph;

  @override
  Size run(Graph? graph, double shiftX, double shiftY) {
    final size = super.run(layoutGraph, shiftX, shiftY);
    if (graph == null) return size;
    final components = _partnershipComponents();
    final generationByNode = _generationByNode();
    final rowHeights = <int, double>{};
    for (final node in personNodes) {
      final generation = generationByNode[node] ?? 0;
      final currentHeight = rowHeights[generation] ?? 0;
      if (node.height > currentHeight) rowHeights[generation] = node.height;
    }
    final rowTops = <int, double>{};
    var rowTop = personNodes
        .map((node) => node.position.dy)
        .reduce((first, second) => first < second ? first : second);
    final maximumGeneration = rowHeights.keys.reduce(
      (first, second) => first > second ? first : second,
    );
    for (var generation = 0; generation <= maximumGeneration; generation++) {
      final height = rowHeights[generation];
      if (height == null) continue;
      rowTops[generation] = rowTop;
      rowTop += height + _treeGenerationSeparation;
    }
    for (final node in personNodes) {
      final generation = generationByNode[node] ?? 0;
      node.position = Offset(
        node.position.dx.roundToDouble(),
        rowTops[generation]!.roundToDouble(),
      );
    }
    for (final connector in familyConnectors) {
      final sourceNode = connector.parent ?? connector.partners!.$1;
      final generation = generationByNode[sourceNode] ?? 0;
      connector.busY =
          (rowTops[generation]! +
                  rowHeights[generation]! +
                  _treeConnectorOffset)
              .roundToDouble();
    }

    final componentByNode = <Node, Set<Node>>{
      for (final component in components)
        for (final node in component) node: component,
    };
    final rows = <double, List<Node>>{};
    for (final node in personNodes) {
      rows.putIfAbsent(node.position.dy, () => []).add(node);
    }
    double packedWidth(List<Node> row) =>
        row.fold<double>(0, (total, node) => total + node.width) +
        configuration.nodeSeparation * (row.length - 1);
    double originalCenter(List<Node> row) {
      final left = row
          .map((node) => node.position.dx)
          .reduce((first, second) => first < second ? first : second);
      final right = row
          .map((node) => node.position.dx + node.width)
          .reduce((first, second) => first > second ? first : second);
      return (left + right) / 2;
    }

    final widestRow = rows.values.reduce(
      (first, second) =>
          packedWidth(first) >= packedWidth(second) ? first : second,
    );
    final clusterCenter = originalCenter(widestRow);
    for (final row in rows.values) {
      final rowCenter = originalCenter(row).clamp(
        clusterCenter - configuration.nodeSeparation,
        clusterCenter + configuration.nodeSeparation,
      );
      final blocks = <Set<Node>>[];
      final seen = <Set<Node>>{};
      for (final node in row) {
        final component = componentByNode[node] ?? {node};
        if (seen.add(component)) blocks.add(component);
      }
      blocks.sort(
        (first, second) => _minimumX(first).compareTo(_minimumX(second)),
      );
      _placeSiblingBranchesOutsidePartnerships(blocks);
      var x = rowCenter - packedWidth(row) / 2;
      for (final block in blocks) {
        final ordered = block.toList()
          ..sort(
            (first, second) => first.position.dx.compareTo(second.position.dx),
          );
        for (final node in ordered) {
          node.position = Offset(x.roundToDouble(), node.position.dy);
          x += node.width + configuration.nodeSeparation;
        }
      }
    }

    for (final entry in partnershipPairs.entries) {
      final first = entry.value.$1;
      final second = entry.value.$2;
      final union = graph.getNodeUsingId(entry.key);
      union.position = Offset(
        ((_nodeCenterX(first) + _nodeCenterX(second)) / 2 - union.width / 2)
            .roundToDouble(),
        first.position.dy.roundToDouble(),
      );
    }
    final maximumX = graph.nodes
        .map((node) => node.position.dx + node.width)
        .reduce((first, second) => first > second ? first : second);
    final maximumY = graph.nodes
        .map((node) => node.position.dy + node.height)
        .reduce((first, second) => first > second ? first : second);
    return Size(maximumX + shiftX, maximumY + shiftY);
  }

  Map<Node, int> _generationByNode() {
    final equality = <Node, Set<Node>>{
      for (final node in personNodes) node: <Node>{},
    };
    for (final pair in partnershipPairs.values) {
      equality[pair.$1]!.add(pair.$2);
      equality[pair.$2]!.add(pair.$1);
    }
    final parentsByChild = <Node, Set<Node>>{};
    for (final edge in generationEdges) {
      parentsByChild.putIfAbsent(edge.$2, () => <Node>{}).add(edge.$1);
    }
    for (final parents in parentsByChild.values) {
      for (final first in parents) {
        equality[first]!.addAll(parents.where((parent) => parent != first));
      }
    }

    final generationComponents = <Set<Node>>[];
    final componentByNode = <Node, Set<Node>>{};
    for (final node in personNodes) {
      if (componentByNode.containsKey(node)) continue;
      final component = <Node>{node};
      final pending = <Node>[node];
      componentByNode[node] = component;
      while (pending.isNotEmpty) {
        final current = pending.removeLast();
        for (final relative in equality[current]!) {
          if (componentByNode.containsKey(relative)) continue;
          component.add(relative);
          componentByNode[relative] = component;
          pending.add(relative);
        }
      }
      generationComponents.add(component);
    }

    final outgoing = <Set<Node>, Set<Set<Node>>>{
      for (final component in generationComponents) component: <Set<Node>>{},
    };
    final indegree = <Set<Node>, int>{
      for (final component in generationComponents) component: 0,
    };
    for (final edge in generationEdges) {
      final source = componentByNode[edge.$1]!;
      final destination = componentByNode[edge.$2]!;
      if (source == destination || !outgoing[source]!.add(destination)) {
        continue;
      }
      indegree[destination] = indegree[destination]! + 1;
    }
    final generationByComponent = <Set<Node>, int>{
      for (final component in generationComponents) component: 0,
    };
    final pending = <Set<Node>>[
      for (final component in generationComponents)
        if (indegree[component] == 0) component,
    ];
    var processed = 0;
    while (pending.isNotEmpty) {
      final current = pending.removeLast();
      processed++;
      for (final child in outgoing[current]!) {
        final nextGeneration = generationByComponent[current]! + 1;
        if (nextGeneration > generationByComponent[child]!) {
          generationByComponent[child] = nextGeneration;
        }
        indegree[child] = indegree[child]! - 1;
        if (indegree[child] == 0) pending.add(child);
      }
    }
    if (processed != generationComponents.length) {
      final orderedY =
          personNodes.map((node) => node.position.dy).toSet().toList()..sort();
      return {
        for (final node in personNodes)
          node: orderedY.indexOf(node.position.dy),
      };
    }
    return {
      for (final node in personNodes)
        node: generationByComponent[componentByNode[node]!]!,
    };
  }

  List<Set<Node>> _partnershipComponents() {
    final adjacency = <Node, Set<Node>>{
      for (final node in personNodes) node: <Node>{},
    };
    for (final pair in partnershipPairs.values) {
      adjacency[pair.$1]?.add(pair.$2);
      adjacency[pair.$2]?.add(pair.$1);
    }
    final components = <Set<Node>>[];
    final visited = <Node>{};
    for (final node in personNodes) {
      if (!visited.add(node)) continue;
      final component = <Node>{node};
      final pending = <Node>[node];
      while (pending.isNotEmpty) {
        final current = pending.removeLast();
        for (final partner in adjacency[current] ?? const <Node>{}) {
          if (visited.add(partner)) {
            component.add(partner);
            pending.add(partner);
          }
        }
      }
      components.add(component);
    }
    return components;
  }

  void _placeSiblingBranchesOutsidePartnerships(List<Set<Node>> blocks) {
    if (blocks.length < 2) return;
    final blockByNode = <Node, Set<Node>>{
      for (final block in blocks)
        for (final node in block) node: block,
    };
    final partnerships = blocks.where((block) => block.length > 1).toList();
    for (final partnership in partnerships) {
      final orderedPartners = partnership.toList()
        ..sort(
          (first, second) => first.position.dx.compareTo(second.position.dx),
        );
      final before = _siblingBlocks(
        orderedPartners.first,
        partnership,
        blockByNode,
      );
      final after = _siblingBlocks(
        orderedPartners.last,
        partnership,
        blockByNode,
      ).where((block) => !before.contains(block)).toList();
      if (before.isEmpty && after.isEmpty) continue;
      final originalOrder = <Set<Node>, int>{
        for (var index = 0; index < blocks.length; index++)
          blocks[index]: index,
      };
      before.sort(
        (first, second) =>
            originalOrder[first]!.compareTo(originalOrder[second]!),
      );
      after.sort(
        (first, second) =>
            originalOrder[first]!.compareTo(originalOrder[second]!),
      );
      blocks.removeWhere(
        (block) => before.contains(block) || after.contains(block),
      );
      final partnershipIndex = blocks.indexOf(partnership);
      blocks
        ..insertAll(partnershipIndex, before)
        ..insertAll(partnershipIndex + before.length + 1, after);
    }
  }

  List<Set<Node>> _siblingBlocks(
    Node person,
    Set<Node> partnership,
    Map<Node, Set<Node>> blockByNode,
  ) {
    final parents = <Node>{
      for (final edge in generationEdges)
        if (edge.$2 == person) edge.$1,
    };
    if (parents.isEmpty) return [];
    final result = <Set<Node>>[];
    for (final edge in generationEdges) {
      if (!parents.contains(edge.$1) || edge.$2 == person) continue;
      final block = blockByNode[edge.$2];
      if (block != null && block != partnership && !result.contains(block)) {
        result.add(block);
      }
    }
    return result;
  }

  double _minimumX(Set<Node> nodes) => nodes
      .map((node) => node.position.dx)
      .reduce((first, second) => first < second ? first : second);

  double _nodeCenterX(Node node) => node.position.dx + node.width / 2;
}

final class _FamilyEdgeRenderer extends EdgeRenderer {
  _FamilyEdgeRenderer(
    this.partnershipPairs,
    List<_FamilyConnectorGroup> familyConnectors,
  ) : familyConnectorsByEdge = {
        for (final connector in familyConnectors)
          connector.representativeEdgeKey: connector,
      };

  final Map<String, (Node, Node)> partnershipPairs;
  final Map<String, _FamilyConnectorGroup> familyConnectorsByEdge;

  @override
  void renderEdge(Canvas canvas, Edge edge, Paint paint) {
    final effectivePaint = edge.paint ?? paint;
    final edgeKey = switch (edge.key) {
      ValueKey<String>(value: final value) => value,
      _ => null,
    };
    final destinationKey = edge.destination.key?.value;
    final pair = destinationKey is String
        ? partnershipPairs[destinationKey]
        : null;
    if (pair != null) {
      if (edge.source == pair.$1) {
        _drawPartnership(canvas, pair.$1, pair.$2, effectivePaint);
      }
      return;
    }
    final familyConnector = edgeKey == null
        ? null
        : familyConnectorsByEdge[edgeKey];
    if (familyConnector != null) {
      _drawFamilyConnector(canvas, familyConnector);
    }
  }

  void _drawFamilyConnector(Canvas canvas, _FamilyConnectorGroup connector) {
    if (connector.children.isEmpty) return;
    final source = connector.partners == null
        ? Offset(
            _pixel(_nodeCenterX(connector.parent!)),
            _pixel(connector.parent!.position.dy + connector.parent!.height),
          )
        : Offset(
            _pixel(
              (_nodeCenterX(connector.partners!.$1) +
                      _nodeCenterX(connector.partners!.$2)) /
                  2,
            ),
            _pixel(
              (getNodeCenter(connector.partners!.$1).dy +
                      getNodeCenter(connector.partners!.$2).dy) /
                  2,
            ),
          );
    final targets = connector.children
        .map(
          (child) => (
            child: child,
            point: Offset(
              _pixel(_nodeCenterX(child.node)),
              _pixel(child.node.position.dy),
            ),
          ),
        )
        .toList(growable: false);
    final busY = connector.busY;
    final leftX = targets
        .map((target) => target.point.dx)
        .reduce((first, second) => first < second ? first : second);
    final rightX = targets
        .map((target) => target.point.dx)
        .reduce((first, second) => first > second ? first : second);
    final structurePaint = Paint()
      ..color = _familyStructureColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt
      ..isAntiAlias = false;
    for (final target in targets) {
      _drawLineKinds(
        canvas,
        Offset(target.point.dx, busY),
        target.point,
        target.child.kinds,
      );
    }
    canvas
      ..drawLine(source, Offset(source.dx, busY), structurePaint)
      ..drawLine(Offset(leftX, busY), Offset(rightX, busY), structurePaint);
    if (source.dx < leftX || source.dx > rightX) {
      canvas.drawLine(
        Offset(source.dx, busY),
        Offset(source.dx < leftX ? leftX : rightX, busY),
        structurePaint,
      );
    }
  }

  void _drawLineKinds(
    Canvas canvas,
    Offset start,
    Offset end,
    Set<FamilyTreeEdgeKind> kinds,
  ) {
    if (kinds.contains(FamilyTreeEdgeKind.biological)) {
      canvas.drawLine(
        start,
        end,
        Paint()
          ..color = _biologicalColor
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.butt
          ..isAntiAlias = false,
      );
    }
    if (kinds.contains(FamilyTreeEdgeKind.adoptive)) {
      drawDashedLine(
        canvas,
        start,
        end,
        Paint()
          ..color = _adoptiveColor
          ..strokeWidth = 2.5
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.butt
          ..isAntiAlias = false,
        0.55,
      );
    }
  }

  double _nodeCenterX(Node node) => node.position.dx + node.width / 2;

  double _pixel(double value) => value.roundToDouble();

  void _drawPartnership(Canvas canvas, Node first, Node second, Paint paint) {
    final firstCenter = getNodeCenter(first);
    final secondCenter = getNodeCenter(second);
    final leftNode = firstCenter.dx <= secondCenter.dx ? first : second;
    final rightNode = leftNode == first ? second : first;
    final leftCenter = getNodeCenter(leftNode);
    final rightCenter = getNodeCenter(rightNode);
    final y = _pixel((leftCenter.dy + rightCenter.dy) / 2);
    final start = Offset(_pixel(leftCenter.dx + leftNode.width / 2), y);
    final end = Offset(_pixel(rightCenter.dx - rightNode.width / 2), y);
    canvas.drawLine(start, end, paint);

    final center = Offset((start.dx + end.dx) / 2, y);
    canvas.drawCircle(
      center,
      15,
      Paint()
        ..color = const Color(0xFFFDF9FC)
        ..style = PaintingStyle.fill,
    );
    canvas.drawCircle(
      center,
      15,
      Paint()
        ..color = _partnershipColor
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );
    final heart = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(Icons.favorite.codePoint),
        style: TextStyle(
          color: _partnershipColor,
          fontSize: 15,
          fontFamily: Icons.favorite.fontFamily,
          package: Icons.favorite.fontPackage,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    heart.paint(canvas, center - Offset(heart.width / 2, heart.height / 2));
  }
}

class _TreeToolbar extends StatelessWidget {
  const _TreeToolbar({
    required this.people,
    required this.namesByPerson,
    required this.focus,
    required this.showAll,
    required this.visibleCount,
    required this.onFocusChanged,
    required this.onShowAllChanged,
  });

  final List<Person> people;
  final Map<PersonId, String> namesByPerson;
  final PersonId focus;
  final bool showAll;
  final int visibleCount;
  final ValueChanged<PersonId> onFocusChanged;
  final ValueChanged<bool> onShowAllChanged;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    child: Wrap(
      spacing: 16,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SizedBox(
          width: 320,
          child: DropdownButtonFormField<PersonId>(
            initialValue: focus,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Persona focal',
              isDense: true,
            ),
            items: people
                .map(
                  (person) => DropdownMenuItem(
                    value: person.id,
                    child: Text(
                      namesByPerson[person.id] ?? 'Persona sense nom',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) onFocusChanged(value);
            },
          ),
        ),
        FilterChip(
          selected: showAll,
          label: const Text('Mostra tot'),
          onSelected: onShowAllChanged,
        ),
        Text('$visibleCount persones visibles'),
        const Text('Família completa · parelles a 1 grau'),
      ],
    ),
  );
}

class _PersonTreeCard extends StatelessWidget {
  const _PersonTreeCard({
    required this.node,
    required this.selected,
    required this.focused,
    required this.onTap,
  });

  final FamilyTreePersonNode node;
  final bool selected;
  final bool focused;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      width: 190,
      child: Material(
        color: selected
            ? colors.primaryContainer
            : colors.surfaceContainerHighest,
        elevation: selected ? 6 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
            color: focused
                ? colors.primary
                : selected
                ? colors.onPrimaryContainer
                : colors.outlineVariant,
            width: focused ? 3 : 1,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.person_outline, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        node.displayName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _lifeSpan(node.person),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (focused) ...[
                  const SizedBox(height: 6),
                  Text(
                    'Persona focal',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _lifeSpan(Person person) =>
      '${historicalDateLabel(person.birthDate)} — '
      '${historicalDateLabel(person.deathDate)}';
}

class _TreeLegend extends StatelessWidget {
  const _TreeLegend();

  @override
  Widget build(BuildContext context) => Card(
    elevation: 3,
    child: const Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Llegenda', style: TextStyle(fontWeight: FontWeight.w700)),
          SizedBox(height: 8),
          _LegendEntry(
            color: _familyStructureColor,
            label: 'Tronc familiar compartit',
          ),
          _LegendEntry(color: _biologicalColor, label: 'Biològica'),
          _LegendEntry(color: _adoptiveColor, label: 'Adoptiva', dashed: true),
          _LegendEntry(color: _partnershipColor, label: 'Parella'),
        ],
      ),
    ),
  );
}

class _LegendEntry extends StatelessWidget {
  const _LegendEntry({
    required this.color,
    required this.label,
    this.dashed = false,
  });

  final Color color;
  final String label;
  final bool dashed;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 28,
          child: Text(
            dashed ? '– – –' : '━━━━',
            style: TextStyle(color: color, fontSize: 10),
          ),
        ),
        const SizedBox(width: 8),
        Text(label),
      ],
    ),
  );
}

class _PersonInspector extends ConsumerWidget {
  const _PersonInspector({
    required this.person,
    required this.displayName,
    required this.focus,
    required this.parentChildRelationships,
    required this.partnerships,
    required this.onMakeFocus,
  });

  final Person person;
  final String displayName;
  final PersonId focus;
  final List<ParentChildRelationship> parentChildRelationships;
  final List<Partnership> partnerships;
  final VoidCallback onMakeFocus;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paths = person.id == focus
        ? const <KinshipPath>[]
        : ref
              .watch(kinshipServiceProvider)
              .getKinship(
                source: person.id,
                target: focus,
                parentChildRelationships: parentChildRelationships,
                partnerships: partnerships,
              );
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const CircleAvatar(radius: 34, child: Icon(Icons.person, size: 36)),
        const SizedBox(height: 16),
        Text(
          displayName,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          '${historicalDateLabel(person.birthDate)} — '
          '${historicalDateLabel(person.deathDate)}',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        if (person.id == focus)
          const Chip(label: Text('Persona focal'))
        else ...[
          Text(
            'Parentiu amb la persona focal',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          if (paths.isEmpty)
            const Text(
              'No s’ha trobat un parentiu dins la profunditat actual.',
            ),
          ...paths.map(
            (path) => ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                path.nature == KinshipNature.adoptive
                    ? Icons.volunteer_activism_outlined
                    : path.nature == KinshipNature.partnership
                    ? Icons.favorite_outline
                    : Icons.account_tree_outlined,
              ),
              title: Text(_kinshipLabel(path.type)),
              subtitle: Text(_kinshipNatureLabel(path.nature)),
            ),
          ),
        ],
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: () => context.go('/people/${person.id.value}'),
          icon: const Icon(Icons.open_in_new),
          label: const Text('Obrir fitxa'),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: person.id == focus ? null : onMakeFocus,
          icon: const Icon(Icons.center_focus_strong),
          label: const Text('Centrar arbre aquí'),
        ),
      ],
    );
  }
}

String _kinshipLabel(KinshipType type) => switch (type) {
  KinshipType.parent => 'Pare o mare',
  KinshipType.child => 'Fill o filla',
  KinshipType.sibling => 'Germà o germana',
  KinshipType.grandparent => 'Avi o àvia',
  KinshipType.grandchild => 'Net o neta',
  KinshipType.auntOrUncle => 'Oncle o tia',
  KinshipType.nieceOrNephew => 'Nebot o neboda',
  KinshipType.firstCousin => 'Cosí o cosina germans',
  KinshipType.partner => 'Parella',
  KinshipType.relative => 'Familiar',
};

String _kinshipNatureLabel(KinshipNature nature) => switch (nature) {
  KinshipNature.biological => 'Parentiu biològic',
  KinshipNature.adoptive => 'Parentiu adoptiu',
  KinshipNature.partnership => 'Relació de parella',
};
