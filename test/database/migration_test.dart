import 'package:drift/native.dart';
import 'package:family_history/database/database.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('migrates schema 1 to 6 without losing projects', () async {
    final database = AppDatabase(
      NativeDatabase.memory(
        setup: (rawDatabase) {
          rawDatabase.execute('''
            CREATE TABLE projects (
              id TEXT NOT NULL PRIMARY KEY,
              name TEXT NOT NULL,
              created_at INTEGER NOT NULL,
              modified_at INTEGER NOT NULL,
              deleted_at INTEGER NULL
            )
          ''');
          rawDatabase.execute('''
            INSERT INTO projects (id, name, created_at, modified_at)
            VALUES ('a3b9e277-80c1-4f06-8ad6-6a924dca6f44', 'Família', 0, 0)
          ''');
          rawDatabase.execute('PRAGMA user_version = 1');
        },
      ),
    );
    addTearDown(database.close);

    final project = await database.select(database.projects).getSingle();
    final version = await database
        .customSelect('PRAGMA user_version')
        .getSingle();
    final placesTable = await database
        .customSelect(
          "SELECT name FROM sqlite_master WHERE type = 'table' AND name = 'places'",
        )
        .getSingleOrNull();
    final partialIndexes = await database
        .customSelect(
          "SELECT name FROM sqlite_master WHERE type = 'index' "
          "AND name IN ('parent_child_unique_active', "
          "'person_names_one_preferred_active')",
        )
        .get();

    expect(project.name, 'Família');
    expect(version.read<int>('user_version'), 6);
    expect(placesTable, isNotNull);
    expect(partialIndexes, hasLength(2));
  });

  test('migrates schema 3 to 6 without losing people', () async {
    final database = AppDatabase(
      NativeDatabase.memory(
        setup: (rawDatabase) {
          rawDatabase.execute('''
            CREATE TABLE persons (
              id TEXT NOT NULL PRIMARY KEY,
              sex TEXT NOT NULL,
              birth_precision TEXT NULL,
              birth_start_date INTEGER NULL,
              birth_end_date INTEGER NULL,
              birth_display_text TEXT NULL,
              death_precision TEXT NULL,
              death_start_date INTEGER NULL,
              death_end_date INTEGER NULL,
              death_display_text TEXT NULL,
              biography TEXT NULL,
              notes TEXT NULL,
              created_at INTEGER NOT NULL,
              modified_at INTEGER NOT NULL,
              deleted_at INTEGER NULL
            )
          ''');
          rawDatabase.execute('''
            INSERT INTO persons (id, sex, created_at, modified_at)
            VALUES ('a3b9e277-80c1-4f06-8ad6-6a924dca6f44', 'UNKNOWN', 0, 0)
          ''');
          rawDatabase.execute('PRAGMA user_version = 3');
        },
      ),
    );
    addTearDown(database.close);

    final person = await database.select(database.persons).getSingle();
    final version = await database
        .customSelect('PRAGMA user_version')
        .getSingle();
    final claimsTable = await database
        .customSelect(
          "SELECT name FROM sqlite_master WHERE type = 'table' AND name = 'claims'",
        )
        .getSingleOrNull();

    expect(person.id, 'a3b9e277-80c1-4f06-8ad6-6a924dca6f44');
    expect(version.read<int>('user_version'), 6);
    expect(claimsTable, isNotNull);
  });

  test('migrates schema 2 through index repair and schema 6', () async {
    final database = AppDatabase(
      NativeDatabase.memory(
        setup: (rawDatabase) {
          rawDatabase.execute('''
            CREATE TABLE projects (
              id TEXT NOT NULL PRIMARY KEY,
              name TEXT NOT NULL,
              created_at INTEGER NOT NULL,
              modified_at INTEGER NOT NULL,
              deleted_at INTEGER NULL
            )
          ''');
          rawDatabase.execute('''
            INSERT INTO projects (id, name, created_at, modified_at)
            VALUES ('a3b9e277-80c1-4f06-8ad6-6a924dca6f44', 'Schema 2', 0, 0)
          ''');
          rawDatabase.execute('CREATE TABLE persons (id TEXT PRIMARY KEY)');
          rawDatabase.execute('''
            CREATE TABLE person_names (
              person_id TEXT, is_preferred INTEGER, deleted_at INTEGER
            )
          ''');
          rawDatabase.execute('''
            CREATE TABLE parent_child_relationships (
              parent_person_id TEXT, child_person_id TEXT,
              nature TEXT, deleted_at INTEGER
            )
          ''');
          rawDatabase.execute('''
            CREATE TABLE partnerships (person_a_id TEXT, person_b_id TEXT)
          ''');
          rawDatabase.execute('CREATE TABLE places (id TEXT PRIMARY KEY)');
          rawDatabase.execute('''
            CREATE TABLE place_relationships (
              source_place_id TEXT, target_place_id TEXT
            )
          ''');
          rawDatabase.execute('''
            CREATE TABLE residences (person_id TEXT, place_id TEXT)
          ''');
          rawDatabase.execute('CREATE TABLE events (place_id TEXT)');
          rawDatabase.execute('''
            CREATE TABLE event_participants (event_id TEXT, person_id TEXT)
          ''');
          rawDatabase.execute('PRAGMA user_version = 2');
        },
      ),
    );
    addTearDown(database.close);

    final project = await database.select(database.projects).getSingle();
    final version = await database
        .customSelect('PRAGMA user_version')
        .getSingle();
    final index = await database
        .customSelect(
          "SELECT name FROM sqlite_master WHERE type = 'index' "
          "AND name = 'person_names_one_preferred_active'",
        )
        .getSingleOrNull();
    final sourceTable = await database
        .customSelect(
          "SELECT name FROM sqlite_master WHERE type = 'table' AND name = 'sources'",
        )
        .getSingleOrNull();

    expect(project.name, 'Schema 2');
    expect(version.read<int>('user_version'), 6);
    expect(index, isNotNull);
    expect(sourceTable, isNotNull);
  });

  test('migrates schema 5 to 6 without losing people', () async {
    final database = AppDatabase(
      NativeDatabase.memory(
        setup: (rawDatabase) {
          rawDatabase.execute('''
            CREATE TABLE persons (
              id TEXT NOT NULL PRIMARY KEY,
              sex TEXT NOT NULL,
              birth_precision TEXT NULL,
              birth_start_date INTEGER NULL,
              birth_end_date INTEGER NULL,
              birth_display_text TEXT NULL,
              death_precision TEXT NULL,
              death_start_date INTEGER NULL,
              death_end_date INTEGER NULL,
              death_display_text TEXT NULL,
              biography TEXT NULL,
              notes TEXT NULL,
              created_at INTEGER NOT NULL,
              modified_at INTEGER NOT NULL,
              deleted_at INTEGER NULL
            )
          ''');
          rawDatabase.execute('''
            INSERT INTO persons (id, sex, created_at, modified_at)
            VALUES ('a3b9e277-80c1-4f06-8ad6-6a924dca6f44', 'UNKNOWN', 0, 0)
          ''');
          rawDatabase.execute('PRAGMA user_version = 5');
        },
      ),
    );
    addTearDown(database.close);

    final person = await database.select(database.persons).getSingle();
    final version = await database
        .customSelect('PRAGMA user_version')
        .getSingle();
    final siblingTable = await database
        .customSelect(
          "SELECT name FROM sqlite_master WHERE type = 'table' "
          "AND name = 'sibling_relationships'",
        )
        .getSingleOrNull();

    expect(person.id, 'a3b9e277-80c1-4f06-8ad6-6a924dca6f44');
    expect(version.read<int>('user_version'), 6);
    expect(siblingTable, isNotNull);
  });
}
