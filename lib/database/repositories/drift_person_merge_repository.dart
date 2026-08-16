import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/database/database.dart' as db;
import 'package:family_history/database/mappers/enum_mapping.dart';
import 'package:family_history/database/mappers/historical_date_mapper.dart';
import 'package:family_history/domain/audit/audit_entry.dart';
import 'package:family_history/domain/claim/claim.dart';
import 'package:family_history/domain/claim/claim_repository.dart';
import 'package:family_history/domain/person/person.dart';
import 'package:family_history/domain/duplicate/duplicate_candidate.dart';
import 'package:family_history/domain/audit/audit_repository.dart';
import 'package:family_history/services/merge/person_merge.dart';

final class DriftPersonMergeRepository implements PersonMergeRepository {
  const DriftPersonMergeRepository(this._database, this._claims, this._audit);
  final db.AppDatabase _database;
  final ClaimRepository _claims;
  final AuditRepository _audit;

  @override
  Future<PersonMergePreview> preview(
    PersonId survivorId,
    PersonId absorbedId,
  ) async {
    if (survivorId == absorbedId) {
      throw ArgumentError('A person cannot be merged with itself.');
    }
    final parentRows = await (_database.select(
      _database.parentChildRelationships,
    )..where((row) => row.deletedAt.isNull())).get();
    final partnershipRows = await (_database.select(
      _database.partnerships,
    )..where((row) => row.deletedAt.isNull())).get();
    final blockers = <MergeBlockingRelation>[];

    for (final row in parentRows.where(
      (row) =>
          row.parentPersonId == absorbedId.value ||
          row.childPersonId == absorbedId.value,
    )) {
      final parent = _replace(row.parentPersonId, absorbedId, survivorId);
      final child = _replace(row.childPersonId, absorbedId, survivorId);
      if (parent == child) {
        blockers.add(
          MergeBlockingRelation(
            id: row.id,
            kind: 'PARENT_CHILD',
            reason: 'La fusió convertiria la relació en una autorelació.',
          ),
        );
      } else if (_hasPath(
        child,
        parent,
        parentRows
            .where((other) => other.id != row.id)
            .map(
              (other) => (
                _replace(other.parentPersonId, absorbedId, survivorId),
                _replace(other.childPersonId, absorbedId, survivorId),
              ),
            ),
      )) {
        blockers.add(
          MergeBlockingRelation(
            id: row.id,
            kind: 'PARENT_CHILD',
            reason: 'La fusió crearia un cicle de parentatge.',
          ),
        );
      }
    }
    for (final row in partnershipRows.where(
      (row) =>
          row.personAId == absorbedId.value ||
          row.personBId == absorbedId.value,
    )) {
      final a = _replace(row.personAId, absorbedId, survivorId);
      final b = _replace(row.personBId, absorbedId, survivorId);
      if (a == b) {
        blockers.add(
          MergeBlockingRelation(
            id: row.id,
            kind: 'PARTNERSHIP',
            reason: 'La fusió convertiria la parella en una autorelació.',
          ),
        );
      }
    }

    final names =
        await (_database.select(_database.personNames)..where(
              (row) =>
                  row.personId.equals(absorbedId.value) &
                  row.deletedAt.isNull(),
            ))
            .get();
    final residences =
        await (_database.select(_database.residences)..where(
              (row) =>
                  row.personId.equals(absorbedId.value) &
                  row.deletedAt.isNull(),
            ))
            .get();
    final events =
        await (_database.select(_database.eventParticipants)..where(
              (row) =>
                  row.personId.equals(absorbedId.value) &
                  row.deletedAt.isNull(),
            ))
            .get();
    return PersonMergePreview(
      survivorId: survivorId,
      absorbedId: absorbedId,
      blockingRelations: List.unmodifiable(blockers),
      reassignedNames: names.length,
      reassignedResidences: residences.length,
      reassignedEvents: events.length,
    );
  }

