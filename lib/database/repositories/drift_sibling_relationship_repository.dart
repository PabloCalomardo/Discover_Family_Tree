import 'package:drift/drift.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/database/database.dart' as db;
import 'package:family_history/database/mappers/enum_mapping.dart';
import 'package:family_history/domain/relationship/sibling_relationship.dart';
import 'package:family_history/domain/relationship/sibling_relationship_repository.dart';

final class DriftSiblingRelationshipRepository
    implements SiblingRelationshipRepository {
  DriftSiblingRelationshipRepository(this._database);

  final db.AppDatabase _database;

  @override
  Stream<List<SiblingRelationship>> watchAll() {
    final query = _database.select(_database.siblingRelationships)
      ..where((table) => table.deletedAt.isNull());
    return query.watch().map(
      (rows) => List.unmodifiable(rows.map((row) => row.toDomain())),
    );
  }

  @override
  Future<void> create(SiblingRelationship relationship) => _database
      .into(_database.siblingRelationships)
      .insert(relationship.toCompanion());

  @override
  Future<void> update(SiblingRelationship relationship) => _database
      .update(_database.siblingRelationships)
      .replace(relationship.toCompanion());

  @override
  Future<void> delete(SiblingRelationshipId id) async {
    final now = DateTime.now().toUtc();
    await (_database.update(
      _database.siblingRelationships,
    )..where((table) => table.id.equals(id.value))).write(
      db.SiblingRelationshipsCompanion(
        modifiedAt: Value(now),
        deletedAt: Value(now),
      ),
    );
  }
}

extension on SiblingRelationship {
  db.SiblingRelationshipsCompanion toCompanion() =>
      db.SiblingRelationshipsCompanion.insert(
        id: id.value,
        personAId: personAId.value,
        personBId: personBId.value,
        kind: enumToSql(kind),
        notes: Value(notes),
        createdAt: createdAt,
        modifiedAt: modifiedAt,
        deletedAt: Value(deletedAt),
      );
}

extension on db.SiblingRelationship {
  SiblingRelationship toDomain() => SiblingRelationship(
    id: SiblingRelationshipId(id),
    personAId: PersonId(personAId),
    personBId: PersonId(personBId),
    kind: enumFromSql(SiblingKind.values, kind),
    notes: notes,
    createdAt: createdAt,
    modifiedAt: modifiedAt,
    deletedAt: deletedAt,
  );
}
