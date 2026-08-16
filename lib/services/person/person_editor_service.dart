import 'package:drift/drift.dart';
import 'package:family_history/core/errors/domain_validation_exception.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/database/database.dart' as db;
import 'package:family_history/database/mappers/enum_mapping.dart';
import 'package:family_history/domain/duplicate/duplicate_candidate.dart';
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

final class PersonCascadeDeletionResult {
  const PersonCascadeDeletionResult({
    required this.people,
    required this.names,
    required this.familyRelationships,
    required this.residences,
    required this.eventParticipations,
    required this.orphanedEvents,
    required this.dismissedDuplicateCandidates,
  });

  final int people;
  final int names;
  final int familyRelationships;
  final int residences;
  final int eventParticipations;
  final int orphanedEvents;
  final int dismissedDuplicateCandidates;
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
    final siblingRows =
        await (_database.select(_database.siblingRelationships)..where(
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
      familyRelationships:
          parentRows.length + siblingRows.length + partnershipRows.length,
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

  Future<PersonCascadeDeletionResult> deleteCascade(
    Set<PersonId> personIds,
  ) async {
    if (personIds.isEmpty) {
      throw ArgumentError('At least one person must be selected.');
    }
    final ids = personIds.map((id) => id.value).toList(growable: false);
    final now = DateTime.now().toUtc();
    return _database.transaction(() async {
      final activePeople = await (_database.select(
        _database.persons,
      )..where((table) => table.id.isIn(ids) & table.deletedAt.isNull())).get();
      if (activePeople.length != ids.length) {
        throw StateError(
          'Alguna de les persones seleccionades ja no existeix o ha estat eliminada.',
        );
      }

      final affectedEventRows =
          await (_database.select(_database.eventParticipants)..where(
                (table) => table.personId.isIn(ids) & table.deletedAt.isNull(),
              ))
              .get();
      final affectedEventIds = affectedEventRows
          .map((row) => row.eventId)
          .toSet();

      final names =
          await (_database.update(_database.personNames)..where(
                (table) => table.personId.isIn(ids) & table.deletedAt.isNull(),
              ))
              .write(
                db.PersonNamesCompanion(
                  isPreferred: const Value(false),
                  modifiedAt: Value(now),
                  deletedAt: Value(now),
                ),
              );
      final parentChild =
          await (_database.update(_database.parentChildRelationships)..where(
                (table) =>
                    (table.parentPersonId.isIn(ids) |
                        table.childPersonId.isIn(ids)) &
                    table.deletedAt.isNull(),
              ))
              .write(
                db.ParentChildRelationshipsCompanion(
                  modifiedAt: Value(now),
                  deletedAt: Value(now),
                ),
              );
      final siblings =
          await (_database.update(_database.siblingRelationships)..where(
                (table) =>
                    (table.personAId.isIn(ids) | table.personBId.isIn(ids)) &
                    table.deletedAt.isNull(),
              ))
              .write(
                db.SiblingRelationshipsCompanion(
                  modifiedAt: Value(now),
                  deletedAt: Value(now),
                ),
              );
      final partnerships =
          await (_database.update(_database.partnerships)..where(
                (table) =>
                    (table.personAId.isIn(ids) | table.personBId.isIn(ids)) &
                    table.deletedAt.isNull(),
              ))
              .write(
                db.PartnershipsCompanion(
                  modifiedAt: Value(now),
                  deletedAt: Value(now),
                ),
              );
      final residences =
          await (_database.update(_database.residences)..where(
                (table) => table.personId.isIn(ids) & table.deletedAt.isNull(),
              ))
              .write(
                db.ResidencesCompanion(
                  modifiedAt: Value(now),
                  deletedAt: Value(now),
                ),
              );
      final participations =
          await (_database.update(_database.eventParticipants)..where(
                (table) => table.personId.isIn(ids) & table.deletedAt.isNull(),
              ))
              .write(
                db.EventParticipantsCompanion(
                  modifiedAt: Value(now),
                  deletedAt: Value(now),
                ),
              );

      var orphanedEvents = 0;
      for (final eventId in affectedEventIds) {
        final remaining =
            await (_database.select(_database.eventParticipants)
                  ..where(
                    (table) =>
                        table.eventId.equals(eventId) &
                        table.deletedAt.isNull(),
                  )
                  ..limit(1))
                .getSingleOrNull();
        if (remaining != null) continue;
        orphanedEvents +=
            await (_database.update(_database.events)..where(
                  (table) =>
                      table.id.equals(eventId) & table.deletedAt.isNull(),
                ))
                .write(
                  db.EventsCompanion(
                    modifiedAt: Value(now),
                    deletedAt: Value(now),
                  ),
                );
      }

      final people =
          await (_database.update(_database.persons)..where(
                (table) => table.id.isIn(ids) & table.deletedAt.isNull(),
              ))
              .write(
                db.PersonsCompanion(
                  modifiedAt: Value(now),
                  deletedAt: Value(now),
                ),
              );
      final duplicateCandidates =
          await (_database.update(_database.duplicateCandidates)..where(
                (table) =>
                    (table.personAId.isIn(ids) | table.personBId.isIn(ids)) &
                    table.status.isNotValue(
                      enumToSql(DuplicateCandidateStatus.merged),
                    ),
              ))
              .write(
                db.DuplicateCandidatesCompanion(
                  status: Value(enumToSql(DuplicateCandidateStatus.dismissed)),
                  resolvedAt: Value(now),
                  modifiedAt: Value(now),
                ),
              );
      return PersonCascadeDeletionResult(
        people: people,
        names: names,
        familyRelationships: parentChild + siblings + partnerships,
        residences: residences,
        eventParticipations: participations,
        orphanedEvents: orphanedEvents,
        dismissedDuplicateCandidates: duplicateCandidates,
      );
    });
  }
}