  @override
  Future<void> execute(PersonMergeCommand command) async {
    final preview = await this.preview(
      command.mergedPerson.id,
      command.absorbedId,
    );
    final unresolved = preview.blockingRelations.where(
      (item) => !command.relationsToConvertToClaims.contains(item.id),
    );
    if (unresolved.isNotEmpty) {
      throw StateError('El merge conté relacions bloquejants no resoltes.');
    }
    await _database.transaction(() async {
      final survivor = await _activePerson(command.mergedPerson.id);
      final absorbed = await _activePerson(command.absorbedId);
      if (!survivor.modifiedAt.isAtSameMomentAs(
            command.expectedSurvivorModifiedAt,
          ) ||
          !absorbed.modifiedAt.isAtSameMomentAs(
            command.expectedAbsorbedModifiedAt,
          )) {
        throw StateError(
          'Les persones han canviat després de la previsualització.',
        );
      }
      final now = DateTime.now().toUtc();
      await _createDiscardedValueClaims(
        survivor,
        absorbed,
        command.mergedPerson,
        now,
      );

      await (_database.update(_database.personNames)..where(
            (row) =>
                (row.personId.equals(command.mergedPerson.id.value) |
                    row.personId.equals(command.absorbedId.value)) &
                row.deletedAt.isNull(),
          ))
          .write(const db.PersonNamesCompanion(isPreferred: Value(false)));
      await (_database.update(_database.personNames)..where(
            (row) =>
                row.personId.equals(command.absorbedId.value) &
                row.deletedAt.isNull(),
          ))
          .write(
            db.PersonNamesCompanion(
              personId: Value(command.mergedPerson.id.value),
              modifiedAt: Value(now),
            ),
          );
      final preferredUpdated =
          await (_database.update(_database.personNames)..where(
                (row) =>
                    row.id.equals(command.preferredNameId.value) &
                    row.personId.equals(command.mergedPerson.id.value) &
                    row.deletedAt.isNull(),
              ))
              .write(
                db.PersonNamesCompanion(
                  isPreferred: const Value(true),
                  modifiedAt: Value(now),
                ),
              );
      if (preferredUpdated != 1) {
        throw StateError('El nom preferit no és vàlid.');
      }

      final converted = <String>[];
      await _rewireParentChild(command, now, converted);
      await _rewirePartnerships(command, now, converted);
      await _rewireSimpleReferences(command, now);
      await _rewireClaims(command);
      final duplicateRowsRemoved = await _rewireDuplicateCandidates(
        command,
        now,
      );

      await _database
          .update(_database.persons)
          .replace(_personCompanion(command.mergedPerson, modifiedAt: now));
      await (_database.update(
        _database.persons,
      )..where((row) => row.id.equals(command.absorbedId.value))).write(
        db.PersonsCompanion(modifiedAt: Value(now), deletedAt: Value(now)),
      );

      await _audit.append(
        AuditEntry(
          id: AuditEntryId.generate(),
          type: AuditType.personMerged,
          origin: AuditOrigin.user,
          occurredAt: now,
          payload: {
            'survivorId': command.mergedPerson.id.value,
            'absorbedId': command.absorbedId.value,
            'preferredNameId': command.preferredNameId.value,
            'convertedRelationshipIds': converted,
            'duplicateCandidateRowsConsolidated': duplicateRowsRemoved,
            'resolvedFields': {
              'sex': command.mergedPerson.sex.name,
              'birthDate': command.mergedPerson.birthDate?.displayText,
              'deathDate': command.mergedPerson.deathDate?.displayText,
              'biography': command.mergedPerson.biography,
              'notes': command.mergedPerson.notes,
            },
          },
          targets: [
            AuditTarget(
              entityType: 'PERSON',
              entityId: command.mergedPerson.id.value,
              role: 'SURVIVOR',
            ),
            AuditTarget(
              entityType: 'PERSON',
              entityId: command.absorbedId.value,
              role: 'ABSORBED',
            ),
          ],
        ),
      );
    });
  }

  Future<db.Person> _activePerson(PersonId id) async {
    final query = _database.select(_database.persons)
      ..where((row) => row.id.equals(id.value) & row.deletedAt.isNull());
    final person = await query.getSingleOrNull();
    if (person == null) throw StateError('No s’ha trobat una persona activa.');
    return person;
  }

