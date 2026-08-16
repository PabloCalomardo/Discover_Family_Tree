import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
import 'package:family_history/database/database.dart';
import 'package:family_history/database/migrations/migration_runner.dart';
import 'package:family_history/services/project/project_manifest.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

class OpenedProjectArchive {
  const OpenedProjectArchive({required this.manifest, required this.workspace});

  final ProjectManifest manifest;
  final Directory workspace;
}

class FamilyHistoryArchiveService {
  FamilyHistoryArchiveService({Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  static const requiredDirectories = [
    'media/audio',
    'media/images',
    'media/documents',
    'thumbnails',
  ];

  final Uuid _uuid;

  Future<void> prepareWorkspace(Directory workspace) async {
    await workspace.create(recursive: true);
    for (final relativePath in requiredDirectories) {
      await Directory(p.joinAll([workspace.path, ...relativePath.split('/')]))
          .create(recursive: true);
    }
  }

  Future<ProjectManifest> writeArchive({
    required File destination,
    required Directory workspace,
    required AppDatabase database,
    required ProjectManifest manifest,
  }) async {
    await prepareWorkspace(workspace);
    final mediaFiles = await _mediaFiles(workspace);
    final checksums = <MediaChecksum>[];
    for (final entry in mediaFiles) {
      final bytes = await entry.file.readAsBytes();
      checksums.add(
        MediaChecksum(
          path: entry.relativePath,
          sha256: sha256.convert(bytes).toString(),
          size: bytes.length,
        ),
      );
    }
    final completeManifest = manifest.copyWith(
      databaseSchemaVersion: database.schemaVersion,
      appVersion: familyHistoryAppVersion,
      media: List.unmodifiable(checksums),
    );
    await File(p.join(workspace.path, 'manifest.json'))
        .writeAsString(completeManifest.encode(), flush: true);

    final snapshot = File(
      p.join(workspace.path, '.database-${_uuid.v4()}.sqlite'),
    );
    try {
      final escapedSnapshot = snapshot.path.replaceAll("'", "''");
      await database.customStatement("VACUUM INTO '$escapedSnapshot'");

      final archive = Archive()
        ..add(ArchiveFile.string('manifest.json', completeManifest.encode()))
        ..add(
          ArchiveFile.bytes('database.sqlite', await snapshot.readAsBytes()),
        );
      for (final directory in requiredDirectories) {
        archive.add(ArchiveFile.directory('$directory/'));
      }
      for (final entry in mediaFiles) {
        archive.add(
          ArchiveFile.bytes(entry.relativePath, await entry.file.readAsBytes()),
        );
      }

      final encoded = ZipEncoder().encodeBytes(archive);
      await _replaceAtomically(destination, encoded);
      return completeManifest;
    } catch (error) {
      throw ProjectFormatException(
        'No s’ha pogut crear una còpia consistent del projecte: $error',
      );
    } finally {
      if (await snapshot.exists()) {
        await snapshot.delete();
      }
    }
  }

  Future<OpenedProjectArchive> openArchive({
    required File source,
    required Directory destination,
  }) async {
    if (!await source.exists()) {
      throw const ProjectFormatException(
        'El projecte seleccionat no existeix.',
      );
    }

    late Archive archive;
    try {
      archive = ZipDecoder().decodeBytes(
        await source.readAsBytes(),
        verify: true,
      );
    } catch (_) {
      throw const ProjectFormatException(
        'El fitxer .famhistory està malmès o no és un ZIP vàlid.',
      );
    }

    final files = <String, ArchiveFile>{};
    for (final entry in archive) {
      if (entry.isSymbolicLink) {
        throw const ProjectFormatException(
          'El projecte conté enllaços simbòlics no admesos.',
        );
      }
      final normalized = _safeArchivePath(entry.name);
      if (normalized.isEmpty) continue;
      if (!_isAllowedPath(normalized)) {
        throw ProjectFormatException(
          'El projecte conté una ruta no admesa: $normalized.',
        );
      }
      if (entry.isFile) files[normalized] = entry;
    }

    final manifestEntry = files['manifest.json'];
    final databaseEntry = files['database.sqlite'];
    if (manifestEntry == null || databaseEntry == null) {
      throw const ProjectFormatException(
        'El projecte no conté manifest.json i database.sqlite.',
      );
    }

    ProjectManifest manifest;
    try {
      manifest = ProjectManifest.decode(utf8.decode(manifestEntry.content));
    } on FormatException {
      throw const ProjectFormatException(
        'El manifest no està codificat correctament en UTF-8.',
      );
    }
    if (manifest.databaseSchemaVersion > currentSchemaVersion) {
      throw ProjectFormatException(
        'Aquest projecte usa l’schema SQLite '
        '${manifest.databaseSchemaVersion}. Actualitza FamilyHistory per obrir-lo.',
      );
    }
    _validateMedia(files, manifest.media);

    if (await destination.exists()) {
      throw const ProjectFormatException(
        'El directori de treball de destinació ja existeix.',
      );
    }
    await prepareWorkspace(destination);
    try {
      for (final entry in files.entries) {
        final output = File(
          p.joinAll([destination.path, ...entry.key.split('/')]),
        );
        await output.parent.create(recursive: true);
        await output.writeAsBytes(entry.value.content, flush: true);
      }
    } catch (_) {
      if (await destination.exists()) {
        await destination.delete(recursive: true);
      }
      rethrow;
    }
    return OpenedProjectArchive(manifest: manifest, workspace: destination);
  }

  void _validateMedia(
    Map<String, ArchiveFile> files,
    List<MediaChecksum> checksums,
  ) {
    final expected = {for (final item in checksums) item.path: item};
    final actualPaths = files.keys.where(
      (path) => path.startsWith('media/') || path.startsWith('thumbnails/'),
    );
    for (final path in actualPaths) {
      final checksum = expected[path];
      if (checksum == null) {
        throw ProjectFormatException(
          'Falta el checksum del fitxer multimèdia $path.',
        );
      }
      final bytes = files[path]!.content;
      if (bytes.length != checksum.size ||
          sha256.convert(bytes).toString() != checksum.sha256) {
        throw ProjectFormatException(
          'El fitxer multimèdia $path no supera la verificació d’integritat.',
        );
      }
    }
    for (final path in expected.keys) {
      if (!files.containsKey(path)) {
        throw ProjectFormatException(
          'Falta el fitxer multimèdia declarat $path.',
        );
      }
    }
  }

  String _safeArchivePath(String input) {
    final slashPath = input.replaceAll('\\', '/');
    final normalized = p.posix.normalize(slashPath);
    if (normalized == '.' || normalized == '/') return '';
    if (p.posix.isAbsolute(normalized) ||
        normalized == '..' ||
        normalized.startsWith('../') ||
        normalized.contains('/../')) {
      throw ProjectFormatException('Ruta insegura dins del projecte: $input.');
    }
    return normalized.replaceAll(RegExp(r'/+$'), '');
  }

  bool _isAllowedPath(String path) =>
      path == 'manifest.json' ||
      path == 'database.sqlite' ||
      path == 'media' ||
      path.startsWith('media/') ||
      path == 'thumbnails' ||
      path.startsWith('thumbnails/');

  Future<List<_WorkspaceFile>> _mediaFiles(Directory workspace) async {
    final result = <_WorkspaceFile>[];
    for (final root in ['media', 'thumbnails']) {
      final directory = Directory(p.join(workspace.path, root));
      if (!await directory.exists()) continue;
      await for (final entity in directory.list(recursive: true)) {
        if (entity is! File) continue;
        final relative = p
            .relative(entity.path, from: workspace.path)
            .replaceAll('\\', '/');
        result.add(_WorkspaceFile(file: entity, relativePath: relative));
      }
    }
    result.sort((a, b) => a.relativePath.compareTo(b.relativePath));
    return result;
  }

  Future<void> _replaceAtomically(File destination, List<int> bytes) async {
    await destination.parent.create(recursive: true);
    final temporary = File('${destination.path}.tmp-${_uuid.v4()}');
    final previous = File('${destination.path}.previous-${_uuid.v4()}');
    await temporary.writeAsBytes(bytes, flush: true);
    var movedPrevious = false;
    try {
      if (await destination.exists()) {
        await destination.rename(previous.path);
        movedPrevious = true;
      }
      await temporary.rename(destination.path);
      if (movedPrevious && await previous.exists()) await previous.delete();
    } catch (_) {
      if (movedPrevious &&
          !await destination.exists() &&
          await previous.exists()) {
        await previous.rename(destination.path);
      }
      rethrow;
    } finally {
      if (await temporary.exists()) await temporary.delete();
    }
  }
}

class _WorkspaceFile {
  const _WorkspaceFile({required this.file, required this.relativePath});

  final File file;
  final String relativePath;
}
