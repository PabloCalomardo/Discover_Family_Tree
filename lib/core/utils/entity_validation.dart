import 'package:family_history/core/errors/domain_validation_exception.dart';

void validateEntityTimestamps({
  required DateTime createdAt,
  required DateTime modifiedAt,
  DateTime? deletedAt,
}) {
  if (modifiedAt.isBefore(createdAt)) {
    throw const DomainValidationException(
      DomainValidationCode.invalidEntity,
      'modifiedAt cannot be before createdAt.',
    );
  }
  if (deletedAt != null && deletedAt.isBefore(createdAt)) {
    throw const DomainValidationException(
      DomainValidationCode.invalidEntity,
      'deletedAt cannot be before createdAt.',
    );
  }
}

String? normalizedOptionalText(String? value) {
  final normalized = value?.trim();
  return normalized == null || normalized.isEmpty ? null : normalized;
}
