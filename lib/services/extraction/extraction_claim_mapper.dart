import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/domain/claim/claim.dart';
import 'package:family_history/domain/event/event_participant.dart';
import 'package:family_history/domain/extraction/extraction.dart';
import 'package:family_history/domain/relationship/parent_child_relationship.dart';
import 'package:family_history/domain/relationship/partnership.dart';
import 'package:family_history/domain/relationship/sibling_relationship.dart';

final class ExtractionClaimMapper {
  const ExtractionClaimMapper();

  List<Claim> map({
    required ExtractionResult extraction,
    required SourceId sourceId,
    required Set<String> selectedRefs,
    DateTime? now,
  }) {
    final timestamp = now ?? DateTime.now().toUtc();
    final ambiguousPeople = extraction.people
        .where((item) => item.resolutionAmbiguous)
        .map((item) => item.ref)
        .toSet();
    final unnamedPeople = extraction.people
        .where((item) => item.requiresName)
        .map((item) => item.ref)
        .toSet();
    final ambiguousPlaces = extraction.places
        .where((item) => item.resolutionAmbiguous)
        .map((item) => item.ref)
        .toSet();
    final personIds = {
      for (final person in extraction.people)
        person.ref: person.resolvedId ?? PersonId.generate(),
    };
    final placeIds = {
      for (final place in extraction.places)
        place.ref: place.resolvedId ?? PlaceId.generate(),
    };

    final requiredPeople = <String>{
      ...extraction.people
          .where((item) => selectedRefs.contains(item.ref))
          .map((item) => item.ref),
    };
    final requiredPlaces = <String>{
      ...extraction.places
          .where((item) => selectedRefs.contains(item.ref))
          .map((item) => item.ref),
    };
    for (final relationship in extraction.relationships.where(
      (item) => selectedRefs.contains(item.ref),
    )) {
      requiredPeople.addAll([relationship.personARef, relationship.personBRef]);
      if (relationship.placeRef != null) {
        requiredPlaces.add(relationship.placeRef!);
      }
    }
    for (final residence in extraction.residences.where(
      (item) => selectedRefs.contains(item.ref),
    )) {
      requiredPeople.add(residence.personRef);
      requiredPlaces.add(residence.placeRef);
    }
    for (final event in extraction.events.where(
      (item) => selectedRefs.contains(item.ref),
    )) {
      requiredPeople.add(event.personRef);
      if (event.placeRef != null) requiredPlaces.add(event.placeRef!);
    }
    if (requiredPeople.any(ambiguousPeople.contains) ||
        requiredPeople.any(unnamedPeople.contains) ||
        requiredPlaces.any(ambiguousPlaces.contains)) {
      throw StateError(
        'Cal identificar totes les persones i resoldre les coincidències '
        'múltiples abans de crear afirmacions.',
      );
    }

    final claims = <Claim>[];
    for (final person in extraction.people) {
      if (!requiredPeople.contains(person.ref) || person.resolvedId != null) {
        continue;
      }
      final id = personIds[person.ref]!;
      claims.add(
        _claim(
          sourceId: sourceId,
          subjectType: ClaimSubjectType.person,
          subjectId: id.value,
          property: ClaimProperty.personCreation,
          value: PersonCreationClaimValue(
            personId: id,
            preferredName: person.displayName,
            sex: person.sex,
          ),
          evidence: person.evidence,
          confidence: person.uncertain ? 0.5 : 1,
          now: timestamp,
        ),
      );
    }
    for (final place in extraction.places) {
      if (!requiredPlaces.contains(place.ref) || place.resolvedId != null) {
        continue;
      }
      final id = placeIds[place.ref]!;
      claims.add(
        _claim(
          sourceId: sourceId,
          subjectType: ClaimSubjectType.place,
          subjectId: id.value,
          property: ClaimProperty.placeCreation,
          value: PlaceCreationClaimValue(
            placeId: id,
            preferredName: place.preferredName,
            placeType: place.type,
          ),
          evidence: place.evidence,
          confidence: 1,
          now: timestamp,
        ),
      );
    }
    for (final relationship in extraction.relationships.where(
      (item) => selectedRefs.contains(item.ref),
    )) {
      final personA = personIds[relationship.personARef]!;
      final personB = personIds[relationship.personBRef]!;
      switch (relationship.type) {
        case CandidateRelationshipType.parentChild:
          final id = ParentChildRelationshipId.generate();
          claims.add(
            _claim(
              sourceId: sourceId,
              subjectType: ClaimSubjectType.relationship,
              subjectId: id.value,
              property: ClaimProperty.parentChildRelationship,
              value: ParentChildClaimValue(
                relationshipId: id,
                parentId: personA,
                childId: personB,
                nature: ParentChildNature.biological,
              ),
              evidence: relationship.evidence,
              confidence: relationship.uncertain ? 0.5 : 1,
              now: timestamp,
            ),
          );
          break;
        case CandidateRelationshipType.partnership:
          final id = PartnershipId.generate();
          claims.add(
            _claim(
              sourceId: sourceId,
              subjectType: ClaimSubjectType.relationship,
              subjectId: id.value,
              property: ClaimProperty.partnership,
              value: PartnershipClaimValue(
                partnershipId: id,
                personAId: personA,
                personBId: personB,
                partnershipType: PartnershipType.marriage,
                placeId: relationship.placeRef == null
                    ? null
                    : placeIds[relationship.placeRef!],
              ),
              evidence: relationship.evidence,
              confidence: relationship.uncertain ? 0.5 : 1,
              now: timestamp,
            ),
          );
          break;
        case CandidateRelationshipType.sibling:
          final id = SiblingRelationshipId.generate();
          claims.add(
            _claim(
              sourceId: sourceId,
              subjectType: ClaimSubjectType.relationship,
              subjectId: id.value,
              property: ClaimProperty.siblingRelationship,
              value: SiblingClaimValue(
                relationshipId: id,
                personAId: personA,
                personBId: personB,
                kind: SiblingKind.unspecified,
              ),
              evidence: relationship.evidence,
              confidence: relationship.uncertain ? 0.5 : 1,
              now: timestamp,
            ),
          );
          break;
      }
    }
    for (final residence in extraction.residences.where(
      (item) => selectedRefs.contains(item.ref),
    )) {
      final id = ResidenceId.generate();
      claims.add(
        _claim(
          sourceId: sourceId,
          subjectType: ClaimSubjectType.residence,
          subjectId: id.value,
          property: ClaimProperty.residence,
          value: ResidenceClaimValue(
            residenceId: id,
            personId: personIds[residence.personRef]!,
            placeId: placeIds[residence.placeRef]!,
            startDate: residence.startDate,
            endDate: residence.endDate,
          ),
          evidence: residence.evidence,
          confidence: residence.uncertain ? 0.5 : 1,
          now: timestamp,
        ),
      );
    }
    for (final event in extraction.events.where(
      (item) => selectedRefs.contains(item.ref),
    )) {
      final id = EventId.generate();
      claims.add(
        _claim(
          sourceId: sourceId,
          subjectType: ClaimSubjectType.event,
          subjectId: id.value,
          property: ClaimProperty.event,
          value: EventClaimValue(
            eventId: id,
            eventType: event.type,
            participantId: personIds[event.personRef]!,
            participantRole: EventParticipantRole.subject,
            date: event.date,
            placeId: event.placeRef == null ? null : placeIds[event.placeRef!],
            title: event.title,
          ),
          evidence: event.evidence,
          confidence: event.uncertain ? 0.5 : 1,
          now: timestamp,
        ),
      );
    }
    return claims;
  }

  Claim _claim({
    required SourceId sourceId,
    required ClaimSubjectType subjectType,
    required String subjectId,
    required ClaimProperty property,
    required ClaimValue value,
    required String evidence,
    required double confidence,
    required DateTime now,
  }) => Claim(
    id: ClaimId.generate(),
    subjectType: subjectType,
    subjectId: subjectId,
    property: property,
    value: value,
    sourceId: sourceId,
    sourceLocator: 'Text: «${evidence.trim()}»',
    confidence: confidence,
    status: ClaimStatus.unreviewed,
    createdAt: now,
    modifiedAt: now,
  );
}
