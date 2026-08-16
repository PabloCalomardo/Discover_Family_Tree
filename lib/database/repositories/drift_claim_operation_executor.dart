import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/database/database.dart' as db;
import 'package:family_history/database/mappers/enum_mapping.dart';
import 'package:family_history/domain/claim/claim.dart';
import 'package:family_history/domain/event/event.dart';
import 'package:family_history/domain/event/event_participant.dart';
import 'package:family_history/domain/event/event_repository.dart';
import 'package:family_history/domain/person/person.dart';
import 'package:family_history/domain/person/person_name.dart';
import 'package:family_history/domain/person/person_repository.dart';
import 'package:family_history/domain/place/place.dart';
import 'package:family_history/domain/place/residence.dart';
import 'package:family_history/domain/place/residence_repository.dart';
import 'package:family_history/domain/place/place_repository.dart';
import 'package:family_history/domain/relationship/parent_child_relationship.dart';
import 'package:family_history/domain/relationship/parent_child_relationship_repository.dart';
import 'package:family_history/domain/relationship/partnership.dart';
import 'package:family_history/domain/relationship/partnership_repository.dart';
import 'package:family_history/services/claim/claim_operation_executor.dart';

final class DriftClaimOperationExecutor implements ClaimOperationExecutor {
  const DriftClaimOperationExecutor(
    this._database,
    this._people,
    this._places,
    this._parentChild,
    this._partnerships,
    this._residences,
    this._events,
  );

  final db.AppDatabase _database;
  final PersonRepository _people;
  final PlaceRepository _places;
  final ParentChildRelationshipRepository _parentChild;
  final PartnershipRepository _partnerships;
  final ResidenceRepository _residences;
  final EventRepository _events;

  @override
  Future<bool> isApplied(Claim claim) async =>
      await (_database.select(_database.claimApplications)
            ..where((row) => row.claimId.equals(claim.id.value)))
          .getSingleOrNull() !=
      null;

  @override
  Future<ClaimApplicationResult> apply(Claim claim) async {
    final existing = await (_database.select(
      _database.claimApplications,
    )..where((row) => row.claimId.equals(claim.id.value))).getSingleOrNull();
    if (existing != null) {
      return ClaimApplicationResult(
        entityType: existing.resultEntityType,
        entityId: existing.resultEntityId,
      );
    }

    final now = DateTime.now().toUtc();
    final result = await _materialize(claim, now);
    await _database
        .into(_database.claimApplications)
        .insert(
          db.ClaimApplicationsCompanion.insert(
            claimId: claim.id.value,
            operationType: claim.property.name,
            resultEntityType: result.entityType,
            resultEntityId: result.entityId,
            appliedAt: now,
            payloadJson: jsonEncode({
              'claimId': claim.id.value,
              'valueType': claim.value.type,
            }),
          ),
        );
    return result;
  }

