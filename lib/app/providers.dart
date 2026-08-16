import 'dart:async';

import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/database/database.dart' as db;
import 'package:family_history/database/drift_transaction_runner.dart';
import 'package:family_history/database/repositories/drift_audit_repository.dart';
import 'package:family_history/database/repositories/drift_claim_repository.dart';
import 'package:family_history/database/repositories/drift_claim_operation_executor.dart';
import 'package:family_history/database/repositories/drift_duplicate_candidate_repository.dart';
import 'package:family_history/database/repositories/drift_event_repository.dart';
import 'package:family_history/database/repositories/drift_parent_child_relationship_repository.dart';
import 'package:family_history/database/repositories/drift_partnership_repository.dart';
import 'package:family_history/database/repositories/drift_person_name_repository.dart';
import 'package:family_history/database/repositories/drift_person_repository.dart';
import 'package:family_history/database/repositories/drift_place_repository.dart';
import 'package:family_history/database/repositories/drift_media_repository.dart';
import 'package:family_history/database/repositories/drift_person_merge_repository.dart';
import 'package:family_history/database/repositories/drift_source_repository.dart';
import 'package:family_history/database/repositories/drift_sibling_relationship_repository.dart';
import 'package:family_history/database/repositories/drift_residence_repository.dart';
import 'package:family_history/domain/event/event.dart';
import 'package:family_history/domain/event/event_repository.dart';
import 'package:family_history/domain/extraction/extraction.dart';
import 'package:family_history/domain/audit/audit_repository.dart';
import 'package:family_history/domain/claim/claim.dart';
import 'package:family_history/domain/claim/claim_repository.dart';
import 'package:family_history/domain/duplicate/duplicate_candidate.dart';
import 'package:family_history/domain/duplicate/duplicate_candidate_repository.dart';
import 'package:family_history/domain/person/person.dart';
import 'package:family_history/domain/person/person_name.dart';
import 'package:family_history/domain/person/person_name_repository.dart';
import 'package:family_history/domain/person/person_repository.dart';
import 'package:family_history/domain/place/place.dart';
import 'package:family_history/domain/place/place_repository.dart';
import 'package:family_history/domain/place/residence.dart';
import 'package:family_history/domain/place/residence_repository.dart';
import 'package:family_history/domain/relationship/parent_child_relationship.dart';
import 'package:family_history/domain/relationship/parent_child_relationship_repository.dart';
import 'package:family_history/domain/relationship/partnership.dart';
import 'package:family_history/domain/relationship/partnership_repository.dart';
import 'package:family_history/domain/relationship/sibling_relationship.dart';
import 'package:family_history/domain/relationship/sibling_relationship_repository.dart';
import 'package:family_history/domain/source/media_asset.dart';
import 'package:family_history/domain/source/source.dart';
import 'package:family_history/domain/source/source_repository.dart';
import 'package:family_history/features/people/people_controller.dart';
import 'package:family_history/features/extraction/text_extraction_controller.dart';
import 'package:family_history/features/places/places_controller.dart';
import 'package:family_history/features/review/review_controller.dart';
import 'package:family_history/features/sources/sources_controller.dart';
import 'package:family_history/services/audit/audit_service.dart';
import 'package:family_history/services/claim/claim_conflict_service.dart';
import 'package:family_history/services/claim/claim_service.dart';
import 'package:family_history/services/duplicate/duplicate_detection_service.dart';
import 'package:family_history/services/event/event_editor_service.dart';
import 'package:family_history/services/extraction/deterministic_extraction_provider.dart';
import 'package:family_history/services/extraction/entity_resolution_service.dart';
import 'package:family_history/services/extraction/extraction_claim_mapper.dart';
import 'package:family_history/services/kinship/kinship_service.dart';
import 'package:family_history/services/person/person_editor_service.dart';
import 'package:family_history/services/merge/person_merge.dart';
import 'package:family_history/services/project/project_workspace_controller.dart';
import 'package:family_history/services/source/source_service.dart';
import 'package:family_history/services/transaction_runner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final projectWorkspaceControllerProvider =
    ChangeNotifierProvider<ProjectWorkspaceController>(
      (ref) => ProjectWorkspaceController.disabled(),
    );

final databaseProvider = Provider<db.AppDatabase>((ref) {
  final projectDatabase = ref
      .watch(projectWorkspaceControllerProvider)
      .database;
  if (projectDatabase != null) return projectDatabase;
  final database = db.AppDatabase.defaults();
  ref.onDispose(() => unawaited(database.close()));
  return database;
});

final personRepositoryProvider = Provider<PersonRepository>(
  (ref) => DriftPersonRepository(ref.watch(databaseProvider)),
);
final personNameRepositoryProvider = Provider<PersonNameRepository>(
  (ref) => DriftPersonNameRepository(ref.watch(databaseProvider)),
);
final parentChildRepositoryProvider =
    Provider<ParentChildRelationshipRepository>(
      (ref) =>
          DriftParentChildRelationshipRepository(ref.watch(databaseProvider)),
    );
