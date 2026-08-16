import 'dart:convert';

const familyHistoryFormat = 'famhistory';
const familyHistoryFormatVersion = 1;
const familyHistoryAppVersion = '1.0.0+1';

class ProjectFormatException implements Exception {
  const ProjectFormatException(this.message);

  final String message;

  @override
  String toString() => message;
}

class MediaChecksum {
  const MediaChecksum({
    required this.path,
    required this.sha256,
    required this.size,
  });

  final String path;
  final String sha256;
  final int size;

  factory MediaChecksum.fromJson(Map<String, Object?> json) {
    final path = json['path'];
    final sha256 = json['sha256'];
    final size = json['size'];
    if (path is! String ||
        path.isEmpty ||
        sha256 is! String ||
        !RegExp(r'^[a-f0-9]{64}$').hasMatch(sha256) ||
        size is! int ||
        size < 0) {
      throw const ProjectFormatException(
        'El manifest conté un checksum multimèdia invàlid.',
      );
    }
    return MediaChecksum(path: path, sha256: sha256, size: size);
  }

  Map<String, Object> toJson() => {
    'path': path,
    'sha256': sha256,
    'size': size,
  };
}

class ProjectManifest {
  const ProjectManifest({
    required this.projectId,
    required this.name,
    required this.createdAt,
    required this.modifiedAt,
    this.databaseSchemaVersion = 4,
    this.appVersion = familyHistoryAppVersion,
    this.media = const [],
  });

  final String projectId;
  final String name;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final int databaseSchemaVersion;
  final String appVersion;
  final List<MediaChecksum> media;

  ProjectManifest copyWith({
    String? name,
    DateTime? modifiedAt,
    int? databaseSchemaVersion,
    String? appVersion,
    List<MediaChecksum>? media,
  }) => ProjectManifest(
    projectId: projectId,
    name: name ?? this.name,
    createdAt: createdAt,
    modifiedAt: modifiedAt ?? this.modifiedAt,
    databaseSchemaVersion: databaseSchemaVersion ?? this.databaseSchemaVersion,
    appVersion: appVersion ?? this.appVersion,
    media: media ?? this.media,
  );

  factory ProjectManifest.fromJson(Map<String, Object?> json) {
    if (json['format'] != familyHistoryFormat) {
      throw const ProjectFormatException(
        'El fitxer no és un projecte FamilyHistory.',
      );
    }
    final version = json['formatVersion'];
    if (version is! int) {
      throw const ProjectFormatException('Falta la versió del format.');
    }
    if (version > familyHistoryFormatVersion) {
      throw ProjectFormatException(
        'Aquest projecte usa el format v$version. Actualitza FamilyHistory per obrir-lo.',
      );
    }
    if (version < 1) {
      throw ProjectFormatException('Versió de format no admesa: $version.');
    }

    final projectId = json['projectId'];
    final name = json['name'];
    final createdAt = DateTime.tryParse('${json['createdAt']}');
    final modifiedAt = DateTime.tryParse('${json['modifiedAt']}');
    if (projectId is! String ||
        projectId.isEmpty ||
        name is! String ||
        name.trim().isEmpty ||
        createdAt == null ||
        modifiedAt == null) {
      throw const ProjectFormatException(
        'El manifest del projecte és incomplet o invàlid.',
      );
    }

    final mediaJson = json['media'];
    final media = <MediaChecksum>[];
    if (mediaJson != null) {
      if (mediaJson is! List) {
        throw const ProjectFormatException(
          'La llista multimèdia del manifest és invàlida.',
        );
      }
      for (final item in mediaJson) {
        if (item is! Map) {
          throw const ProjectFormatException(
            'La llista multimèdia del manifest és invàlida.',
          );
        }
        media.add(MediaChecksum.fromJson(item.cast<String, Object?>()));
      }
    }

    return ProjectManifest(
      projectId: projectId,
      name: name.trim(),
      createdAt: createdAt.toUtc(),
      modifiedAt: modifiedAt.toUtc(),
      databaseSchemaVersion: json['databaseSchemaVersion'] is int
          ? json['databaseSchemaVersion']! as int
          : 1,
      appVersion: json['appVersion'] is String
          ? json['appVersion']! as String
          : 'desconeguda',
      media: List.unmodifiable(media),
    );
  }

  factory ProjectManifest.decode(String source) {
    Object? decoded;
    try {
      decoded = jsonDecode(source);
    } on FormatException {
      throw const ProjectFormatException('El manifest no és un JSON vàlid.');
    }
    if (decoded is! Map) {
      throw const ProjectFormatException('El manifest no és un objecte JSON.');
    }
    return ProjectManifest.fromJson(decoded.cast<String, Object?>());
  }

  Map<String, Object> toJson() => {
    'format': familyHistoryFormat,
    'formatVersion': familyHistoryFormatVersion,
    'projectId': projectId,
    'name': name,
    'createdAt': createdAt.toUtc().toIso8601String(),
    'modifiedAt': modifiedAt.toUtc().toIso8601String(),
    'appVersion': appVersion,
    'databaseSchemaVersion': databaseSchemaVersion,
    'media': media.map((item) => item.toJson()).toList(),
  };

  String encode() => const JsonEncoder.withIndent('  ').convert(toJson());
}
