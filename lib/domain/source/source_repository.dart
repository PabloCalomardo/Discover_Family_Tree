import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/domain/source/media_asset.dart';
import 'package:family_history/domain/source/source.dart';

abstract interface class SourceRepository {
  Future<Source?> get(SourceId id);
  Stream<List<Source>> watchAll();
  Future<void> create(Source source);
  Future<void> update(Source source);
  Future<void> delete(SourceId id);
}

abstract interface class MediaRepository {
  Future<MediaAsset?> get(MediaId id);
  Future<MediaAsset?> findByChecksum(String checksum, int size);
  Stream<List<MediaAsset>> watchForSource(SourceId sourceId);
  Future<void> create(MediaAsset media);
  Future<void> createLink(SourceMedia link);
  Future<void> deleteLink(SourceMediaId id);
}
