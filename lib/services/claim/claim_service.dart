import 'package:family_history/domain/audit/audit_entry.dart';
import 'package:family_history/domain/claim/claim.dart';
import 'package:family_history/domain/claim/claim_repository.dart';
import 'package:family_history/services/audit/audit_service.dart';
import 'package:family_history/services/claim/claim_operation_executor.dart';
import 'package:family_history/services/transaction_runner.dart';

final class ClaimService {
  const ClaimService(
    this._claims,
    this._audit,
    this._transactions,
    this._executor,
  );
  final ClaimRepository _claims;
  final AuditService _audit;
  final TransactionRunner _transactions;
  final ClaimOperationExecutor _executor;

  Future<void> create(Claim claim) => _transactions.run(() async {
    await _claims.create(claim);
    await _record(AuditType.claimCreated, claim);
  });

  Future<void> createAll(List<Claim> claims) => _transactions.run(() async {
    for (final claim in claims) {
      await _claims.create(claim);
      await _record(AuditType.claimCreated, claim);
    }
  });

  Future<void> update(Claim claim) => _transactions.run(() async {
    await _claims.update(claim);
    await _record(AuditType.claimUpdated, claim);
  });

  Future<ClaimApplicationResult> acceptAndApply(Claim claim) =>
      _transactions.run(() async {
        if (await _executor.isApplied(claim)) {
          return _executor.apply(claim);
        }
        final accepted = claim.copyWith(
          status: ClaimStatus.accepted,
          modifiedAt: DateTime.now().toUtc(),
        );
        await _claims.update(accepted);
        final result = await _executor.apply(accepted);
        await _audit.record(
          type: AuditType.claimApplied,
          payload: {
            'property': accepted.property.name,
            'valueType': accepted.value.type,
            'resultEntityType': result.entityType,
            'resultEntityId': result.entityId,
          },
          targets: [
            AuditTarget(
              entityType: 'CLAIM',
              entityId: accepted.id.value,
              role: 'CLAIM',
            ),
            AuditTarget(
              entityType: result.entityType,
              entityId: result.entityId,
              role: 'MATERIALIZED',
            ),
          ],
        );
        return result;
      });

  Future<bool> isApplied(Claim claim) => _executor.isApplied(claim);

  Future<void> _record(AuditType type, Claim claim) => _audit.record(
    type: type,
    payload: {
      'property': claim.property.name,
      'status': claim.status.name,
      'valueType': claim.value.type,
    },
    targets: [
      AuditTarget(entityType: 'CLAIM', entityId: claim.id.value, role: 'CLAIM'),
      AuditTarget(
        entityType: claim.subjectType.name.toUpperCase(),
        entityId: claim.subjectId,
        role: 'SUBJECT',
      ),
    ],
  );
}
