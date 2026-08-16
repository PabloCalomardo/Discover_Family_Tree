import 'package:family_history/core/ids/domain_id.dart';

enum AuditOrigin { user, system, migration }

enum AuditType {
  personCreated,
  personUpdated,
  personDeleted,
  personMerged,
  relationshipCreated,
  relationshipDeleted,
  placeCreated,
  placeUpdated,
  residenceCreated,
  residenceDeleted,
  eventCreated,
  eventDeleted,
  sourceCreated,
  sourceUpdated,
  sourceDeleted,
  mediaAttached,
  mediaDetached,
  claimCreated,
  claimUpdated,
  claimApplied,
  claimDeleted,
  duplicateReviewed,
}

final class AuditTarget {
  const AuditTarget({
    required this.entityType,
    required this.entityId,
    required this.role,
  });
  final String entityType;
  final String entityId;
  final String role;
}

final class AuditEntry {
  AuditEntry({
    required this.id,
    required this.type,
    required this.origin,
    required this.occurredAt,
    required this.payload,
    required List<AuditTarget> targets,
    this.payloadVersion = 1,
  }) : targets = List.unmodifiable(targets);

  final AuditEntryId id;
  final AuditType type;
  final AuditOrigin origin;
  final DateTime occurredAt;
  final int payloadVersion;
  final Map<String, Object?> payload;
  final List<AuditTarget> targets;
}
