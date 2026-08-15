import 'package:family_history/core/errors/domain_validation_exception.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/domain/place/place_relationship.dart';
import 'package:family_history/services/place/place_graph_validator.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/domain_factories.dart';

void main() {
  const validator = PlaceGraphValidator();

  PlaceRelationship relation({
    required int id,
    required int source,
    required int target,
    required PlaceRelationshipType type,
  }) => PlaceRelationship(
    id: PlaceRelationshipId(
      '00000000-0000-4000-8000-${id.toRadixString(16).padLeft(12, '0')}',
    ),
    sourcePlaceId: placeId(source),
    targetPlaceId: placeId(target),
    type: type,
    createdAt: testTimestamp,
    modifiedAt: testTimestamp,
  );

  test('treats SAME_AS as symmetric for duplicate detection', () {
    final first = relation(
      id: 1,
      source: 1,
      target: 2,
      type: PlaceRelationshipType.sameAs,
    );
    final reversed = relation(
      id: 2,
      source: 2,
      target: 1,
      type: PlaceRelationshipType.sameAs,
    );

    expect(
      () => validator.validateCanAdd([first], reversed),
      throwsA(
        isA<DomainValidationException>().having(
          (error) => error.code,
          'code',
          DomainValidationCode.duplicatePlaceRelationship,
        ),
      ),
    );
  });

  test('rejects cycles in LOCATED_IN hierarchies', () {
    final first = relation(
      id: 1,
      source: 1,
      target: 2,
      type: PlaceRelationshipType.locatedIn,
    );
    final second = relation(
      id: 2,
      source: 2,
      target: 3,
      type: PlaceRelationshipType.locatedIn,
    );
    final closing = relation(
      id: 3,
      source: 3,
      target: 1,
      type: PlaceRelationshipType.locatedIn,
    );

    expect(
      () => validator.validateCanAdd([first, second], closing),
      throwsA(
        isA<DomainValidationException>().having(
          (error) => error.code,
          'code',
          DomainValidationCode.placeHierarchyCycle,
        ),
      ),
    );
  });

  test('keeps PREVIOUSLY_KNOWN_AS directional', () {
    final first = relation(
      id: 1,
      source: 1,
      target: 2,
      type: PlaceRelationshipType.previouslyKnownAs,
    );
    final reversed = relation(
      id: 2,
      source: 2,
      target: 1,
      type: PlaceRelationshipType.previouslyKnownAs,
    );

    expect(() => validator.validateCanAdd([first], reversed), returnsNormally);
  });
}
