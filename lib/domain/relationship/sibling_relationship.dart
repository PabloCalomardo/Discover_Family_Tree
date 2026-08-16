import 'package:family_history/core/errors/domain_validation_exception.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/core/utils/entity_validation.dart';

enum SiblingKind { unspecified, full, half, adoptive, step }

final class SiblingRelationship {
  SiblingRelationship({
    required this.id,
    required PersonId personAId,
    required PersonId personBId,
    required this.kind,
    required this.createdAt,
    required this.modifiedAt,
    String? notes,
    this.deletedAt,
  }) : personAId = _first(personAId, personBId),
       personBId = _second(personAId, personBId),
       notes = normalizedOptionalText(notes) {
    if (personAId == personBId) {
      throw const DomainValidationException(
        DomainValidationCode.invalidEntity,
        'A person cannot be their own sibling.',
      );
    }
    validateEntityTimestamps(
      createdAt: createdAt,
      modifiedAt: modifiedAt,
      deletedAt: deletedAt,
    );
  }

  final SiblingRelationshipId id;
  final PersonId personAId;
  final PersonId personBId;
  final SiblingKind kind;
  final String? notes;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final DateTime? deletedAt;

  bool get isDeleted => deletedAt != null;
  bool involves(PersonId personId) =>
      personAId == personId || personBId == personId;
  PersonId other(PersonId personId) => personAId == personId
      ? personBId
      : personBId == personId
      ? personAId
      : throw ArgumentError('The person does not belong to this relationship.');

  static PersonId _first(PersonId a, PersonId b) =>
      a.value.compareTo(b.value) <= 0 ? a : b;
  static PersonId _second(PersonId a, PersonId b) =>
      a.value.compareTo(b.value) <= 0 ? b : a;
}
