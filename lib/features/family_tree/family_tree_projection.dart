import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/domain/person/person.dart';
import 'package:family_history/domain/person/person_name.dart';
import 'package:family_history/domain/relationship/parent_child_relationship.dart';
import 'package:family_history/domain/relationship/partnership.dart';

sealed class FamilyTreeNode {
  const FamilyTreeNode(this.key);

  final String key;
}

final class FamilyTreePersonNode extends FamilyTreeNode {
  FamilyTreePersonNode({required this.person, required this.displayName})
    : super('person:${person.id.value}');

  final Person person;
  final String displayName;
}

final class FamilyTreeUnionNode extends FamilyTreeNode {
  FamilyTreeUnionNode({required this.partnership})
    : super('union:${partnership.id.value}');

  final Partnership partnership;
}

enum FamilyTreeEdgeKind { biological, adoptive, partnership }

final class FamilyTreeEdge {
  const FamilyTreeEdge({
    required this.key,
    required this.sourceKey,
    required this.destinationKey,
    required this.kind,
  });

  final String key;
  final String sourceKey;
  final String destinationKey;
  final FamilyTreeEdgeKind kind;
}

final class FamilyTreeProjection {
  const FamilyTreeProjection({
    required this.nodes,
    required this.edges,
    required this.visiblePersonIds,
  });

  final List<FamilyTreeNode> nodes;
  final List<FamilyTreeEdge> edges;
  final Set<PersonId> visiblePersonIds;
}

final class FamilyTreeProjector {
  const FamilyTreeProjector();

  FamilyTreeProjection project({
    required Iterable<Person> people,
    required Iterable<PersonName> names,
    required Iterable<ParentChildRelationship> parentChildRelationships,
    required Iterable<Partnership> partnerships,
    PersonId? focus,
    bool showAll = false,
  }) {
    final activePeople = {
      for (final person in people.where((person) => !person.isDeleted))
        person.id: person,
    };
    final activeParentChild = parentChildRelationships
        .where(
          (relationship) =>
              !relationship.isDeleted &&
              activePeople.containsKey(relationship.parentId) &&
              activePeople.containsKey(relationship.childId),
        )
        .toList(growable: false);
    final activePartnerships = partnerships
        .where(
          (partnership) =>
              !partnership.isDeleted &&
              activePeople.containsKey(partnership.personAId) &&
              activePeople.containsKey(partnership.personBId),
        )
        .toList(growable: false);

    final visibleIds =
        showAll || focus == null || !activePeople.containsKey(focus)
        ? activePeople.keys.toSet()
        : _focusedPeople(
            focus: focus,
            parentChildRelationships: activeParentChild,
            partnerships: activePartnerships,
          );
    final preferredNames = _preferredNames(names);
    final displayParentChild = _withoutRedundantGenerationJumps(
      activeParentChild,
    );
    final nodes = <FamilyTreeNode>[
      for (final person in activePeople.values)
        if (visibleIds.contains(person.id))
          FamilyTreePersonNode(
            person: person,
            displayName: preferredNames[person.id] ?? 'Persona sense nom',
          ),
    ];
    final edges = <FamilyTreeEdge>[];

    for (final relationship in displayParentChild) {
      if (!visibleIds.contains(relationship.parentId) ||
          !visibleIds.contains(relationship.childId)) {
        continue;
      }
      edges.add(
        FamilyTreeEdge(
          key: 'parent:${relationship.id.value}',
          sourceKey: 'person:${relationship.parentId.value}',
          destinationKey: 'person:${relationship.childId.value}',
          kind: relationship.nature == ParentChildNature.biological
              ? FamilyTreeEdgeKind.biological
              : FamilyTreeEdgeKind.adoptive,
        ),
      );
    }

    for (final partnership in activePartnerships) {
      if (!visibleIds.contains(partnership.personAId) ||
          !visibleIds.contains(partnership.personBId)) {
        continue;
      }
      final union = FamilyTreeUnionNode(partnership: partnership);
      nodes.add(union);
      edges
        ..add(
          FamilyTreeEdge(
            key: 'partnership-a:${partnership.id.value}',
            sourceKey: 'person:${partnership.personAId.value}',
            destinationKey: union.key,
            kind: FamilyTreeEdgeKind.partnership,
          ),
        )
        ..add(
          FamilyTreeEdge(
            key: 'partnership-b:${partnership.id.value}',
            sourceKey: 'person:${partnership.personBId.value}',
            destinationKey: union.key,
            kind: FamilyTreeEdgeKind.partnership,
          ),
        );
    }

    return FamilyTreeProjection(
      nodes: List.unmodifiable(nodes),
      edges: List.unmodifiable(edges),
      visiblePersonIds: Set.unmodifiable(visibleIds),
    );
  }

  Map<PersonId, String> _preferredNames(Iterable<PersonName> names) {
    final byPerson = <PersonId, List<PersonName>>{};
    for (final name in names.where((name) => !name.isDeleted)) {
      byPerson.putIfAbsent(name.personId, () => []).add(name);
    }
    return {
      for (final entry in byPerson.entries)
        entry.key:
            entry.value
                .where((name) => name.isPreferred)
                .firstOrNull
                ?.displayName ??
            entry.value.first.displayName,
    };
  }

  List<ParentChildRelationship> _withoutRedundantGenerationJumps(
    List<ParentChildRelationship> relationships,
  ) {
    final childrenByParent = <PersonId, Set<PersonId>>{};
    for (final relationship in relationships) {
      childrenByParent
          .putIfAbsent(relationship.parentId, () => <PersonId>{})
          .add(relationship.childId);
    }
    final redundantPairs = <(PersonId, PersonId), bool>{};
    bool isRedundant(PersonId parent, PersonId child) {
      final pair = (parent, child);
      return redundantPairs.putIfAbsent(pair, () {
        final visited = <PersonId>{parent};
        final pending = <PersonId>[
          for (final directChild in childrenByParent[parent] ?? <PersonId>{})
            if (directChild != child) directChild,
        ];
        while (pending.isNotEmpty) {
          final current = pending.removeLast();
          if (current == child) return true;
          if (!visited.add(current)) continue;
          pending.addAll(childrenByParent[current] ?? <PersonId>{});
        }
        return false;
      });
    }

    return relationships
        .where(
          (relationship) =>
              !isRedundant(relationship.parentId, relationship.childId),
        )
        .toList(growable: false);
  }

  Set<PersonId> _focusedPeople({
    required PersonId focus,
    required List<ParentChildRelationship> parentChildRelationships,
    required List<Partnership> partnerships,
  }) {
    final ancestors = <PersonId>{focus};
    final pendingAncestors = <PersonId>[focus];
    while (pendingAncestors.isNotEmpty) {
      final current = pendingAncestors.removeLast();
      for (final relationship in parentChildRelationships) {
        if (relationship.childId == current &&
            ancestors.add(relationship.parentId)) {
          pendingAncestors.add(relationship.parentId);
        }
      }
    }

    final family = ancestors.toSet();
    final pendingDescendants = ancestors.toList();
    while (pendingDescendants.isNotEmpty) {
      final current = pendingDescendants.removeLast();
      for (final relationship in parentChildRelationships) {
        if (relationship.parentId == current &&
            family.add(relationship.childId)) {
          pendingDescendants.add(relationship.childId);
        }
      }
    }

    final visible = family.toSet();
    for (final partnership in partnerships) {
      if (family.contains(partnership.personAId)) {
        visible.add(partnership.personBId);
      }
      if (family.contains(partnership.personBId)) {
        visible.add(partnership.personAId);
      }
    }
    return visible;
  }
}
