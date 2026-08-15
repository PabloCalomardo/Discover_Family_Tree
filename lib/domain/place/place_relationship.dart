import 'package:family_history/core/errors/domain_validation_exception.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/core/utils/entity_validation.dart';

enum PlaceRelationshipType { locatedIn, sameAs, previouslyKnownAs }

final class PlaceRelationship {
  PlaceRelationship({
    required this.id,
    required this.sourcePlaceId,
    required this.targetPlaceId,
    required this.type,
    required this.createdAt,
    required this.modifiedAt,
    this.deletedAt,
  }) {
    if (sourcePlaceId == targetPlaceId) {
      throw const DomainValidationException(
        DomainValidationCode.invalidEntity,
        'A place cannot be related to itself.',
      );
    }
    validateEntityTimestamps(
      createdAt: createdAt,
      modifiedAt: modifiedAt,
      deletedAt: deletedAt,
    );
  }

  final PlaceRelationshipId id;
  final PlaceId sourcePlaceId;
  final PlaceId targetPlaceId;
  final PlaceRelationshipType type;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final DateTime? deletedAt;

  bool get isDeleted => deletedAt != null;

  bool isEquivalentTo(PlaceRelationship other) {
    if (type != other.type) return false;
    if (type == PlaceRelationshipType.sameAs) {
      return (sourcePlaceId == other.sourcePlaceId &&
              targetPlaceId == other.targetPlaceId) ||
          (sourcePlaceId == other.targetPlaceId &&
              targetPlaceId == other.sourcePlaceId);
    }
    return sourcePlaceId == other.sourcePlaceId &&
        targetPlaceId == other.targetPlaceId;
  }
}
