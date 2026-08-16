import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/domain/duplicate/duplicate_candidate.dart';

abstract interface class DuplicateCandidateRepository {
  Stream<List<DuplicateCandidate>> watchAll();
  Future<DuplicateCandidate?> getByPair(PersonId personAId, PersonId personBId);
  Future<void> upsert(DuplicateCandidate candidate);
  Future<void> updateStatus(
    DuplicateCandidateId id,
    DuplicateCandidateStatus status,
  );
}
