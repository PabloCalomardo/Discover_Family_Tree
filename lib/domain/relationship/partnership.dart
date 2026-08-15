import 'package:family_history/core/dates/historical_date.dart';
import 'package:family_history/core/errors/domain_validation_exception.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/core/utils/entity_validation.dart';

enum PartnershipType { marriage, partnership, unknown }

final class Partnership {
  Partnership({
    required this.id,
    required this.personAId,
    required this.personBId,
    required this.type,
    required this.createdAt,
    required this.modifiedAt,
    this.startDate,
    this.endDate,
    this.placeId,
    String? notes,
    this.deletedAt,
  }) : notes = normalizedOptionalText(notes) {
    if (personAId == personBId) {
      throw const DomainValidationException(
        DomainValidationCode.invalidEntity,
        'A partnership requires two different people.',
      );
    }
    validateEntityTimestamps(
      createdAt: createdAt,
      modifiedAt: modifiedAt,
      deletedAt: deletedAt,
    );
  }

  final PartnershipId id;
  final PersonId personAId;
  final PersonId personBId;
  final PartnershipType type;
  final HistoricalDate? startDate;
  final HistoricalDate? endDate;
  final PlaceId? placeId;
  final String? notes;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final DateTime? deletedAt;

  bool get isDeleted => deletedAt != null;

  bool connects(PersonId first, PersonId second) =>
      (personAId == first && personBId == second) ||
      (personAId == second && personBId == first);
}
