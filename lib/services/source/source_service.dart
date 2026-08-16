import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:crypto/crypto.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/domain/audit/audit_entry.dart';
import 'package:family_history/domain/source/media_asset.dart';
import 'package:family_history/domain/source/source.dart';
import 'package:family_history/domain/source/source_repository.dart';
import 'package:family_history/services/audit/audit_service.dart';
import 'package:family_history/services/transaction_runner.dart';
import 'package:path/path.dart' as p;

final class SourceService {
  const SourceService(
    this._sources,
    this._media,
    this._audit,
    this._transactions,
  );

  final SourceRepository _sources;
  final MediaRepository _media;
  final AuditService _audit;
  final TransactionRunner _transactions;

  Future<void> create(Source source) => _transactions.run(() async {
    await _sources.create(source);
    await _audit.record(
      type: AuditType.sourceCreated,
      payload: {'title': source.title, 'type': source.type.name},
      targets: [
        AuditTarget(
          entityType: 'SOURCE',
          entityId: source.id.value,
          role: 'CREATED',
        ),
      ],
    );
  });

  Future<void> update(Source source) => _transactions.run(() async {
    await _sources.update(source);
    await _audit.record(
      type: AuditType.sourceUpdated,
      payload: {'title': source.title, 'type': source.type.name},
      targets: [
        AuditTarget(
          entityType: 'SOURCE',
          entityId: source.id.value,
          role: 'UPDATED',
        ),
      ],
    );
  });

  Future<void> delete(SourceId id) => _transactions.run(() async {
    await _sources.delete(id);
    await _audit.record(
      type: AuditType.sourceDeleted,
      payload: const {},
      targets: [
        AuditTarget(entityType: 'SOURCE', entityId: id.value, role: 'DELETED'),
      ],
    );
  });

  Future<MediaAsset> attachFile({
    required SourceId sourceId,
    required File input,
    required Directory workspace,
    required MediaType type,
    SourceMediaRole role = SourceMediaRole.attachment,
    String? caption,
  }) async {
    final bytes = await input.readAsBytes();
    final checksum = sha256.convert(bytes).toString();
    final existing = await _media.findByChecksum(checksum, bytes.length);
    final now = DateTime.now().toUtc();
    final newMediaId = MediaId.generate();
    final media =
        existing ??
        MediaAsset(
          id: newMediaId,
          type: type,
          relativePath: _relativePath(newMediaId, type, input.path),
          originalFilename: p.basename(input.path),
          mimeType: _mimeType(input.path, type),
          checksumSha256: checksum,
          fileSize: bytes.length,
          createdAt: now,
          modifiedAt: now,
        );
    File? output;
    File? thumbnail;
    if (existing == null) {
      output = File(
        p.joinAll([workspace.path, ...media.relativePath.split('/')]),
      );
      await output.parent.create(recursive: true);
      await output.writeAsBytes(bytes, flush: true);
      if (type == MediaType.image) {
        thumbnail = await _writeThumbnail(workspace, media.id, bytes);
      }
    }
    try {
      await _transactions.run(() async {
        if (existing == null) await _media.create(media);
        final link = SourceMedia(
          id: SourceMediaId.generate(),
          sourceId: sourceId,
          mediaId: media.id,
          role: role,
          caption: caption,
          sortOrder: 0,
          createdAt: now,
          modifiedAt: now,
        );
        await _media.createLink(link);
        await _audit.record(
          type: AuditType.mediaAttached,
          payload: {
            'relativePath': media.relativePath,
            'checksumSha256': media.checksumSha256,
          },
          targets: [
            AuditTarget(
              entityType: 'SOURCE',
              entityId: sourceId.value,
              role: 'SOURCE',
            ),
            AuditTarget(
              entityType: 'MEDIA',
              entityId: media.id.value,
              role: 'ATTACHED',
            ),
          ],
        );
      });
    } catch (_) {
      if (existing == null && output != null && await output.exists()) {
        await output.delete();
      }
      if (existing == null && thumbnail != null && await thumbnail.exists()) {
        await thumbnail.delete();
      }
      rethrow;
    }
    return media;
  }

  String _relativePath(MediaId id, MediaType type, String originalPath) {
    final folder = switch (type) {
      MediaType.audio => 'audio',
      MediaType.image => 'images',
      MediaType.document || MediaType.other => 'documents',
    };
    final extension = p.extension(originalPath).toLowerCase();
    return 'media/$folder/${id.value}$extension';
  }

  String? _mimeType(String path, MediaType type) {
    final extension = p.extension(path).toLowerCase();
    return switch (extension) {
      '.jpg' || '.jpeg' => 'image/jpeg',
      '.png' => 'image/png',
      '.gif' => 'image/gif',
      '.webp' => 'image/webp',
      '.mp3' => 'audio/mpeg',
      '.m4a' => 'audio/mp4',
      '.wav' => 'audio/wav',
      '.pdf' => 'application/pdf',
      _ => type == MediaType.document ? 'application/octet-stream' : null,
    };
  }

  Future<File?> _writeThumbnail(
    Directory workspace,
    MediaId mediaId,
    List<int> bytes,
  ) async {
    try {
      final codec = await ui.instantiateImageCodec(
        Uint8List.fromList(bytes),
        targetWidth: 320,
      );
      final frame = await codec.getNextFrame();
      final data = await frame.image.toByteData(format: ui.ImageByteFormat.png);
      frame.image.dispose();
      codec.dispose();
      if (data == null) return null;
      final file = File(
        p.join(workspace.path, 'thumbnails', '${mediaId.value}.png'),
      );
      await file.parent.create(recursive: true);
      await file.writeAsBytes(data.buffer.asUint8List(), flush: true);
      return file;
    } catch (_) {
      return null;
    }
  }
}
