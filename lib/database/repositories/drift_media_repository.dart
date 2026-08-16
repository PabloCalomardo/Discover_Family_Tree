import 'package:drift/drift.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/database/database.dart' as db;
import 'package:family_history/database/mappers/enum_mapping.dart';
import 'package:family_history/domain/source/media_asset.dart';
import 'package:family_history/domain/source/source_repository.dart';

final class DriftMediaRepository implements MediaRepository {
  DriftMediaRepository(this._database);
  final db.AppDatabase _database;

  @override
  Future<MediaAsset?> get(MediaId id) async {
    final query = _database.select(_database.mediaAssets)
      ..where((row) => row.id.equals(id.value) & row.deletedAt.isNull());
    return (await query.getSingleOrNull())?.toDomain();
  }

  @override
  Future<MediaAsset?> findByChecksum(String checksum, int size) async {
    final query = _database.select(_database.mediaAssets)
      ..where(
        (row) =>
            row.checksumSha256.equals(checksum) &
            row.fileSize.equals(size) &
            row.deletedAt.isNull(),
      );
    return (await query.getSingleOrNull())?.toDomain();
  }

  @override
  Stream<List<MediaAsset>> watchForSource(SourceId sourceId) {
    final query =
        _database.select(_database.mediaAssets).join([
          innerJoin(
            _database.sourceMediaLinks,
            _database.sourceMediaLinks.mediaId.equalsExp(
              _database.mediaAssets.id,
            ),
          ),
        ])..where(
          _database.sourceMediaLinks.sourceId.equals(sourceId.value) &
              _database.sourceMediaLinks.deletedAt.isNull() &
              _database.mediaAssets.deletedAt.isNull(),
        );
    return query.watch().map(
      (rows) => List.unmodifiable(
        rows.map((row) => row.readTable(_database.mediaAssets).toDomain()),
      ),
    );
  }

  @override
  Future<void> create(MediaAsset media) =>
      _database.into(_database.mediaAssets).insert(media.toCompanion());

  @override
  Future<void> createLink(SourceMedia link) =>
      _database.into(_database.sourceMediaLinks).insert(link.toCompanion());

  @override
  Future<void> deleteLink(SourceMediaId id) async {
    final now = DateTime.now().toUtc();
    await (_database.update(
      _database.sourceMediaLinks,
    )..where((row) => row.id.equals(id.value))).write(
      db.SourceMediaLinksCompanion(
        modifiedAt: Value(now),
        deletedAt: Value(now),
      ),
    );
  }
}

extension on MediaAsset {
  db.MediaAssetsCompanion toCompanion() => db.MediaAssetsCompanion.insert(
    id: id.value,
    type: enumToSql(type),
    relativePath: relativePath,
    mimeType: Value(mimeType),
    originalFilename: Value(originalFilename),
    checksumSha256: checksumSha256,
    fileSize: fileSize,
    createdAt: createdAt,
    modifiedAt: modifiedAt,
    deletedAt: Value(deletedAt),
  );
}

extension on db.MediaAsset {
  MediaAsset toDomain() => MediaAsset(
    id: MediaId(id),
    type: enumFromSql(MediaType.values, type),
    relativePath: relativePath,
    mimeType: mimeType,
    originalFilename: originalFilename,
    checksumSha256: checksumSha256,
    fileSize: fileSize,
    createdAt: createdAt,
    modifiedAt: modifiedAt,
    deletedAt: deletedAt,
  );
}

extension on SourceMedia {
  db.SourceMediaLinksCompanion toCompanion() =>
      db.SourceMediaLinksCompanion.insert(
        id: id.value,
        sourceId: sourceId.value,
        mediaId: mediaId.value,
        role: enumToSql(role),
        caption: Value(caption),
        sortOrder: Value(sortOrder),
        createdAt: createdAt,
        modifiedAt: modifiedAt,
        deletedAt: Value(deletedAt),
      );
}
