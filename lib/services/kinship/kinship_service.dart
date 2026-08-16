import 'package:family_history/core/errors/domain_validation_exception.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/domain/relationship/parent_child_relationship.dart';
import 'package:family_history/domain/relationship/partnership.dart';
import 'package:family_history/domain/relationship/sibling_relationship.dart';
import 'package:family_history/services/kinship/family_graph_validator.dart';
import 'package:family_history/services/kinship/kinship_path.dart';

final class KinshipService {
  const KinshipService({this.defaultMaxDepth = 4});

  final int defaultMaxDepth;
  final FamilyGraphValidator _validator = const FamilyGraphValidator();

  List<KinshipPath> getKinship({
    required PersonId source,
    required PersonId target,
    required Iterable<ParentChildRelationship> parentChildRelationships,
    Iterable<Partnership> partnerships = const [],
    Iterable<SiblingRelationship> siblingRelationships = const [],
    int? maxDepth,
  }) {
    if (source == target) {
      return const [];
    }

    final depth = maxDepth ?? defaultMaxDepth;
    if (depth < 1) {
      throw const DomainValidationException(
        DomainValidationCode.invalidEntity,
        'Kinship traversal depth must be at least 1.',
      );
    }

    final activeRelationships = parentChildRelationships
        .where((relationship) => !relationship.isDeleted)
        .toList(growable: false);
    _validator.validate(activeRelationships);

    final adjacency = <PersonId, List<_TraversalEdge>>{};
    for (final relationship in activeRelationships) {
      adjacency
          .putIfAbsent(relationship.parentId, () => [])
          .add(
            _TraversalEdge(
              to: relationship.childId,
              relationship: relationship,
              direction: KinshipDirection.towardChild,
            ),
          );
      adjacency
          .putIfAbsent(relationship.childId, () => [])
          .add(
            _TraversalEdge(
              to: relationship.parentId,
              relationship: relationship,
              direction: KinshipDirection.towardParent,
            ),
          );
    }

    final results = <KinshipPath>[];

    void traverse(
      PersonId current,
      Set<PersonId> visited,
      List<KinshipStep> steps,
    ) {
      if (current == target) {
        results.add(_pathFromSteps(steps));
        return;
      }
      if (steps.length == depth) {
        return;
      }

      for (final edge in adjacency[current] ?? const <_TraversalEdge>[]) {
        if (visited.contains(edge.to)) {
          continue;
        }
        final nextStep = KinshipStep.parentChild(
          from: current,
          to: edge.to,
          relationshipId: edge.relationship.id,
          direction: edge.direction,
          nature: edge.relationship.nature,
        );
        traverse(edge.to, {...visited, edge.to}, [...steps, nextStep]);
      }
    }

    traverse(source, {source}, const []);

    for (final partnership in partnerships.where(
      (partnership) =>
          !partnership.isDeleted && partnership.connects(source, target),
    )) {
      results.add(
        KinshipPath(
          type: KinshipType.partner,
          nature: KinshipNature.partnership,
          steps: [
            KinshipStep.partnership(
              from: source,
              to: target,
              relationshipId: partnership.id,
            ),
          ],
        ),
      );
    }

    for (final sibling in siblingRelationships.where(
      (relationship) =>
          !relationship.isDeleted &&
          relationship.involves(source) &&
          relationship.involves(target),
    )) {
      results.add(
        KinshipPath(
          type: KinshipType.sibling,
          nature: KinshipNature.sibling,
          steps: [
            KinshipStep.sibling(
              from: source,
              to: target,
              relationshipId: sibling.id,
            ),
          ],
        ),
      );
    }

    results.sort((first, second) {
      final lengthComparison = first.length.compareTo(second.length);
      return lengthComparison != 0
          ? lengthComparison
          : first.type.index.compareTo(second.type.index);
    });
    return List.unmodifiable(results);
  }

  KinshipPath _pathFromSteps(List<KinshipStep> steps) {
    final directions = steps
        .map((step) => step.direction!)
        .toList(growable: false);
    final nature =
        steps.any(
          (step) => step.parentChildNature == ParentChildNature.adoptive,
        )
        ? KinshipNature.adoptive
        : KinshipNature.biological;

    return KinshipPath(
      type: _classify(directions),
      nature: nature,
      steps: steps,
    );
  }

  KinshipType _classify(List<KinshipDirection> directions) {
    const up = KinshipDirection.towardParent;
    const down = KinshipDirection.towardChild;

    if (_matches(directions, const [down])) return KinshipType.parent;
    if (_matches(directions, const [up])) return KinshipType.child;
    if (_matches(directions, const [up, down])) return KinshipType.sibling;
    if (_matches(directions, const [down, down])) {
      return KinshipType.grandparent;
    }
    if (_matches(directions, const [up, up])) return KinshipType.grandchild;
    if (_matches(directions, const [up, down, down])) {
      return KinshipType.auntOrUncle;
    }
    if (_matches(directions, const [up, up, down])) {
      return KinshipType.nieceOrNephew;
    }
    if (_matches(directions, const [up, up, down, down])) {
      return KinshipType.firstCousin;
    }
    return KinshipType.relative;
  }

  bool _matches(
    List<KinshipDirection> actual,
    List<KinshipDirection> expected,
  ) {
    if (actual.length != expected.length) {
      return false;
    }
    for (var index = 0; index < actual.length; index++) {
      if (actual[index] != expected[index]) {
        return false;
      }
    }
    return true;
  }
}

final class _TraversalEdge {
  const _TraversalEdge({
    required this.to,
    required this.relationship,
    required this.direction,
  });

  final PersonId to;
  final ParentChildRelationship relationship;
  final KinshipDirection direction;
}