  Future<void> _createDiscardedValueClaims(
    db.Person survivor,
    db.Person absorbed,
    Person merged,
    DateTime now,
  ) async {
    final sourceValues = [survivor, absorbed];
    for (final row in sourceValues) {
      final sex = enumFromSql(PersonSex.values, row.sex);
      if (sex != merged.sex) {
        await _claims.create(
          _claim(
            merged.id,
            ClaimProperty.personSex,
            EnumClaimValue(row.sex),
            now,
          ),
        );
      }
      final birth = historicalDateFromFields(
        precision: row.birthPrecision,
        startDate: row.birthStartDate,
        endDate: row.birthEndDate,
        displayText: row.birthDisplayText,
      );
      if (birth != null && birth != merged.birthDate) {
        await _claims.create(
          _claim(
            merged.id,
            ClaimProperty.personBirthDate,
            HistoricalDateClaimValue(birth),
            now,
          ),
        );
      }
      final death = historicalDateFromFields(
        precision: row.deathPrecision,
        startDate: row.deathStartDate,
        endDate: row.deathEndDate,
        displayText: row.deathDisplayText,
      );
      if (death != null && death != merged.deathDate) {
        await _claims.create(
          _claim(
            merged.id,
            ClaimProperty.personDeathDate,
            HistoricalDateClaimValue(death),
            now,
          ),
        );
      }
      if (row.biography != null && row.biography != merged.biography) {
        await _claims.create(
          _claim(
            merged.id,
            ClaimProperty.personBiography,
            TextClaimValue(row.biography!),
            now,
          ),
        );
      }
      if (row.notes != null && row.notes != merged.notes) {
        await _claims.create(
          _claim(
            merged.id,
            ClaimProperty.personNotes,
            TextClaimValue(row.notes!),
            now,
          ),
        );
      }
    }
  }

  Claim _claim(
    PersonId subject,
    ClaimProperty property,
    ClaimValue value,
    DateTime now,
  ) => Claim(
    id: ClaimId.generate(),
    subjectType: ClaimSubjectType.person,
    subjectId: subject.value,
    property: property,
    value: value,
    status: ClaimStatus.unreviewed,
    createdAt: now,
    modifiedAt: now,
  );

  Future<void> _rewireParentChild(
    PersonMergeCommand command,
    DateTime now,
    List<String> converted,
  ) async {
    final rows = await (_database.select(
      _database.parentChildRelationships,
    )..where((row) => row.deletedAt.isNull())).get();
    final groups =
        <String, List<(db.ParentChildRelationship, String, String)>>{};
    for (final row in rows) {
      final parent = _replace(
        row.parentPersonId,
        command.absorbedId,
        command.mergedPerson.id,
      );
      final child = _replace(
        row.childPersonId,
        command.absorbedId,
        command.mergedPerson.id,
      );
      final key = '$parent|$child|${row.nature}';
      groups.putIfAbsent(key, () => []).add((row, parent, child));
    }
    for (final group in groups.values) {
      final available = group
          .where(
            (item) => !command.relationsToConvertToClaims.contains(item.$1.id),
          )
          .toList();
      (db.ParentChildRelationship, String, String)? keeper;
      if (available.isNotEmpty) {
        keeper =
            available
                .where(
                  (item) =>
                      item.$1.parentPersonId == item.$2 &&
                      item.$1.childPersonId == item.$3,
                )
                .firstOrNull ??
            available.first;
      }
      for (final item in group) {
        final row = item.$1;
        if (keeper != null && row.id == keeper.$1.id) continue;
        await (_database.update(
          _database.parentChildRelationships,
        )..where((item) => item.id.equals(row.id))).write(
          db.ParentChildRelationshipsCompanion(
            modifiedAt: Value(now),
            deletedAt: Value(now),
          ),
        );
        converted.add(row.id);
        await _claims.create(
          _claim(
            command.mergedPerson.id,
            ClaimProperty.parentChildRelationship,
            RelationshipClaimValue(
              personId: PersonId(
                item.$2 == command.mergedPerson.id.value ? item.$3 : item.$2,
              ),
              relationshipType: row.nature,
            ),
            now,
          ),
        );
      }
      if (keeper != null &&
          (keeper.$1.parentPersonId != keeper.$2 ||
              keeper.$1.childPersonId != keeper.$3)) {
        await (_database.update(
          _database.parentChildRelationships,
        )..where((item) => item.id.equals(keeper!.$1.id))).write(
          db.ParentChildRelationshipsCompanion(
            parentPersonId: Value(keeper.$2),
            childPersonId: Value(keeper.$3),
            modifiedAt: Value(now),
          ),
        );
      }
    }
  }

