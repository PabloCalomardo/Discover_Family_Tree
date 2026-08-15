import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/domain/event/event.dart';
import 'package:family_history/domain/event/event_participant.dart';

abstract interface class EventRepository {
  Stream<List<FamilyEvent>> watchForPerson(PersonId personId);
  Future<void> create(FamilyEvent event);
  Future<void> update(FamilyEvent event);
  Future<void> delete(EventId id);
  Future<void> addParticipant(EventParticipant participant);
  Future<void> removeParticipant(EventParticipantId id);
}
