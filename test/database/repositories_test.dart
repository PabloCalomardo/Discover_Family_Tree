import 'package:drift/native.dart';
import 'package:family_history/core/dates/historical_date.dart';
import 'package:family_history/core/dates/historical_period.dart';
import 'package:family_history/core/errors/domain_validation_exception.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/database/database.dart' as db;
import 'package:family_history/database/repositories/drift_event_repository.dart';
import 'package:family_history/database/repositories/drift_parent_child_relationship_repository.dart';
import 'package:family_history/database/repositories/drift_partnership_repository.dart';
import 'package:family_history/database/repositories/drift_person_repository.dart';
import 'package:family_history/database/repositories/drift_person_name_repository.dart';
import 'package:family_history/database/repositories/drift_place_relationship_repository.dart';
import 'package:family_history/database/repositories/drift_place_repository.dart';
import 'package:family_history/database/repositories/drift_residence_repository.dart';
import 'package:family_history/domain/event/event.dart';
import 'package:family_history/domain/event/event_participant.dart';
import 'package:family_history/domain/person/person.dart';
import 'package:family_history/domain/person/person_name.dart';
import 'package:family_history/domain/place/place_relationship.dart';
import 'package:family_history/domain/place/residence.dart';
import 'package:family_history/domain/relationship/parent_child_relationship.dart';
import 'package:family_history/domain/relationship/partnership.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/domain_factories.dart';

