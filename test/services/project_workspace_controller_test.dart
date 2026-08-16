import 'dart:io';

import 'package:drift/native.dart';
import 'package:family_history/database/database.dart';
import 'package:family_history/services/project/project_workspace_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  test('migrates legacy data, saves, creates and reopens projects', () async {
    final temporary = await Directory.systemTemp.createTemp(
      'famhistory-project-',
    );
    addTearDown(() async {
      if (await temporary.exists()) await temporary.delete(recursive: true);
    });
    final legacyDirectory = Directory(p.join(temporary.path, 'legacy'));
    await legacyDirectory.create(recursive: true);
    final legacyFile = File(
      p.join(legacyDirectory.path, 'family_history.sqlite'),
    );
    final legacyDatabase = AppDatabase(NativeDatabase(legacyFile));
    final now = DateTime.utc(2026, 8, 15);
    await legacyDatabase
        .into(legacyDatabase.projects)
        .insert(
          ProjectsCompanion.insert(
            id: 'legacy-project',
            name: 'Projecte anterior',
            createdAt: now,
            modifiedAt: now,
          ),
        );
    await legacyDatabase.close();
    final originalBytes = await legacyFile.readAsBytes();
    AppDatabase databaseFactory(String path) =>
        AppDatabase(NativeDatabase(File(path)));

    final controller = await ProjectWorkspaceController.initialize(
      applicationDirectory: Directory(p.join(temporary.path, 'support')),
      legacyDirectory: legacyDirectory,
      databaseFactory: databaseFactory,
    );
    addTearDown(() async {
      await controller.close();
      controller.dispose();
    });

    expect(controller.isAvailable, isTrue);
    expect(
      (await controller.database!.select(controller.database!.projects).get())
          .map((project) => project.id),
      contains('legacy-project'),
    );
    expect(await legacyFile.readAsBytes(), originalBytes);

    final migratedArchive = File(p.join(temporary.path, 'migrated.famhistory'));
    await controller.saveAs(migratedArchive);
    expect(await migratedArchive.exists(), isTrue);

    final newArchive = File(p.join(temporary.path, 'new-project.famhistory'));
    await controller.createProject(
      name: 'Projecte nou',
      destination: newArchive,
    );
    expect(controller.manifest!.name, 'Projecte nou');
    expect(
      (await controller.database!.select(controller.database!.projects).get())
          .map((project) => project.id),
      isNot(contains('legacy-project')),
    );

    final backup = File(p.join(temporary.path, 'backup.famhistory'));
    await controller.createBackup(backup);
    expect(await backup.exists(), isTrue);
    expect(controller.archiveFile!.path, newArchive.path);

    await controller.openProject(migratedArchive);
    expect(
      (await controller.database!.select(controller.database!.projects).get())
          .map((project) => project.id),
      contains('legacy-project'),
    );
  });
}
