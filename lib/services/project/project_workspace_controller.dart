import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:family_history/database/database.dart';
import 'package:family_history/services/project/family_history_archive_service.dart';
import 'package:family_history/services/project/project_manifest.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

typedef ProjectDatabaseFactory = AppDatabase Function(String path);

class ProjectWorkspaceController extends ChangeNotifier {
  ProjectWorkspaceController._({
    required this._applicationDirectory,
    required this._archives,
    required this._uuid,
    required this._databaseFactory,
  });

  ProjectWorkspaceController.disabled()
    : _applicationDirectory = Directory.systemTemp,
      _archives = FamilyHistoryArchiveService(),
      _uuid = const Uuid(),
      _databaseFactory = AppDatabase.atPath;

  static Future<ProjectWorkspaceController> initialize({
    Directory? applicationDirectory,
    Directory? legacyDirectory,
    FamilyHistoryArchiveService? archives,
    Uuid? uuid,
    ProjectDatabaseFactory databaseFactory = AppDatabase.atPath,
  }) async {
    final supportDirectory =
        applicationDirectory ?? await getApplicationSupportDirectory();
    final controller = ProjectWorkspaceController._(
      applicationDirectory: Directory(
        p.join(supportDirectory.path, 'FamilyHistory'),
      ),
      archives: archives ?? FamilyHistoryArchiveService(uuid: uuid),
      uuid: uuid ?? const Uuid(),
      databaseFactory: databaseFactory,
    );
    await controller._initialize(
      legacyDirectory ?? await getApplicationDocumentsDirectory(),
    );
    return controller;
  }

  final Directory _applicationDirectory;
  final FamilyHistoryArchiveService _archives;
  final Uuid _uuid;
  final ProjectDatabaseFactory _databaseFactory;

  AppDatabase? _database;
  Directory? _workspace;
  ProjectManifest? _manifest;
  File? _archiveFile;
  bool _busy = false;

  AppDatabase? get database => _database;
  Directory? get workspace => _workspace;
  ProjectManifest? get manifest => _manifest;
  File? get archiveFile => _archiveFile;
  bool get isAvailable => _database != null && _manifest != null;
  bool get isBusy => _busy;
  bool get hasArchive => _archiveFile != null;

  Future<void> _initialize(Directory legacyDirectory) async {
    await _applicationDirectory.create(recursive: true);
    final restored = await _restoreLastSession();
    if (restored) return;
    await _migrateLegacyOrCreate(legacyDirectory);
  }

