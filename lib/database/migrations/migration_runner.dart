import 'package:drift/drift.dart';

const initialSchemaVersion = 1;
const currentSchemaVersion = 3;

Future<void> runMigrations(
  Migrator migrator, {
  required int from,
  required int to,
  required Future<void> Function() createSchemaVersion2,
  required Future<void> Function() ensureSchemaVersion3Indexes,
}) async {
  for (var version = from + 1; version <= to; version++) {
    switch (version) {
      case initialSchemaVersion:
        await migrator.createAll();
      case 2:
        await createSchemaVersion2();
      case 3:
        await ensureSchemaVersion3Indexes();
      default:
        throw StateError(
          'No migration registered for schema version $version.',
        );
    }
  }
}
