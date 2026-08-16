import 'package:drift/native.dart';
import 'package:family_history/app/providers.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/database/database.dart' as db;
import 'package:family_history/domain/claim/claim.dart';
import 'package:family_history/domain/extraction/extraction.dart';
import 'package:family_history/domain/person/person_name.dart';
import 'package:family_history/domain/place/place.dart';
import 'package:family_history/domain/source/source.dart';
import 'package:family_history/services/extraction/deterministic_extraction_provider.dart';
import 'package:family_history/services/extraction/entity_resolution_service.dart';
import 'package:family_history/services/extraction/extraction_claim_mapper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  const extractor = DeterministicExtractionProvider();
  const resolver = EntityResolutionService();
  const mapper = ExtractionClaimMapper();
  final now = DateTime.utc(2026, 8, 16);

  test('resolves only unique exact names and places', () {
    final claraId = PersonId.generate();
    final manresaId = PlaceId.generate();
    final extraction = extractor.extractSync(
      'Em dic Clara Vidal. Vaig néixer a Manresa el 12 de març de 1958.',
    );

    final resolved = resolver.resolve(
      extraction: extraction,
      knownNames: [
        PersonName(
          id: PersonNameId.generate(),
          personId: claraId,
          displayName: 'Clara Vidal',
          type: PersonNameType.birth,
          isPreferred: true,
          createdAt: now,
          modifiedAt: now,
        ),
      ],
      knownPlaces: [
        Place(
          id: manresaId,
          preferredName: 'Manresa',
          type: PlaceType.city,
          createdAt: now,
          modifiedAt: now,
        ),
      ],
    );

    expect(resolved.people.single.resolvedId, claraId);
    expect(resolved.places.single.resolvedId, manresaId);
  });

  test('blocks duplicated exact matches instead of choosing silently', () {
    final extraction = extractor.extractSync('Em dic Clara Vidal.');
    PersonName knownName(PersonId personId) => PersonName(
      id: PersonNameId.generate(),
      personId: personId,
      displayName: 'Clara Vidal',
      type: PersonNameType.birth,
      isPreferred: true,
      createdAt: now,
      modifiedAt: now,
    );
    final resolved = resolver.resolve(
      extraction: extraction,
      knownNames: [
        knownName(PersonId.generate()),
        knownName(PersonId.generate()),
      ],
      knownPlaces: const [],
    );

    expect(resolved.people.single.resolvedId, isNull);
    expect(resolved.people.single.resolutionAmbiguous, isTrue);
    expect(
      () => mapper.map(
        extraction: resolved,
        sourceId: SourceId.generate(),
        selectedRefs: {resolved.people.single.ref},
        now: now,
      ),
      throwsStateError,
    );
  });

  test('adds creation dependencies before selected relationship claims', () {
    final extraction = extractor.extractSync(
      'Em dic Clara Vidal. La meva mare, Rosa Puig, havia nascut a Berga.',
    );
    final relation = extraction.relationships.single;

    final claims = mapper.map(
      extraction: extraction,
      sourceId: SourceId.generate(),
      selectedRefs: {relation.ref},
      now: now,
    );

    expect(
      claims.where((claim) => claim.property == ClaimProperty.personCreation),
      hasLength(2),
    );
    final relationClaim = claims.singleWhere(
      (claim) => claim.property == ClaimProperty.parentChildRelationship,
    );
    final value = relationClaim.value as ParentChildClaimValue;
    final people = claims
        .where((claim) => claim.value is PersonCreationClaimValue)
        .map((claim) => claim.value as PersonCreationClaimValue)
        .toList();
    expect(
      people
          .singleWhere((person) => person.preferredName == 'Rosa Puig')
          .personId,
      value.parentId,
    );
    expect(
      people
          .singleWhere((person) => person.preferredName == 'Clara Vidal')
          .personId,
      value.childId,
    );
  });

  test('maps an explicit sibling claim without inventing a parent', () {
    final extraction = extractor.extractSync(
      "Em dic Clara Vidal. Em vaig casar amb l'Àlex Serra. "
      "Em sembla que l'Àlex tenia una germana que es deia Marta.",
    );
    final sibling = extraction.relationships.singleWhere(
      (item) => item.type == CandidateRelationshipType.sibling,
    );

    final claims = mapper.map(
      extraction: extraction,
      sourceId: SourceId.generate(),
      selectedRefs: {sibling.ref},
      now: now,
    );

    final siblingClaims = claims.where(
      (claim) => claim.property == ClaimProperty.siblingRelationship,
    );
    expect(siblingClaims, hasLength(1));
    expect(siblingClaims.single.value, isA<SiblingClaimValue>());
    expect(
      claims.where(
        (claim) => claim.property == ClaimProperty.parentChildRelationship,
      ),
      isEmpty,
      reason: 'No s’han de crear progenitors ficticis.',
    );
    expect(
      claims.where((claim) => claim.property == ClaimProperty.personCreation),
      hasLength(2),
    );
  });

  test(
    'requires narrator identity before mapping first-person family relations',
    () {
      const text =
          'Els meus pares es deien Maria i Josep. Em vaig casar amb l’Antoni.';
      final unnamed = extractor.extractSync(text);
      expect(
        () => mapper.map(
          extraction: unnamed,
          sourceId: SourceId.generate(),
          selectedRefs: unnamed.relationships.map((item) => item.ref).toSet(),
          now: now,
        ),
        throwsStateError,
      );

      final named = extractor.extractSync(text, narratorName: 'Mercè Soler');
      final claims = mapper.map(
        extraction: named,
        sourceId: SourceId.generate(),
        selectedRefs: {
          ...named.people.map((item) => item.ref),
          ...named.relationships.map((item) => item.ref),
        },
        now: now,
      );
      expect(
        claims.where((item) => item.property == ClaimProperty.personCreation),
        hasLength(4),
      );
      expect(
        claims.where(
          (item) => item.property == ClaimProperty.parentChildRelationship,
        ),
        hasLength(2),
      );
      expect(
        claims.where((item) => item.property == ClaimProperty.partnership),
        hasLength(1),
      );
    },
  );

  test(
    'persists all selected claims and audits in one controller operation',
    () async {
      final database = db.AppDatabase(NativeDatabase.memory());
      final container = ProviderContainer(
        overrides: [databaseProvider.overrideWithValue(database)],
      );
      addTearDown(() async {
        container.dispose();
        await database.close();
      });
      final sourceId = SourceId.generate();
      await container
          .read(sourceRepositoryProvider)
          .create(
            Source(
              id: sourceId,
              type: SourceType.interview,
              title: 'Entrevista sintètica',
              createdAt: now,
              modifiedAt: now,
            ),
          );
      final controller = container.read(textExtractionControllerProvider);
      final extraction = await controller.analyze(
        'Em dic Clara Vidal. Vaig néixer a Manresa el 12 de març de 1958.',
      );
      final selected = {
        ...extraction.people.map((item) => item.ref),
        ...extraction.places.map((item) => item.ref),
        ...extraction.events.map((item) => item.ref),
      };

      final count = await controller.createClaims(
        sourceId: sourceId,
        extraction: extraction,
        selectedRefs: selected,
      );

      expect(count, 3);
      expect(await database.select(database.claims).get(), hasLength(3));
      expect(await database.select(database.auditEntries).get(), hasLength(3));
    },
  );
}
