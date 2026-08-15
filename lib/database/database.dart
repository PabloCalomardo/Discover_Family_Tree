import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:family_history/database/migrations/migration_runner.dart';
import 'package:family_history/database/tables/family_tables.dart';
import 'package:family_history/database/tables/projects.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    Projects,
    Persons,
    PersonNames,
    ParentChildRelationships,
    Partnerships,
    Places,
    PlaceRelationships,
    Residences,
    Events,
    EventParticipants,
  ],
)
final class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  AppDatabase.defaults() : super(driftDatabase(name: 'family_history'));

  @override
  int get schemaVersion => currentSchemaVersion;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) => migrator.createAll(),
    onUpgrade: (migrator, from, to) => runMigrations(
      migrator,
      from: from,
      to: to,
      createSchemaVersion2: () async {
        await migrator.createTable(persons);
        await migrator.createTable(places);
        await migrator.createTable(personNames);
        await migrator.createTable(parentChildRelationships);
        await migrator.createTable(partnerships);
        await migrator.createTable(placeRelationships);
        await migrator.createTable(residences);
        await migrator.createTable(events);
        await migrator.createTable(eventParticipants);
      },
      ensureSchemaVersion3Indexes: () async {
        for (final index in [
          personNamesPersonId,
          personNamesOnePreferredActive,
          parentChildParentId,
          parentChildChildId,
          parentChildUniqueActive,
          partnershipsPersonAId,
          partnershipsPersonBId,
          placeRelationshipsSourceId,
          placeRelationshipsTargetId,
          residencesPersonId,
          residencesPlaceId,
          eventsPlaceId,
          eventParticipantsEventId,
          eventParticipantsPersonId,
        ]) {
          final statement = index.createStatementsByDialect[SqlDialect.sqlite]!
              .replaceFirst('CREATE INDEX', 'CREATE INDEX IF NOT EXISTS')
              .replaceFirst(
                'CREATE UNIQUE INDEX',
                'CREATE UNIQUE INDEX IF NOT EXISTS',
              );
          await customStatement(statement);
        }
      },
    ),
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
