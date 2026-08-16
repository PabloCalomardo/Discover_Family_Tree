import 'package:family_history/domain/audit/audit_entry.dart';

abstract interface class AuditRepository {
  Future<void> append(AuditEntry entry);
  Stream<List<AuditEntry>> watchForEntity(String entityType, String entityId);
}
