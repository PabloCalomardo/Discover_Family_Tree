import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/domain/relationship/sibling_relationship.dart';

abstract interface class SiblingRelationshipRepository {
  Stream<List<SiblingRelationship>> watchAll();
  Future<void> create(SiblingRelationship relationship);
  Future<void> update(SiblingRelationship relationship);
  Future<void> delete(SiblingRelationshipId id);
}
