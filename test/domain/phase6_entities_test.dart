import 'package:family_history/core/dates/historical_date.dart';
import 'package:family_history/core/errors/domain_validation_exception.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/domain/claim/claim.dart';
import 'package:family_history/domain/source/media_asset.dart';
import 'package:family_history/domain/source/source.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime.utc(2026, 8, 16);

  test('source normalizes bibliographic text', () {
    final source = Source(
      id: SourceId.generate(),
      type: SourceType.registry,
      title: '  Registre civil  ',
      creator: '  Ajuntament  ',
      createdAt: now,
      modifiedAt: now,
    );
    expect(source.title, 'Registre civil');
    expect(source.creator, 'Ajuntament');
  });

  test('media rejects unsafe paths and invalid checksums', () {
    expect(
      () => MediaAsset(
        id: MediaId.generate(),
        type: MediaType.document,
        relativePath: '../outside.pdf',
        checksumSha256: 'invalid',
        fileSize: 1,
        createdAt: now,
        modifiedAt: now,
      ),
      throwsA(isA<DomainValidationException>()),
    );
  });

  test('typed claim values round-trip through JSON', () {
    final value = HistoricalDateClaimValue(HistoricalDate.year(1912));
    final decoded = ClaimValue.decode(value.type, value.encode());
    expect(decoded, isA<HistoricalDateClaimValue>());
    expect(
      (decoded as HistoricalDateClaimValue).value,
      HistoricalDate.year(1912),
    );
  });

  test('claim rejects value type incompatible with property', () {
    expect(
      () => Claim(
        id: ClaimId.generate(),
        subjectType: ClaimSubjectType.person,
        subjectId: PersonId.generate().value,
        property: ClaimProperty.personBirthDate,
        value: TextClaimValue('1912'),
        status: ClaimStatus.unreviewed,
        createdAt: now,
        modifiedAt: now,
      ),
      throwsA(isA<DomainValidationException>()),
    );
  });
}
