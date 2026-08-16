import 'package:family_history/domain/claim/claim.dart';

final class ClaimApplicationResult {
  const ClaimApplicationResult({
    required this.entityType,
    required this.entityId,
  });

  final String entityType;
  final String entityId;
}

abstract interface class ClaimOperationExecutor {
  Future<bool> isApplied(Claim claim);
  Future<ClaimApplicationResult> apply(Claim claim);
}
