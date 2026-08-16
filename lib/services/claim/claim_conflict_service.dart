import 'package:family_history/domain/claim/claim.dart';

final class ClaimConflict {
  const ClaimConflict({
    required this.subjectType,
    required this.subjectId,
    required this.property,
    required this.claims,
  });
  final ClaimSubjectType subjectType;
  final String subjectId;
  final ClaimProperty property;
  final List<Claim> claims;
}

final class ClaimConflictService {
  const ClaimConflictService();

  List<ClaimConflict> detect(Iterable<Claim> claims) {
    final eligible = claims.where(
      (claim) =>
          claim.deletedAt == null && claim.status != ClaimStatus.rejected,
    );
    final groups = <String, List<Claim>>{};
    for (final claim in eligible) {
      if (!_isSingleValued(claim.property)) continue;
      final key =
          '${claim.subjectType.name}|${claim.subjectId}|${claim.property.name}';
      groups.putIfAbsent(key, () => []).add(claim);
    }
    final result = <ClaimConflict>[];
    for (final group in groups.values) {
      if (group.length < 2 || !_containsIncompatiblePair(group)) continue;
      final first = group.first;
      result.add(
        ClaimConflict(
          subjectType: first.subjectType,
          subjectId: first.subjectId,
          property: first.property,
          claims: List.unmodifiable(group),
        ),
      );
    }
    return List.unmodifiable(result);
  }

  bool _isSingleValued(ClaimProperty property) => switch (property) {
    ClaimProperty.personSex ||
    ClaimProperty.personBirthDate ||
    ClaimProperty.personDeathDate => true,
    _ => false,
  };

  bool _containsIncompatiblePair(List<Claim> claims) {
    for (var a = 0; a < claims.length; a++) {
      for (var b = a + 1; b < claims.length; b++) {
        if (!_compatible(claims[a].value, claims[b].value)) return true;
      }
    }
    return false;
  }

  bool _compatible(ClaimValue a, ClaimValue b) {
    if (a is EnumClaimValue && b is EnumClaimValue) {
      if (a.value == 'UNKNOWN' || b.value == 'UNKNOWN') return true;
      return a.value == b.value;
    }
    if (a is HistoricalDateClaimValue && b is HistoricalDateClaimValue) {
      final aStart = a.value.startDate;
      final aEnd = a.value.endDate;
      final bStart = b.value.startDate;
      final bEnd = b.value.endDate;
      if (aEnd != null && bStart != null && aEnd.isBefore(bStart)) return false;
      if (bEnd != null && aStart != null && bEnd.isBefore(aStart)) return false;
      return true;
    }
    return a.encode() == b.encode();
  }
}
