import 'package:drift/drift.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/database/database.dart' as db;
import 'package:family_history/database/mappers/enum_mapping.dart';
import 'package:family_history/domain/person/person_name.dart';
import 'package:family_history/domain/person/person_name_repository.dart';

final class DriftPersonNameRepository implements PersonNameRepository {
  DriftPersonNameRepository(this._database);

  final db.AppDatabase _database;

  @override
  Stream<List<PersonName>> watchAll() {
    final query = _database.select(_database.personNames)
      ..where((table) => table.deletedAt.isNull())
      ..orderBy([
        (table) => OrderingTerm.desc(table.isPreferred),
        (table) => OrderingTerm.asc(table.displayName),
      ]);
    return query.watch().map(
      (rows) => List.unmodifiable(rows.map((row) => row.toDomain())),
    );
  }

  @override
  Stream<List<PersonName>> watchForPerson(PersonId personId) {
    final query = _database.select(_database.personNames)
      ..where(
        (table) =>
            table.personId.equals(personId.value) & table.deletedAt.isNull(),
      )
      ..orderBy([
        (table) => OrderingTerm.desc(table.isPreferred),
        (table) => OrderingTerm.asc(table.displayName),
      ]);
    return query.watch().map(
      (rows) => List.unmodifiable(rows.map((row) => row.toDomain())),
    );
  }

  @override
  Future<void> create(PersonName name) async {
    await _database.into(_database.personNames).insert(name.toCompanion());
  }

  @override
  Future<void> update(PersonName name) async {
    await _database.update(_database.personNames).replace(name.toCompanion());
  }

  @override
  Future<void> delete(PersonNameId id) async {
    final now = DateTime.now().toUtc();
    await (_database.update(
      _database.personNames,
    )..where((table) => table.id.equals(id.value))).write(
      db.PersonNamesCompanion(modifiedAt: Value(now), deletedAt: Value(now)),
    );
  }
}

extension on PersonName {
  db.PersonNamesCompanion toCompanion() => db.PersonNamesCompanion.insert(
    id: id.value,
    personId: personId.value,
    givenNames: Value(givenNames),
    familyNames: Value(familyNames),
    displayName: displayName,
    type: enumToSql(type),
    isPreferred: Value(isPreferred),
    createdAt: createdAt,
    modifiedAt: modifiedAt,
    deletedAt: Value(deletedAt),
  );
}

extension on db.PersonName {
  PersonName toDomain() => PersonName(
    id: PersonNameId(id),
    personId: PersonId(personId),
    givenNames: givenNames,
    familyNames: familyNames,
    displayName: displayName,
    type: enumFromSql(PersonNameType.values, type),
    isPreferred: isPreferred,
    createdAt: createdAt,
    modifiedAt: modifiedAt,
    deletedAt: deletedAt,
  );
}