void main() {
  late db.AppDatabase database;
  late DriftPersonRepository personRepository;
  late DriftPlaceRepository placeRepository;
  late DriftResidenceRepository residenceRepository;
  late DriftEventRepository eventRepository;

  setUp(() {
    database = db.AppDatabase(NativeDatabase.memory());
    personRepository = DriftPersonRepository(database);
    placeRepository = DriftPlaceRepository(database);
    residenceRepository = DriftResidenceRepository(database);
    eventRepository = DriftEventRepository(database);
  });

  tearDown(() => database.close());

  Future<Person> createPerson(int id) async {
    final person = Person(
      id: personId(id),
      sex: PersonSex.unspecified,
      birthDate: HistoricalDate.year(1912),
      createdAt: testTimestamp,
      modifiedAt: testTimestamp,
    );
    await personRepository.create(person);
    return person;
  }

  test('round-trips person historical dates through schema v2', () async {
    final person = await createPerson(1);

    final stored = await personRepository.get(person.id);

    expect(stored, isNotNull);
    expect(stored!.birthDate, HistoricalDate.year(1912));
  });

  test('queries possible residents by place and period', () async {
    final person = await createPerson(1);
    final home = place(id: 1, name: 'Mas Puig');
    await placeRepository.create(home);

    final oldResidence = Residence(
      id: ResidenceId('00000000-0000-4000-8000-000000000201'),
      personId: person.id,
      placeId: home.id,
      startDate: HistoricalDate.year(1900),
      endDate: HistoricalDate.year(1910),
      createdAt: testTimestamp,
      modifiedAt: testTimestamp,
    );
    final overlappingResidence = Residence(
      id: ResidenceId('00000000-0000-4000-8000-000000000202'),
      personId: person.id,
      placeId: home.id,
      startDate: HistoricalDate.year(1925),
      endDate: HistoricalDate.unknown(),
      createdAt: testTimestamp,
      modifiedAt: testTimestamp,
    );
    await residenceRepository.create(oldResidence);
    await residenceRepository.create(overlappingResidence);

    final results = await residenceRepository
        .watchResidentsAtPlace(
          home.id,
          period: HistoricalPeriod(
            start: DateTime.utc(1920),
            end: DateTime.utc(1930),
          ),
        )
        .first;

    expect(results.map((residence) => residence.id), [overlappingResidence.id]);
  });

  test(
    'queries events for a person chronologically with unknown dates last',
    () async {
      final person = await createPerson(1);
      final datedEvent = FamilyEvent(
        id: eventId(1),
        type: EventType.birth,
        date: HistoricalDate.year(1912),
        createdAt: testTimestamp,
        modifiedAt: testTimestamp,
      );
      final unknownEvent = FamilyEvent(
        id: eventId(2),
        type: EventType.custom,
        date: HistoricalDate.unknown(),
        title: 'Data desconeguda',
        createdAt: testTimestamp,
        modifiedAt: testTimestamp,
      );
      await eventRepository.create(unknownEvent);
      await eventRepository.create(datedEvent);
      await eventRepository.addParticipant(
        EventParticipant(
          id: EventParticipantId('00000000-0000-4000-8000-000000000211'),
          eventId: unknownEvent.id,
          personId: person.id,
          role: EventParticipantRole.subject,
          createdAt: testTimestamp,
          modifiedAt: testTimestamp,
        ),
      );
      await eventRepository.addParticipant(
        EventParticipant(
          id: EventParticipantId('00000000-0000-4000-8000-000000000212'),
          eventId: datedEvent.id,
          personId: person.id,
          role: EventParticipantRole.subject,
          createdAt: testTimestamp,
          modifiedAt: testTimestamp,
        ),
      );

      final results = await eventRepository.watchForPerson(person.id).first;

      expect(results.map((event) => event.id), [
        datedEvent.id,
        unknownEvent.id,
      ]);
    },
  );

  test('repository rejects inverse duplicate SAME_AS relationships', () async {
    final firstPlace = place(id: 1, name: 'Casa Nova');
    final secondPlace = place(id: 2, name: 'Can Nou');
    await placeRepository.create(firstPlace);
    await placeRepository.create(secondPlace);
    final repository = DriftPlaceRelationshipRepository(database);

    await repository.create(
      PlaceRelationship(
        id: PlaceRelationshipId('00000000-0000-4000-8000-000000000221'),
        sourcePlaceId: firstPlace.id,
        targetPlaceId: secondPlace.id,
        type: PlaceRelationshipType.sameAs,
        createdAt: testTimestamp,
        modifiedAt: testTimestamp,
      ),
    );

    expect(
      () => repository.create(
        PlaceRelationship(
          id: PlaceRelationshipId('00000000-0000-4000-8000-000000000222'),
          sourcePlaceId: secondPlace.id,
          targetPlaceId: firstPlace.id,
          type: PlaceRelationshipType.sameAs,
          createdAt: testTimestamp,
          modifiedAt: testTimestamp,
        ),
      ),
      throwsA(isA<DomainValidationException>()),
    );
  });

  test(
    'persists names, parentage and partnerships through repositories',
    () async {
      final first = await createPerson(1);
      final second = await createPerson(2);
      final child = await createPerson(3);
      final home = place(id: 1, name: 'Mas Puig');
      await placeRepository.create(home);

      final nameRepository = DriftPersonNameRepository(database);
      await nameRepository.create(
        PersonName(
          id: PersonNameId('00000000-0000-4000-8000-000000000231'),
          personId: first.id,
          displayName: 'Pere Puig',
          type: PersonNameType.birth,
          isPreferred: true,
          createdAt: testTimestamp,
          modifiedAt: testTimestamp,
        ),
      );

      final parentRepository = DriftParentChildRelationshipRepository(database);
      await parentRepository.create(
        relationship(id: 232, parent: first.id, child: child.id),
      );

      final partnershipRepository = DriftPartnershipRepository(database);
      await partnershipRepository.create(
        Partnership(
          id: PartnershipId('00000000-0000-4000-8000-000000000233'),
          personAId: first.id,
          personBId: second.id,
          type: PartnershipType.marriage,
          placeId: home.id,
          createdAt: testTimestamp,
          modifiedAt: testTimestamp,
        ),
      );

      expect(
        (await nameRepository.watchForPerson(first.id).first)
            .single
            .displayName,
        'Pere Puig',
      );
      expect(
        (await parentRepository.watchAll().first).single.childId,
        child.id,
      );
      expect(
        (await partnershipRepository.watchAll().first).single.placeId,
        home.id,
      );
    },
  );

  test('parent repository rejects a persisted mixed parentage cycle', () async {
    final first = await createPerson(1);
    final second = await createPerson(2);
    final third = await createPerson(3);
    final repository = DriftParentChildRelationshipRepository(database);
    await repository.create(
      relationship(id: 241, parent: first.id, child: second.id),
    );
    await repository.create(
      relationship(
        id: 242,
        parent: second.id,
        child: third.id,
        nature: ParentChildNature.adoptive,
      ),
    );

    expect(
      () => repository.create(
        relationship(id: 243, parent: third.id, child: first.id),
      ),
      throwsA(isA<DomainValidationException>()),
    );
  });
}
