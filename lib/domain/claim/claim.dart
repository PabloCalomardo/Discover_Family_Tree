import 'dart:convert';

import 'package:family_history/core/dates/historical_date.dart';
import 'package:family_history/core/errors/domain_validation_exception.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/core/utils/entity_validation.dart';
import 'package:family_history/domain/event/event.dart';
import 'package:family_history/domain/event/event_participant.dart';
import 'package:family_history/domain/person/person.dart';
import 'package:family_history/domain/place/place.dart';
import 'package:family_history/domain/relationship/parent_child_relationship.dart';
import 'package:family_history/domain/relationship/partnership.dart';

enum ClaimSubjectType { person, place, event, residence, relationship }

enum ClaimProperty {
  personCreation,
  personPreferredName,
  personSex,
  personBirthDate,
  personDeathDate,
  personBiography,
  personNotes,
  placeCreation,
  placePreferredName,
  placeType,
  placeCoordinates,
  placeDescription,
  placeNotes,
  parentChildRelationship,
  partnership,
  residence,
  event,
}

enum ClaimStatus { unreviewed, accepted, disputed, rejected }

sealed class ClaimValue {
  const ClaimValue();

  String get type;
  Map<String, Object?> toJson();

  String encode() => jsonEncode(toJson());

  static ClaimValue decode(String type, String source) {
    final value = jsonDecode(source);
    if (value is! Map) {
      throw const FormatException('Claim value must be a JSON object.');
    }
    final json = value.cast<String, Object?>();
    return switch (type) {
      'TEXT' => TextClaimValue(json['value']! as String),
      'ENUM' => EnumClaimValue(json['value']! as String),
      'HISTORICAL_DATE' => HistoricalDateClaimValue.fromJson(json),
      'PERSON_REFERENCE' => PersonReferenceClaimValue(
        PersonId(json['personId']! as String),
      ),
      'RELATIONSHIP' => RelationshipClaimValue(
        personId: PersonId(json['personId']! as String),
        relationshipType: json['relationshipType']! as String,
      ),
      'PERSON_CREATION' => PersonCreationClaimValue.fromJson(json),
      'PLACE_CREATION' => PlaceCreationClaimValue.fromJson(json),
      'PARENT_CHILD' => ParentChildClaimValue.fromJson(json),
      'PARTNERSHIP' => PartnershipClaimValue.fromJson(json),
      'RESIDENCE' => ResidenceClaimValue.fromJson(json),
      'EVENT' => EventClaimValue.fromJson(json),
      'COORDINATES' => CoordinatesClaimValue(
        latitude: (json['latitude']! as num).toDouble(),
        longitude: (json['longitude']! as num).toDouble(),
      ),
      _ => throw FormatException('Unknown claim value type: $type'),
    };
  }
}

Map<String, Object?> _historicalDateJson(HistoricalDate value) => {
  'precision': value.precision.name,
  'start': value.startDate?.toIso8601String(),
  'end': value.endDate?.toIso8601String(),
  'displayText': value.displayText,
};

HistoricalDate? _historicalDateFromJson(Object? value) {
  if (value == null) return null;
  return HistoricalDateClaimValue.fromJson(
    (value as Map).cast<String, Object?>(),
  ).value;
}

final class TextClaimValue extends ClaimValue {
  TextClaimValue(String value) : value = value.trim();
  final String value;
  @override
  String get type => 'TEXT';
  @override
  Map<String, Object?> toJson() => {'value': value};
}

final class EnumClaimValue extends ClaimValue {
  EnumClaimValue(String value) : value = value.trim().toUpperCase();
  final String value;
  @override
  String get type => 'ENUM';
  @override
  Map<String, Object?> toJson() => {'value': value};
}

final class HistoricalDateClaimValue extends ClaimValue {
  const HistoricalDateClaimValue(this.value);
  final HistoricalDate value;
  @override
  String get type => 'HISTORICAL_DATE';
  @override
  Map<String, Object?> toJson() => {
    'precision': value.precision.name,
    'start': value.startDate?.toIso8601String(),
    'end': value.endDate?.toIso8601String(),
    'displayText': value.displayText,
  };

