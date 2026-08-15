import 'package:family_history/core/errors/domain_validation_exception.dart';
import 'package:uuid/uuid.dart';

abstract base class DomainId {
  DomainId(String value) : value = value.toLowerCase() {
    if (!Uuid.isValidUUID(fromString: value)) {
      throw DomainValidationException(
        DomainValidationCode.invalidUuid,
        '"$value" is not a valid UUID.',
      );
    }
  }

  final String value;

  @override
  bool operator ==(Object other) =>
      other.runtimeType == runtimeType &&
      other is DomainId &&
      other.value == value;

  @override
  int get hashCode => Object.hash(runtimeType, value);

  @override
  String toString() => value;
}

final class PersonId extends DomainId {
  PersonId(super.value);

  factory PersonId.generate() => PersonId(const Uuid().v4());
}

final class PersonNameId extends DomainId {
  PersonNameId(super.value);

  factory PersonNameId.generate() => PersonNameId(const Uuid().v4());
}

final class ParentChildRelationshipId extends DomainId {
  ParentChildRelationshipId(super.value);

  factory ParentChildRelationshipId.generate() =>
      ParentChildRelationshipId(const Uuid().v4());
}

final class PartnershipId extends DomainId {
  PartnershipId(super.value);

  factory PartnershipId.generate() => PartnershipId(const Uuid().v4());
}

final class PlaceId extends DomainId {
  PlaceId(super.value);

  factory PlaceId.generate() => PlaceId(const Uuid().v4());
}

final class PlaceRelationshipId extends DomainId {
  PlaceRelationshipId(super.value);

  factory PlaceRelationshipId.generate() =>
      PlaceRelationshipId(const Uuid().v4());
}

final class ResidenceId extends DomainId {
  ResidenceId(super.value);

  factory ResidenceId.generate() => ResidenceId(const Uuid().v4());
}

final class EventId extends DomainId {
  EventId(super.value);

  factory EventId.generate() => EventId(const Uuid().v4());
}

final class EventParticipantId extends DomainId {
  EventParticipantId(super.value);

  factory EventParticipantId.generate() =>
      EventParticipantId(const Uuid().v4());
}
