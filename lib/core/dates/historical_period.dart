import 'package:family_history/core/dates/historical_date.dart';
import 'package:family_history/core/errors/domain_validation_exception.dart';

final class HistoricalPeriod {
  HistoricalPeriod({DateTime? start, DateTime? end})
    : start = start == null ? null : _dateOnly(start),
      end = end == null ? null : _dateOnly(end) {
    if (this.start != null &&
        this.end != null &&
        this.start!.isAfter(this.end!)) {
      throw const DomainValidationException(
        DomainValidationCode.invalidHistoricalDate,
        'A period cannot start after it ends.',
      );
    }
  }

  final DateTime? start;
  final DateTime? end;

  bool possiblyOverlaps({
    HistoricalDate? intervalStart,
    HistoricalDate? intervalEnd,
  }) {
    final earliestIntervalStart = intervalStart?.startDate;
    final latestIntervalEnd = intervalEnd?.endDate;

    if (end != null &&
        earliestIntervalStart != null &&
        earliestIntervalStart.isAfter(end!)) {
      return false;
    }
    if (start != null &&
        latestIntervalEnd != null &&
        latestIntervalEnd.isBefore(start!)) {
      return false;
    }
    return true;
  }

  static DateTime _dateOnly(DateTime date) =>
      DateTime.utc(date.year, date.month, date.day);
}
