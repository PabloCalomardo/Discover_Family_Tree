import 'package:family_history/core/errors/domain_validation_exception.dart';
import 'package:family_history/domain/relationship/parent_child_relationship.dart';
import 'package:family_history/services/kinship/family_graph_validator.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/domain_factories.dart';

void main() {
  const validator = FamilyGraphValidator();

  test('rejects an exact active duplicate', () {
    final existing = relationship(
      id: 1,
      parent: personId(1),
      child: personId(2),
    );
    final duplicate = relationship(
      id: 2,
      parent: personId(1),
      child: personId(2),
    );

    expect(
      () => validator.validateCanAdd([existing], duplicate),
      throwsA(
        isA<DomainValidationException>().having(
          (error) => error.code,
          'code',
          DomainValidationCode.duplicateRelationship,
        ),
      ),
    );
  });

  test('allows biological and adoptive relationships for the same pair', () {
    final biological = relationship(
      id: 1,
      parent: personId(1),
      child: personId(2),
    );
    final adoptive = relationship(
      id: 2,
      parent: personId(1),
      child: personId(2),
      nature: ParentChildNature.adoptive,
    );

    expect(
      () => validator.validateCanAdd([biological], adoptive),
      returnsNormally,
    );
  });

  test('rejects a cycle combining biological and adoptive edges', () {
    final relationships = [
      relationship(id: 1, parent: personId(1), child: personId(2)),
      relationship(
        id: 2,
        parent: personId(2),
        child: personId(3),
        nature: ParentChildNature.adoptive,
      ),
    ];
    final closingEdge = relationship(
      id: 3,
      parent: personId(3),
      child: personId(1),
    );

    expect(
      () => validator.validateCanAdd(relationships, closingEdge),
      throwsA(
        isA<DomainValidationException>().having(
          (error) => error.code,
          'code',
          DomainValidationCode.parentageCycle,
        ),
      ),
    );
  });
}