final partnershipRepositoryProvider = Provider<PartnershipRepository>(
  (ref) => DriftPartnershipRepository(ref.watch(databaseProvider)),
);
final siblingRepositoryProvider = Provider<SiblingRelationshipRepository>(
  (ref) => DriftSiblingRelationshipRepository(ref.watch(databaseProvider)),
);
final placeRepositoryProvider = Provider<PlaceRepository>(
  (ref) => DriftPlaceRepository(ref.watch(databaseProvider)),
);
final residenceRepositoryProvider = Provider<ResidenceRepository>(
  (ref) => DriftResidenceRepository(ref.watch(databaseProvider)),
);
final eventRepositoryProvider = Provider<EventRepository>(
  (ref) => DriftEventRepository(ref.watch(databaseProvider)),
);
final sourceRepositoryProvider = Provider<SourceRepository>(
  (ref) => DriftSourceRepository(ref.watch(databaseProvider)),
);
final mediaRepositoryProvider = Provider<MediaRepository>(
  (ref) => DriftMediaRepository(ref.watch(databaseProvider)),
);
final claimRepositoryProvider = Provider<ClaimRepository>(
  (ref) => DriftClaimRepository(ref.watch(databaseProvider)),
);
final duplicateCandidateRepositoryProvider =
    Provider<DuplicateCandidateRepository>(
      (ref) => DriftDuplicateCandidateRepository(ref.watch(databaseProvider)),
    );
final auditRepositoryProvider = Provider<AuditRepository>(
  (ref) => DriftAuditRepository(ref.watch(databaseProvider)),
);
final transactionRunnerProvider = Provider<TransactionRunner>(
  (ref) => DriftTransactionRunner(ref.watch(databaseProvider)),
);

final auditServiceProvider = Provider<AuditService>(
  (ref) => AuditService(ref.watch(auditRepositoryProvider)),
);
final claimServiceProvider = Provider<ClaimService>(
  (ref) => ClaimService(
    ref.watch(claimRepositoryProvider),
    ref.watch(auditServiceProvider),
    ref.watch(transactionRunnerProvider),
    DriftClaimOperationExecutor(
      ref.watch(databaseProvider),
      ref.watch(personRepositoryProvider),
      ref.watch(placeRepositoryProvider),
      ref.watch(parentChildRepositoryProvider),
      ref.watch(siblingRepositoryProvider),
      ref.watch(partnershipRepositoryProvider),
      ref.watch(residenceRepositoryProvider),
      ref.watch(eventRepositoryProvider),
    ),
  ),
);
final claimConflictServiceProvider = Provider<ClaimConflictService>(
  (ref) => const ClaimConflictService(),
);
final duplicateDetectionServiceProvider = Provider<DuplicateDetectionService>(
  (ref) => const DuplicateDetectionService(),
);
final personMergeServiceProvider = Provider<PersonMergeService>(
  (ref) => PersonMergeService(
    DriftPersonMergeRepository(
      ref.watch(databaseProvider),
      ref.watch(claimRepositoryProvider),
      ref.watch(auditRepositoryProvider),
    ),
  ),
);
final sourceServiceProvider = Provider<SourceService>(
  (ref) => SourceService(
    ref.watch(sourceRepositoryProvider),
    ref.watch(mediaRepositoryProvider),
    ref.watch(auditServiceProvider),
    ref.watch(transactionRunnerProvider),
  ),
);
final extractionProvider = Provider<ExtractionProvider>(
  (ref) => const DeterministicExtractionProvider(),
);
final entityResolutionServiceProvider = Provider<EntityResolutionService>(
  (ref) => const EntityResolutionService(),
);
final extractionClaimMapperProvider = Provider<ExtractionClaimMapper>(
  (ref) => const ExtractionClaimMapper(),
);
final textExtractionControllerProvider = Provider<TextExtractionController>(
  (ref) => TextExtractionController(
    ref.watch(extractionProvider),
    ref.watch(entityResolutionServiceProvider),
    ref.watch(personNameRepositoryProvider),
    ref.watch(placeRepositoryProvider),
    ref.watch(extractionClaimMapperProvider),
    ref.watch(claimServiceProvider),
  ),
);
final sourcesControllerProvider = Provider<SourcesController>(
  (ref) => SourcesController(ref.watch(sourceServiceProvider)),
);
final reviewControllerProvider = Provider<ReviewController>(
  (ref) => ReviewController(
    ref.watch(personRepositoryProvider),
    ref.watch(personNameRepositoryProvider),
    ref.watch(parentChildRepositoryProvider),
    ref.watch(partnershipRepositoryProvider),
    ref.watch(duplicateCandidateRepositoryProvider),
    ref.watch(duplicateDetectionServiceProvider),
    ref.watch(personMergeServiceProvider),
    ref.watch(auditServiceProvider),
    ref.watch(transactionRunnerProvider),
  ),
);

