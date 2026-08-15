import 'package:family_history/database/database.dart' as db;
import 'package:family_history/domain/event/event.dart';
import 'package:family_history/domain/event/event_participant.dart';
import 'package:family_history/domain/event/event_repository.dart';

final class EventEditorService {
  EventEditorService(this._database, this._events);

  final db.AppDatabase _database;
  final EventRepository _events;

  Future<void> createForPerson(
    FamilyEvent event,
    EventParticipant participant,
  ) async {
    await _database.transaction(() async {
      await _events.create(event);
      await _events.addParticipant(participant);
    });
  }
}
