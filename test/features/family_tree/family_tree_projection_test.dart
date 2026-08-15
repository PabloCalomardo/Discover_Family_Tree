import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/domain/person/person.dart';
import 'package:family_history/domain/person/person_name.dart';
import 'package:family_history/domain/relationship/parent_child_relationship.dart';
import 'package:family_history/features/family_tree/family_tree_projection.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/domain_factories.dart';

void main() {
  const projector = FamilyTreeProjector();

  Person person(int id) => Person(
    id: personId(id),
    sex: PersonSex.unspecified,
    createdAt: testTimestamp,
    modifiedAt: testTimestamp,
  );

  PersonName name(int id, PersonId owner, String displayName) => PersonName(
    id: PersonNameId(
      '00000000-0000-4000-8000-${id.toString().padLeft(12, '0')}',
    ),
    personId: owner,
    displayName: displayName,
    type: PersonNameType.birth,
    isPreferred: true,
    createdAt: testTimestamp,
    modifiedAt: testTimestamp,
  );

  test('includes the ancestor-descendant family and one partnership hop', () {
    final people = [for (var id = 1; id <= 10; id++) person(id)];
    final relationships = [
      relationship(id: 1, parent: personId(2), child: personId(1)),
      relationship(id: 2, parent: personId(3), child: personId(2)),
      relationship(id: 3, parent: personId(4), child: personId(3)),
      relationship(id: 4, parent: personId(1), child: personId(5)),
      relationship(id: 5, parent: personId(5), child: personId(6)),
      relationship(id: 6, parent: personId(6), child: personId(7)),
      relationship(id: 7, parent: personId(10), child: personId(8)),
      relationship(id: 8, parent: personId(8), child: personId(5)),
    ];
    final partnerships = [
      partnership(id: 1, personA: personId(1), personB: personId(8)),
      partnership(id: 2, personA: personId(8), personB: personId(9)),
    ];

    final projection = projector.project(
      people: people,
      names: const [],
      parentChildRelationships: relationships,
      partnerships: partnerships,
      focus: personId(1),
    );

    expect(
      projection.visiblePersonIds,
      equals({
        personId(1),
        personId(2),
        personId(3),
        personId(4),
        personId(5),
        personId(6),
        personId(7),
        personId(8),
      }),
    );
    expect(projection.visiblePersonIds, isNot(contains(personId(9))));
    expect(projection.visiblePersonIds, isNot(contains(personId(10))));
    expect(projection.nodes.whereType<FamilyTreeUnionNode>(), hasLength(1));
  });

  test('keeps biological and adoptive edges between the same people', () {
    final parent = person(1);
    final child = person(2);
    final projection = projector.project(
      people: [parent, child],
      names: [name(1, parent.id, 'Nom preferit')],
      parentChildRelationships: [
        relationship(id: 1, parent: parent.id, child: child.id),
        relationship(
          id: 2,
          parent: parent.id,
          child: child.id,
          nature: ParentChildNature.adoptive,
        ),
      ],
      partnerships: const [],
      showAll: true,
    );

    expect(
      projection.edges.map((edge) => edge.kind),
      containsAll([FamilyTreeEdgeKind.biological, FamilyTreeEdgeKind.adoptive]),
    );
    expect(projection.edges, hasLength(2));
    expect(
      projection.nodes
          .whereType<FamilyTreePersonNode>()
          .firstWhere((node) => node.person.id == parent.id)
          .displayName,
      'Nom preferit',
    );
  });

  test('show all includes disconnected family branches', () {
    final projection = projector.project(
      people: [person(1), person(2), person(9)],
      names: const [],
      parentChildRelationships: [
        relationship(id: 1, parent: personId(1), child: personId(2)),
      ],
      partnerships: const [],
      focus: personId(1),
      showAll: true,
    );

    expect(projection.visiblePersonIds, hasLength(3));
    expect(projection.visiblePersonIds, contains(personId(9)));
  });

  test('hides a direct generation jump when an intermediate path exists', () {
    final projection = projector.project(
      people: [person(1), person(2), person(3), person(4)],
      names: const [],
      parentChildRelationships: [
        relationship(id: 1, parent: personId(1), child: personId(2)),
        relationship(id: 2, parent: personId(2), child: personId(3)),
        relationship(id: 3, parent: personId(1), child: personId(3)),
        relationship(id: 4, parent: personId(1), child: personId(4)),
      ],
      partnerships: const [],
      showAll: true,
    );

    final lineageEdges = projection.edges.where(
      (edge) => edge.kind != FamilyTreeEdgeKind.partnership,
    );
    expect(lineageEdges, hasLength(3));
    expect(
      lineageEdges,
      isNot(
        contains(
          isA<FamilyTreeEdge>()
              .having(
                (edge) => edge.sourceKey,
                'source',
                'person:${personId(1).value}',
              )
              .having(
                (edge) => edge.destinationKey,
                'destination',
                'person:${personId(3).value}',
              ),
        ),
      ),
    );
  });
}
