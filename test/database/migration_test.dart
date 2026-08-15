import 'package:drift/native.dart';
import 'package:family_history/database/database.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('migrates schema 1 to 3 without losing projects', () async {
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
    expect(version.read<int>('user_version'), 3);
    expect(placesTable, isNotNull);
    expect(partialIndexes, hasLength(2));
  });
}
