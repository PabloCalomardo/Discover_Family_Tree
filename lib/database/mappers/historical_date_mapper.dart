import 'package:family_history/core/dates/historical_date.dart';
import 'package:family_history/database/mappers/enum_mapping.dart';

typedef HistoricalDateFields = ({
  String? precision,
  DateTime? startDate,
  DateTime? endDate,
  String? displayText,
});

HistoricalDateFields historicalDateToFields(HistoricalDate? date) => (
  precision: date == null ? null : enumToSql(date.precision),
  startDate: date?.startDate,
  endDate: date?.endDate,
  displayText: date?.displayText,
);

HistoricalDate? historicalDateFromFields({
  required String? precision,
  required DateTime? startDate,
  required DateTime? endDate,
  required String? displayText,
}) {
  if (precision == null) return null;

  final parsed = enumFromSql(HistoricalDatePrecision.values, precision);
  return switch (parsed) {
    HistoricalDatePrecision.exactDay => HistoricalDate.exactDay(
      startDate!.year,
      startDate.month,
      startDate.day,
      displayText: displayText,
    ),
    HistoricalDatePrecision.month => HistoricalDate.month(
      startDate!.year,
      startDate.month,
      displayText: displayText,
    ),
    HistoricalDatePrecision.year => HistoricalDate.year(
      startDate!.year,
      displayText: displayText,
    ),
    HistoricalDatePrecision.range => HistoricalDate.range(
      startDate!,
      endDate!,
      displayText: displayText,
    ),
    HistoricalDatePrecision.approximate => HistoricalDate.approximate(
      startDate!,
      displayText: displayText,
    ),
    HistoricalDatePrecision.before => HistoricalDate.before(
      endDate!,
      displayText: displayText,
    ),
    HistoricalDatePrecision.after => HistoricalDate.after(
      startDate!,
      displayText: displayText,
    ),
    HistoricalDatePrecision.unknown => HistoricalDate.unknown(
      displayText: displayText,
    ),
  };
}
