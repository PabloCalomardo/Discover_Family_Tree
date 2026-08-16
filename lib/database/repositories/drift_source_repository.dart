import 'package:drift/drift.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/database/database.dart' as db;
import 'package:family_history/database/mappers/enum_mapping.dart';
import 'package:family_history/database/mappers/historical_date_mapper.dart';
import 'package:family_history/domain/source/source.dart';
import 'package:family_history/domain/source/source_repository.dart';

final class DriftSourceRepository implements SourceRepository {
  DriftSourceRepository(this._database);
  final db.AppDatabase _database;

  @override
  Future<Source?> get(SourceId id) async {
    final query = _database.select(_database.sources)
      ..where((row) => row.id.equals(id.value) & row.deletedAt.isNull());
    return (await query.getSingleOrNull())?.toDomain();
  }

  @override
  Stream<List<Source>> watchAll() {
    final query = _database.select(_database.sources)
      ..where((row) => row.deletedAt.isNull())
      ..orderBy([(row) => OrderingTerm.asc(row.title)]);
    return query.watch().map(
      (rows) => List.unmodifiable(rows.map((row) => row.toDomain())),
    );
  }

  @override
  Future<void> create(Source source) =>
      _database.into(_database.sources).insert(source.toCompanion());

  @override
  Future<void> update(Source source) =>
      _database.update(_database.sources).replace(source.toCompanion());

  @override
  Future<void> delete(SourceId id) async {
    final now = DateTime.now().toUtc();
    await (_database.update(
      _database.sources,
    )..where((row) => row.id.equals(id.value))).write(
      db.SourcesCompanion(modifiedAt: Value(now), deletedAt: Value(now)),
    );
  }
}

extension on Source {
  db.SourcesCompanion toCompanion() {
    final date = historicalDateToFields(sourceDate);
    return db.SourcesCompanion.insert(
      id: id.value,
      type: enumToSql(type),
      title: title,
      description: Value(description),
      sourceDatePrecision: Value(date.precision),
      sourceDateStartDate: Value(date.startDate),
      sourceDateEndDate: Value(date.endDate),
      sourceDateDisplayText: Value(date.displayText),
      creator: Value(creator),
      repositoryName: Value(repositoryName),
      referenceCode: Value(referenceCode),
      originalLocation: Value(originalLocation),
      url: Value(url),
      accessedAt: Value(accessedAt),
      notes: Value(notes),
      createdAt: createdAt,
      modifiedAt: modifiedAt,
      deletedAt: Value(deletedAt),
    );
  }
}

extension on db.Source {
  Source toDomain() => Source(
    id: SourceId(id),
    type: enumFromSql(SourceType.values, type),
    title: title,
    description: description,
    sourceDate: historicalDateFromFields(
      precision: sourceDatePrecision,
      startDate: sourceDateStartDate,
      endDate: sourceDateEndDate,
      displayText: sourceDateDisplayText,
    ),
    creator: creator,
    repositoryName: repositoryName,
    referenceCode: referenceCode,
    originalLocation: originalLocation,
    url: url,
    accessedAt: accessedAt,
    notes: notes,
    createdAt: createdAt,
    modifiedAt: modifiedAt,
    deletedAt: deletedAt,
  );
}