  Future<ClaimApplicationResult> _materialize(Claim claim, DateTime now) async {
    final value = claim.value;
    switch (claim.property) {
      case ClaimProperty.personCreation:
        final creation = value as PersonCreationClaimValue;
        await _people.create(
          Person(
            id: creation.personId,
            sex: creation.sex,
            birthDate: creation.birthDate,
            deathDate: creation.deathDate,
            biography: creation.biography,
            notes: creation.notes,
            createdAt: now,
            modifiedAt: now,
          ),
        );
        await _database
            .into(_database.personNames)
            .insert(
              db.PersonNamesCompanion.insert(
                id: PersonNameId.generate().value,
                personId: creation.personId.value,
                displayName: creation.preferredName.trim(),
                type: enumToSql(PersonNameType.other),
                isPreferred: const Value(true),
                createdAt: now,
                modifiedAt: now,
              ),
            );
        return ClaimApplicationResult(
          entityType: 'PERSON',
          entityId: creation.personId.value,
        );
      case ClaimProperty.personPreferredName:
        final personId = PersonId(claim.subjectId);
        await (_database.update(_database.personNames)..where(
              (row) =>
                  row.personId.equals(personId.value) &
                  row.isPreferred.equals(true) &
                  row.deletedAt.isNull(),
            ))
            .write(
              db.PersonNamesCompanion(
                isPreferred: const Value(false),
                modifiedAt: Value(now),
              ),
            );
        final nameId = PersonNameId.generate();
        await _database
            .into(_database.personNames)
            .insert(
              db.PersonNamesCompanion.insert(
                id: nameId.value,
                personId: personId.value,
                displayName: (value as TextClaimValue).value,
                type: enumToSql(PersonNameType.other),
                isPreferred: const Value(true),
                createdAt: now,
                modifiedAt: now,
              ),
            );
        return ClaimApplicationResult(
          entityType: 'PERSON_NAME',
          entityId: nameId.value,
        );
      case ClaimProperty.personSex:
      case ClaimProperty.personBirthDate:
      case ClaimProperty.personDeathDate:
      case ClaimProperty.personBiography:
      case ClaimProperty.personNotes:
        final person = await _requiredPerson(PersonId(claim.subjectId));
        await _people.update(
          Person(
            id: person.id,
            sex: claim.property == ClaimProperty.personSex
                ? PersonSex.values.byName(
                    (value as EnumClaimValue).value.toLowerCase(),
                  )
                : person.sex,
            birthDate: claim.property == ClaimProperty.personBirthDate
                ? (value as HistoricalDateClaimValue).value
                : person.birthDate,
            deathDate: claim.property == ClaimProperty.personDeathDate
                ? (value as HistoricalDateClaimValue).value
                : person.deathDate,
            biography: claim.property == ClaimProperty.personBiography
                ? (value as TextClaimValue).value
                : person.biography,
            notes: claim.property == ClaimProperty.personNotes
                ? (value as TextClaimValue).value
                : person.notes,
            createdAt: person.createdAt,
            modifiedAt: now,
            deletedAt: person.deletedAt,
          ),
        );
        return ClaimApplicationResult(
          entityType: 'PERSON',
          entityId: person.id.value,
        );
      case ClaimProperty.placeCreation:
        final creation = value as PlaceCreationClaimValue;
        await _places.create(
          Place(
            id: creation.placeId,
            preferredName: creation.preferredName,
            type: creation.placeType,
            latitude: creation.latitude,
            longitude: creation.longitude,
            description: creation.description,
            notes: creation.notes,
            createdAt: now,
            modifiedAt: now,
          ),
        );
        return ClaimApplicationResult(
          entityType: 'PLACE',
          entityId: creation.placeId.value,
        );
      case ClaimProperty.placePreferredName:
      case ClaimProperty.placeType:
      case ClaimProperty.placeCoordinates:
      case ClaimProperty.placeDescription:
      case ClaimProperty.placeNotes:
        final place = await _requiredPlace(PlaceId(claim.subjectId));
        final coordinates = value is CoordinatesClaimValue ? value : null;
        await _places.update(
          Place(
            id: place.id,
            preferredName: claim.property == ClaimProperty.placePreferredName
                ? (value as TextClaimValue).value
                : place.preferredName,
            type: claim.property == ClaimProperty.placeType
                ? PlaceType.values.byName(
                    (value as EnumClaimValue).value.toLowerCase(),
                  )
                : place.type,
            latitude: coordinates?.latitude ?? place.latitude,
            longitude: coordinates?.longitude ?? place.longitude,
            description: claim.property == ClaimProperty.placeDescription
                ? (value as TextClaimValue).value
                : place.description,
            notes: claim.property == ClaimProperty.placeNotes
                ? (value as TextClaimValue).value
                : place.notes,
            createdAt: place.createdAt,
            modifiedAt: now,
            deletedAt: place.deletedAt,
          ),
        );
        return ClaimApplicationResult(
          entityType: 'PLACE',
          entityId: place.id.value,
        );
      case ClaimProperty.parentChildRelationship:
        final relation = value as ParentChildClaimValue;
        await _parentChild.create(
          ParentChildRelationship(
            id: relation.relationshipId,
            parentId: relation.parentId,
            childId: relation.childId,
            nature: relation.nature,
            notes: relation.notes,
            createdAt: now,
            modifiedAt: now,
          ),
        );
        return ClaimApplicationResult(
          entityType: 'PARENT_CHILD_RELATIONSHIP',
          entityId: relation.relationshipId.value,
        );
      case ClaimProperty.partnership:
        final partnership = value as PartnershipClaimValue;
        await _partnerships.create(
          Partnership(
            id: partnership.partnershipId,
            personAId: partnership.personAId,
            personBId: partnership.personBId,
            type: partnership.partnershipType,
            placeId: partnership.placeId,
            notes: partnership.notes,
            createdAt: now,
            modifiedAt: now,
          ),
        );
        return ClaimApplicationResult(
          entityType: 'PARTNERSHIP',
          entityId: partnership.partnershipId.value,
        );
      case ClaimProperty.residence:
        final residence = value as ResidenceClaimValue;
        await _residences.create(
          Residence(
            id: residence.residenceId,
            personId: residence.personId,
            placeId: residence.placeId,
            startDate: residence.startDate,
            endDate: residence.endDate,
            reason: residence.reason,
            notes: residence.notes,
            createdAt: now,
            modifiedAt: now,
          ),
        );
        return ClaimApplicationResult(
          entityType: 'RESIDENCE',
          entityId: residence.residenceId.value,
        );
      case ClaimProperty.event:
        final event = value as EventClaimValue;
        await _events.create(
          FamilyEvent(
            id: event.eventId,
            type: event.eventType,
            date: event.date,
            placeId: event.placeId,
            title: event.title,
            description: event.description,
            createdAt: now,
            modifiedAt: now,
          ),
        );
        await _events.addParticipant(
          EventParticipant(
            id: EventParticipantId.generate(),
            eventId: event.eventId,
            personId: event.participantId,
            role: event.participantRole,
            createdAt: now,
            modifiedAt: now,
          ),
        );
        return ClaimApplicationResult(
          entityType: 'EVENT',
          entityId: event.eventId.value,
        );
    }
  }

  Future<Person> _requiredPerson(PersonId id) async {
    final person = await _people.get(id);
    if (person == null) throw StateError('Claim person does not exist.');
    return person;
  }

  Future<Place> _requiredPlace(PlaceId id) async {
    final place = await _places.get(id);
    if (place == null) throw StateError('Claim place does not exist.');
    return place;
  }
}
