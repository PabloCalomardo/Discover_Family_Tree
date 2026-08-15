import 'package:family_history/core/dates/historical_date.dart';
import 'package:family_history/core/errors/domain_validation_exception.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/core/utils/entity_validation.dart';

enum ParentChildNature { biological, adoptive }

final class ParentChildRelationship {
  ParentChildRelationship({
    required this.id,
    required this.parentId,
    required this.childId,
    required this.nature,
    required this.createdAt,
    required this.modifiedAt,
    this.startDate,
    this.endDate,
    String? notes,
    this.deletedAt,
  }) : notes = normalizedOptionalText(notes) {
    if (parentId == childId) {
      throw const DomainValidationException(
        DomainValidationCode.invalidEntity,
        'A person cannot be their own parent.',
      );
    }
    validateEntityTimestamps(
      createdAt: createdAt,
      modifiedAt: modifiedAt,
      deletedAt: deletedAt,
    );
  }

  final ParentChildRelationshipId id;
  final PersonId parentId;
  final PersonId childId;
  final ParentChildNature nature;
  final HistoricalDate? startDate;
  final HistoricalDate? endDate;
  final String? notes;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final DateTime? deletedAt;

  bool get isDeleted => deletedAt != null;
}
