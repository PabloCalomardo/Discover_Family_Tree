import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/core/utils/entity_validation.dart';

enum EventParticipantRole { subject, spouse, witness, parent, child, other }

final class EventParticipant {
  EventParticipant({
    required this.id,
    required this.eventId,
    required this.personId,
    required this.role,
    required this.createdAt,
    required this.modifiedAt,
    this.deletedAt,
  }) {
    validateEntityTimestamps(
      createdAt: createdAt,
      modifiedAt: modifiedAt,
      deletedAt: deletedAt,
    );
  }

  final EventParticipantId id;
  final EventId eventId;
  final PersonId personId;
  final EventParticipantRole role;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final DateTime? deletedAt;

  bool get isDeleted => deletedAt != null;
}