  Future<void> _rewirePartnerships(
    PersonMergeCommand command,
    DateTime now,
    List<String> converted,
  ) async {
    final rows = await (_database.select(
      _database.partnerships,
    )..where((row) => row.deletedAt.isNull())).get();
    final seen = <String, String>{};
    for (final row in rows) {
      var a = _replace(
        row.personAId,
        command.absorbedId,
        command.mergedPerson.id,
      );
      var b = _replace(
        row.personBId,
        command.absorbedId,
        command.mergedPerson.id,
      );
      if (a.compareTo(b) > 0) (a, b) = (b, a);
      final key = '$a|$b|${row.type}';
      final excluded = command.relationsToConvertToClaims.contains(row.id);
      if (excluded || seen.containsKey(key)) {
        await (_database.update(
          _database.partnerships,
        )..where((item) => item.id.equals(row.id))).write(
          db.PartnershipsCompanion(
            modifiedAt: Value(now),
            deletedAt: Value(now),
          ),
        );
        converted.add(row.id);
        await _claims.create(
          _claim(
            command.mergedPerson.id,
            ClaimProperty.partnership,
            RelationshipClaimValue(
              personId: PersonId(a == command.mergedPerson.id.value ? b : a),
              relationshipType: row.type,
            ),
            now,
          ),
        );
        continue;
      }
      seen[key] = row.id;
      if (row.personAId != a || row.personBId != b) {
        await (_database.update(
          _database.partnerships,
        )..where((item) => item.id.equals(row.id))).write(
          db.PartnershipsCompanion(
            personAId: Value(a),
            personBId: Value(b),
            modifiedAt: Value(now),
          ),
        );
      }
    }
  }

  Future<void> _rewireSimpleReferences(
    PersonMergeCommand command,
    DateTime now,
  ) async {
    await (_database.update(_database.residences)..where(
          (row) =>
              row.personId.equals(command.absorbedId.value) &
              row.deletedAt.isNull(),
        ))
        .write(
          db.ResidencesCompanion(
            personId: Value(command.mergedPerson.id.value),
            modifiedAt: Value(now),
          ),
        );
    final participants = await (_database.select(
      _database.eventParticipants,
    )..where((row) => row.deletedAt.isNull())).get();
    final seen = <String>{};
    for (final row in participants) {
      final personId = _replace(
        row.personId,
        command.absorbedId,
        command.mergedPerson.id,
      );
      final key = '${row.eventId}|$personId|${row.role}';
      if (seen.contains(key)) {
        await (_database.update(
          _database.eventParticipants,
        )..where((item) => item.id.equals(row.id))).write(
          db.EventParticipantsCompanion(
            modifiedAt: Value(now),
            deletedAt: Value(now),
          ),
        );
      } else {
        seen.add(key);
        if (personId != row.personId) {
          await (_database.update(
            _database.eventParticipants,
          )..where((item) => item.id.equals(row.id))).write(
            db.EventParticipantsCompanion(
              personId: Value(personId),
              modifiedAt: Value(now),
            ),
          );
        }
      }
    }
  }

  Future<void> _rewireClaims(PersonMergeCommand command) async {
    final rows = await (_database.select(
      _database.claims,
    )..where((row) => row.deletedAt.isNull())).get();
    for (final row in rows) {
      final subjectId = row.subjectId == command.absorbedId.value
          ? command.mergedPerson.id.value
          : row.subjectId;
      final decoded = jsonDecode(row.valueJson);
      final rewritten = _replaceJsonPersonId(
        decoded,
        command.absorbedId.value,
        command.mergedPerson.id.value,
      );
      if (subjectId != row.subjectId ||
          jsonEncode(rewritten) != row.valueJson) {
        await (_database.update(
          _database.claims,
        )..where((item) => item.id.equals(row.id))).write(
          db.ClaimsCompanion(
            subjectId: Value(subjectId),
            valueJson: Value(jsonEncode(rewritten)),
            modifiedAt: Value(DateTime.now().toUtc()),
          ),
        );
      }
    }
  }