  Future<bool> _restoreLastSession() async {
    final sessionFile = _sessionFile;
    if (!await sessionFile.exists()) return false;
    try {
      final decoded = jsonDecode(await sessionFile.readAsString());
      if (decoded is! Map) return false;
      final workspacePath = decoded['workspace'];
      if (workspacePath is! String) return false;
      final workspace = Directory(workspacePath);
      final databaseFile = File(p.join(workspace.path, 'database.sqlite'));
      final manifestFile = File(p.join(workspace.path, 'manifest.json'));
      if (!await databaseFile.exists() || !await manifestFile.exists()) {
        return false;
      }
      final manifest = ProjectManifest.decode(
        await manifestFile.readAsString(),
      );
      final archivePath = decoded['archive'];
      await _activate(
        workspace: workspace,
        manifest: manifest,
        archiveFile: archivePath is String ? File(archivePath) : null,
        persist: false,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> _migrateLegacyOrCreate(Directory legacyDirectory) async {
    final id = _uuid.v4();
    final workspace = Directory(p.join(_projectsDirectory.path, id));
    await _archives.prepareWorkspace(workspace);
    final targetDatabase = File(p.join(workspace.path, 'database.sqlite'));
    final legacyDatabase = File(
      p.join(legacyDirectory.path, 'family_history.sqlite'),
    );
    if (await legacyDatabase.exists()) {
      await legacyDatabase.copy(targetDatabase.path);
      for (final suffix in ['-wal', '-shm']) {
        final companion = File('${legacyDatabase.path}$suffix');
        if (await companion.exists()) {
          await companion.copy('${targetDatabase.path}$suffix');
        }
      }
    }
    final now = DateTime.now().toUtc();
    final manifest = ProjectManifest(
      projectId: id,
      name: 'La meva família',
      createdAt: now,
      modifiedAt: now,
    );
    await _writeLocalManifest(workspace, manifest);
    await _activate(
      workspace: workspace,
      manifest: manifest,
      archiveFile: null,
    );
  }

  Future<void> createProject({
    required String name,
    required File destination,
  }) => _exclusive(() async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      throw const ProjectFormatException('El projecte necessita un nom.');
    }
    final now = DateTime.now().toUtc();
    final manifest = ProjectManifest(
      projectId: _uuid.v4(),
      name: trimmedName,
      createdAt: now,
      modifiedAt: now,
    );
    final workspace = Directory(
      p.join(_projectsDirectory.path, manifest.projectId),
    );
    await _archives.prepareWorkspace(workspace);
    final database = _databaseFactory(
      p.join(workspace.path, 'database.sqlite'),
    );
    try {
      await _upsertProject(database, manifest);
      final savedManifest = await _archives.writeArchive(
        destination: _withExtension(destination),
        workspace: workspace,
        database: database,
        manifest: manifest,
      );
      await database.close();
      await _activate(
        workspace: workspace,
        manifest: savedManifest,
        archiveFile: _withExtension(destination),
      );
    } catch (_) {
      await database.close();
      rethrow;
    }
  });

  Future<void> openProject(File source) => _exclusive(() async {
    final workspace = Directory(
      p.join(_projectsDirectory.path, 'opened-${_uuid.v4()}'),
    );
    final opened = await _archives.openArchive(
      source: source,
      destination: workspace,
    );
    try {
      await _activate(
        workspace: opened.workspace,
        manifest: opened.manifest,
        archiveFile: source,
      );
    } catch (_) {
      if (await workspace.exists()) await workspace.delete(recursive: true);
      rethrow;
    }
  });

  Future<void> save() async {
    final destination = _archiveFile;
    if (destination == null) {
      throw const ProjectFormatException(
        'Tria una ubicació amb “Desar com” abans de desar.',
      );
    }
    await saveAs(destination);
  }

  Future<void> saveAs(File destination) => _exclusive(() async {
    final database = _requireDatabase();
    final workspace = _requireWorkspace();
    final updated = _requireManifest().copyWith(
      modifiedAt: DateTime.now().toUtc(),
    );
    await _upsertProject(database, updated);
    final target = _withExtension(destination);
    final saved = await _archives.writeArchive(
      destination: target,
      workspace: workspace,
      database: database,
      manifest: updated,
    );
    _manifest = saved;
    _archiveFile = target;
    await _writeLocalManifest(workspace, saved);
    await _persistSession();
  });

  Future<void> createBackup(File destination) => _exclusive(() async {
    final database = _requireDatabase();
    final workspace = _requireWorkspace();
    final updated = _requireManifest().copyWith(
      modifiedAt: DateTime.now().toUtc(),
    );
    await _upsertProject(database, updated);
    final saved = await _archives.writeArchive(
      destination: _withExtension(destination),
      workspace: workspace,
      database: database,
      manifest: updated,
    );
    _manifest = saved;
    await _writeLocalManifest(workspace, saved);
    await _persistSession();
  });

  Future<void> _activate({
    required Directory workspace,
    required ProjectManifest manifest,
    required File? archiveFile,
    bool persist = true,
  }) async {
    final databasePath = p.join(workspace.path, 'database.sqlite');
    final nextDatabase = _databaseFactory(databasePath);
    try {
      await nextDatabase.customSelect('SELECT 1').get();
      await _upsertProject(nextDatabase, manifest);
    } catch (_) {
      await nextDatabase.close();
      rethrow;
    }
    final previousDatabase = _database;
    _database = nextDatabase;
    _workspace = workspace;
    _manifest = manifest;
    _archiveFile = archiveFile;
    if (persist) await _persistSession();
    notifyListeners();
    if (previousDatabase != null) await previousDatabase.close();
  }

  Future<void> _upsertProject(AppDatabase database, ProjectManifest manifest) =>
      database
          .into(database.projects)
          .insertOnConflictUpdate(
            ProjectsCompanion.insert(
              id: manifest.projectId,
              name: manifest.name,
              createdAt: manifest.createdAt,
              modifiedAt: manifest.modifiedAt,
            ),
          );

  Future<T> _exclusive<T>(Future<T> Function() action) async {
    if (_busy) {
      throw const ProjectFormatException('Ja hi ha una operació en curs.');
    }
    _busy = true;
    notifyListeners();
    try {
      return await action();
    } finally {
      _busy = false;
      notifyListeners();
    }
  }

  Future<void> _writeLocalManifest(
    Directory workspace,
    ProjectManifest manifest,
  ) =>
      File(p.join(workspace.path, 'manifest.json'))
          .writeAsString(manifest.encode(), flush: true);

  Future<void> _persistSession() async {
    final workspace = _workspace;
    if (workspace == null) return;
    await _sessionFile.writeAsString(
      jsonEncode({'workspace': workspace.path, 'archive': _archiveFile?.path}),
      flush: true,
    );
  }

  File _withExtension(File file) =>
      p.extension(file.path).toLowerCase() == '.famhistory'
      ? file
      : File('${file.path}.famhistory');

  AppDatabase _requireDatabase() {
    final value = _database;
    if (value == null) {
      throw const ProjectFormatException('No hi ha cap projecte actiu.');
    }
    return value;
  }

  Directory _requireWorkspace() {
    final value = _workspace;
    if (value == null) {
      throw const ProjectFormatException('No hi ha cap projecte actiu.');
    }
    return value;
  }

  ProjectManifest _requireManifest() {
    final value = _manifest;
    if (value == null) {
      throw const ProjectFormatException('No hi ha cap projecte actiu.');
    }
    return value;
  }

  Directory get _projectsDirectory =>
      Directory(p.join(_applicationDirectory.path, 'projects'));
  File get _sessionFile =>
      File(p.join(_applicationDirectory.path, 'session.json'));

  Future<void> close() async {
    final database = _database;
    _database = null;
    if (database != null) await database.close();
  }

  @override
  void dispose() {
    unawaited(close());
    super.dispose();
  }
}
