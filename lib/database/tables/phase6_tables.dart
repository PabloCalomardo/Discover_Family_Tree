import 'package:drift/drift.dart';
import 'package:family_history/database/tables/family_tables.dart';

class Sources extends Table {
  TextColumn get id => text()();
  TextColumn get type => text()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  TextColumn get sourceDatePrecision => text().nullable()();
  DateTimeColumn get sourceDateStartDate => dateTime().nullable()();
  DateTimeColumn get sourceDateEndDate => dateTime().nullable()();
  TextColumn get sourceDateDisplayText => text().nullable()();
  TextColumn get creator => text().nullable()();
  TextColumn get repositoryName => text().nullable()();
  TextColumn get referenceCode => text().nullable()();
  TextColumn get originalLocation => text().nullable()();
  TextColumn get url => text().nullable()();
  DateTimeColumn get accessedAt => dateTime().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get modifiedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@TableIndex.sql(
  'CREATE UNIQUE INDEX media_relative_path_active '
  'ON media (relative_path) WHERE deleted_at IS NULL',
)
@TableIndex.sql(
  'CREATE UNIQUE INDEX media_checksum_size_active '
  'ON media (checksum_sha256, file_size) WHERE deleted_at IS NULL',
)
class MediaAssets extends Table {
  @override
  String get tableName => 'media';

  TextColumn get id => text()();
  TextColumn get type => text()();
  TextColumn get relativePath => text()();
  TextColumn get mimeType => text().nullable()();
  TextColumn get originalFilename => text().nullable()();
  TextColumn get checksumSha256 => text().withLength(min: 64, max: 64)();
  IntColumn get fileSize => integer()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get modifiedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => ['CHECK (file_size >= 0)'];
}

@TableIndex(name: 'source_media_source_id', columns: {#sourceId})
@TableIndex(name: 'source_media_media_id', columns: {#mediaId})
@TableIndex.sql(
  'CREATE UNIQUE INDEX source_media_pair_active '
  'ON source_media (source_id, media_id) WHERE deleted_at IS NULL',
)
class SourceMediaLinks extends Table {
  @override
  String get tableName => 'source_media';

  TextColumn get id => text()();
  TextColumn get sourceId => text().references(Sources, #id)();
  TextColumn get mediaId => text().references(MediaAssets, #id)();
  TextColumn get role => text()();
  TextColumn get caption => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get modifiedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => ['CHECK (sort_order >= 0)'];
}

@TableIndex(name: 'claims_subject', columns: {#subjectType, #subjectId})
@TableIndex(
  name: 'claims_subject_property',
  columns: {#subjectType, #subjectId, #property},
)
@TableIndex(name: 'claims_source_id', columns: {#sourceId})
@TableIndex(name: 'claims_status', columns: {#status})
class Claims extends Table {
  TextColumn get id => text()();
  TextColumn get subjectType => text()();
  TextColumn get subjectId => text()();
  TextColumn get property => text()();
  TextColumn get valueType => text()();
  TextColumn get valueJson => text()();
  IntColumn get payloadVersion => integer().withDefault(const Constant(1))();
  TextColumn get sourceId => text().nullable().references(Sources, #id)();
  TextColumn get sourceLocator => text().nullable()();
  RealColumn get confidence => real().nullable()();
  TextColumn get status => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get modifiedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
    'CHECK (payload_version >= 1)',
    'CHECK (confidence IS NULL OR confidence BETWEEN 0 AND 1)',
  ];
}

@TableIndex(
  name: 'claim_applications_result',
  columns: {#resultEntityType, #resultEntityId},
)
class ClaimApplications extends Table {
  TextColumn get claimId => text().references(Claims, #id)();
  TextColumn get operationType => text()();
  TextColumn get resultEntityType => text()();
  TextColumn get resultEntityId => text()();
  DateTimeColumn get appliedAt => dateTime()();
  TextColumn get payloadJson => text()();

  @override
  Set<Column<Object>> get primaryKey => {claimId};
}

@TableIndex.sql(
  'CREATE UNIQUE INDEX duplicate_candidates_pair '
  'ON duplicate_candidates (person_a_id, person_b_id)',
)
@TableIndex(name: 'duplicate_candidates_status', columns: {#status})
class DuplicateCandidates extends Table {
  TextColumn get id => text()();
  @ReferenceName('duplicateCandidatesAsA')
  TextColumn get personAId => text().references(Persons, #id)();
  @ReferenceName('duplicateCandidatesAsB')
  TextColumn get personBId => text().references(Persons, #id)();
  IntColumn get score => integer()();
  TextColumn get reasonCodesJson => text()();
  IntColumn get detectorVersion => integer()();
  TextColumn get status => text()();
  DateTimeColumn get lastEvaluatedAt => dateTime()();
  DateTimeColumn get resolvedAt => dateTime().nullable()();
  TextColumn get mergedIntoPersonId =>
      text().nullable().references(Persons, #id)();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get modifiedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
    'CHECK (person_a_id < person_b_id)',
    'CHECK (score BETWEEN 0 AND 100)',
    'CHECK (detector_version >= 1)',
  ];
}

@TableIndex(name: 'audit_entries_occurred_at', columns: {#occurredAt})
class AuditEntries extends Table {
  TextColumn get id => text()();
  TextColumn get type => text()();
  TextColumn get origin => text()();
  DateTimeColumn get occurredAt => dateTime()();
  IntColumn get payloadVersion => integer().withDefault(const Constant(1))();
  TextColumn get payloadJson => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => ['CHECK (payload_version >= 1)'];
}

@TableIndex(name: 'audit_targets_entity', columns: {#entityType, #entityId})
class AuditTargets extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get auditEntryId => text().references(AuditEntries, #id)();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get role => text()();
}
