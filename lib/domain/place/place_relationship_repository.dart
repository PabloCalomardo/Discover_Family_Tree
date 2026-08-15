import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/domain/place/place_relationship.dart';

abstract interface class PlaceRelationshipRepository {
  Stream<List<PlaceRelationship>> watchAll();
  Future<void> create(PlaceRelationship relationship);
  Future<void> update(PlaceRelationship relationship);
  Future<void> delete(PlaceRelationshipId id);
}
