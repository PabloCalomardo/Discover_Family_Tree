import 'package:drift/native.dart';
import 'package:family_history/core/errors/domain_validation_exception.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/database/database.dart' as db;
import 'package:family_history/database/repositories/drift_person_name_repository.dart';
import 'package:family_history/database/repositories/drift_person_repository.dart';
import 'package:family_history/database/repositories/drift_partnership_repository.dart';
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
  late PersonEditorService service;

  setUp(() {
    database = db.AppDatabase(NativeDatabase.memory());
    people = DriftPersonRepository(database);
    names = DriftPersonNameRepository(database);
    partnerships = DriftPartnershipRepository(database);
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
}
