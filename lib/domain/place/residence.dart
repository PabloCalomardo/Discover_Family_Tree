import 'package:family_history/core/dates/historical_date.dart';
import 'package:family_history/core/dates/temporal_validation.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/core/utils/entity_validation.dart';

final class Residence {
  Residence({
    required this.id,
    required this.personId,
    required this.placeId,
    required this.createdAt,
    required this.modifiedAt,
    this.startDate,
    this.endDate,
    String? reason,
    String? notes,
    this.deletedAt,
  }) : reason = normalizedOptionalText(reason),
       notes = normalizedOptionalText(notes) {
    validatePossibleInterval(start: startDate, end: endDate);
    validateEntityTimestamps(
      createdAt: createdAt,
      modifiedAt: modifiedAt,
      deletedAt: deletedAt,
    );
  }

  final ResidenceId id;
  final PersonId personId;
  final PlaceId placeId;
  final HistoricalDate? startDate;
  final HistoricalDate? endDate;
  final String? reason;
  final String? notes;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final DateTime? deletedAt;

  bool get isDeleted => deletedAt != null;
}
