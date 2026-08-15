import 'package:family_history/core/dates/historical_date.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/core/utils/entity_validation.dart';

enum EventType {
  birth,
  death,
  marriage,
  separation,
  move,
  baptism,
  funeral,
  education,
  employment,
  military,
  war,
  purchase,
  sale,
  inheritance,
  travel,
  migration,
  custom,
}

final class FamilyEvent {
  FamilyEvent({
    required this.id,
    required this.type,
    required this.createdAt,
    required this.modifiedAt,
    this.date,
    this.placeId,
    String? title,
    String? description,
    this.deletedAt,
  }) : title = normalizedOptionalText(title),
       description = normalizedOptionalText(description) {
    validateEntityTimestamps(
      createdAt: createdAt,
      modifiedAt: modifiedAt,
      deletedAt: deletedAt,
    );
  }

  final EventId id;
  final EventType type;
  final HistoricalDate? date;
  final PlaceId? placeId;
  final String? title;
  final String? description;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final DateTime? deletedAt;

  bool get isDeleted => deletedAt != null;
}
