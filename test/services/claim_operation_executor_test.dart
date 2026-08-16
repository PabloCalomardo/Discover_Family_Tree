import 'package:drift/native.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/database/database.dart' show AppDatabase;
import 'package:family_history/database/drift_transaction_runner.dart';
import 'package:family_history/database/repositories/drift_audit_repository.dart';
import 'package:family_history/database/repositories/drift_claim_operation_executor.dart';
import 'package:family_history/database/repositories/drift_claim_repository.dart';
import 'package:family_history/database/repositories/drift_event_repository.dart';
import 'package:family_history/database/repositories/drift_parent_child_relationship_repository.dart';
import 'package:family_history/database/repositories/drift_partnership_repository.dart';
import 'package:family_history/database/repositories/drift_person_repository.dart';
import 'package:family_history/database/repositories/drift_place_repository.dart';
import 'package:family_history/database/repositories/drift_residence_repository.dart';
import 'package:family_history/domain/audit/audit_entry.dart';
import 'package:family_history/domain/claim/claim.dart';
import 'package:family_history/domain/person/person.dart';
import 'package:family_history/domain/place/place.dart';
import 'package:family_history/domain/relationship/parent_child_relationship.dart';
import 'package:family_history/domain/relationship/partnership.dart';
import 'package:family_history/domain/event/event.dart';
import 'package:family_history/domain/event/event_participant.dart';
import 'package:family_history/services/audit/audit_service.dart';
import 'package:family_history/services/claim/claim_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late DriftClaimRepository claims;
  late DriftPersonRepository people;
  late DriftParentChildRelationshipRepository relationships;
  late ClaimService service;
  final now = DateTime.utc(2026, 8, 16);

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    claims = DriftClaimRepository(database);
    people = DriftPersonRepository(database);
    relationships = DriftParentChildRelationshipRepository(database);
    final places = DriftPlaceRepository(database);
    final partnerships = DriftPartnershipRepository(database);
    final residences = DriftResidenceRepository(database);
    final events = DriftEventRepository(database);
    final audit = DriftAuditRepository(database);
    service = ClaimService(
      claims,
      AuditService(audit),
      DriftTransactionRunner(database),
      DriftClaimOperationExecutor(
        database,
        people,
        places,
        relationships,
        partnerships,
        residences,
        events,
      ),
    );
  });

  tearDown(() => database.close());

  test('accepting a person creation claim materializes it once', () async {
    final personId = PersonId.generate();
    final claim = Claim(
      id: ClaimId.generate(),
      subjectType: ClaimSubjectType.person,
      subjectId: personId.value,
      property: ClaimProperty.personCreation,
      value: PersonCreationClaimValue(
        personId: personId,
        preferredName: 'Maria Puig',
        sex: PersonSex.female,
      ),
      status: ClaimStatus.unreviewed,
      createdAt: now,
      modifiedAt: now,
    );
    await service.create(claim);

    await service.acceptAndApply(claim);
    await service.acceptAndApply(claim);

    expect((await people.watchAll().first).single.id, personId);
    expect(await database.select(database.personNames).get(), hasLength(1));
    expect(
      await database.select(database.claimApplications).get(),
      hasLength(1),
    );
    final stored = await claims.get(claim.id);
    expect(stored?.status, ClaimStatus.accepted);
    final audits = await DriftAuditRepository(database)
        .watchForEntity('CLAIM', claim.id.value)
        .first;
    expect(
      audits.where((entry) => entry.type == AuditType.claimApplied),
      hasLength(1),
    );
  });

  test('accepting a parent-child claim preserves graph validation', () async {
    final parent = PersonId.generate();
    final child = PersonId.generate();
    for (final id in [parent, child]) {
      await people.create(
        Person(id: id, sex: PersonSex.unknown, createdAt: now, modifiedAt: now),
      );
    }
    final relationshipId = ParentChildRelationshipId.generate();
    final claim = Claim(
      id: ClaimId.generate(),
      subjectType: ClaimSubjectType.relationship,
      subjectId: relationshipId.value,
      property: ClaimProperty.parentChildRelationship,
      value: ParentChildClaimValue(
        relationshipId: relationshipId,
        parentId: parent,
        childId: child,
        nature: ParentChildNature.biological,
      ),
      status: ClaimStatus.unreviewed,
      createdAt: now,
      modifiedAt: now,
    );
    await service.create(claim);

    await service.acceptAndApply(claim);

    final stored = (await relationships.watchAll().first).single;
    expect(stored.id, relationshipId);
    expect(stored.parentId, parent);
    expect(stored.childId, child);
  });

  test('materializes place, partnership, residence and event claims', () async {
    final first = PersonId.generate();
    final second = PersonId.generate();
    for (final id in [first, second]) {
      await people.create(
        Person(id: id, sex: PersonSex.unknown, createdAt: now, modifiedAt: now),
      );
    }

    Future<void> apply(
      ClaimSubjectType subjectType,
      String subjectId,
      ClaimProperty property,
      ClaimValue value,
    ) async {
      final claim = Claim(
        id: ClaimId.generate(),
        subjectType: subjectType,
        subjectId: subjectId,
        property: property,
        value: value,
        status: ClaimStatus.unreviewed,
        createdAt: now,
        modifiedAt: now,
      );
      await service.create(claim);
      await service.acceptAndApply(claim);
    }

    final placeId = PlaceId.generate();
    await apply(
      ClaimSubjectType.place,
      placeId.value,
      ClaimProperty.placeCreation,
      PlaceCreationClaimValue(
        placeId: placeId,
        preferredName: 'Barcelona',
        placeType: PlaceType.city,
      ),
    );
    await apply(
      ClaimSubjectType.place,
      placeId.value,
      ClaimProperty.placeCoordinates,
      const CoordinatesClaimValue(latitude: 41.38, longitude: 2.17),
    );

    final partnershipId = PartnershipId.generate();
    await apply(
      ClaimSubjectType.relationship,
      partnershipId.value,
      ClaimProperty.partnership,
      PartnershipClaimValue(
        partnershipId: partnershipId,
        personAId: first,
        personBId: second,
        partnershipType: PartnershipType.marriage,
        placeId: placeId,
      ),
    );
    final residenceId = ResidenceId.generate();
    await apply(
      ClaimSubjectType.residence,
      residenceId.value,
      ClaimProperty.residence,
      ResidenceClaimValue(
        residenceId: residenceId,
        personId: first,
        placeId: placeId,
      ),
    );
    final eventId = EventId.generate();
    await apply(
      ClaimSubjectType.event,
      eventId.value,
      ClaimProperty.event,
      EventClaimValue(
        eventId: eventId,
        eventType: EventType.marriage,
        participantId: first,
        participantRole: EventParticipantRole.subject,
        placeId: placeId,
      ),
    );

    final place = await DriftPlaceRepository(database).get(placeId);
    expect(place?.latitude, 41.38);
    expect(await database.select(database.partnerships).get(), hasLength(1));
    expect(await database.select(database.residences).get(), hasLength(1));
    expect(await database.select(database.events).get(), hasLength(1));
    expect(
      await database.select(database.eventParticipants).get(),
      hasLength(1),
    );
    expect(
      await database.select(database.claimApplications).get(),
      hasLength(5),
    );
  });
}
