import 'package:family_history/core/errors/domain_validation_exception.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

void main() {
  const value = 'a3b9e277-80c1-4f06-8ad6-6a924dca6f44';

  test('validates, normalizes and compares typed identifiers', () {
    final first = PersonId(value.toUpperCase());
    final second = PersonId(value);

    expect(first, second);
    expect(first.value, value);
    expect(first == PersonNameId(value), isFalse);
  });

  test('generates UUID v4 identifiers', () {
    final id = PersonId.generate();

    expect(Uuid.isValidUUID(fromString: id.value), isTrue);
    expect(id.value.split('-')[2].startsWith('4'), isTrue);
  });

  test('rejects malformed identifiers', () {
    expect(
      () => PersonId('not-a-uuid'),
      throwsA(
        isA<DomainValidationException>().having(
          (error) => error.code,
          'code',
          DomainValidationCode.invalidUuid,
        ),
      ),
    );
  });
}
