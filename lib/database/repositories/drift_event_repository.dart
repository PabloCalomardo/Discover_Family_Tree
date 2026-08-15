import 'package:drift/drift.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/database/database.dart' as db;
import 'package:family_history/database/mappers/enum_mapping.dart';
import 'package:family_history/database/mappers/historical_date_mapper.dart';
import 'package:family_history/domain/event/event.dart';
import 'package:family_history/domain/event/event_participant.dart';
import 'package:family_history/domain/event/event_repository.dart';

final class DriftEventRepository implements EventRepository {
  DriftEventRepository(this._database);

  final db.AppDatabase _database;

  @override
  Stream<List<FamilyEvent>> watchForPerson(PersonId personId) {
    final query =
        _database.select(_database.events).join([
          innerJoin(
            _database.eventParticipants,
            _database.eventParticipants.eventId.equalsExp(_database.events.id),
          ),
        ])..where(
          _database.events.deletedAt.isNull() &
              _database.eventParticipants.deletedAt.isNull() &
              _database.eventParticipants.personId.equals(personId.value),
        );

    return query.watch().map((rows) {
      final byId = <EventId, FamilyEvent>{};
      for (final row in rows) {
        final event = row.readTable(_database.events).toDomain();
        byId[event.id] = event;
      }
      final events = byId.values.toList()
        ..sort((first, second) {
          final firstDate = first.date?.startDate;
          final secondDate = second.date?.startDate;
          if (firstDate == null) return secondDate == null ? 0 : 1;
          if (secondDate == null) return -1;
          return firstDate.compareTo(secondDate);
        });
      return List.unmodifiable(events);
    });
  }

  @override
  Future<void> create(FamilyEvent event) async {
    await _database.into(_database.events).insert(event.toCompanion());
  }

  @override
  Future<void> update(FamilyEvent event) async {
    await _database.update(_database.events).replace(event.toCompanion());
  }

  @override
  Future<void> delete(EventId id) async {
    final now = DateTime.now().toUtc();
    await _database.transaction(() async {
      await (_database.update(
        _database.events,
      )..where((table) => table.id.equals(id.value))).write(
        db.EventsCompanion(modifiedAt: Value(now), deletedAt: Value(now)),
      );
      await (_database.update(
        _database.eventParticipants,
      )..where((table) => table.eventId.equals(id.value))).write(
        db.EventParticipantsCompanion(
          modifiedAt: Value(now),
          deletedAt: Value(now),
        ),
      );
    });
  }

  @override
  Future<void> addParticipant(EventParticipant participant) async {
    await _database
        .into(_database.eventParticipants)
        .insert(participant.toCompanion());
  }

  @override
  Future<void> removeParticipant(EventParticipantId id) async {
    final now = DateTime.now().toUtc();
    await (_database.update(
      _database.eventParticipants,
    )..where((table) => table.id.equals(id.value))).write(
      db.EventParticipantsCompanion(
        modifiedAt: Value(now),
        deletedAt: Value(now),
      ),
    );
  }
}

extension on FamilyEvent {
  db.EventsCompanion toCompanion() {
    final eventDate = historicalDateToFields(date);
    return db.EventsCompanion.insert(
      id: id.value,
      type: enumToSql(type),
      datePrecision: Value(eventDate.precision),
      dateStartDate: Value(eventDate.startDate),
      dateEndDate: Value(eventDate.endDate),
      dateDisplayText: Value(eventDate.displayText),
      placeId: Value(placeId?.value),
      title: Value(title),
      description: Value(description),
      createdAt: createdAt,
      modifiedAt: modifiedAt,
      deletedAt: Value(deletedAt),
    );
  }
}

extension on db.Event {
  FamilyEvent toDomain() => FamilyEvent(
    id: EventId(id),
    type: enumFromSql(EventType.values, type),
    date: historicalDateFromFields(
      precision: datePrecision,
      startDate: dateStartDate,
      endDate: dateEndDate,
      displayText: dateDisplayText,
    ),
    placeId: placeId == null ? null : PlaceId(placeId!),
    title: title,
    description: description,
    createdAt: createdAt,
    modifiedAt: modifiedAt,
    deletedAt: deletedAt,
  );
}

extension on EventParticipant {
  db.EventParticipantsCompanion toCompanion() =>
      db.EventParticipantsCompanion.insert(
        id: id.value,
        eventId: eventId.value,
        personId: personId.value,
        role: enumToSql(role),
        createdAt: createdAt,
        modifiedAt: modifiedAt,
        deletedAt: Value(deletedAt),
      );
}
