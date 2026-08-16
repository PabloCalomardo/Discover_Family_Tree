import 'dart:collection';

import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/domain/relationship/parent_child_relationship.dart';

enum KinshipType {
  parent,
  child,
  sibling,
  grandparent,
  grandchild,
  auntOrUncle,
  nieceOrNephew,
  firstCousin,
  partner,
  relative,
}

enum KinshipNature { biological, adoptive, sibling, partnership }

enum KinshipDirection { towardParent, towardChild }

enum KinshipStepType { parentChild, sibling, partnership }

final class KinshipStep {
  const KinshipStep._({
    required this.from,
    required this.to,
    required this.relationshipId,
    required this.type,
    required this.direction,
    required this.parentChildNature,
  });

  const KinshipStep.parentChild({
    required PersonId from,
    required PersonId to,
    required ParentChildRelationshipId relationshipId,
    required KinshipDirection direction,
    required ParentChildNature nature,
  }) : this._(
         from: from,
         to: to,
         relationshipId: relationshipId,
         type: KinshipStepType.parentChild,
         direction: direction,
         parentChildNature: nature,
       );

  const KinshipStep.partnership({
    required PersonId from,
    required PersonId to,
    required PartnershipId relationshipId,
  }) : this._(
         from: from,
         to: to,
         relationshipId: relationshipId,
         type: KinshipStepType.partnership,
         direction: null,
         parentChildNature: null,
       );

  const KinshipStep.sibling({
    required PersonId from,
    required PersonId to,
    required SiblingRelationshipId relationshipId,
  }) : this._(
         from: from,
         to: to,
         relationshipId: relationshipId,
         type: KinshipStepType.sibling,
         direction: null,
         parentChildNature: null,
       );

  final PersonId from;
  final PersonId to;
  final DomainId relationshipId;
  final KinshipStepType type;
  final KinshipDirection? direction;
  final ParentChildNature? parentChildNature;
}

final class KinshipPath {
  KinshipPath({
    required this.type,
    required this.nature,
    required List<KinshipStep> steps,
  }) : steps = UnmodifiableListView(steps);

  final KinshipType type;
  final KinshipNature nature;
  final UnmodifiableListView<KinshipStep> steps;

  int get length => steps.length;
}
