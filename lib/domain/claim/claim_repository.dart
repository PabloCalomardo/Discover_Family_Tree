import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/domain/claim/claim.dart';

abstract interface class ClaimRepository {
  Future<Claim?> get(ClaimId id);
  Stream<List<Claim>> watchForSubject(ClaimSubjectType type, String subjectId);
  Stream<List<Claim>> watchAll();
  Stream<List<Claim>> watchForSource(SourceId sourceId);
  Future<void> create(Claim claim);
  Future<void> update(Claim claim);
  Future<void> delete(ClaimId id);
}
