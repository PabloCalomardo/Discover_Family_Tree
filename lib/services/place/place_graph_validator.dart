import 'package:family_history/core/errors/domain_validation_exception.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/domain/place/place_relationship.dart';

final class PlaceGraphValidator {
  const PlaceGraphValidator();

  void validateCanAdd(
    Iterable<PlaceRelationship> existing,
    PlaceRelationship candidate,
  ) {
    if (candidate.isDeleted) return;

    final active = existing.where((relationship) => !relationship.isDeleted);
    if (active.any(candidate.isEquivalentTo)) {
      throw const DomainValidationException(
        DomainValidationCode.duplicatePlaceRelationship,
        'The same active place relationship already exists.',
      );
    }
    validate([...active, candidate]);
  }

  void validate(Iterable<PlaceRelationship> relationships) {
    final containersByPlace = <PlaceId, Set<PlaceId>>{};
    for (final relationship in relationships) {
      if (relationship.isDeleted ||
          relationship.type != PlaceRelationshipType.locatedIn) {
        continue;
      }
      containersByPlace
          .putIfAbsent(relationship.sourcePlaceId, () => <PlaceId>{})
          .add(relationship.targetPlaceId);
    }

    final visiting = <PlaceId>{};
    final visited = <PlaceId>{};

    bool hasCycle(PlaceId place) {
      if (visiting.contains(place)) return true;
      if (visited.contains(place)) return false;

      visiting.add(place);
      for (final container in containersByPlace[place] ?? const <PlaceId>{}) {
        if (hasCycle(container)) return true;
      }
      visiting.remove(place);
      visited.add(place);
      return false;
    }

    for (final place in containersByPlace.keys) {
      if (hasCycle(place)) {
        throw const DomainValidationException(
          DomainValidationCode.placeHierarchyCycle,
          'LOCATED_IN place relationships cannot form a cycle.',
        );
      }
    }
  }
}
