import 'package:drift/drift.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/database/database.dart' as db;
import 'package:family_history/database/mappers/enum_mapping.dart';
import 'package:family_history/domain/claim/claim.dart';
import 'package:family_history/domain/claim/claim_repository.dart';

final class DriftClaimRepository implements ClaimRepository {
  DriftClaimRepository(this._database);
  final db.AppDatabase _database;

  @override
  Future<Claim?> get(ClaimId id) async =>
      (await (_database.select(_database.claims)
                ..where((row) => row.id.equals(id.value)))
              .getSingleOrNull())
          ?.toDomain();

  @override
  Stream<List<Claim>> watchForSubject(ClaimSubjectType type, String subjectId) {
    final query = _database.select(_database.claims)
      ..where(
        (row) =>
            row.subjectType.equals(enumToSql(type)) &
            row.subjectId.equals(subjectId) &
            row.deletedAt.isNull(),
      )
      ..orderBy([(row) => OrderingTerm.desc(row.createdAt)]);
    return query.watch().map(_mapRows);
  }

  @override
  Stream<List<Claim>> watchAll() {
    final query = _database.select(_database.claims)
      ..where((row) => row.deletedAt.isNull())
      ..orderBy([(row) => OrderingTerm.desc(row.createdAt)]);
    return query.watch().map(_mapRows);
  }

  @override
  Stream<List<Claim>> watchForSource(SourceId sourceId) {
    final query = _database.select(_database.claims)
      ..where(
        (row) => row.sourceId.equals(sourceId.value) & row.deletedAt.isNull(),
      )
      ..orderBy([(row) => OrderingTerm.desc(row.createdAt)]);
    return query.watch().map(_mapRows);
  }

  List<Claim> _mapRows(List<db.Claim> rows) =>
      List.unmodifiable(rows.map((row) => row.toDomain()));

  @override
  Future<void> create(Claim claim) =>
      _database.into(_database.claims).insert(claim.toCompanion());

  @override
  Future<void> update(Claim claim) =>
      _database.update(_database.claims).replace(claim.toCompanion());

  @override
  Future<void> delete(ClaimId id) async {
    final now = DateTime.now().toUtc();
    await (_database.update(
      _database.claims,
    )..where((row) => row.id.equals(id.value))).write(
      db.ClaimsCompanion(modifiedAt: Value(now), deletedAt: Value(now)),
    );
  }
}

extension on Claim {
  db.ClaimsCompanion toCompanion() => db.ClaimsCompanion.insert(
    id: id.value,
    subjectType: enumToSql(subjectType),
    subjectId: subjectId,
    property: enumToSql(property),
    valueType: value.type,
    valueJson: value.encode(),
    payloadVersion: Value(payloadVersion),
    sourceId: Value(sourceId?.value),
    sourceLocator: Value(sourceLocator),
    confidence: Value(confidence),
    status: enumToSql(status),
    createdAt: createdAt,
    modifiedAt: modifiedAt,
    deletedAt: Value(deletedAt),
  );
}

extension on db.Claim {
  Claim toDomain() => Claim(
    id: ClaimId(id),
    subjectType: enumFromSql(ClaimSubjectType.values, subjectType),
    subjectId: subjectId,
    property: enumFromSql(ClaimProperty.values, property),
    value: ClaimValue.decode(valueType, valueJson),
    payloadVersion: payloadVersion,
    sourceId: sourceId == null ? null : SourceId(sourceId!),
    sourceLocator: sourceLocator,
    confidence: confidence,
    status: enumFromSql(ClaimStatus.values, status),
    createdAt: createdAt,
    modifiedAt: modifiedAt,
    deletedAt: deletedAt,
  );
}
