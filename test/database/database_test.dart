import 'package:drift/native.dart';
import 'package:family_history/database/database.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() => database.close());

  test('opens schema version 5 with foreign keys enabled', () async {
    final result = await database
        .customSelect('PRAGMA foreign_keys')
        .getSingle();

    expect(result.read<int>('foreign_keys'), 1);
    expect(database.schemaVersion, 5);
  });

  test('stores a project with a UUID domain identifier', () async {
    final now = DateTime.utc(2026, 8, 14);
    const projectId = 'a3b9e277-80c1-4f06-8ad6-6a924dca6f44';

    await database
        .into(database.projects)
        .insert(
          ProjectsCompanion.insert(
            id: projectId,
            name: 'Família de prova',
            createdAt: now,
            modifiedAt: now,
          ),
        );

    final project = await database.select(database.projects).getSingle();
    expect(project.id, projectId);
    expect(project.name, 'Família de prova');
  });

  test('creates all phase 1 and phase 2 tables', () async {
    final rows = await database
        .customSelect("SELECT name FROM sqlite_master WHERE type = 'table'")
        .get();
    final names = rows.map((row) => row.read<String>('name')).toSet();

    expect(
      names,
      containsAll({
        'projects',
        'persons',
        'person_names',
        'parent_child_relationships',
        'partnerships',
        'places',
        'place_relationships',
        'residences',
        'events',
        'event_participants',
      }),
    );
  });

  test('creates all phase 6 tables and indexes', () async {
    final rows = await database
        .customSelect("SELECT name FROM sqlite_master WHERE type = 'table'")
        .get();
    final names = rows.map((row) => row.read<String>('name')).toSet();
    expect(
      names,
      containsAll({
        'sources',
        'media',
        'source_media',
        'claims',
        'claim_applications',
        'duplicate_candidates',
        'audit_entries',
        'audit_targets',
      }),
    );
    final indexes = await database
        .customSelect("SELECT name FROM sqlite_master WHERE type = 'index'")
        .get();
    final indexNames = indexes.map((row) => row.read<String>('name')).toSet();
    expect(indexNames, contains('claims_subject_property'));
    expect(indexNames, contains('duplicate_candidates_pair'));
    expect(indexNames, contains('media_checksum_size_active'));
  });
}
