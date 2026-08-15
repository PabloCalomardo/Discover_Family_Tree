import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/domain/relationship/parent_child_relationship.dart';
import 'package:family_history/domain/relationship/partnership.dart';
import 'package:family_history/domain/place/place.dart';

final testTimestamp = DateTime.utc(2026, 8, 14);

PersonId personId(int value) => PersonId(_uuid(value));

PlaceId placeId(int value) => PlaceId(_uuid(value));

EventId eventId(int value) => EventId(_uuid(value));

Place place({required int id, required String name}) => Place(
  id: placeId(id),
  preferredName: name,
  type: PlaceType.house,
  createdAt: testTimestamp,
  modifiedAt: testTimestamp,
);

ParentChildRelationship relationship({
  required int id,
  required PersonId parent,
  required PersonId child,
  ParentChildNature nature = ParentChildNature.biological,
  DateTime? deletedAt,
}) => ParentChildRelationship(
  id: ParentChildRelationshipId(_uuid(id)),
  parentId: parent,
  childId: child,
  nature: nature,
  createdAt: testTimestamp,
  modifiedAt: testTimestamp,
  deletedAt: deletedAt,
);

Partnership partnership({
  required int id,
  required PersonId personA,
  required PersonId personB,
}) => Partnership(
  id: PartnershipId(_uuid(id)),
  personAId: personA,
  personBId: personB,
  type: PartnershipType.marriage,
  createdAt: testTimestamp,
  modifiedAt: testTimestamp,
);

String _uuid(int value) {
  final suffix = value.toRadixString(16).padLeft(12, '0');
  return '00000000-0000-4000-8000-$suffix';
}
