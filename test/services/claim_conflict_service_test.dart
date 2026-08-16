import 'package:family_history/core/dates/historical_date.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/domain/claim/claim.dart';
import 'package:family_history/services/claim/claim_conflict_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime.utc(2026, 8, 16);
  final personId = PersonId.generate().value;

  Claim birth(int year, {ClaimStatus status = ClaimStatus.unreviewed}) => Claim(
    id: ClaimId.generate(),
    subjectType: ClaimSubjectType.person,
    subjectId: personId,
    property: ClaimProperty.personBirthDate,
    value: HistoricalDateClaimValue(HistoricalDate.year(year)),
    status: status,
    createdAt: now,
    modifiedAt: now,
  );

  test('detects disjoint historical date claims', () {
    final conflicts = const ClaimConflictService().detect([
      birth(1912),
      birth(1914),
    ]);
    expect(conflicts, hasLength(1));
  });

  test('does not report rejected or overlapping claims', () {
    expect(
      const ClaimConflictService().detect([
        birth(1912),
        birth(1912),
        birth(1914, status: ClaimStatus.rejected),
      ]),
      isEmpty,
    );
  });
}
