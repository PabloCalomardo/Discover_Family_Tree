import 'package:drift/drift.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/database/database.dart' as db;
import 'package:family_history/database/mappers/enum_mapping.dart';
import 'package:family_history/domain/place/place.dart';
import 'package:family_history/domain/place/place_repository.dart';

final class DriftPlaceRepository implements PlaceRepository {
  DriftPlaceRepository(this._database);

  final db.AppDatabase _database;

  @override
  Future<Place?> get(PlaceId id) async {
    final query = _database.select(_database.places)
      ..where((table) => table.id.equals(id.value) & table.deletedAt.isNull());
    return (await query.getSingleOrNull())?.toDomain();
  }

  @override
  Stream<List<Place>> watchAll() {
    final query = _database.select(_database.places)
      ..where((table) => table.deletedAt.isNull())
      ..orderBy([(table) => OrderingTerm.asc(table.preferredName)]);
    return query.watch().map(
      (rows) => List.unmodifiable(rows.map((row) => row.toDomain())),
    );
  }

  @override
  Future<void> create(Place place) async {
    await _database.into(_database.places).insert(place.toCompanion());
  }

  @override
  Future<void> update(Place place) async {
    await _database.update(_database.places).replace(place.toCompanion());
  }

  @override
  Future<void> delete(PlaceId id) async {
    final now = DateTime.now().toUtc();
    await (_database.update(
      _database.places,
    )..where((table) => table.id.equals(id.value))).write(
      db.PlacesCompanion(modifiedAt: Value(now), deletedAt: Value(now)),
    );
  }
}

extension on Place {
  db.PlacesCompanion toCompanion() => db.PlacesCompanion.insert(
    id: id.value,
    preferredName: preferredName,
    type: enumToSql(type),
    latitude: Value(latitude),
    longitude: Value(longitude),
    description: Value(description),
    notes: Value(notes),
    createdAt: createdAt,
    modifiedAt: modifiedAt,
    deletedAt: Value(deletedAt),
  );
}

extension on db.Place {
  Place toDomain() => Place(
    id: PlaceId(id),
    preferredName: preferredName,
    type: enumFromSql(PlaceType.values, type),
    latitude: latitude,
    longitude: longitude,
    description: description,
    notes: notes,
    createdAt: createdAt,
    modifiedAt: modifiedAt,
    deletedAt: deletedAt,
  );
}
