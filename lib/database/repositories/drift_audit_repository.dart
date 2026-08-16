import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/database/database.dart' as db;
import 'package:family_history/database/mappers/enum_mapping.dart';
import 'package:family_history/domain/audit/audit_entry.dart';
import 'package:family_history/domain/audit/audit_repository.dart';

final class DriftAuditRepository implements AuditRepository {
  DriftAuditRepository(this._database);
  final db.AppDatabase _database;

  @override
  Future<void> append(AuditEntry entry) async {
    await _database.transaction(() async {
      await _database
          .into(_database.auditEntries)
          .insert(
            db.AuditEntriesCompanion.insert(
              id: entry.id.value,
              type: enumToSql(entry.type),
              origin: enumToSql(entry.origin),
              occurredAt: entry.occurredAt,
              payloadVersion: Value(entry.payloadVersion),
              payloadJson: jsonEncode(entry.payload),
            ),
          );
      for (final target in entry.targets) {
        await _database
            .into(_database.auditTargets)
            .insert(
              db.AuditTargetsCompanion.insert(
                auditEntryId: entry.id.value,
                entityType: target.entityType,
                entityId: target.entityId,
                role: target.role,
              ),
            );
      }
    });
  }

  @override
  Stream<List<AuditEntry>> watchForEntity(String entityType, String entityId) {
    final query =
        _database.select(_database.auditEntries).join([
          innerJoin(
            _database.auditTargets,
            _database.auditTargets.auditEntryId.equalsExp(
              _database.auditEntries.id,
            ),
          ),
        ])..where(
          _database.auditTargets.entityType.equals(entityType) &
              _database.auditTargets.entityId.equals(entityId),
        );
    return query.watch().asyncMap((rows) async {
      final entries = <AuditEntry>[];
      for (final row in rows) {
        final item = row.readTable(_database.auditEntries);
        final targetRows = await (_database.select(
          _database.auditTargets,
        )..where((target) => target.auditEntryId.equals(item.id))).get();
        entries.add(
          AuditEntry(
            id: AuditEntryId(item.id),
            type: enumFromSql(AuditType.values, item.type),
            origin: enumFromSql(AuditOrigin.values, item.origin),
            occurredAt: item.occurredAt,
            payloadVersion: item.payloadVersion,
            payload: (jsonDecode(item.payloadJson) as Map)
                .cast<String, Object?>(),
            targets: targetRows
                .map(
                  (target) => AuditTarget(
                    entityType: target.entityType,
                    entityId: target.entityId,
                    role: target.role,
                  ),
                )
                .toList(),
          ),
        );
      }
      entries.sort((a, b) => b.occurredAt.compareTo(a.occurredAt));
      return List.unmodifiable(entries);
    });
  }
}
