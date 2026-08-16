import 'package:drift/native.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/database/database.dart' show AppDatabase;
import 'package:family_history/database/repositories/drift_audit_repository.dart';
import 'package:family_history/database/repositories/drift_claim_repository.dart';
import 'package:family_history/database/repositories/drift_duplicate_candidate_repository.dart';
import 'package:family_history/database/repositories/drift_media_repository.dart';
import 'package:family_history/database/repositories/drift_person_repository.dart';
import 'package:family_history/database/repositories/drift_source_repository.dart';
import 'package:family_history/domain/audit/audit_entry.dart';
import 'package:family_history/domain/claim/claim.dart';
import 'package:family_history/domain/duplicate/duplicate_candidate.dart';
import 'package:family_history/domain/person/person.dart';
import 'package:family_history/domain/source/media_asset.dart';
import 'package:family_history/domain/source/source.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  final now = DateTime.utc(2026, 8, 16);

  setUp(() => database = AppDatabase(NativeDatabase.memory()));
  tearDown(() => database.close());

  test('persists sources, media links and typed claims', () async {
    final sources = DriftSourceRepository(database);
    final media = DriftMediaRepository(database);
    final claims = DriftClaimRepository(database);
    final source = Source(
      id: SourceId.generate(),
      type: SourceType.document,
      title: 'Certificat',
      createdAt: now,
      modifiedAt: now,
    );
    await sources.create(source);
    final asset = MediaAsset(
      id: MediaId.generate(),
      type: MediaType.document,
      relativePath: 'media/documents/certificat.pdf',
      checksumSha256: List.filled(64, 'a').join(),
      fileSize: 10,
      createdAt: now,
      modifiedAt: now,
    );
    await media.create(asset);
    await media.createLink(
      SourceMedia(
        id: SourceMediaId.generate(),
        sourceId: source.id,
        mediaId: asset.id,
        role: SourceMediaRole.primary,
        sortOrder: 0,
        createdAt: now,
        modifiedAt: now,
      ),
    );
    final personId = PersonId.generate();
    final claim = Claim(
      id: ClaimId.generate(),
      subjectType: ClaimSubjectType.person,
      subjectId: personId.value,
      property: ClaimProperty.personSex,
      value: EnumClaimValue('MALE'),
      sourceId: source.id,
      status: ClaimStatus.accepted,
      createdAt: now,
      modifiedAt: now,
    );
    await claims.create(claim);

    expect(await sources.get(source.id), isNotNull);
    expect(await media.watchForSource(source.id).first, hasLength(1));
    final storedClaims = await claims.watchForSource(source.id).first;
    expect(storedClaims.single.value, isA<EnumClaimValue>());
  });

  test('persists canonical duplicate candidate and audit targets', () async {
    final people = DriftPersonRepository(database);
    final first = PersonId.generate();
    final second = PersonId.generate();
    for (final id in [first, second]) {
      await people.create(
        Person(id: id, sex: PersonSex.unknown, createdAt: now, modifiedAt: now),
      );
    }
    final duplicates = DriftDuplicateCandidateRepository(database);
    final candidate = DuplicateCandidate(
      id: DuplicateCandidateId.generate(),
      personAId: second,
      personBId: first,
      score: 75,
      reasonCodes: const ['NAME_EXACT'],
      detectorVersion: 1,
      status: DuplicateCandidateStatus.pending,
      lastEvaluatedAt: now,
      createdAt: now,
      modifiedAt: now,
    );
    await duplicates.upsert(candidate);
    expect(await duplicates.getByPair(first, second), isNotNull);

    final audit = DriftAuditRepository(database);
    final entry = AuditEntry(
      id: AuditEntryId.generate(),
      type: AuditType.duplicateReviewed,
      origin: AuditOrigin.user,
      occurredAt: now,
      payload: const {'status': 'PENDING'},
      targets: [
        AuditTarget(entityType: 'PERSON', entityId: first.value, role: 'A'),
      ],
    );
    await audit.append(entry);
    expect(
      await audit.watchForEntity('PERSON', first.value).first,
      hasLength(1),
    );
  });
}
