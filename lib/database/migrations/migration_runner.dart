import 'package:drift/drift.dart';

const initialSchemaVersion = 1;
const currentSchemaVersion = 5;

Future<void> runMigrations(
  Migrator migrator, {
  required int from,
  required int to,
  required Future<void> Function() createSchemaVersion2,
  required Future<void> Function() ensureSchemaVersion3Indexes,
  required Future<void> Function() createSchemaVersion4,
  required Future<void> Function() createSchemaVersion5,
}) async {
  for (var version = from + 1; version <= to; version++) {
    switch (version) {
      case initialSchemaVersion:
        await migrator.createAll();
      case 2:
        await createSchemaVersion2();
      case 3:
        await ensureSchemaVersion3Indexes();
      case 4:
        await createSchemaVersion4();
      case 5:
        await createSchemaVersion5();
      default:
        throw StateError(
          'No migration registered for schema version $version.',
        );
    }
  }
}
