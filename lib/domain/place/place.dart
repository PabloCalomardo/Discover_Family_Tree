import 'package:family_history/core/errors/domain_validation_exception.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/core/utils/entity_validation.dart';

enum PlaceType {
  house,
  farmhouse,
  apartment,
  building,
  street,
  neighborhood,
  village,
  town,
  city,
  municipality,
  region,
  country,
  church,
  cemetery,
  hospital,
  school,
  workplace,
  other,
  custom,
}

final class Place {
  Place({
    required this.id,
    required String preferredName,
    required this.type,
    required this.createdAt,
    required this.modifiedAt,
    this.latitude,
    this.longitude,
    String? description,
    String? notes,
    this.deletedAt,
  }) : preferredName = preferredName.trim(),
       description = normalizedOptionalText(description),
       notes = normalizedOptionalText(notes) {
    if (this.preferredName.isEmpty) {
      throw const DomainValidationException(
        DomainValidationCode.invalidEntity,
        'A place must have a preferred name.',
      );
    }
    if ((latitude == null) != (longitude == null)) {
      throw const DomainValidationException(
        DomainValidationCode.invalidEntity,
        'Latitude and longitude must be provided together.',
      );
    }
    if (latitude != null && (latitude! < -90 || latitude! > 90)) {
      throw const DomainValidationException(
        DomainValidationCode.invalidEntity,
        'Latitude must be between -90 and 90.',
      );
    }
    if (longitude != null && (longitude! < -180 || longitude! > 180)) {
      throw const DomainValidationException(
        DomainValidationCode.invalidEntity,
        'Longitude must be between -180 and 180.',
      );
    }
    validateEntityTimestamps(
      createdAt: createdAt,
      modifiedAt: modifiedAt,
      deletedAt: deletedAt,
    );
  }

  final PlaceId id;
  final String preferredName;
  final PlaceType type;
  final double? latitude;
  final double? longitude;
  final String? description;
  final String? notes;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final DateTime? deletedAt;

  bool get isDeleted => deletedAt != null;
}