  factory HistoricalDateClaimValue.fromJson(Map<String, Object?> json) {
    final precision = HistoricalDatePrecision.values.byName(
      json['precision']! as String,
    );
    final start = json['start'] == null
        ? null
        : DateTime.parse(json['start']! as String);
    final end = json['end'] == null
        ? null
        : DateTime.parse(json['end']! as String);
    final display = json['displayText'] as String?;
    final date = switch (precision) {
      HistoricalDatePrecision.exactDay => HistoricalDate.exactDay(
        start!.year,
        start.month,
        start.day,
        displayText: display,
      ),
      HistoricalDatePrecision.month => HistoricalDate.month(
        start!.year,
        start.month,
        displayText: display,
      ),
      HistoricalDatePrecision.year => HistoricalDate.year(
        start!.year,
        displayText: display,
      ),
      HistoricalDatePrecision.range => HistoricalDate.range(
        start!,
        end!,
        displayText: display,
      ),
      HistoricalDatePrecision.approximate => HistoricalDate.approximate(
        start!,
        displayText: display,
      ),
      HistoricalDatePrecision.before => HistoricalDate.before(
        end!,
        displayText: display,
      ),
      HistoricalDatePrecision.after => HistoricalDate.after(
        start!,
        displayText: display,
      ),
      HistoricalDatePrecision.unknown => HistoricalDate.unknown(
        displayText: display,
      ),
    };
    return HistoricalDateClaimValue(date);
  }
}

final class PersonReferenceClaimValue extends ClaimValue {
  const PersonReferenceClaimValue(this.personId);
  final PersonId personId;
  @override
  String get type => 'PERSON_REFERENCE';
  @override
  Map<String, Object?> toJson() => {'personId': personId.value};
}

final class RelationshipClaimValue extends ClaimValue {
  const RelationshipClaimValue({
    required this.personId,
    required this.relationshipType,
  });
  final PersonId personId;
  final String relationshipType;
  @override
  String get type => 'RELATIONSHIP';
  @override
  Map<String, Object?> toJson() => {
    'personId': personId.value,
    'relationshipType': relationshipType,
  };
}

final class CoordinatesClaimValue extends ClaimValue {
  const CoordinatesClaimValue({
    required this.latitude,
    required this.longitude,
  });
  final double latitude;
  final double longitude;
  @override
  String get type => 'COORDINATES';
  @override
  Map<String, Object?> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
  };
}

final class PersonCreationClaimValue extends ClaimValue {
  const PersonCreationClaimValue({
    required this.personId,
    required this.preferredName,
    required this.sex,
    this.birthDate,
    this.deathDate,
    this.biography,
    this.notes,
  });
  final PersonId personId;
  final String preferredName;
  final PersonSex sex;
  final HistoricalDate? birthDate;
  final HistoricalDate? deathDate;
  final String? biography;
  final String? notes;
  @override
  String get type => 'PERSON_CREATION';
  @override
  Map<String, Object?> toJson() => {
    'personId': personId.value,
    'preferredName': preferredName,
    'sex': sex.name,
    'birthDate': birthDate == null ? null : _historicalDateJson(birthDate!),
    'deathDate': deathDate == null ? null : _historicalDateJson(deathDate!),
    'biography': biography,
    'notes': notes,
  };
  factory PersonCreationClaimValue.fromJson(Map<String, Object?> json) =>
      PersonCreationClaimValue(
        personId: PersonId(json['personId']! as String),
        preferredName: json['preferredName']! as String,
        sex: PersonSex.values.byName(json['sex']! as String),
        birthDate: _historicalDateFromJson(json['birthDate']),
        deathDate: _historicalDateFromJson(json['deathDate']),
        biography: json['biography'] as String?,
        notes: json['notes'] as String?,
      );
}

final class PlaceCreationClaimValue extends ClaimValue {
  const PlaceCreationClaimValue({
    required this.placeId,
    required this.preferredName,
    required this.placeType,
    this.latitude,
    this.longitude,
    this.description,
    this.notes,
  });
  final PlaceId placeId;
  final String preferredName;
  final PlaceType placeType;
  final double? latitude;
  final double? longitude;
  final String? description;
  final String? notes;
  @override
  String get type => 'PLACE_CREATION';
  @override
  Map<String, Object?> toJson() => {
    'placeId': placeId.value,
    'preferredName': preferredName,
    'placeType': placeType.name,
    'latitude': latitude,
    'longitude': longitude,
    'description': description,
    'notes': notes,
  };
  factory PlaceCreationClaimValue.fromJson(Map<String, Object?> json) =>
      PlaceCreationClaimValue(
        placeId: PlaceId(json['placeId']! as String),
        preferredName: json['preferredName']! as String,
        placeType: PlaceType.values.byName(json['placeType']! as String),
        latitude: (json['latitude'] as num?)?.toDouble(),
        longitude: (json['longitude'] as num?)?.toDouble(),
        description: json['description'] as String?,
        notes: json['notes'] as String?,
      );
}

