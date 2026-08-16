import 'package:family_history/core/errors/domain_validation_exception.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/domain/person/person.dart';
import 'package:family_history/domain/person/person_name.dart';
import 'package:family_history/domain/relationship/parent_child_relationship.dart';
import 'package:family_history/domain/relationship/partnership.dart';
import 'package:family_history/domain/relationship/sibling_relationship.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/domain_factories.dart';

void main() {
  test('creates a person and a preferred name', () {
    final person = Person(
      id: personId(1),
      sex: PersonSex.unspecified,
      biography: '  Una biografia  ',
      createdAt: testTimestamp,
      modifiedAt: testTimestamp,
    );
    final name = PersonName(
      id: PersonNameId('00000000-0000-4000-8000-000000000010'),
      personId: person.id,
      displayName: '  Maria Puig  ',
      type: PersonNameType.birth,
      isPreferred: true,
      createdAt: testTimestamp,
      modifiedAt: testTimestamp,
    );

    expect(person.biography, 'Una biografia');
    expect(name.displayName, 'Maria Puig');
    expect(name.isPreferred, isTrue);
  });

  test('rejects self-parentage, self-partnership and self-siblinghood', () {
    final person = personId(1);
    final matcher = isA<DomainValidationException>().having(
      (error) => error.code,
      'code',
      DomainValidationCode.invalidEntity,
    );

    expect(
      () => ParentChildRelationship(
        id: ParentChildRelationshipId('00000000-0000-4000-8000-000000000020'),
        parentId: person,
        childId: person,
        nature: ParentChildNature.biological,
        createdAt: testTimestamp,
        modifiedAt: testTimestamp,
      ),
      throwsA(matcher),
    );
    expect(
      () => Partnership(
        id: PartnershipId('00000000-0000-4000-8000-000000000021'),
        personAId: person,
        personBId: person,
        type: PartnershipType.marriage,
        createdAt: testTimestamp,
        modifiedAt: testTimestamp,
      ),
      throwsA(matcher),
    );
    expect(
      () => SiblingRelationship(
        id: SiblingRelationshipId('00000000-0000-4000-8000-000000000022'),
        personAId: person,
        personBId: person,
        kind: SiblingKind.unspecified,
        createdAt: testTimestamp,
        modifiedAt: testTimestamp,
      ),
      throwsA(matcher),
    );
  });

  test('canonicalizes a sibling pair regardless of input order', () {
    final first = personId(1);
    final second = personId(2);
    final sibling = SiblingRelationship(
      id: SiblingRelationshipId('00000000-0000-4000-8000-000000000023'),
      personAId: second,
      personBId: first,
      kind: SiblingKind.half,
      createdAt: testTimestamp,
      modifiedAt: testTimestamp,
    );

    expect(sibling.personAId, first);
    expect(sibling.personBId, second);
    expect(sibling.other(first), second);
  });
}
