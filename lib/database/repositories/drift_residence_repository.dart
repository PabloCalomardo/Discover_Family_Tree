import 'package:drift/drift.dart';
import 'package:family_history/core/dates/historical_period.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/database/database.dart' as db;
import 'package:family_history/database/mappers/historical_date_mapper.dart';
import 'package:family_history/domain/place/residence.dart';
import 'package:family_history/domain/place/residence_repository.dart';

final class DriftResidenceRepository implements ResidenceRepository {
  DriftResidenceRepository(this._database);

  final db.AppDatabase _database;

  @override
  Stream<List<Residence>> watchForPerson(PersonId personId) {
    final query = _database.select(_database.residences)
      ..where(
        (table) =>
            table.personId.equals(personId.value) & table.deletedAt.isNull(),
      );
    return query.watch().map(_sortedResidences);
  }

  @override
  Stream<List<Residence>> watchResidentsAtPlace(
    PlaceId placeId, {
    HistoricalPeriod? period,
  }) {
    final query = _database.select(_database.residences)
      ..where((table) {
        Expression<bool> predicate =
            table.placeId.equals(placeId.value) & table.deletedAt.isNull();
        if (period?.end case final end?) {
          predicate =
              predicate &
              (table.startStartDate.isNull() |
                  table.startStartDate.isSmallerOrEqualValue(end));
        }
        if (period?.start case final start?) {
          predicate =
              predicate &
              (table.endEndDate.isNull() |
                  table.endEndDate.isBiggerOrEqualValue(start));
        }
        return predicate;
      });

    return query.watch().map(_sortedResidences);
  }

  List<Residence> _sortedResidences(List<db.Residence> rows) {
    final residences = rows.map((row) => row.toDomain()).toList();
    residences.sort((first, second) {
      final firstDate = first.startDate?.startDate;
      final secondDate = second.startDate?.startDate;
      if (firstDate == null) return secondDate == null ? 0 : 1;
      if (secondDate == null) return -1;
      return firstDate.compareTo(secondDate);
    });
    return List.unmodifiable(residences);
  }

  @override
  Future<void> create(Residence residence) async {
    await _database.into(_database.residences).insert(residence.toCompanion());
  }

  @override
  Future<void> update(Residence residence) async {
    await _database
        .update(_database.residences)
        .replace(residence.toCompanion());
  }

  @override
  Future<void> delete(ResidenceId id) async {
    final now = DateTime.now().toUtc();
    await (_database.update(
      _database.residences,
    )..where((table) => table.id.equals(id.value))).write(
      db.ResidencesCompanion(modifiedAt: Value(now), deletedAt: Value(now)),
    );
  }
}

extension on Residence {
  db.ResidencesCompanion toCompanion() {
    final start = historicalDateToFields(startDate);
    final end = historicalDateToFields(endDate);
    return db.ResidencesCompanion.insert(
      id: id.value,
      personId: personId.value,
      placeId: placeId.value,
      startPrecision: Value(start.precision),
      startStartDate: Value(start.startDate),
      startEndDate: Value(start.endDate),
      startDisplayText: Value(start.displayText),
      endPrecision: Value(end.precision),
      endStartDate: Value(end.startDate),
      endEndDate: Value(end.endDate),
      endDisplayText: Value(end.displayText),
      reason: Value(reason),
      notes: Value(notes),
      createdAt: createdAt,
      modifiedAt: modifiedAt,
      deletedAt: Value(deletedAt),
    );
  }
}

extension on db.Residence {
  Residence toDomain() => Residence(
    id: ResidenceId(id),
    personId: PersonId(personId),
    placeId: PlaceId(placeId),
    startDate: historicalDateFromFields(
      precision: startPrecision,
      startDate: startStartDate,
      endDate: startEndDate,
      displayText: startDisplayText,
    ),
    endDate: historicalDateFromFields(
      precision: endPrecision,
      startDate: endStartDate,
      endDate: endEndDate,
      displayText: endDisplayText,
    ),
    reason: reason,
    notes: notes,
    createdAt: createdAt,
    modifiedAt: modifiedAt,
    deletedAt: deletedAt,
  );
}