final class ParentChildClaimValue extends ClaimValue {
  const ParentChildClaimValue({
    required this.relationshipId,
    required this.parentId,
    required this.childId,
    required this.nature,
    this.notes,
  });
  final ParentChildRelationshipId relationshipId;
  final PersonId parentId;
  final PersonId childId;
  final ParentChildNature nature;
  final String? notes;
  @override
  String get type => 'PARENT_CHILD';
  @override
  Map<String, Object?> toJson() => {
    'relationshipId': relationshipId.value,
    'parentPersonId': parentId.value,
    'childPersonId': childId.value,
    'nature': nature.name,
    'notes': notes,
  };
  factory ParentChildClaimValue.fromJson(Map<String, Object?> json) =>
      ParentChildClaimValue(
        relationshipId: ParentChildRelationshipId(
          json['relationshipId']! as String,
        ),
        parentId: PersonId(json['parentPersonId']! as String),
        childId: PersonId(json['childPersonId']! as String),
        nature: ParentChildNature.values.byName(json['nature']! as String),
        notes: json['notes'] as String?,
      );
}

final class PartnershipClaimValue extends ClaimValue {
  const PartnershipClaimValue({
    required this.partnershipId,
    required this.personAId,
    required this.personBId,
    required this.partnershipType,
    this.placeId,
    this.notes,
  });
  final PartnershipId partnershipId;
  final PersonId personAId;
  final PersonId personBId;
  final PartnershipType partnershipType;
  final PlaceId? placeId;
  final String? notes;
  @override
  String get type => 'PARTNERSHIP';
  @override
  Map<String, Object?> toJson() => {
    'partnershipId': partnershipId.value,
    'personAId': personAId.value,
    'personBId': personBId.value,
    'partnershipType': partnershipType.name,
    'placeId': placeId?.value,
    'notes': notes,
  };
  factory PartnershipClaimValue.fromJson(Map<String, Object?> json) =>
      PartnershipClaimValue(
        partnershipId: PartnershipId(json['partnershipId']! as String),
        personAId: PersonId(json['personAId']! as String),
        personBId: PersonId(json['personBId']! as String),
        partnershipType: PartnershipType.values.byName(
          json['partnershipType']! as String,
        ),
        placeId: json['placeId'] == null
            ? null
            : PlaceId(json['placeId']! as String),
        notes: json['notes'] as String?,
      );
}

final class ResidenceClaimValue extends ClaimValue {
  const ResidenceClaimValue({
    required this.residenceId,
    required this.personId,
    required this.placeId,
    this.startDate,
    this.endDate,
    this.reason,
    this.notes,
  });
  final ResidenceId residenceId;
  final PersonId personId;
  final PlaceId placeId;
  final HistoricalDate? startDate;
  final HistoricalDate? endDate;
  final String? reason;
  final String? notes;
  @override
  String get type => 'RESIDENCE';
  @override
  Map<String, Object?> toJson() => {
    'residenceId': residenceId.value,
    'personId': personId.value,
    'placeId': placeId.value,
    'startDate': startDate == null ? null : _historicalDateJson(startDate!),
    'endDate': endDate == null ? null : _historicalDateJson(endDate!),
    'reason': reason,
    'notes': notes,
  };
  factory ResidenceClaimValue.fromJson(Map<String, Object?> json) =>
      ResidenceClaimValue(
        residenceId: ResidenceId(json['residenceId']! as String),
        personId: PersonId(json['personId']! as String),
        placeId: PlaceId(json['placeId']! as String),
        startDate: _historicalDateFromJson(json['startDate']),
        endDate: _historicalDateFromJson(json['endDate']),
        reason: json['reason'] as String?,
        notes: json['notes'] as String?,
      );
}

