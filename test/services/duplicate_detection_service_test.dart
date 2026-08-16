import 'package:family_history/core/dates/historical_date.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/domain/person/person.dart';
import 'package:family_history/domain/person/person_name.dart';
import 'package:family_history/services/duplicate/duplicate_detection_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime.utc(2026, 8, 16);

  DuplicatePersonRecord record(String name, int birthYear) {
    final id = PersonId.generate();
    return DuplicatePersonRecord(
      person: Person(
        id: id,
        sex: PersonSex.unknown,
        birthDate: HistoricalDate.year(birthYear),
        createdAt: now,
        modifiedAt: now,
      ),
      names: [
        PersonName(
          id: PersonNameId.generate(),
          personId: id,
          displayName: name,
          type: PersonNameType.birth,
          isPreferred: true,
          createdAt: now,
          modifiedAt: now,
        ),
      ],
    );
  }

  test('finds deterministic match with normalized accents', () {
    final matches = const DuplicateDetectionService().detect([
      record('Josep García', 1912),
      record('Josep Garcia', 1912),
    ]);
    expect(matches, hasLength(1));
    expect(matches.single.score, greaterThanOrEqualTo(60));
    expect(matches.single.reasonCodes, contains('NAME_EXACT'));
  });

  test('rejects strongly incompatible dates', () {
    final matches = const DuplicateDetectionService().detect([
      record('Josep Garcia', 1812),
      record('Josep Garcia', 1912),
    ]);
    expect(matches, isEmpty);
  });
}
