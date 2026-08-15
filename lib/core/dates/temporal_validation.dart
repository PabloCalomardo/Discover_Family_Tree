import 'package:family_history/core/dates/historical_date.dart';
import 'package:family_history/core/errors/domain_validation_exception.dart';

void validatePossibleInterval({HistoricalDate? start, HistoricalDate? end}) {
  final earliestStart = start?.startDate;
  final latestEnd = end?.endDate;
  if (earliestStart != null &&
      latestEnd != null &&
      earliestStart.isAfter(latestEnd)) {
    throw const DomainValidationException(
      DomainValidationCode.invalidHistoricalDate,
      'The interval starts unequivocally after it ends.',
    );
  }
}
