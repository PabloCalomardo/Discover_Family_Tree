import 'package:drift/drift.dart';

@TableIndex(name: 'person_names_person_id', columns: {#personId})
@TableIndex.sql(
  'CREATE UNIQUE INDEX person_names_one_preferred_active '
  'ON person_names (person_id) '
  'WHERE is_preferred = 1 AND deleted_at IS NULL',
)
class PersonNames extends Table {
  TextColumn get id => text()();
  TextColumn get personId => text().references(Persons, #id)();
  TextColumn get givenNames => text().nullable()();
  TextColumn get familyNames => text().nullable()();
  TextColumn get displayName => text()();
  TextColumn get type => text()();
  BoolColumn get isPreferred => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get modifiedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Persons extends Table {
  TextColumn get id => text()();
  TextColumn get sex => text()();
  TextColumn get birthPrecision => text().nullable()();
  DateTimeColumn get birthStartDate => dateTime().nullable()();
  DateTimeColumn get birthEndDate => dateTime().nullable()();
  TextColumn get birthDisplayText => text().nullable()();
  TextColumn get deathPrecision => text().nullable()();
  DateTimeColumn get deathStartDate => dateTime().nullable()();
  DateTimeColumn get deathEndDate => dateTime().nullable()();
  TextColumn get deathDisplayText => text().nullable()();
  TextColumn get biography => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get modifiedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@TableIndex(name: 'parent_child_parent_id', columns: {#parentPersonId})
@TableIndex(name: 'parent_child_child_id', columns: {#childPersonId})
@TableIndex.sql(
  'CREATE UNIQUE INDEX parent_child_unique_active '
  'ON parent_child_relationships '
  '(parent_person_id, child_person_id, nature) '
  'WHERE deleted_at IS NULL',
)
class ParentChildRelationships extends Table {
  TextColumn get id => text()();
  @ReferenceName('childrenRelationships')
  TextColumn get parentPersonId => text().references(Persons, #id)();
  @ReferenceName('parentRelationships')
  TextColumn get childPersonId => text().references(Persons, #id)();
  TextColumn get nature => text()();
  TextColumn get startPrecision => text().nullable()();
  DateTimeColumn get startStartDate => dateTime().nullable()();
  DateTimeColumn get startEndDate => dateTime().nullable()();
  TextColumn get startDisplayText => text().nullable()();
  TextColumn get endPrecision => text().nullable()();
  DateTimeColumn get endStartDate => dateTime().nullable()();
  DateTimeColumn get endEndDate => dateTime().nullable()();
  TextColumn get endDisplayText => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get modifiedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
    'CHECK (parent_person_id <> child_person_id)',
  ];
}

@TableIndex(name: 'partnerships_person_a_id', columns: {#personAId})
@TableIndex(name: 'partnerships_person_b_id', columns: {#personBId})
class Partnerships extends Table {
  TextColumn get id => text()();
  @ReferenceName('partnershipsAsPersonA')
  TextColumn get personAId => text().references(Persons, #id)();
  @ReferenceName('partnershipsAsPersonB')
  TextColumn get personBId => text().references(Persons, #id)();
  TextColumn get type => text()();
  TextColumn get startPrecision => text().nullable()();
  DateTimeColumn get startStartDate => dateTime().nullable()();
  DateTimeColumn get startEndDate => dateTime().nullable()();
  TextColumn get startDisplayText => text().nullable()();
  TextColumn get endPrecision => text().nullable()();
  DateTimeColumn get endStartDate => dateTime().nullable()();
  DateTimeColumn get endEndDate => dateTime().nullable()();
  TextColumn get endDisplayText => text().nullable()();
  TextColumn get placeId => text().nullable().references(Places, #id)();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get modifiedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => ['CHECK (person_a_id <> person_b_id)'];
}

class Places extends Table {
  TextColumn get id => text()();
  TextColumn get preferredName => text()();
  TextColumn get type => text()();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get modifiedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
    'CHECK ((latitude IS NULL) = (longitude IS NULL))',
    'CHECK (latitude IS NULL OR latitude BETWEEN -90 AND 90)',
    'CHECK (longitude IS NULL OR longitude BETWEEN -180 AND 180)',
  ];
}

@TableIndex(name: 'place_relationships_source_id', columns: {#sourcePlaceId})
@TableIndex(name: 'place_relationships_target_id', columns: {#targetPlaceId})
class PlaceRelationships extends Table {
  TextColumn get id => text()();
  @ReferenceName('outgoingPlaceRelationships')
  TextColumn get sourcePlaceId => text().references(Places, #id)();
  @ReferenceName('incomingPlaceRelationships')
  TextColumn get targetPlaceId => text().references(Places, #id)();
  TextColumn get type => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get modifiedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
    'CHECK (source_place_id <> target_place_id)',
  ];
}

@TableIndex(name: 'residences_person_id', columns: {#personId})
@TableIndex(name: 'residences_place_id', columns: {#placeId})
class Residences extends Table {
  TextColumn get id => text()();
  TextColumn get personId => text().references(Persons, #id)();
  TextColumn get placeId => text().references(Places, #id)();
  TextColumn get startPrecision => text().nullable()();
  DateTimeColumn get startStartDate => dateTime().nullable()();
  DateTimeColumn get startEndDate => dateTime().nullable()();
  TextColumn get startDisplayText => text().nullable()();
  TextColumn get endPrecision => text().nullable()();
  DateTimeColumn get endStartDate => dateTime().nullable()();
  DateTimeColumn get endEndDate => dateTime().nullable()();
  TextColumn get endDisplayText => text().nullable()();
  TextColumn get reason => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get modifiedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@TableIndex(name: 'events_place_id', columns: {#placeId})
class Events extends Table {
  TextColumn get id => text()();
  TextColumn get type => text()();
  TextColumn get datePrecision => text().nullable()();
  DateTimeColumn get dateStartDate => dateTime().nullable()();
  DateTimeColumn get dateEndDate => dateTime().nullable()();
  TextColumn get dateDisplayText => text().nullable()();
  TextColumn get placeId => text().nullable().references(Places, #id)();
  TextColumn get title => text().nullable()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get modifiedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@TableIndex(name: 'event_participants_event_id', columns: {#eventId})
@TableIndex(name: 'event_participants_person_id', columns: {#personId})
class EventParticipants extends Table {
  TextColumn get id => text()();
  TextColumn get eventId => text().references(Events, #id)();
  TextColumn get personId => text().references(Persons, #id)();
  TextColumn get role => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get modifiedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
