import 'package:drift/drift.dart';
import 'package:family_history/core/errors/domain_validation_exception.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/database/database.dart' as db;
import 'package:family_history/domain/person/person.dart';
import 'package:family_history/domain/person/person_name.dart';
import 'package:family_history/domain/person/person_name_repository.dart';
import 'package:family_history/domain/person/person_repository.dart';

final class PersonDeletionBlockers {
  const PersonDeletionBlockers({
    required this.familyRelationships,
    required this.residences,
    required this.eventParticipations,
  });

  final int familyRelationships;
  final int residences;
  final int eventParticipations;

  bool get canDelete =>
      familyRelationships == 0 && residences == 0 && eventParticipations == 0;
}

final class PersonEditorService {
  PersonEditorService(this._database, this._people, this._names);

  final db.AppDatabase _database;
  final PersonRepository _people;
  final PersonNameRepository _names;

  Future<void> create(Person person, PersonName preferredName) async {
    await _database.transaction(() async {
      await _people.create(person);
      await _names.create(preferredName);
    });
  }

  Future<void> update(Person person, PersonName preferredName) async {
    await _database.transaction(() async {
      await _people.update(person);
      await _names.update(preferredName);
    });
  }

  Future<PersonDeletionBlockers> deletionBlockers(PersonId id) async {
    final parentRows =
        await (_database.select(_database.parentChildRelationships)..where(
              (table) =>
                  (table.parentPersonId.equals(id.value) |
                      table.childPersonId.equals(id.value)) &
                  table.deletedAt.isNull(),
            ))
            .get();
    final partnershipRows =
        await (_database.select(_database.partnerships)..where(
              (table) =>
                  (table.personAId.equals(id.value) |
                      table.personBId.equals(id.value)) &
                  table.deletedAt.isNull(),
            ))
            .get();
    final residenceRows =
        await (_database.select(_database.residences)..where(
              (table) =>
                  table.personId.equals(id.value) & table.deletedAt.isNull(),
            ))
            .get();
    final participationRows =
        await (_database.select(_database.eventParticipants)..where(
              (table) =>
                  table.personId.equals(id.value) & table.deletedAt.isNull(),
            ))
            .get();

    return PersonDeletionBlockers(
      familyRelationships: parentRows.length + partnershipRows.length,
      residences: residenceRows.length,
      eventParticipations: participationRows.length,
    );
  }

  Future<void> delete(PersonId id) async {
    final blockers = await deletionBlockers(id);
    if (!blockers.canDelete) {
      throw const DomainValidationException(
        DomainValidationCode.deletionBlocked,
        'The person still has active dependent records.',
      );
    }

    final now = DateTime.now().toUtc();
    await _database.transaction(() async {
      await (_database.update(_database.personNames)..where(
            (table) =>
                table.personId.equals(id.value) & table.deletedAt.isNull(),
          ))
          .write(
            db.PersonNamesCompanion(
              modifiedAt: Value(now),
              deletedAt: Value(now),
            ),
          );
      await _people.delete(id);
    });
  }
}
