import 'package:family_history/core/errors/domain_validation_exception.dart';
import 'package:family_history/core/ids/domain_id.dart';

enum DuplicateCandidateStatus {
  pending,
  confirmedSame,
  differentPerson,
  dismissed,
  merged,
}

final class DuplicateCandidate {
  DuplicateCandidate({
    required this.id,
    required PersonId personAId,
    required PersonId personBId,
    required this.score,
    required List<String> reasonCodes,
    required this.detectorVersion,
    required this.status,
    required this.lastEvaluatedAt,
    required this.createdAt,
    required this.modifiedAt,
    this.resolvedAt,
    this.mergedIntoPersonId,
  }) : personAId = personAId.value.compareTo(personBId.value) < 0
           ? personAId
           : personBId,
       personBId = personAId.value.compareTo(personBId.value) < 0
           ? personBId
           : personAId,
       reasonCodes = List.unmodifiable(reasonCodes) {
    if (personAId == personBId ||
        score < 0 ||
        score > 100 ||
        detectorVersion < 1) {
      throw const DomainValidationException(
        DomainValidationCode.invalidEntity,
        'Duplicate candidate is invalid.',
      );
    }
  }

  final DuplicateCandidateId id;
  final PersonId personAId;
  final PersonId personBId;
  final int score;
  final List<String> reasonCodes;
  final int detectorVersion;
  final DuplicateCandidateStatus status;
  final DateTime lastEvaluatedAt;
  final DateTime? resolvedAt;
  final PersonId? mergedIntoPersonId;
  final DateTime createdAt;
  final DateTime modifiedAt;
}
