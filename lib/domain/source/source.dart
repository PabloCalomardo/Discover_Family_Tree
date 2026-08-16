import 'package:family_history/core/dates/historical_date.dart';
import 'package:family_history/core/errors/domain_validation_exception.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/core/utils/entity_validation.dart';

enum SourceType {
  interview,
  document,
  photo,
  letter,
  book,
  registry,
  website,
  personalKnowledge,
  other,
}

final class Source {
  Source({
    required this.id,
    required this.type,
    required String title,
    required this.createdAt,
    required this.modifiedAt,
    this.sourceDate,
    String? description,
    String? creator,
    String? repositoryName,
    String? referenceCode,
    String? originalLocation,
    String? url,
    this.accessedAt,
    String? notes,
    this.deletedAt,
  }) : title = title.trim(),
       description = normalizedOptionalText(description),
       creator = normalizedOptionalText(creator),
       repositoryName = normalizedOptionalText(repositoryName),
       referenceCode = normalizedOptionalText(referenceCode),
       originalLocation = normalizedOptionalText(originalLocation),
       url = normalizedOptionalText(url),
       notes = normalizedOptionalText(notes) {
    if (this.title.isEmpty) {
      throw const DomainValidationException(
        DomainValidationCode.invalidEntity,
        'A source must have a title.',
      );
    }
    validateEntityTimestamps(
      createdAt: createdAt,
      modifiedAt: modifiedAt,
      deletedAt: deletedAt,
    );
  }

  final SourceId id;
  final SourceType type;
  final String title;
  final String? description;
  final HistoricalDate? sourceDate;
  final String? creator;
  final String? repositoryName;
  final String? referenceCode;
  final String? originalLocation;
  final String? url;
  final DateTime? accessedAt;
  final String? notes;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final DateTime? deletedAt;

  bool get isDeleted => deletedAt != null;
}
