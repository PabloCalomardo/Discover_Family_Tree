import 'package:family_history/core/dates/historical_date.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/core/utils/entity_validation.dart';

enum PersonSex { male, female, intersex, unknown, unspecified }

final class Person {
  Person({
    required this.id,
    required this.sex,
    required this.createdAt,
    required this.modifiedAt,
    this.birthDate,
    this.deathDate,
    String? biography,
    String? notes,
    this.deletedAt,
  }) : biography = normalizedOptionalText(biography),
       notes = normalizedOptionalText(notes) {
    validateEntityTimestamps(
      createdAt: createdAt,
      modifiedAt: modifiedAt,
      deletedAt: deletedAt,
    );
  }

  final PersonId id;
  final PersonSex sex;
  final HistoricalDate? birthDate;
  final HistoricalDate? deathDate;
  final String? biography;
  final String? notes;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final DateTime? deletedAt;

  bool get isDeleted => deletedAt != null;
}
