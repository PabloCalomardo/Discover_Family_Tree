import 'dart:io';

import 'package:archive/archive.dart';
import 'package:drift/native.dart';
import 'package:family_history/database/database.dart';
import 'package:family_history/services/project/family_history_archive_service.dart';
import 'package:family_history/services/project/project_manifest.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  late Directory temporary;
  late FamilyHistoryArchiveService service;

  setUp(() async {
    temporary = await Directory.systemTemp.createTemp('famhistory-archive-');
    service = FamilyHistoryArchiveService();
  });

  tearDown(() async {
    if (await temporary.exists()) await temporary.delete(recursive: true);
  });

  test('packages and opens SQLite, folders and verified media', () async {
    final workspace = Directory(p.join(temporary.path, 'workspace'));
    await service.prepareWorkspace(workspace);
    final database = AppDatabase(
      NativeDatabase(File(p.join(workspace.path, 'database.sqlite'))),
    );
    addTearDown(database.close);
    final now = DateTime.utc(2026, 8, 15);
    await database
        .into(database.projects)
        .insert(
          ProjectsCompanion.insert(
            id: 'project-1',
            name: 'Família Puig',
            createdAt: now,
            modifiedAt: now,
          ),
        );
    final media = File(p.join(workspace.path, 'media', 'images', 'retrat.bin'));
    await media.writeAsBytes([1, 2, 3, 4], flush: true);
    await File(p.join(workspace.path, 'thumbnails', 'retrat.bin'))
        .writeAsBytes([4, 3, 2, 1], flush: true);
    final archiveFile = File(p.join(temporary.path, 'familia.famhistory'));

    final savedManifest = await service.writeArchive(
      destination: archiveFile,
      workspace: workspace,
      database: database,
      manifest: ProjectManifest(
        projectId: 'project-1',
        name: 'Família Puig',
        createdAt: now,
        modifiedAt: now,
      ),
    );
    final opened = await service.openArchive(
      source: archiveFile,
      destination: Directory(p.join(temporary.path, 'opened')),
    );

    expect(savedManifest.media, hasLength(2));
    expect(opened.manifest.projectId, 'project-1');
    expect(
      await File(p.join(opened.workspace.path, 'media', 'images', 'retrat.bin'))
          .readAsBytes(),
      [1, 2, 3, 4],
    );
    for (final relative in FamilyHistoryArchiveService.requiredDirectories) {
      expect(
        await Directory(
          p.joinAll([opened.workspace.path, ...relative.split('/')]),
        ).exists(),
        isTrue,
      );
    }
    final restoredDatabase = AppDatabase(
      NativeDatabase(File(p.join(opened.workspace.path, 'database.sqlite'))),
    );
    expect(
      await restoredDatabase.select(restoredDatabase.projects).get(),
      hasLength(1),
    );
    await restoredDatabase.close();
  });

  test('rejects changed media using the SHA-256 manifest checksum', () async {
    final archiveFile = await _createArchiveWithMedia(temporary, service);
    final archive = ZipDecoder().decodeBytes(await archiveFile.readAsBytes());
    archive.add(ArchiveFile.bytes('media/images/retrat.bin', [9, 9, 9]));
    await archiveFile.writeAsBytes(
      ZipEncoder().encodeBytes(archive),
      flush: true,
    );

    expect(
      () => service.openArchive(
        source: archiveFile,
        destination: Directory(p.join(temporary.path, 'tampered')),
      ),
      throwsA(
        isA<ProjectFormatException>().having(
          (error) => error.message,
          'message',
          contains('integritat'),
        ),
      ),
    );
  });

  test('rejects paths that could escape the extraction directory', () async {
    final archiveFile = await _createArchiveWithMedia(temporary, service);
    final archive = ZipDecoder().decodeBytes(await archiveFile.readAsBytes());
    archive.add(ArchiveFile.bytes('../outside.txt', [1]));
    await archiveFile.writeAsBytes(
      ZipEncoder().encodeBytes(archive),
      flush: true,
    );

    expect(
      () => service.openArchive(
        source: archiveFile,
        destination: Directory(p.join(temporary.path, 'unsafe')),
      ),
      throwsA(isA<ProjectFormatException>()),
    );
    expect(await File(p.join(temporary.path, 'outside.txt')).exists(), isFalse);
  });

  test('rejects a project with a future SQLite schema', () async {
    final now = DateTime.utc(2026, 8, 16);
    final archive = Archive()
      ..add(
        ArchiveFile.string(
          'manifest.json',
          ProjectManifest(
            projectId: 'project-1',
            name: 'Família futura',
            createdAt: now,
            modifiedAt: now,
            databaseSchemaVersion: 999,
          ).encode(),
        ),
      )
      ..add(ArchiveFile.bytes('database.sqlite', [0]));
    final archiveFile = File(p.join(temporary.path, 'future.famhistory'));
    await archiveFile.writeAsBytes(ZipEncoder().encodeBytes(archive));

    expect(
      () => service.openArchive(
        source: archiveFile,
        destination: Directory(p.join(temporary.path, 'future-opened')),
      ),
      throwsA(
        isA<ProjectFormatException>().having(
          (error) => error.message,
          'message',
          contains('schema SQLite'),
        ),
      ),
    );
  });
}

Future<File> _createArchiveWithMedia(
  Directory temporary,
  FamilyHistoryArchiveService service,
) async {
  final workspace = Directory(p.join(temporary.path, 'source-workspace'));
  await service.prepareWorkspace(workspace);
  await File(p.join(workspace.path, 'media', 'images', 'retrat.bin'))
      .writeAsBytes([1, 2, 3], flush: true);
  final database = AppDatabase(
    NativeDatabase(File(p.join(workspace.path, 'database.sqlite'))),
  );
  final now = DateTime.utc(2026, 8, 15);
  await database.customSelect('SELECT 1').get();
  final archiveFile = File(p.join(temporary.path, 'project.famhistory'));
  await service.writeArchive(
    destination: archiveFile,
    workspace: workspace,
    database: database,
    manifest: ProjectManifest(
      projectId: 'project-1',
      name: 'Família Puig',
      createdAt: now,
      modifiedAt: now,
    ),
  );
  await database.close();
  return archiveFile;
}
