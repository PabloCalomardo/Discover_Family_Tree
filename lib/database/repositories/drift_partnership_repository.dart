import 'package:drift/drift.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/database/database.dart' as db;
import 'package:family_history/database/mappers/enum_mapping.dart';
import 'package:family_history/database/mappers/historical_date_mapper.dart';
import 'package:family_history/domain/relationship/partnership.dart';
import 'package:family_history/domain/relationship/partnership_repository.dart';

final class DriftPartnershipRepository implements PartnershipRepository {
  DriftPartnershipRepository(this._database);

  final db.AppDatabase _database;

  @override
  Stream<List<Partnership>> watchAll() {
    final query = _database.select(_database.partnerships)
      ..where((table) => table.deletedAt.isNull());
    return query.watch().map(
      (rows) => List.unmodifiable(rows.map((row) => row.toDomain())),
    );
  }

  @override
  Future<void> create(Partnership partnership) async {
    await _database
        .into(_database.partnerships)
        .insert(partnership.toCompanion());
  }

  @override
  Future<void> update(Partnership partnership) async {
    await _database
        .update(_database.partnerships)
        .replace(partnership.toCompanion());
  }

  @override
  Future<void> delete(PartnershipId id) async {
    final now = DateTime.now().toUtc();
    await (_database.update(
      _database.partnerships,
    )..where((table) => table.id.equals(id.value))).write(
      db.PartnershipsCompanion(modifiedAt: Value(now), deletedAt: Value(now)),
    );
  }
}

extension on Partnership {
  db.PartnershipsCompanion toCompanion() {
    final start = historicalDateToFields(startDate);
    final end = historicalDateToFields(endDate);
    return db.PartnershipsCompanion.insert(
      id: id.value,
      personAId: personAId.value,
      personBId: personBId.value,
      type: enumToSql(type),
      startPrecision: Value(start.precision),
      startStartDate: Value(start.startDate),
      startEndDate: Value(start.endDate),
      startDisplayText: Value(start.displayText),
      endPrecision: Value(end.precision),
      endStartDate: Value(end.startDate),
      endEndDate: Value(end.endDate),
      endDisplayText: Value(end.displayText),
      placeId: Value(placeId?.value),
      notes: Value(notes),
      createdAt: createdAt,
      modifiedAt: modifiedAt,
      deletedAt: Value(deletedAt),
    );
  }
}

extension on db.Partnership {
  Partnership toDomain() => Partnership(
    id: PartnershipId(id),
    personAId: PersonId(personAId),
    personBId: PersonId(personBId),
    type: enumFromSql(PartnershipType.values, type),
    startDate: historicalDateFromFields(
      precision: startPrecision,
      startDate: startStartDate,
      endDate: startEndDate,
      displayText: startDisplayText,
    ),
    endDate: historicalDateFromFields(
      precision: endPrecision,
      startDate: endStartDate,
      endDate: endEndDate,
      displayText: endDisplayText,
    ),
    placeId: placeId == null ? null : PlaceId(placeId!),
    notes: notes,
    createdAt: createdAt,
    modifiedAt: modifiedAt,
    deletedAt: deletedAt,
  );
}
