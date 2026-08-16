import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/domain/audit/audit_entry.dart';
import 'package:family_history/domain/audit/audit_repository.dart';

final class AuditService {
  const AuditService(this._repository);
  final AuditRepository _repository;

  Future<void> record({
    required AuditType type,
    required Map<String, Object?> payload,
    required List<AuditTarget> targets,
    AuditOrigin origin = AuditOrigin.user,
  }) => _repository.append(
    AuditEntry(
      id: AuditEntryId.generate(),
      type: type,
      origin: origin,
      occurredAt: DateTime.now().toUtc(),
      payload: payload,
      targets: targets,
    ),
  );
}
