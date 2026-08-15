import 'package:family_history/core/dates/historical_date.dart';
import 'package:family_history/core/dates/historical_period.dart';
import 'package:family_history/core/errors/domain_validation_exception.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/domain/place/place.dart';
import 'package:family_history/domain/place/place_relationship.dart';
import 'package:family_history/domain/place/residence.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/domain_factories.dart';

void main() {
  test('validates paired geographic coordinates and their ranges', () {
    expect(
      () => Place(
        id: placeId(1),
        preferredName: 'Mas Puig',
        type: PlaceType.farmhouse,
        latitude: 41.4,
        createdAt: testTimestamp,
        modifiedAt: testTimestamp,
      ),
      throwsA(isA<DomainValidationException>()),
    );
    expect(
      () => Place(
        id: placeId(1),
        preferredName: 'Mas Puig',
        type: PlaceType.farmhouse,
        latitude: 91,
        longitude: 2.1,
        createdAt: testTimestamp,
        modifiedAt: testTimestamp,
      ),
      throwsA(isA<DomainValidationException>()),
    );
  });

  test('rejects self-related places', () {
    expect(
      () => PlaceRelationship(
        id: PlaceRelationshipId('00000000-0000-4000-8000-000000000100'),
        sourcePlaceId: placeId(1),
        targetPlaceId: placeId(1),
        type: PlaceRelationshipType.locatedIn,
        createdAt: testTimestamp,
        modifiedAt: testTimestamp,
      ),
      throwsA(isA<DomainValidationException>()),
    );
  });

  test('rejects only unequivocally reversed residence intervals', () {
    expect(
      () => Residence(
        id: ResidenceId('00000000-0000-4000-8000-000000000101'),
        personId: personId(1),
        placeId: placeId(1),
        startDate: HistoricalDate.year(1936),
        endDate: HistoricalDate.year(1912),
        createdAt: testTimestamp,
        modifiedAt: testTimestamp,
      ),
      throwsA(isA<DomainValidationException>()),
    );
    expect(
      () => Residence(
        id: ResidenceId('00000000-0000-4000-8000-000000000102'),
        personId: personId(1),
        placeId: placeId(1),
        startDate: HistoricalDate.after(DateTime(1900)),
        endDate: HistoricalDate.unknown(),
        createdAt: testTimestamp,
        modifiedAt: testTimestamp,
      ),
      returnsNormally,
    );
  });

  test('uses possible overlap semantics for uncertain periods', () {
    final period = HistoricalPeriod(
      start: DateTime.utc(1920),
      end: DateTime.utc(1930),
    );

    expect(
      period.possiblyOverlaps(
        intervalStart: HistoricalDate.year(1912),
        intervalEnd: HistoricalDate.year(1936),
      ),
      isTrue,
    );
    expect(
      period.possiblyOverlaps(intervalStart: HistoricalDate.year(1940)),
      isFalse,
    );
    expect(
      period.possiblyOverlaps(
        intervalStart: HistoricalDate.unknown(),
        intervalEnd: HistoricalDate.unknown(),
      ),
      isTrue,
    );
  });
}
