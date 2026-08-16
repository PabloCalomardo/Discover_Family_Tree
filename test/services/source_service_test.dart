import 'dart:io';

import 'package:drift/native.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/database/database.dart' show AppDatabase;
import 'package:family_history/database/drift_transaction_runner.dart';
import 'package:family_history/database/repositories/drift_audit_repository.dart';
import 'package:family_history/database/repositories/drift_media_repository.dart';
import 'package:family_history/database/repositories/drift_source_repository.dart';
import 'package:family_history/domain/source/media_asset.dart';
import 'package:family_history/domain/source/source.dart';
import 'package:family_history/services/audit/audit_service.dart';
import 'package:family_history/services/source/source_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  test('copies attached media into the workspace and audits it', () async {
    final temporary = await Directory.systemTemp.createTemp('source-service-');
    addTearDown(() => temporary.delete(recursive: true));
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final sources = DriftSourceRepository(database);
    final media = DriftMediaRepository(database);
    final auditRepository = DriftAuditRepository(database);
    final service = SourceService(
      sources,
      media,
      AuditService(auditRepository),
      DriftTransactionRunner(database),
    );
    final now = DateTime.utc(2026, 8, 16);
    final source = Source(
      id: SourceId.generate(),
      type: SourceType.document,
      title: 'Document',
      createdAt: now,
      modifiedAt: now,
    );
    await service.create(source);
    final input = File(p.join(temporary.path, 'original.pdf'));
    await input.writeAsBytes([1, 2, 3, 4]);

    final attached = await service.attachFile(
      sourceId: source.id,
      input: input,
      workspace: temporary,
      type: MediaType.document,
      role: SourceMediaRole.primary,
      caption: 'Original',
    );

    expect(attached.relativePath, startsWith('media/documents/'));
    expect(
      await File(
        p.joinAll([temporary.path, ...attached.relativePath.split('/')]),
      ).readAsBytes(),
      [1, 2, 3, 4],
    );
    expect(await media.watchForSource(source.id).first, hasLength(1));
    expect(
      await auditRepository.watchForEntity('SOURCE', source.id.value).first,
      hasLength(2),
    );
  });
}