final personEditorServiceProvider = Provider<PersonEditorService>(
  (ref) => PersonEditorService(
    ref.watch(databaseProvider),
    ref.watch(personRepositoryProvider),
    ref.watch(personNameRepositoryProvider),
  ),
);
final eventEditorServiceProvider = Provider<EventEditorService>(
  (ref) => EventEditorService(
    ref.watch(databaseProvider),
    ref.watch(eventRepositoryProvider),
  ),
);

final peopleControllerProvider = Provider<PeopleController>(
  (ref) => PeopleController(
    ref.watch(personEditorServiceProvider),
    ref.watch(parentChildRepositoryProvider),
    ref.watch(siblingRepositoryProvider),
    ref.watch(partnershipRepositoryProvider),
    ref.watch(residenceRepositoryProvider),
    ref.watch(eventRepositoryProvider),
    ref.watch(eventEditorServiceProvider),
    ref.watch(auditServiceProvider),
    ref.watch(transactionRunnerProvider),
  ),
);
final placesControllerProvider = Provider<PlacesController>(
  (ref) => PlacesController(
    ref.watch(placeRepositoryProvider),
    ref.watch(residenceRepositoryProvider),
    ref.watch(auditServiceProvider),
    ref.watch(transactionRunnerProvider),
  ),
);

final peopleProvider = StreamProvider<List<Person>>(
  (ref) => ref.watch(personRepositoryProvider).watchAll(),
);
final personProvider = FutureProvider.family<Person?, PersonId>(
  (ref, id) => ref.watch(personRepositoryProvider).get(id),
);
final personNamesProvider = StreamProvider.family<List<PersonName>, PersonId>(
  (ref, id) => ref.watch(personNameRepositoryProvider).watchForPerson(id),
);
final allPersonNamesProvider = StreamProvider<List<PersonName>>(
  (ref) => ref.watch(personNameRepositoryProvider).watchAll(),
);
final parentChildRelationshipsProvider =
    StreamProvider<List<ParentChildRelationship>>(
      (ref) => ref.watch(parentChildRepositoryProvider).watchAll(),
    );
final partnershipsProvider = StreamProvider<List<Partnership>>(
  (ref) => ref.watch(partnershipRepositoryProvider).watchAll(),
);
final siblingRelationshipsProvider = StreamProvider<List<SiblingRelationship>>(
  (ref) => ref.watch(siblingRepositoryProvider).watchAll(),
);
final placesProvider = StreamProvider<List<Place>>(
  (ref) => ref.watch(placeRepositoryProvider).watchAll(),
);
final placeProvider = FutureProvider.family<Place?, PlaceId>(
  (ref, id) => ref.watch(placeRepositoryProvider).get(id),
);
final personResidencesProvider =
    StreamProvider.family<List<Residence>, PersonId>(
      (ref, id) => ref.watch(residenceRepositoryProvider).watchForPerson(id),
    );
final placeResidencesProvider = StreamProvider.family<List<Residence>, PlaceId>(
  (ref, id) => ref.watch(residenceRepositoryProvider).watchResidentsAtPlace(id),
);
final personEventsProvider = StreamProvider.family<List<FamilyEvent>, PersonId>(
  (ref, id) => ref.watch(eventRepositoryProvider).watchForPerson(id),
);
final kinshipServiceProvider = Provider<KinshipService>(
  (ref) => const KinshipService(),
);

final sourcesProvider = StreamProvider<List<Source>>(
  (ref) => ref.watch(sourceRepositoryProvider).watchAll(),
);
final sourceProvider = FutureProvider.family<Source?, SourceId>(
  (ref, id) => ref.watch(sourceRepositoryProvider).get(id),
);
final sourceMediaProvider = StreamProvider.family<List<MediaAsset>, SourceId>(
  (ref, id) => ref.watch(mediaRepositoryProvider).watchForSource(id),
);
final claimsProvider = StreamProvider<List<Claim>>(
  (ref) => ref.watch(claimRepositoryProvider).watchAll(),
);
final subjectClaimsProvider =
    StreamProvider.family<List<Claim>, (ClaimSubjectType, String)>(
      (ref, subject) => ref
          .watch(claimRepositoryProvider)
          .watchForSubject(subject.$1, subject.$2),
    );
final sourceClaimsProvider = StreamProvider.family<List<Claim>, SourceId>(
  (ref, id) => ref.watch(claimRepositoryProvider).watchForSource(id),
);
final claimConflictsProvider = Provider<AsyncValue<List<ClaimConflict>>>((ref) {
  final claims = ref.watch(claimsProvider);
  return claims.whenData(ref.watch(claimConflictServiceProvider).detect);
});
final duplicateCandidatesProvider = StreamProvider<List<DuplicateCandidate>>(
  (ref) => ref.watch(duplicateCandidateRepositoryProvider).watchAll(),
);
final mergePreviewProvider =
    FutureProvider.family<PersonMergePreview, (PersonId, PersonId)>(
      (ref, pair) =>
          ref.watch(reviewControllerProvider).previewMerge(pair.$1, pair.$2),
    );
