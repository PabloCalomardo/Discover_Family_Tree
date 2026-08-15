import 'package:family_history/core/dates/historical_date.dart';
import 'package:family_history/core/errors/domain_validation_exception.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('represents exact, partial and uncertain historical dates', () {
    final exact = HistoricalDate.exactDay(1912, 4, 12);
    final month = HistoricalDate.month(1912, 4);
    final year = HistoricalDate.year(1912);
    final approximate = HistoricalDate.approximate(
      DateTime(1912),
      displayText: 'cap al 1912',
    );
    final unknown = HistoricalDate.unknown(displayText: 'desconeguda');

    expect(exact.startDate, DateTime.utc(1912, 4, 12));
    expect(exact.endDate, exact.startDate);
    expect(month.startDate, DateTime.utc(1912, 4));
    expect(month.endDate, DateTime.utc(1912, 4, 30));
    expect(year.startDate, DateTime.utc(1912));
    expect(year.endDate, DateTime.utc(1912, 12, 31));
    expect(approximate.precision, HistoricalDatePrecision.approximate);
    expect(unknown.startDate, isNull);
    expect(unknown.endDate, isNull);
  });

  test('represents ranges, before and after boundaries', () {
    final range = HistoricalDate.range(DateTime(1910), DateTime(1915));
    final before = HistoricalDate.before(DateTime(1932));
    final after = HistoricalDate.after(DateTime(1900));

    expect(range.precision, HistoricalDatePrecision.range);
    expect(before.startDate, isNull);
    expect(before.endDate, DateTime.utc(1932));
    expect(after.startDate, DateTime.utc(1900));
    expect(after.endDate, isNull);
  });

  test('rejects invalid calendar dates and reversed ranges', () {
    final matcher = isA<DomainValidationException>().having(
      (error) => error.code,
      'code',
      DomainValidationCode.invalidHistoricalDate,
    );

    expect(() => HistoricalDate.exactDay(1912, 2, 30), throwsA(matcher));
    expect(
      () => HistoricalDate.range(DateTime(1915), DateTime(1910)),
      throwsA(matcher),
    );
  });
}
