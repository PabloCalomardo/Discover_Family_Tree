import 'package:family_history/core/errors/domain_validation_exception.dart';

enum HistoricalDatePrecision {
  exactDay,
  month,
  year,
  range,
  approximate,
  before,
  after,
  unknown,
}

final class HistoricalDate {
  HistoricalDate._({
    required this.precision,
    required this.startDate,
    required this.endDate,
    this.displayText,
  }) {
    if (startDate != null && endDate != null && startDate!.isAfter(endDate!)) {
      _invalid('The start date cannot be after the end date.');
    }
    if (displayText != null && displayText!.trim().isEmpty) {
      _invalid('Display text cannot be empty.');
    }
  }

  factory HistoricalDate.exactDay(
    int year,
    int month,
    int day, {
    String? displayText,
  }) {
    final date = _checkedDate(year, month, day);
    return HistoricalDate._(
      precision: HistoricalDatePrecision.exactDay,
      startDate: date,
      endDate: date,
      displayText: displayText,
    );
  }

  factory HistoricalDate.month(int year, int month, {String? displayText}) {
    final start = _checkedDate(year, month, 1);
    final end = DateTime.utc(year, month + 1, 0);
    return HistoricalDate._(
      precision: HistoricalDatePrecision.month,
      startDate: start,
      endDate: end,
      displayText: displayText,
    );
  }

  factory HistoricalDate.year(int year, {String? displayText}) =>
      HistoricalDate._(
        precision: HistoricalDatePrecision.year,
        startDate: DateTime.utc(year),
        endDate: DateTime.utc(year, 12, 31),
        displayText: displayText,
      );

  factory HistoricalDate.range(
    DateTime start,
    DateTime end, {
    String? displayText,
  }) => HistoricalDate._(
    precision: HistoricalDatePrecision.range,
    startDate: _dateOnly(start),
    endDate: _dateOnly(end),
    displayText: displayText,
  );

  factory HistoricalDate.approximate(DateTime anchor, {String? displayText}) {
    final date = _dateOnly(anchor);
    return HistoricalDate._(
      precision: HistoricalDatePrecision.approximate,
      startDate: date,
      endDate: date,
      displayText: displayText,
    );
  }

  factory HistoricalDate.before(DateTime date, {String? displayText}) =>
      HistoricalDate._(
        precision: HistoricalDatePrecision.before,
        startDate: null,
        endDate: _dateOnly(date),
        displayText: displayText,
      );

  factory HistoricalDate.after(DateTime date, {String? displayText}) =>
      HistoricalDate._(
        precision: HistoricalDatePrecision.after,
        startDate: _dateOnly(date),
        endDate: null,
        displayText: displayText,
      );

  factory HistoricalDate.unknown({String? displayText}) => HistoricalDate._(
    precision: HistoricalDatePrecision.unknown,
    startDate: null,
    endDate: null,
    displayText: displayText,
  );

  final HistoricalDatePrecision precision;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? displayText;

  static DateTime _checkedDate(int year, int month, int day) {
    final date = DateTime.utc(year, month, day);
    if (date.year != year || date.month != month || date.day != day) {
      _invalid('$year-$month-$day is not a valid calendar date.');
    }
    return date;
  }

  static DateTime _dateOnly(DateTime date) =>
      DateTime.utc(date.year, date.month, date.day);

  static Never _invalid(String message) => throw DomainValidationException(
    DomainValidationCode.invalidHistoricalDate,
    message,
  );

  @override
  bool operator ==(Object other) =>
      other is HistoricalDate &&
      other.precision == precision &&
      other.startDate == startDate &&
      other.endDate == endDate &&
      other.displayText == displayText;

  @override
  int get hashCode => Object.hash(precision, startDate, endDate, displayText);
}