  Object? _replaceJsonPersonId(Object? value, String from, String to) {
    if (value is List) {
      return value.map((item) => _replaceJsonPersonId(item, from, to)).toList();
    }
    if (value is Map) {
      return value.map((key, item) {
        const personIdKeys = {
          'personId',
          'parentPersonId',
          'childPersonId',
          'personAId',
          'personBId',
          'participantPersonId',
        };
        final replacement = personIdKeys.contains(key) && item == from
            ? to
            : _replaceJsonPersonId(item, from, to);
        return MapEntry(key, replacement);
      });
    }
    return value;
  }

  Future<int> _rewireDuplicateCandidates(
    PersonMergeCommand command,
    DateTime now,
  ) async {
    final rows = await _database.select(_database.duplicateCandidates).get();
    final groups = <String, List<(db.DuplicateCandidate, String, String)>>{};
    var removed = 0;
    for (final row in rows) {
      var a = _replace(
        row.personAId,
        command.absorbedId,
        command.mergedPerson.id,
      );
      var b = _replace(
        row.personBId,
        command.absorbedId,
        command.mergedPerson.id,
      );
      if (a == b) {
        await (_database.update(
          _database.duplicateCandidates,
        )..where((item) => item.id.equals(row.id))).write(
          db.DuplicateCandidatesCompanion(
            status: Value(enumToSql(DuplicateCandidateStatus.merged)),
            mergedIntoPersonId: Value(command.mergedPerson.id.value),
            resolvedAt: Value(now),
            modifiedAt: Value(now),
          ),
        );
        continue;
      }
      if (a.compareTo(b) > 0) (a, b) = (b, a);
      final key = '$a|$b';
      groups.putIfAbsent(key, () => []).add((row, a, b));
    }
    for (final group in groups.values) {
      group.sort((a, b) {
        final aAlreadyCanonical =
            a.$1.personAId == a.$2 && a.$1.personBId == a.$3;
        final bAlreadyCanonical =
            b.$1.personAId == b.$2 && b.$1.personBId == b.$3;
        if (aAlreadyCanonical != bAlreadyCanonical) {
          return aAlreadyCanonical ? -1 : 1;
        }
        return b.$1.score.compareTo(a.$1.score);
      });
      final keeper = group.first;
      for (final duplicate in group.skip(1)) {
        await (_database.delete(
          _database.duplicateCandidates,
        )..where((item) => item.id.equals(duplicate.$1.id))).go();
        removed++;
      }
      if (keeper.$1.personAId != keeper.$2 ||
          keeper.$1.personBId != keeper.$3) {
        await (_database.update(
          _database.duplicateCandidates,
        )..where((item) => item.id.equals(keeper.$1.id))).write(
          db.DuplicateCandidatesCompanion(
            personAId: Value(keeper.$2),
            personBId: Value(keeper.$3),
            modifiedAt: Value(now),
          ),
        );
      }
    }
    return removed;
  }

  db.PersonsCompanion _personCompanion(
    Person person, {
    required DateTime modifiedAt,
  }) {
    final birth = historicalDateToFields(person.birthDate);
    final death = historicalDateToFields(person.deathDate);
    return db.PersonsCompanion.insert(
      id: person.id.value,
      sex: enumToSql(person.sex),
      birthPrecision: Value(birth.precision),
      birthStartDate: Value(birth.startDate),
      birthEndDate: Value(birth.endDate),
      birthDisplayText: Value(birth.displayText),
      deathPrecision: Value(death.precision),
      deathStartDate: Value(death.startDate),
      deathEndDate: Value(death.endDate),
      deathDisplayText: Value(death.displayText),
      biography: Value(person.biography),
      notes: Value(person.notes),
      createdAt: person.createdAt,
      modifiedAt: modifiedAt,
      deletedAt: const Value(null),
    );
  }

  String _replace(String value, PersonId from, PersonId to) =>
      value == from.value ? to.value : value;

  bool _hasPath(String start, String target, Iterable<(String, String)> edges) {
    final graph = <String, List<String>>{};
    for (final edge in edges) {
      graph.putIfAbsent(edge.$1, () => []).add(edge.$2);
    }
    final pending = <String>[start];
    final seen = <String>{};
    while (pending.isNotEmpty) {
      final current = pending.removeLast();
      if (current == target) return true;
      if (!seen.add(current)) continue;
      pending.addAll(graph[current] ?? const []);
    }
    return false;
  }
}
