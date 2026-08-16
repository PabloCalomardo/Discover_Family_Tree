import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/database/database.dart' as db;
import 'package:family_history/database/mappers/enum_mapping.dart';
import 'package:family_history/domain/duplicate/duplicate_candidate.dart';
import 'package:family_history/domain/duplicate/duplicate_candidate_repository.dart';

final class DriftDuplicateCandidateRepository
    implements DuplicateCandidateRepository {
  DriftDuplicateCandidateRepository(this._database);
  final db.AppDatabase _database;

  @override
  Stream<List<DuplicateCandidate>> watchAll() {
    final query = _database.select(_database.duplicateCandidates)
      ..orderBy([(row) => OrderingTerm.desc(row.score)]);
    return query.watch().map(
      (rows) => List.unmodifiable(rows.map((row) => row.toDomain())),
    );
  }

  @override
  Future<DuplicateCandidate?> getByPair(
    PersonId personAId,
    PersonId personBId,
  ) async {
    final a = personAId.value.compareTo(personBId.value) < 0
        ? personAId.value
        : personBId.value;
    final b = personAId.value.compareTo(personBId.value) < 0
        ? personBId.value
        : personAId.value;
    final query = _database.select(_database.duplicateCandidates)
      ..where((row) => row.personAId.equals(a) & row.personBId.equals(b));
    return (await query.getSingleOrNull())?.toDomain();
  }

  @override
  Future<void> upsert(DuplicateCandidate candidate) => _database
      .into(_database.duplicateCandidates)
      .insertOnConflictUpdate(candidate.toCompanion());

  @override
  Future<void> updateStatus(
    DuplicateCandidateId id,
    DuplicateCandidateStatus status,
  ) async {
    final now = DateTime.now().toUtc();
    await (_database.update(
      _database.duplicateCandidates,
    )..where((row) => row.id.equals(id.value))).write(
      db.DuplicateCandidatesCompanion(
        status: Value(enumToSql(status)),
        resolvedAt: status == DuplicateCandidateStatus.pending
            ? const Value(null)
            : Value(now),
        modifiedAt: Value(now),
      ),
    );
  }
}

extension on DuplicateCandidate {
  db.DuplicateCandidatesCompanion toCompanion() =>
      db.DuplicateCandidatesCompanion.insert(
        id: id.value,
        personAId: personAId.value,
        personBId: personBId.value,
        score: score,
        reasonCodesJson: jsonEncode(reasonCodes),
        detectorVersion: detectorVersion,
        status: enumToSql(status),
        lastEvaluatedAt: lastEvaluatedAt,
        resolvedAt: Value(resolvedAt),
        mergedIntoPersonId: Value(mergedIntoPersonId?.value),
        createdAt: createdAt,
        modifiedAt: modifiedAt,
      );
}

extension on db.DuplicateCandidate {
  DuplicateCandidate toDomain() => DuplicateCandidate(
    id: DuplicateCandidateId(id),
    personAId: PersonId(personAId),
    personBId: PersonId(personBId),
    score: score,
    reasonCodes: (jsonDecode(reasonCodesJson) as List).cast<String>(),
    detectorVersion: detectorVersion,
    status: enumFromSql(DuplicateCandidateStatus.values, status),
    lastEvaluatedAt: lastEvaluatedAt,
    resolvedAt: resolvedAt,
    mergedIntoPersonId: mergedIntoPersonId == null
        ? null
        : PersonId(mergedIntoPersonId!),
    createdAt: createdAt,
    modifiedAt: modifiedAt,
  );
}
