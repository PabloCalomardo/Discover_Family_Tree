import 'package:drift/drift.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/database/database.dart' as db;
import 'package:family_history/database/mappers/enum_mapping.dart';
import 'package:family_history/domain/place/place_relationship.dart';
import 'package:family_history/domain/place/place_relationship_repository.dart';
import 'package:family_history/services/place/place_graph_validator.dart';

final class DriftPlaceRelationshipRepository
    implements PlaceRelationshipRepository {
  DriftPlaceRelationshipRepository(this._database);

  final db.AppDatabase _database;
  final PlaceGraphValidator _validator = const PlaceGraphValidator();

  @override
  Stream<List<PlaceRelationship>> watchAll() {
    final query = _database.select(_database.placeRelationships)
      ..where((table) => table.deletedAt.isNull());
    return query.watch().map(
      (rows) => List.unmodifiable(rows.map((row) => row.toDomain())),
    );
  }

  @override
  Future<void> create(PlaceRelationship relationship) async {
    _validator.validateCanAdd(await _activeRelationships(), relationship);
    await _database
        .into(_database.placeRelationships)
        .insert(relationship.toCompanion());
  }

  @override
  Future<void> update(PlaceRelationship relationship) async {
    final others = (await _activeRelationships()).where(
      (existing) => existing.id != relationship.id,
    );
    _validator.validateCanAdd(others, relationship);
    await _database
        .update(_database.placeRelationships)
        .replace(relationship.toCompanion());
  }

  @override
  Future<void> delete(PlaceRelationshipId id) async {
    final now = DateTime.now().toUtc();
    await (_database.update(
      _database.placeRelationships,
    )..where((table) => table.id.equals(id.value))).write(
      db.PlaceRelationshipsCompanion(
        modifiedAt: Value(now),
        deletedAt: Value(now),
      ),
    );
  }

  Future<List<PlaceRelationship>> _activeRelationships() async {
    final query = _database.select(_database.placeRelationships)
      ..where((table) => table.deletedAt.isNull());
    return (await query.get()).map((row) => row.toDomain()).toList();
  }
}

extension on PlaceRelationship {
  db.PlaceRelationshipsCompanion toCompanion() =>
      db.PlaceRelationshipsCompanion.insert(
        id: id.value,
        sourcePlaceId: sourcePlaceId.value,
        targetPlaceId: targetPlaceId.value,
        type: enumToSql(type),
        createdAt: createdAt,
        modifiedAt: modifiedAt,
        deletedAt: Value(deletedAt),
      );
}

extension on db.PlaceRelationship {
  PlaceRelationship toDomain() => PlaceRelationship(
    id: PlaceRelationshipId(id),
    sourcePlaceId: PlaceId(sourcePlaceId),
    targetPlaceId: PlaceId(targetPlaceId),
    type: enumFromSql(PlaceRelationshipType.values, type),
    createdAt: createdAt,
    modifiedAt: modifiedAt,
    deletedAt: deletedAt,
  );
}
