import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/domain/relationship/parent_child_relationship.dart';
import 'package:family_history/domain/relationship/sibling_relationship.dart';
import 'package:family_history/services/kinship/kinship_path.dart';
import 'package:family_history/services/kinship/kinship_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/domain_factories.dart';

void main() {
  const service = KinshipService();

  test('derives biological parent, sibling and grandparent paths', () {
    final grandparent = personId(1);
    final parent = personId(2);
    final aunt = personId(3);
    final child = personId(4);
    final relationships = [
      relationship(id: 1, parent: grandparent, child: parent),
      relationship(id: 2, parent: grandparent, child: aunt),
      relationship(id: 3, parent: parent, child: child),
    ];

    expect(
      service
          .getKinship(
            source: grandparent,
            target: child,
            parentChildRelationships: relationships,
          )
          .single
          .type,
      KinshipType.grandparent,
    );
    expect(
      service
          .getKinship(
            source: parent,
            target: aunt,
            parentChildRelationships: relationships,
          )
          .single
          .type,
      KinshipType.sibling,
    );
    expect(
      service
          .getKinship(
            source: aunt,
            target: child,
            parentChildRelationships: relationships,
          )
          .single
          .type,
      KinshipType.auntOrUncle,
    );
  });

  test('returns partnership only as a direct relationship', () {
    final first = personId(1);
    final second = personId(2);

    final path = service
        .getKinship(
          source: first,
          target: second,
          parentChildRelationships: const [],
          partnerships: [partnership(id: 1, personA: first, personB: second)],
        )
        .single;

    expect(path.type, KinshipType.partner);
    expect(path.nature, KinshipNature.partnership);
  });

  test('returns adoptive and biological paths for Joan and Marc', () {
    final grandfather = personId(1);
    final pere = personId(2);
    final joan = personId(3);
    final marc = personId(4);
    final relationships = [
      relationship(id: 1, parent: grandfather, child: pere),
      relationship(id: 2, parent: grandfather, child: joan),
      relationship(id: 3, parent: pere, child: marc),
      relationship(
        id: 4,
        parent: joan,
        child: marc,
        nature: ParentChildNature.adoptive,
      ),
    ];

    final joanToMarc = service.getKinship(
      source: joan,
      target: marc,
      parentChildRelationships: relationships,
    );
    expect(joanToMarc, hasLength(2));
    expect(
      joanToMarc.map((path) => (path.type, path.nature)),
      containsAll([
        (KinshipType.parent, KinshipNature.adoptive),
        (KinshipType.auntOrUncle, KinshipNature.biological),
      ]),
    );

    final grandfatherToMarc = service.getKinship(
      source: grandfather,
      target: marc,
      parentChildRelationships: relationships,
    );
    expect(grandfatherToMarc, hasLength(2));
    expect(
      grandfatherToMarc.map((path) => (path.type, path.nature)),
      containsAll([
        (KinshipType.grandparent, KinshipNature.biological),
        (KinshipType.grandparent, KinshipNature.adoptive),
      ]),
    );
  });

  test('derives first cousins within the default depth of four', () {
    final grandparent = personId(1);
    final firstParent = personId(2);
    final secondParent = personId(3);
    final firstCousin = personId(4);
    final secondCousin = personId(5);
    final relationships = [
      relationship(id: 1, parent: grandparent, child: firstParent),
      relationship(id: 2, parent: grandparent, child: secondParent),
      relationship(id: 3, parent: firstParent, child: firstCousin),
      relationship(id: 4, parent: secondParent, child: secondCousin),
    ];

    final path = service
        .getKinship(
          source: firstCousin,
          target: secondCousin,
          parentChildRelationships: relationships,
        )
        .single;

    expect(path.type, KinshipType.firstCousin);
    expect(path.length, 4);
  });

  test('returns explicit siblinghood without a shared known parent', () {
    final first = personId(1);
    final second = personId(2);
    final explicit = SiblingRelationship(
      id: SiblingRelationshipId('00000000-0000-4000-8000-000000000030'),
      personAId: first,
      personBId: second,
      kind: SiblingKind.unspecified,
      createdAt: testTimestamp,
      modifiedAt: testTimestamp,
    );

    final path = service
        .getKinship(
          source: first,
          target: second,
          parentChildRelationships: const [],
          siblingRelationships: [explicit],
        )
        .single;

    expect(path.type, KinshipType.sibling);
    expect(path.nature, KinshipNature.sibling);
    expect(path.length, 1);
  });
}
