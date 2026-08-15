enum DomainValidationCode {
  invalidUuid,
  invalidHistoricalDate,
  invalidEntity,
  duplicateRelationship,
  parentageCycle,
  duplicatePlaceRelationship,
  placeHierarchyCycle,
  deletionBlocked,
}

final class DomainValidationException implements Exception {
  const DomainValidationException(this.code, this.message);

  final DomainValidationCode code;
  final String message;

  @override
  String toString() => 'DomainValidationException($code): $message';
}
