import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/domain/relationship/parent_child_relationship.dart';

abstract interface class ParentChildRelationshipRepository {
  Stream<List<ParentChildRelationship>> watchAll();
  Future<void> create(ParentChildRelationship relationship);
  Future<void> update(ParentChildRelationship relationship);
  Future<void> delete(ParentChildRelationshipId id);
}
