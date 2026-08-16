import 'package:family_history/domain/event/event.dart';
import 'package:family_history/domain/extraction/extraction.dart';
import 'package:family_history/services/extraction/deterministic_extraction_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const provider = DeterministicExtractionProvider();
  const interview = '''Em dic Clara Vidal. Vaig néixer a Manresa el 12 de març de 1958. La meva mare,
Rosa Puig, havia nascut a Berga, però no recordo quin any. El meu pare era en
Jordi Vidal. Els meus pares van viure al carrer Nou 18 de Manresa des de 1955
fins aproximadament al 1970. Jo també hi vaig viure de petita. L'any 1981 em
vaig casar amb l'Àlex Serra a Barcelona. Em sembla que l'Àlex tenia una germana
que es deia Marta, però no n'estic del tot segura.''';
  const extendedFamily =
      '''El meu arbre genealògic és força gran i està ple d’històries familiars. Els meus pares es deien Maria i Josep i van viure sempre al mateix poble. Jo tenia dos germans: en Joan, que era el més gran, i la Teresa, que era la més petita. Per part de mare, els meus avis es deien Rosa i Miquel, i per part de pare, Anna i Pere. També vaig arribar a conèixer una de les meves besàvies, la Caterina, que va viure molts anys. Quan em vaig fer gran, em vaig casar amb l’Antoni, el meu marit. Junts vam tenir tres fills, dos nois i una noia. Amb el temps, els nostres fills també van formar les seves pròpies famílies. Ara tinc diversos nets, que són una part molt important de la meva vida. M’agrada explicar-los coses sobre els seus avantpassats perquè coneguin d’on venen i no oblidin la història de la nostra família.''';

  test('extracts only explicit people, places and directed relationships', () {
    final result = provider.extractSync(interview);

    expect(
      result.people.map((item) => item.displayName),
      containsAll([
        'Clara Vidal',
        'Rosa Puig',
        'Jordi Vidal',
        'Àlex Serra',
        'Marta',
      ]),
    );
    expect(
      result.places.map((item) => item.preferredName),
      containsAll([
        'Manresa',
        'Berga',
        'carrer Nou 18 de Manresa',
        'Barcelona',
      ]),
    );

    final parents = result.relationships.where(
      (item) => item.type == CandidateRelationshipType.parentChild,
    );
    expect(parents, hasLength(2));
    expect(
      parents.every((item) => item.personBRef == 'narrator'),
      isTrue,
      reason: 'personA is the parent and personB is the child',
    );
    expect(
      result.relationships.where(
        (item) => item.type == CandidateRelationshipType.partnership,
      ),
      hasLength(1),
    );
    expect(
      result.relationships
          .singleWhere((item) => item.type == CandidateRelationshipType.sibling)
          .uncertain,
      isTrue,
    );
  });

  test('extracts exact evidence offsets and conservative ambiguity', () {
    final result = provider.extractSync(interview);

    expect(result.evidenceSpans, isNotEmpty);
    for (final span in result.evidenceSpans) {
      expect(span.start, inInclusiveRange(0, interview.length - 1));
      expect(span.end, inInclusiveRange(span.start + 1, interview.length));
      expect(interview.substring(span.start, span.end), isNotEmpty);
    }
    expect(
      result.evidenceSpans.where((span) => span.kind == EvidenceKind.person),
      isNotEmpty,
    );
    expect(
      result.evidenceSpans.where((span) => span.kind == EvidenceKind.place),
      isNotEmpty,
    );
    expect(
      result.evidenceSpans.where(
        (span) => span.kind == EvidenceKind.relationship,
      ),
      isNotEmpty,
    );
    expect(result.ambiguities, isNotEmpty);
  });

  test('parses explicit birth date without inventing missing dates', () {
    final result = provider.extractSync(interview);
    final births = result.events.where((item) => item.type == EventType.birth);

    expect(births, hasLength(2));
    final clara = births.singleWhere((item) => item.personRef == 'narrator');
    expect(clara.date?.startDate, DateTime.utc(1958, 3, 12));
    final rosa = births.singleWhere((item) => item.personRef != 'narrator');
    expect(rosa.date, isNull);
  });

  test('does not extract unanchored capitalized words as people', () {
    final result = provider.extractSync(
      'Aquest text parla de Barcelona i dilluns, però no identifica ningú.',
    );

    expect(result.people, isEmpty);
    expect(result.relationships, isEmpty);
    expect(result.events, isEmpty);
  });

  test(
    'extracts explicit extended-family lists without inventing unnamed people',
    () {
      final result = provider.extractSync(
        extendedFamily,
        narratorName: 'Mercè Soler',
      );

      expect(
        result.people.map((item) => item.displayName),
        containsAll([
          'Mercè Soler',
          'Maria',
          'Josep',
          'Joan',
          'Teresa',
          'Rosa',
          'Miquel',
          'Anna',
          'Pere',
          'Caterina',
          'Antoni',
        ]),
      );
      expect(result.people, hasLength(11));
      expect(
        result.relationships.where(
          (item) => item.type == CandidateRelationshipType.parentChild,
        ),
        hasLength(2),
      );
      expect(
        result.relationships.where(
          (item) => item.type == CandidateRelationshipType.sibling,
        ),
        hasLength(2),
      );
      expect(
        result.relationships.where(
          (item) => item.type == CandidateRelationshipType.partnership,
        ),
        hasLength(1),
      );
      expect(
        result.ambiguities,
        containsAll([
          contains('branca materna'),
          contains('branca paterna'),
          contains('besàvia'),
          contains('tres fills'),
          contains('diversos nets'),
        ]),
      );
    },
  );

  test(
    'detects the family but blocks narrator-dependent relations without a name',
    () {
      final result = provider.extractSync(extendedFamily);

      final narrator = result.people.singleWhere(
        (item) => item.ref == 'narrator',
      );
      expect(narrator.requiresName, isTrue);
      expect(result.people, hasLength(11));
      expect(result.relationships, hasLength(5));
      expect(result.ambiguities, contains(contains('persona narradora')));
    },
  );

  test('extracts a named third-person extended family narrative', () {
    const text =
        '''La Maria Soler Puig és una dona de 78 anys que explica com està formada la seva família. Els seus pares es deien Josep Soler Ferrer i Teresa Puig Martí, i van viure sempre al mateix poble. La Maria tenia dos germans: en Joan Soler Puig, que era el més gran, i l’Anna Soler Puig, que era la més petita. Els seus avis materns es deien Miquel Puig Serra i Rosa Martí Roca, mentre que els avis paterns es deien Pere Soler Vidal i Carme Ferrer Costa. També va arribar a conèixer una de les seves besàvies, Caterina Roca Pons. Quan la Maria es va fer gran, es va casar amb Antoni Garcia López. La parella va tenir tres fills: Jordi Garcia Soler, Marc Garcia Soler i Laura Garcia Soler. Amb els anys, els seus fills van formar les seves pròpies famílies. Actualment, la Maria té diversos nets i està molt contenta de poder-los explicar històries sobre els seus avantpassats. Per a ella, conèixer l’arbre genealògic és una manera de mantenir viva la història de la família.''';

    final result = provider.extractSync(
      text,
      referenceDate: DateTime.utc(2026, 8, 16),
    );

    expect(
      result.people.map((person) => person.displayName),
      containsAll([
        'Maria Soler Puig',
        'Josep Soler Ferrer',
        'Teresa Puig Martí',
        'Joan Soler Puig',
        'Anna Soler Puig',
        'Miquel Puig Serra',
        'Rosa Martí Roca',
        'Pere Soler Vidal',
        'Carme Ferrer Costa',
        'Caterina Roca Pons',
        'Antoni Garcia López',
        'Jordi Garcia Soler',
        'Marc Garcia Soler',
        'Laura Garcia Soler',
      ]),
    );
    expect(result.people, hasLength(14));
    expect(
      result.relationships.where(
        (item) => item.type == CandidateRelationshipType.parentChild,
      ),
      hasLength(8),
    );
    expect(
      result.relationships.where(
        (item) => item.type == CandidateRelationshipType.sibling,
      ),
      hasLength(2),
    );
    expect(
      result.relationships.where(
        (item) => item.type == CandidateRelationshipType.partnership,
      ),
      hasLength(1),
    );
    expect(result.relationships, hasLength(11));
    final inferredBirth = result.events.singleWhere(
      (item) => item.type == EventType.birth,
    );
    expect(inferredBirth.personRef, 'narrator');
    expect(inferredBirth.uncertain, isTrue);
    expect(inferredBirth.date?.startDate, DateTime.utc(1947, 8, 17));
    expect(inferredBirth.date?.endDate, DateTime.utc(1948, 8, 16));
    expect(inferredBirth.date?.displayText, '1947–1948 (inferit de 78 anys)');
    expect(
      result.evidenceSpans.any(
        (span) =>
            span.kind == EvidenceKind.date &&
            text.substring(span.start, span.end) == '78',
      ),
      isTrue,
    );
    expect(result.ambiguities, contains(contains('diversos nets')));
    expect(result.ambiguities, contains(contains('cal confirmar-lo')));
  });
}
