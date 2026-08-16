import 'package:drift/native.dart';
import 'package:family_history/core/errors/domain_validation_exception.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/database/database.dart' as db;
import 'package:family_history/database/repositories/drift_person_name_repository.dart';
import 'package:family_history/database/repositories/drift_person_repository.dart';
import 'package:family_history/database/repositories/drift_partnership_repository.dart';
import 'package:family_history/database/repositories/drift_parent_child_relationship_repository.dart';
import 'package:family_history/database/repositories/drift_sibling_relationship_repository.dart';
import 'package:family_history/database/repositories/drift_event_repository.dart';
import 'package:family_history/database/repositories/drift_duplicate_candidate_repository.dart';
import 'package:family_history/domain/duplicate/duplicate_candidate.dart';
import 'package:family_history/domain/event/event.dart';
import 'package:family_history/domain/event/event_participant.dart';
import 'package:family_history/domain/relationship/parent_child_relationship.dart';
import 'package:family_history/domain/relationship/sibling_relationship.dart';
import 'package:family_history/domain/person/person.dart';
import 'package:family_history/domain/person/person_name.dart';
import 'package:family_history/services/person/person_editor_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/domain_factories.dart';

void main() {
  late db.AppDatabase database;
  late DriftPersonRepository people;
  late DriftPersonNameRepository names;
  late DriftPartnershipRepository partnerships;
  late DriftParentChildRelationshipRepository parentChild;
  late DriftSiblingRelationshipRepository siblings;
  late DriftEventRepository events;
  late DriftDuplicateCandidateRepository duplicates;
  late PersonEditorService service;

  setUp(() {
    database = db.AppDatabase(NativeDatabase.memory());
    people = DriftPersonRepository(database);
    names = DriftPersonNameRepository(database);
    partnerships = DriftPartnershipRepository(database);
    parentChild = DriftParentChildRelationshipRepository(database);
    siblings = DriftSiblingRelationshipRepository(database);
    events = DriftEventRepository(database);
    duplicates = DriftDuplicateCandidateRepository(database);
    service = PersonEditorService(database, people, names);
  });

  tearDown(() => database.close());

  Person person(int id) => Person(
    id: personId(id),
    sex: PersonSex.unspecified,
    createdAt: testTimestamp,
    modifiedAt: testTimestamp,
  );

  PersonName name(int id, PersonId owner, String displayName) => PersonName(
    id: PersonNameId(
      '00000000-0000-4000-8000-${id.toString().padLeft(12, '0')}',
    ),
    personId: owner,
    displayName: displayName,
    type: PersonNameType.birth,
    isPreferred: true,
    createdAt: testTimestamp,
    modifiedAt: testTimestamp,
  );

  test('creates a person and preferred name atomically', () async {
    final createdPerson = person(1);
    final invalidName = name(1, personId(99), 'Nom sense persona');

    await expectLater(
      service.create(createdPerson, invalidName),
      throwsA(anything),
    );

    expect(await people.get(createdPerson.id), isNull);
  });

  test(
    'blocks deletion with dependencies and soft-deletes when clear',
    () async {
      final first = person(1);
      final second = person(2);
      await service.create(first, name(1, first.id, 'Primera persona'));
      await service.create(second, name(2, second.id, 'Segona persona'));
      final relationship = partnership(
        id: 1,
        personA: first.id,
        personB: second.id,
      );
      await partnerships.create(relationship);

      final blockers = await service.deletionBlockers(first.id);
      expect(blockers.familyRelationships, 1);
      await expectLater(
        service.delete(first.id),
        throwsA(
          isA<DomainValidationException>().having(
            (error) => error.code,
            'code',
            DomainValidationCode.deletionBlocked,
          ),
        ),
      );

      await partnerships.delete(relationship.id);
      await service.delete(first.id);

      expect(await people.get(first.id), isNull);
      expect(await names.watchForPerson(first.id).first, isEmpty);
    },
  );

  test(
    'cascade-deletes several people and every family relationship',
    () async {
      final first = person(1);
      final second = person(2);
      final survivor = person(3);
      await service.create(first, name(1, first.id, 'Primera persona'));
      await service.create(second, name(2, second.id, 'Segona persona'));
      await service.create(survivor, name(3, survivor.id, 'Supervivent'));
      await parentChild.create(
        ParentChildRelationship(
          id: ParentChildRelationshipId.generate(),
          parentId: survivor.id,
          childId: first.id,
          nature: ParentChildNature.biological,
          createdAt: testTimestamp,
          modifiedAt: testTimestamp,
        ),
      );
      await siblings.create(
        SiblingRelationship(
          id: SiblingRelationshipId.generate(),
          personAId: first.id,
          personBId: second.id,
          kind: SiblingKind.unspecified,
          createdAt: testTimestamp,
          modifiedAt: testTimestamp,
        ),
      );
      await partnerships.create(
        partnership(id: 2, personA: second.id, personB: survivor.id),
      );
      await duplicates.upsert(
        DuplicateCandidate(
          id: DuplicateCandidateId.generate(),
          personAId: first.id,
          personBId: survivor.id,
          score: 70,
          reasonCodes: const ['SAME_NAME'],
          detectorVersion: 1,
          status: DuplicateCandidateStatus.pending,
          lastEvaluatedAt: testTimestamp,
          createdAt: testTimestamp,
          modifiedAt: testTimestamp,
        ),
      );
      final sharedEvent = FamilyEvent(
        id: EventId.generate(),
        type: EventType.custom,
        title: 'Esdeveniment compartit',
        createdAt: testTimestamp,
        modifiedAt: testTimestamp,
      );
      final orphanedEvent = FamilyEvent(
        id: EventId.generate(),
        type: EventType.custom,
        title: 'Esdeveniment individual',
        createdAt: testTimestamp,
        modifiedAt: testTimestamp,
      );
      await events.create(sharedEvent);
      await events.create(orphanedEvent);
      for (final entry in [
        (sharedEvent.id, first.id),
        (sharedEvent.id, survivor.id),
        (orphanedEvent.id, second.id),
      ]) {
        await events.addParticipant(
          EventParticipant(
            id: EventParticipantId.generate(),
            eventId: entry.$1,
            personId: entry.$2,
            role: EventParticipantRole.subject,
            createdAt: testTimestamp,
            modifiedAt: testTimestamp,
          ),
        );
      }

      final result = await service.deleteCascade({first.id, second.id});

      expect(result.people, 2);
      expect(result.names, 2);
      expect(result.familyRelationships, 3);
      expect(result.eventParticipations, 2);
      expect(result.orphanedEvents, 1);
      expect(result.dismissedDuplicateCandidates, 1);
      expect(await people.get(first.id), isNull);
      expect(await people.get(second.id), isNull);
      expect(await people.get(survivor.id), isNotNull);
      expect(await parentChild.watchAll().first, isEmpty);
      expect(await siblings.watchAll().first, isEmpty);
      expect(await partnerships.watchAll().first, isEmpty);
      expect(await events.watchForPerson(survivor.id).first, hasLength(1));
      final activeEvents = await (database.select(
        database.events,
      )..where((row) => row.deletedAt.isNull())).get();
      expect(activeEvents.single.id, sharedEvent.id.value);
      expect(
        (await duplicates.watchAll().first).single.status,
        DuplicateCandidateStatus.dismissed,
      );
    },
  );
}
