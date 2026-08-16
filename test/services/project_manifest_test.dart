import 'package:family_history/services/project/project_manifest.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('manifest v1 round-trips with independent version fields', () {
    final manifest = ProjectManifest(
      projectId: 'project-1',
      name: 'Família Puig',
      createdAt: DateTime.utc(2026, 8, 15),
      modifiedAt: DateTime.utc(2026, 8, 16),
      databaseSchemaVersion: 3,
      appVersion: '1.0.0+1',
      media: const [
        MediaChecksum(
          path: 'media/images/retrat.jpg',
          sha256: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
          size: 42,
        ),
      ],
    );

    final restored = ProjectManifest.decode(manifest.encode());

    expect(restored.projectId, 'project-1');
    expect(restored.name, 'Família Puig');
    expect(restored.databaseSchemaVersion, 3);
    expect(restored.appVersion, '1.0.0+1');
    expect(restored.media.single.path, 'media/images/retrat.jpg');
  });

  test('rejects a future format version with an actionable error', () {
    expect(
      () => ProjectManifest.fromJson({
        'format': 'famhistory',
        'formatVersion': 2,
        'projectId': 'project-1',
        'name': 'Família Puig',
        'createdAt': '2026-08-15T00:00:00Z',
        'modifiedAt': '2026-08-15T00:00:00Z',
      }),
      throwsA(
        isA<ProjectFormatException>().having(
          (error) => error.message,
          'message',
          contains('Actualitza FamilyHistory'),
        ),
      ),
    );
  });
}
