import 'package:drift/drift.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/database/database.dart' as db;
import 'package:family_history/database/mappers/enum_mapping.dart';
import 'package:family_history/database/mappers/historical_date_mapper.dart';
import 'package:family_history/domain/relationship/parent_child_relationship.dart';
import 'package:family_history/domain/relationship/parent_child_relationship_repository.dart';
import 'package:family_history/services/kinship/family_graph_validator.dart';

final class DriftParentChildRelationshipRepository
    implements ParentChildRelationshipRepository {
  DriftParentChildRelationshipRepository(this._database);

  final db.AppDatabase _database;
  final FamilyGraphValidator _validator = const FamilyGraphValidator();

  @override
  Stream<List<ParentChildRelationship>> watchAll() {
    final query = _database.select(_database.parentChildRelationships)
      ..where((table) => table.deletedAt.isNull());
    return query.watch().map(
      (rows) => List.unmodifiable(rows.map((row) => row.toDomain())),
    );
  }

  @override
  Future<void> create(ParentChildRelationship relationship) async {
    _validator.validateCanAdd(await _activeRelationships(), relationship);
    await _database
        .into(_database.parentChildRelationships)
        .insert(relationship.toCompanion());
  }

  @override
  Future<void> update(ParentChildRelationship relationship) async {
    final others = (await _activeRelationships()).where(
      (existing) => existing.id != relationship.id,
    );
    _validator.validateCanAdd(others, relationship);
    await _database
        .update(_database.parentChildRelationships)
        .replace(relationship.toCompanion());
  }

  @override
  Future<void> delete(ParentChildRelationshipId id) async {
    final now = DateTime.now().toUtc();
    await (_database.update(
      _database.parentChildRelationships,
    )..where((table) => table.id.equals(id.value))).write(
      db.ParentChildRelationshipsCompanion(
        modifiedAt: Value(now),
        deletedAt: Value(now),
      ),
    );
  }

  Future<List<ParentChildRelationship>> _activeRelationships() async {
    final query = _database.select(_database.parentChildRelationships)
      ..where((table) => table.deletedAt.isNull());
    return (await query.get()).map((row) => row.toDomain()).toList();
  }
}

extension on ParentChildRelationship {
  db.ParentChildRelationshipsCompanion toCompanion() {
    final start = historicalDateToFields(startDate);
    final end = historicalDateToFields(endDate);
    return db.ParentChildRelationshipsCompanion.insert(
      id: id.value,
      parentPersonId: parentId.value,
      childPersonId: childId.value,
      nature: enumToSql(nature),
      startPrecision: Value(start.precision),
      startStartDate: Value(start.startDate),
      startEndDate: Value(start.endDate),
      startDisplayText: Value(start.displayText),
      endPrecision: Value(end.precision),
      endStartDate: Value(end.startDate),
      endEndDate: Value(end.endDate),
      endDisplayText: Value(end.displayText),
      notes: Value(notes),
      createdAt: createdAt,
      modifiedAt: modifiedAt,
      deletedAt: Value(deletedAt),
    );
  }
}

extension on db.ParentChildRelationship {
  ParentChildRelationship toDomain() => ParentChildRelationship(
    id: ParentChildRelationshipId(id),
    parentId: PersonId(parentPersonId),
    childId: PersonId(childPersonId),
    nature: enumFromSql(ParentChildNature.values, nature),
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
    notes: notes,
    createdAt: createdAt,
    modifiedAt: modifiedAt,
    deletedAt: deletedAt,
  );
}
