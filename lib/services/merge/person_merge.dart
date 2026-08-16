import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/domain/person/person.dart';

final class MergeBlockingRelation {
  const MergeBlockingRelation({
    required this.id,
    required this.kind,
    required this.reason,
  });
  final String id;
  final String kind;
  final String reason;
}

final class PersonMergePreview {
  const PersonMergePreview({
    required this.survivorId,
    required this.absorbedId,
    required this.blockingRelations,
    required this.reassignedNames,
    required this.reassignedResidences,
    required this.reassignedEvents,
  });
  final PersonId survivorId;
  final PersonId absorbedId;
  final List<MergeBlockingRelation> blockingRelations;
  final int reassignedNames;
  final int reassignedResidences;
  final int reassignedEvents;
}

final class PersonMergeCommand {
  const PersonMergeCommand({
    required this.mergedPerson,
    required this.absorbedId,
    required this.expectedSurvivorModifiedAt,
    required this.expectedAbsorbedModifiedAt,
    required this.preferredNameId,
    required this.relationsToConvertToClaims,
  });
  final Person mergedPerson;
  final PersonId absorbedId;
  final DateTime expectedSurvivorModifiedAt;
  final DateTime expectedAbsorbedModifiedAt;
  final PersonNameId preferredNameId;
  final Set<String> relationsToConvertToClaims;
}

abstract interface class PersonMergeRepository {
  Future<PersonMergePreview> preview(PersonId survivorId, PersonId absorbedId);
  Future<void> execute(PersonMergeCommand command);
}

final class PersonMergeService {
  const PersonMergeService(this._repository);
  final PersonMergeRepository _repository;

  Future<PersonMergePreview> preview(
    PersonId survivorId,
    PersonId absorbedId,
  ) => _repository.preview(survivorId, absorbedId);

  Future<void> merge(PersonMergeCommand command) =>
      _repository.execute(command);
}
