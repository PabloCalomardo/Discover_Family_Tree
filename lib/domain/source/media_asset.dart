import 'package:family_history/core/errors/domain_validation_exception.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/core/utils/entity_validation.dart';

enum MediaType { audio, image, document, other }

enum SourceMediaRole { primary, attachment, supplement }

final class MediaAsset {
  MediaAsset({
    required this.id,
    required this.type,
    required String relativePath,
    required String checksumSha256,
    required this.fileSize,
    required this.createdAt,
    required this.modifiedAt,
    String? mimeType,
    String? originalFilename,
    this.deletedAt,
  }) : relativePath = relativePath.replaceAll('\\', '/').trim(),
       checksumSha256 = checksumSha256.toLowerCase(),
       mimeType = normalizedOptionalText(mimeType),
       originalFilename = normalizedOptionalText(originalFilename) {
    if (this.relativePath.isEmpty ||
        this.relativePath.startsWith('/') ||
        this.relativePath.split('/').contains('..')) {
      throw const DomainValidationException(
        DomainValidationCode.invalidEntity,
        'Media must use a safe relative path.',
      );
    }
    if (!RegExp(r'^[a-f0-9]{64}$').hasMatch(this.checksumSha256) ||
        fileSize < 0) {
      throw const DomainValidationException(
        DomainValidationCode.invalidEntity,
        'Media checksum or size is invalid.',
      );
    }
    validateEntityTimestamps(
      createdAt: createdAt,
      modifiedAt: modifiedAt,
      deletedAt: deletedAt,
    );
  }

  final MediaId id;
  final MediaType type;
  final String relativePath;
  final String? mimeType;
  final String? originalFilename;
  final String checksumSha256;
  final int fileSize;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final DateTime? deletedAt;
}

final class SourceMedia {
  SourceMedia({
    required this.id,
    required this.sourceId,
    required this.mediaId,
    required this.role,
    required this.sortOrder,
    required this.createdAt,
    required this.modifiedAt,
    String? caption,
    this.deletedAt,
  }) : caption = normalizedOptionalText(caption) {
    if (sortOrder < 0) {
      throw const DomainValidationException(
        DomainValidationCode.invalidEntity,
        'Source media sort order cannot be negative.',
      );
    }
    validateEntityTimestamps(
      createdAt: createdAt,
      modifiedAt: modifiedAt,
      deletedAt: deletedAt,
    );
  }

  final SourceMediaId id;
  final SourceId sourceId;
  final MediaId mediaId;
  final SourceMediaRole role;
  final String? caption;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final DateTime? deletedAt;
}
