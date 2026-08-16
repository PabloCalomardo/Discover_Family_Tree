import 'package:drift/native.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/database/database.dart' show AppDatabase;
import 'package:family_history/database/repositories/drift_audit_repository.dart';
import 'package:family_history/database/repositories/drift_claim_repository.dart';
import 'package:family_history/database/repositories/drift_event_repository.dart';
import 'package:family_history/database/repositories/drift_parent_child_relationship_repository.dart';
import 'package:family_history/database/repositories/drift_person_merge_repository.dart';
import 'package:family_history/database/repositories/drift_person_name_repository.dart';
import 'package:family_history/database/repositories/drift_person_repository.dart';
import 'package:family_history/database/repositories/drift_place_repository.dart';
import 'package:family_history/database/repositories/drift_residence_repository.dart';
import 'package:family_history/database/repositories/drift_sibling_relationship_repository.dart';
import 'package:family_history/domain/claim/claim.dart';
import 'package:family_history/domain/event/event.dart';
import 'package:family_history/domain/event/event_participant.dart';
import 'package:family_history/domain/person/person.dart';
import 'package:family_history/domain/person/person_name.dart';
import 'package:family_history/domain/place/place.dart';
import 'package:family_history/domain/place/residence.dart';
import 'package:family_history/domain/relationship/parent_child_relationship.dart';
import 'package:family_history/domain/relationship/sibling_relationship.dart';
import 'package:family_history/services/merge/person_merge.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late DriftPersonRepository people;
  late DriftPersonNameRepository names;
  late DriftParentChildRelationshipRepository relationships;
  late DriftSiblingRelationshipRepository siblings;
  late DriftClaimRepository claims;
  late DriftAuditRepository audit;
  late DriftPersonMergeRepository merges;
  final now = DateTime.utc(2026, 8, 16);

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    people = DriftPersonRepository(database);
    names = DriftPersonNameRepository(database);
    relationships = DriftParentChildRelationshipRepository(database);
    siblings = DriftSiblingRelationshipRepository(database);
    claims = DriftClaimRepository(database);
    audit = DriftAuditRepository(database);
    merges = DriftPersonMergeRepository(database, claims, audit);
  });
  tearDown(() => database.close());

  Future<(Person, Person, PersonName, PersonName)> seed() async {
    final survivor = Person(
      id: PersonId.generate(),
      sex: PersonSex.male,
      biography: 'Biografia A',
      createdAt: now,
      modifiedAt: now,
    );
    final absorbed = Person(
      id: PersonId.generate(),
      sex: PersonSex.unknown,
      biography: 'Biografia B',
      createdAt: now,
      modifiedAt: now,
    );
    await people.create(survivor);
    await people.create(absorbed);
    final nameA = PersonName(
      id: PersonNameId.generate(),
      personId: survivor.id,
      displayName: 'Joan Puig',
      type: PersonNameType.birth,
      isPreferred: true,
      createdAt: now,
      modifiedAt: now,
    );
    final nameB = PersonName(
      id: PersonNameId.generate(),
      personId: absorbed.id,
      displayName: 'Joan Pujol',
      type: PersonNameType.alias,
      isPreferred: true,
      createdAt: now,
      modifiedAt: now,
    );
    await names.create(nameA);
    await names.create(nameB);
    return (survivor, absorbed, nameA, nameB);
  }

  test(
    'merge keeps names and converts discarded scalar value into claim',
    () async {
      final seeded = await seed();
      final survivor = seeded.$1;
      final absorbed = seeded.$2;
      final merged = Person(
        id: survivor.id,
        sex: survivor.sex,
        biography: survivor.biography,
        createdAt: survivor.createdAt,
        modifiedAt: now.add(const Duration(minutes: 1)),
      );
      await merges.execute(
        PersonMergeCommand(
          mergedPerson: merged,
          absorbedId: absorbed.id,
          expectedSurvivorModifiedAt: survivor.modifiedAt,
          expectedAbsorbedModifiedAt: absorbed.modifiedAt,
          preferredNameId: seeded.$3.id,
          relationsToConvertToClaims: const {},
        ),
      );

      expect(await people.get(absorbed.id), isNull);
      expect(await names.watchForPerson(survivor.id).first, hasLength(2));
      final storedClaims = await claims
          .watchForSubject(ClaimSubjectType.person, survivor.id.value)
          .first;
      expect(
        storedClaims.where(
          (claim) => claim.property == ClaimProperty.personBiography,
        ),
        isNotEmpty,
      );
      expect(
        await audit.watchForEntity('PERSON', survivor.id.value).first,
        hasLength(1),
      );
    },
  );

  test('preview blocks a relationship between merged people', () async {
    final seeded = await seed();
    final relation = ParentChildRelationship(
      id: ParentChildRelationshipId.generate(),
      parentId: seeded.$1.id,
      childId: seeded.$2.id,
      nature: ParentChildNature.biological,
      createdAt: now,
      modifiedAt: now,
    );
    await relationships.create(relation);
    final preview = await merges.preview(seeded.$1.id, seeded.$2.id);
    expect(
      preview.blockingRelations.map((item) => item.id),
      contains(relation.id.value),
    );
  });

  test('explicitly converts a blocking relationship into a claim', () async {
    final seeded = await seed();
    final survivor = seeded.$1;
    final absorbed = seeded.$2;
    final relation = ParentChildRelationship(
      id: ParentChildRelationshipId.generate(),
      parentId: survivor.id,
      childId: absorbed.id,
      nature: ParentChildNature.biological,
      createdAt: now,
      modifiedAt: now,
    );
    await relationships.create(relation);
    await merges.execute(
      PersonMergeCommand(
        mergedPerson: Person(
          id: survivor.id,
          sex: survivor.sex,
          biography: survivor.biography,
          createdAt: survivor.createdAt,
          modifiedAt: now.add(const Duration(minutes: 1)),
        ),
        absorbedId: absorbed.id,
        expectedSurvivorModifiedAt: survivor.modifiedAt,
        expectedAbsorbedModifiedAt: absorbed.modifiedAt,
        preferredNameId: seeded.$3.id,
        relationsToConvertToClaims: {relation.id.value},
      ),
    );

    expect(await relationships.watchAll().first, isEmpty);
    final storedClaims = await claims
        .watchForSubject(ClaimSubjectType.person, survivor.id.value)
        .first;
    expect(
      storedClaims.where(
        (claim) => claim.property == ClaimProperty.parentChildRelationship,
      ),
      isNotEmpty,
    );
  });

  test('reassigns non-conflicting parent-child relationships', () async {
    final seeded = await seed();
    final survivor = seeded.$1;
    final absorbed = seeded.$2;
    final child = Person(
      id: PersonId.generate(),
      sex: PersonSex.unknown,
      createdAt: now,
      modifiedAt: now,
    );
    await people.create(child);
    final relation = ParentChildRelationship(
      id: ParentChildRelationshipId.generate(),
      parentId: absorbed.id,
      childId: child.id,
      nature: ParentChildNature.biological,
      createdAt: now,
      modifiedAt: now,
    );
    await relationships.create(relation);
    await merges.execute(
      PersonMergeCommand(
        mergedPerson: Person(
          id: survivor.id,
          sex: survivor.sex,
          biography: survivor.biography,
          createdAt: survivor.createdAt,
          modifiedAt: now.add(const Duration(minutes: 1)),
        ),
        absorbedId: absorbed.id,
        expectedSurvivorModifiedAt: survivor.modifiedAt,
        expectedAbsorbedModifiedAt: absorbed.modifiedAt,
        preferredNameId: seeded.$3.id,
        relationsToConvertToClaims: const {},
      ),
    );
    final stored = await relationships.watchAll().first;
    expect(stored, hasLength(1));
    expect(stored.single.parentId, survivor.id);
    expect(stored.single.childId, child.id);
  });

  test('reassigns residences and event participations', () async {
    final seeded = await seed();
    final survivor = seeded.$1;
    final absorbed = seeded.$2;
    final places = DriftPlaceRepository(database);
    final residences = DriftResidenceRepository(database);
    final events = DriftEventRepository(database);
    final place = Place(
      id: PlaceId.generate(),
      preferredName: 'Mas Puig',
      type: PlaceType.farmhouse,
      createdAt: now,
      modifiedAt: now,
    );
    await places.create(place);
    await residences.create(
      Residence(
        id: ResidenceId.generate(),
        personId: absorbed.id,
        placeId: place.id,
        createdAt: now,
        modifiedAt: now,
      ),
    );
    final event = FamilyEvent(
      id: EventId.generate(),
      type: EventType.employment,
      createdAt: now,
      modifiedAt: now,
    );
    await events.create(event);
    await events.addParticipant(
      EventParticipant(
        id: EventParticipantId.generate(),
        eventId: event.id,
        personId: absorbed.id,
        role: EventParticipantRole.subject,
        createdAt: now,
        modifiedAt: now,
      ),
    );

    await merges.execute(
      PersonMergeCommand(
        mergedPerson: Person(
          id: survivor.id,
          sex: survivor.sex,
          biography: survivor.biography,
          createdAt: survivor.createdAt,
          modifiedAt: now.add(const Duration(minutes: 1)),
        ),
        absorbedId: absorbed.id,
        expectedSurvivorModifiedAt: survivor.modifiedAt,
        expectedAbsorbedModifiedAt: absorbed.modifiedAt,
        preferredNameId: seeded.$3.id,
        relationsToConvertToClaims: const {},
      ),
    );

    expect(await residences.watchForPerson(survivor.id).first, hasLength(1));
    expect(await events.watchForPerson(survivor.id).first, hasLength(1));
  });

  test('rewires explicit siblinghood without creating a parent', () async {
    final seeded = await seed();
    final survivor = seeded.$1;
    final absorbed = seeded.$2;
    final sibling = Person(
      id: PersonId.generate(),
      sex: PersonSex.unknown,
      createdAt: now,
      modifiedAt: now,
    );
    await people.create(sibling);
    await siblings.create(
      SiblingRelationship(
        id: SiblingRelationshipId.generate(),
        personAId: absorbed.id,
        personBId: sibling.id,
        kind: SiblingKind.unspecified,
        createdAt: now,
        modifiedAt: now,
      ),
    );

    await merges.execute(
      PersonMergeCommand(
        mergedPerson: Person(
          id: survivor.id,
          sex: survivor.sex,
          biography: survivor.biography,
          createdAt: survivor.createdAt,
          modifiedAt: now.add(const Duration(minutes: 1)),
        ),
        absorbedId: absorbed.id,
        expectedSurvivorModifiedAt: survivor.modifiedAt,
        expectedAbsorbedModifiedAt: absorbed.modifiedAt,
        preferredNameId: seeded.$3.id,
        relationsToConvertToClaims: const {},
      ),
    );

    final stored = (await siblings.watchAll().first).single;
    expect(stored.involves(survivor.id), isTrue);
    expect(stored.involves(sibling.id), isTrue);
    expect(await relationships.watchAll().first, isEmpty);
  });

  test('preview blocks a sibling relation between merged people', () async {
    final seeded = await seed();
    final relation = SiblingRelationship(
      id: SiblingRelationshipId.generate(),
      personAId: seeded.$1.id,
      personBId: seeded.$2.id,
      kind: SiblingKind.unspecified,
      createdAt: now,
      modifiedAt: now,
    );
    await siblings.create(relation);

    final preview = await merges.preview(seeded.$1.id, seeded.$2.id);

    expect(
      preview.blockingRelations.single,
      isA<MergeBlockingRelation>()
          .having((item) => item.id, 'id', relation.id.value)
          .having((item) => item.kind, 'kind', 'SIBLING_RELATIONSHIP'),
    );
  });
}
