import 'package:drift/drift.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/database/database.dart' as db;
import 'package:family_history/database/mappers/enum_mapping.dart';
import 'package:family_history/database/mappers/historical_date_mapper.dart';
import 'package:family_history/domain/person/person.dart';
import 'package:family_history/domain/person/person_repository.dart';

final class DriftPersonRepository implements PersonRepository {
  DriftPersonRepository(this._database);

  final db.AppDatabase _database;

  @override
  Future<Person?> get(PersonId id) async {
    final query = _database.select(_database.persons)
      ..where((table) => table.id.equals(id.value) & table.deletedAt.isNull());
    return (await query.getSingleOrNull())?.toDomain();
  }

  @override
  Stream<List<Person>> watchAll() {
    final query = _database.select(_database.persons)
      ..where((table) => table.deletedAt.isNull())
      ..orderBy([(table) => OrderingTerm.asc(table.createdAt)]);
    return query.watch().map(
      (rows) => List.unmodifiable(rows.map((row) => row.toDomain())),
    );
  }

  @override
  Future<void> create(Person person) async {
    await _database.into(_database.persons).insert(person.toCompanion());
  }

  @override
  Future<void> update(Person person) async {
    await _database.update(_database.persons).replace(person.toCompanion());
  }

  @override
  Future<void> delete(PersonId id) async {
    final now = DateTime.now().toUtc();
    await (_database.update(
      _database.persons,
    )..where((table) => table.id.equals(id.value))).write(
      db.PersonsCompanion(modifiedAt: Value(now), deletedAt: Value(now)),
    );
  }
}

extension on Person {
  db.PersonsCompanion toCompanion() {
    final birth = historicalDateToFields(birthDate);
    final death = historicalDateToFields(deathDate);
    return db.PersonsCompanion.insert(
      id: id.value,
      sex: enumToSql(sex),
      birthPrecision: Value(birth.precision),
      birthStartDate: Value(birth.startDate),
      birthEndDate: Value(birth.endDate),
      birthDisplayText: Value(birth.displayText),
      deathPrecision: Value(death.precision),
      deathStartDate: Value(death.startDate),
      deathEndDate: Value(death.endDate),
      deathDisplayText: Value(death.displayText),
      biography: Value(biography),
      notes: Value(notes),
      createdAt: createdAt,
      modifiedAt: modifiedAt,
      deletedAt: Value(deletedAt),
    );
  }
}

extension on db.Person {
  Person toDomain() => Person(
    id: PersonId(id),
    sex: enumFromSql(PersonSex.values, sex),
    birthDate: historicalDateFromFields(
      precision: birthPrecision,
      startDate: birthStartDate,
      endDate: birthEndDate,
      displayText: birthDisplayText,
    ),
    deathDate: historicalDateFromFields(
      precision: deathPrecision,
      startDate: deathStartDate,
      endDate: deathEndDate,
      displayText: deathDisplayText,
    ),
    biography: biography,
    notes: notes,
    createdAt: createdAt,
    modifiedAt: modifiedAt,
    deletedAt: deletedAt,
  );
}
