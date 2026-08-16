import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/domain/audit/audit_entry.dart';
import 'package:family_history/domain/duplicate/duplicate_candidate.dart';
import 'package:family_history/domain/duplicate/duplicate_candidate_repository.dart';
import 'package:family_history/domain/person/person_name_repository.dart';
import 'package:family_history/domain/person/person_repository.dart';
import 'package:family_history/domain/relationship/parent_child_relationship_repository.dart';
import 'package:family_history/domain/relationship/partnership_repository.dart';
import 'package:family_history/services/audit/audit_service.dart';
import 'package:family_history/services/duplicate/duplicate_detection_service.dart';
import 'package:family_history/services/merge/person_merge.dart';
import 'package:family_history/services/transaction_runner.dart';

final class ReviewController {
  const ReviewController(
    this._people,
    this._names,
    this._parentChild,
    this._partnerships,
    this._duplicates,
    this._detector,
    this._merge,
    this._audit,
    this._transactions,
  );

  final PersonRepository _people;
  final PersonNameRepository _names;
  final ParentChildRelationshipRepository _parentChild;
  final PartnershipRepository _partnerships;
  final DuplicateCandidateRepository _duplicates;
  final DuplicateDetectionService _detector;
  final PersonMergeService _merge;
  final AuditService _audit;
  final TransactionRunner _transactions;

  Future<int> scanDuplicates() async {
    final people = await _people.watchAll().first;
    final names = await _names.watchAll().first;
    final parentChild = await _parentChild.watchAll().first;
    final partnerships = await _partnerships.watchAll().first;
    final related = <PersonId, Set<PersonId>>{};
    void addRelation(PersonId a, PersonId b) {
      related.putIfAbsent(a, () => <PersonId>{}).add(b);
      related.putIfAbsent(b, () => <PersonId>{}).add(a);
    }

    for (final relation in parentChild) {
      addRelation(relation.parentId, relation.childId);
    }
    for (final partnership in partnerships) {
      addRelation(partnership.personAId, partnership.personBId);
    }
    final matches = _detector.detect(
      people.map(
        (person) => DuplicatePersonRecord(
          person: person,
          names: names.where((name) => name.personId == person.id).toList(),
          relatedPersonIds: related[person.id] ?? const {},
        ),
      ),
    );
    final now = DateTime.now().toUtc();
    for (final match in matches) {
      final existing = await _duplicates.getByPair(
        match.personAId,
        match.personBId,
      );
      if (existing != null) {
        final status = existing.status;
        if (status == DuplicateCandidateStatus.differentPerson ||
            status == DuplicateCandidateStatus.confirmedSame ||
            status == DuplicateCandidateStatus.merged) {
          continue;
        }
        final unchangedDismissal =
            status == DuplicateCandidateStatus.dismissed &&
            existing.detectorVersion ==
                DuplicateDetectionService.detectorVersion &&
            existing.score == match.score &&
            _sameReasons(existing.reasonCodes, match.reasonCodes);
        if (unchangedDismissal) continue;
      }
      await _duplicates.upsert(
        DuplicateCandidate(
          id: existing?.id ?? DuplicateCandidateId.generate(),
          personAId: match.personAId,
          personBId: match.personBId,
          score: match.score,
          reasonCodes: match.reasonCodes,
          detectorVersion: DuplicateDetectionService.detectorVersion,
          status: DuplicateCandidateStatus.pending,
          lastEvaluatedAt: now,
          createdAt: existing?.createdAt ?? now,
          modifiedAt: now,
        ),
      );
    }
    return matches.length;
  }

  bool _sameReasons(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var index = 0; index < a.length; index++) {
      if (a[index] != b[index]) return false;
    }
    return true;
  }

  Future<void> setStatus(
    DuplicateCandidate candidate,
    DuplicateCandidateStatus status,
  ) => _transactions.run(() async {
    await _duplicates.updateStatus(candidate.id, status);
    await _audit.record(
      type: AuditType.duplicateReviewed,
      payload: {'status': status.name, 'score': candidate.score},
      targets: [
        AuditTarget(
          entityType: 'PERSON',
          entityId: candidate.personAId.value,
          role: 'CANDIDATE_A',
        ),
        AuditTarget(
          entityType: 'PERSON',
          entityId: candidate.personBId.value,
          role: 'CANDIDATE_B',
        ),
      ],
    );
  });

  Future<PersonMergePreview> previewMerge(
    PersonId survivor,
    PersonId absorbed,
  ) => _merge.preview(survivor, absorbed);
  Future<void> merge(PersonMergeCommand command) => _merge.merge(command);
}
