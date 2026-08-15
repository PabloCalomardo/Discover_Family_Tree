import 'package:family_history/core/errors/domain_validation_exception.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/core/utils/entity_validation.dart';

enum PersonNameType { birth, married, alias, nickname, other }

final class PersonName {
  PersonName({
    required this.id,
    required this.personId,
    required String displayName,
    required this.type,
    required this.createdAt,
    required this.modifiedAt,
    String? givenNames,
    String? familyNames,
    this.isPreferred = false,
    this.deletedAt,
  }) : displayName = displayName.trim(),
       givenNames = normalizedOptionalText(givenNames),
       familyNames = normalizedOptionalText(familyNames) {
    if (this.displayName.isEmpty) {
      throw const DomainValidationException(
        DomainValidationCode.invalidEntity,
        'A person name must have a display name.',
      );
    }
    validateEntityTimestamps(
      createdAt: createdAt,
      modifiedAt: modifiedAt,
      deletedAt: deletedAt,
    );
  }

  final PersonNameId id;
  final PersonId personId;
  final String? givenNames;
  final String? familyNames;
  final String displayName;
  final PersonNameType type;
  final bool isPreferred;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final DateTime? deletedAt;

  bool get isDeleted => deletedAt != null;
}
