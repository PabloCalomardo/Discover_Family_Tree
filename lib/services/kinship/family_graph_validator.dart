import 'package:family_history/core/errors/domain_validation_exception.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/domain/relationship/parent_child_relationship.dart';

final class FamilyGraphValidator {
  const FamilyGraphValidator();

  void validateCanAdd(
    Iterable<ParentChildRelationship> existing,
    ParentChildRelationship candidate,
  ) {
    if (candidate.isDeleted) {
      return;
    }

    final active = existing.where((relationship) => !relationship.isDeleted);
    final isDuplicate = active.any(
      (relationship) =>
          relationship.parentId == candidate.parentId &&
          relationship.childId == candidate.childId &&
          relationship.nature == candidate.nature,
    );
    if (isDuplicate) {
      throw const DomainValidationException(
        DomainValidationCode.duplicateRelationship,
        'The same active parent-child relationship already exists.',
      );
    }

    validate([...active, candidate]);
  }

  void validate(Iterable<ParentChildRelationship> relationships) {
    final childrenByParent = <PersonId, Set<PersonId>>{};
    for (final relationship in relationships) {
      if (relationship.isDeleted) {
        continue;
      }
      childrenByParent
          .putIfAbsent(relationship.parentId, () => <PersonId>{})
          .add(relationship.childId);
    }

    final visiting = <PersonId>{};
    final visited = <PersonId>{};

    bool hasCycle(PersonId person) {
      if (visiting.contains(person)) {
        return true;
      }
      if (visited.contains(person)) {
        return false;
      }

      visiting.add(person);
      for (final child in childrenByParent[person] ?? const <PersonId>{}) {
        if (hasCycle(child)) {
          return true;
        }
      }
      visiting.remove(person);
      visited.add(person);
      return false;
    }

    for (final person in childrenByParent.keys) {
      if (hasCycle(person)) {
        throw const DomainValidationException(
          DomainValidationCode.parentageCycle,
          'Parent-child relationships cannot form a cycle.',
        );
      }
    }
  }
}