final class EventClaimValue extends ClaimValue {
  const EventClaimValue({
    required this.eventId,
    required this.eventType,
    required this.participantId,
    required this.participantRole,
    this.date,
    this.placeId,
    this.title,
    this.description,
  });
  final EventId eventId;
  final EventType eventType;
  final PersonId participantId;
  final EventParticipantRole participantRole;
  final HistoricalDate? date;
  final PlaceId? placeId;
  final String? title;
  final String? description;
  @override
  String get type => 'EVENT';
  @override
  Map<String, Object?> toJson() => {
    'eventId': eventId.value,
    'eventType': eventType.name,
    'participantPersonId': participantId.value,
    'participantRole': participantRole.name,
    'date': date == null ? null : _historicalDateJson(date!),
    'placeId': placeId?.value,
    'title': title,
    'description': description,
  };
  factory EventClaimValue.fromJson(Map<String, Object?> json) =>
      EventClaimValue(
        eventId: EventId(json['eventId']! as String),
        eventType: EventType.values.byName(json['eventType']! as String),
        participantId: PersonId(json['participantPersonId']! as String),
        participantRole: EventParticipantRole.values.byName(
          json['participantRole']! as String,
        ),
        date: _historicalDateFromJson(json['date']),
        placeId: json['placeId'] == null
            ? null
            : PlaceId(json['placeId']! as String),
        title: json['title'] as String?,
        description: json['description'] as String?,
      );
}

final class Claim {
  Claim({
    required this.id,
    required this.subjectType,
    required this.subjectId,
    required this.property,
    required this.value,
    required this.status,
    required this.createdAt,
    required this.modifiedAt,
    this.payloadVersion = 1,
    this.sourceId,
    String? sourceLocator,
    this.confidence,
    this.deletedAt,
  }) : sourceLocator = normalizedOptionalText(sourceLocator) {
    if (payloadVersion < 1 ||
        (confidence != null && (confidence! < 0 || confidence! > 1))) {
      throw const DomainValidationException(
        DomainValidationCode.invalidEntity,
        'Claim payload version or confidence is invalid.',
      );
    }
    _validatePropertyValue(property, value);
    validateEntityTimestamps(
      createdAt: createdAt,
      modifiedAt: modifiedAt,
      deletedAt: deletedAt,
    );
  }

  final ClaimId id;
  final ClaimSubjectType subjectType;
  final String subjectId;
  final ClaimProperty property;
  final ClaimValue value;
  final int payloadVersion;
  final SourceId? sourceId;
  final String? sourceLocator;
  final double? confidence;
  final ClaimStatus status;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final DateTime? deletedAt;

  Claim copyWith({ClaimStatus? status, DateTime? modifiedAt}) => Claim(
    id: id,
    subjectType: subjectType,
    subjectId: subjectId,
    property: property,
    value: value,
    payloadVersion: payloadVersion,
    sourceId: sourceId,
    sourceLocator: sourceLocator,
    confidence: confidence,
    status: status ?? this.status,
    createdAt: createdAt,
    modifiedAt: modifiedAt ?? this.modifiedAt,
    deletedAt: deletedAt,
  );

  static void _validatePropertyValue(ClaimProperty property, ClaimValue value) {
    final valid = switch (property) {
      ClaimProperty.personCreation => value is PersonCreationClaimValue,
      ClaimProperty.personBirthDate ||
      ClaimProperty.personDeathDate => value is HistoricalDateClaimValue,
      ClaimProperty.personSex => value is EnumClaimValue,
      ClaimProperty.personPreferredName ||
      ClaimProperty.personBiography ||
      ClaimProperty.personNotes => value is TextClaimValue,
      ClaimProperty.placeCreation => value is PlaceCreationClaimValue,
      ClaimProperty.placePreferredName ||
      ClaimProperty.placeDescription ||
      ClaimProperty.placeNotes => value is TextClaimValue,
      ClaimProperty.placeType => value is EnumClaimValue,
      ClaimProperty.placeCoordinates => value is CoordinatesClaimValue,
      ClaimProperty.parentChildRelationship =>
        value is ParentChildClaimValue || value is RelationshipClaimValue,
      ClaimProperty.partnership =>
        value is PartnershipClaimValue || value is RelationshipClaimValue,
      ClaimProperty.residence =>
        value is ResidenceClaimValue || value is PersonReferenceClaimValue,
      ClaimProperty.event =>
        value is EventClaimValue || value is TextClaimValue,
    };
    if (!valid) {
      throw const DomainValidationException(
        DomainValidationCode.invalidEntity,
        'Claim value type does not match its property.',
      );
    }
  }
}
