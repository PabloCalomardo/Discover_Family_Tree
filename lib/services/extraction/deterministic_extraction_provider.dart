import 'package:family_history/core/dates/historical_date.dart';
import 'package:family_history/domain/event/event.dart';
import 'package:family_history/domain/extraction/extraction.dart';
import 'package:family_history/domain/person/person.dart';
import 'package:family_history/domain/place/place.dart';

final class DeterministicExtractionProvider implements ExtractionProvider {
  const DeterministicExtractionProvider();

  // Keep this expression in valid UTF-8: production input contains real
  // Catalan accents and apostrophes, not mojibake test literals.
  static const _properName =
      r"[A-ZÀ-ÖØ-Þ][A-Za-zÀ-ÖØ-öø-ÿ·'’\-]+(?:\s+[A-ZÀ-ÖØ-Þ][A-Za-zÀ-ÖØ-öø-ÿ·'’\-]+){0,3}";

  static const _name =
      r"[A-ZÀ-ÖØ-Þ][A-Za-zÀ-ÖØ-öø-ÿ·'’-]+(?:\s+[A-ZÀ-ÖØ-Þ][A-Za-zÀ-ÖØ-öø-ÿ·'’-]+){0,3}";

  @override
  Future<ExtractionResult> extract(ExtractionRequest request) async =>
      extractSync(
        request.text,
        narratorName: request.narratorName,
        referenceDate: request.referenceDate,
      );

  ExtractionResult extractSync(
    String text, {
    String? narratorName,
    DateTime? referenceDate,
  }) {
    final builder = _ExtractionBuilder(text);

    _extractThirdPersonNarrator(text, builder);

    final narrator = RegExp(
      '(?:^|[.!?]\\s+)(?:[Ee]m dic|[Jj]o s[oó]c)\\s+(?<name>$_name)',
      unicode: true,
    ).firstMatch(text);
    if (narrator != null) {
      builder.addPerson(
        narrator.namedGroup('name')!,
        narrator,
        groupName: 'name',
        refHint: 'narrator',
      );
    }
    if (builder.narratorRef == null &&
        _containsFirstPersonFamilyContext(text)) {
      builder.addNarrator(narratorName);
    }

    _extractPluralParents(text, builder);
    _extractParents(text, builder);
    _extractSiblingLists(text, builder);
    _extractGrandparents(text, builder);
    _extractGreatGrandparents(text, builder);
    _extractBirths(text, builder);
    _extractResidences(text, builder);
    _extractMarriage(text, builder);
    _extractSiblings(text, builder);
    _extractUnnamedDescendants(text, builder);
    _extractThirdPersonFamily(text, builder);
    _extractAges(
      text,
      builder,
      referenceDate: (referenceDate ?? DateTime.now()).toUtc(),
    );

    return builder.build();
  }

  void _extractAges(
    String text,
    _ExtractionBuilder builder, {
    required DateTime referenceDate,
  }) {
    final pattern = RegExp(
      '(?<subject>(?:La|El)\\s+$_properName)\\s+(?:és|era)\\s+'
      '(?:un|una)\\s+[A-Za-zÀ-ÖØ-öø-ÿ·’-]+\\s+de\\s+'
      '(?<age>\\d{1,3})\\s+anys\\b',
      unicode: true,
    );
    for (final match in pattern.allMatches(text)) {
      final personRef = builder.findPersonRef(match.namedGroup('subject')!);
      if (personRef == null || builder.hasBirthEvent(personRef)) continue;
      final age = int.parse(match.namedGroup('age')!);
      if (age > 130) {
        builder.ambiguities.add(
          '${match.group(0)}: l’edat queda fora del rang admès de 0 a 130 anys.',
        );
        continue;
      }
      final earliest = _subtractYears(
        referenceDate,
        age + 1,
      ).add(const Duration(days: 1));
      final latest = _subtractYears(referenceDate, age);
      final display = earliest.year == latest.year
          ? '${earliest.year} (inferit de $age anys)'
          : '${earliest.year}–${latest.year} (inferit de $age anys)';
      builder.addSpan(match, 'subject', EvidenceKind.person, personRef);
      builder.addSpan(match, 'age', EvidenceKind.date, 'inferred-birth');
      builder.events.add(
        CandidateEvent(
          ref: 'event-${builder.events.length + 1}',
          type: EventType.birth,
          personRef: personRef,
          evidence: match.group(0)!,
          date: HistoricalDate.range(earliest, latest, displayText: display),
          title: 'Naixement estimat',
          uncertain: true,
        ),
      );
      builder.ambiguities.add(
        'L’any de naixement de ${builder.personName(personRef)} s’ha inferit '
        'a partir de l’edat ($age anys) i de la data de l’anàlisi; cal '
        'confirmar-lo.',
      );
    }
  }

  DateTime _subtractYears(DateTime date, int years) {
    final targetYear = date.year - years;
    final lastDay = DateTime.utc(targetYear, date.month + 1, 0).day;
    return DateTime.utc(
      targetYear,
      date.month,
      date.day > lastDay ? lastDay : date.day,
    );
  }

  void _extractThirdPersonNarrator(String text, _ExtractionBuilder builder) {
    final match = RegExp(
      '(?:^|[.!?]\\s+)(?<article>La|El)\\s+(?<name>$_properName)\\s+'
      '(?:és|era)\\s+(?:un|una)\\b',
      unicode: true,
    ).firstMatch(text);
    if (match == null) return;
    builder.addPerson(
      match.namedGroup('name')!,
      match,
      groupName: 'name',
      refHint: 'narrator',
      sex: match.namedGroup('article') == 'La'
          ? PersonSex.female
          : PersonSex.male,
    );
  }

  void _extractThirdPersonFamily(String text, _ExtractionBuilder builder) {
    final subjectRef = builder.narratorRef;
    if (subjectRef == null) return;

    final parents = RegExp(
      '(?<relation>Els seus pares)\\s+(?:es deien|es diuen|eren)\\s+'
      '(?<name1>$_properName)\\s+i\\s+(?<name2>$_properName)',
      unicode: true,
    );
    for (final match in parents.allMatches(text)) {
      final refs = [
        builder.addPerson(
          match.namedGroup('name1')!,
          match,
          groupName: 'name1',
        ),
        builder.addPerson(
          match.namedGroup('name2')!,
          match,
          groupName: 'name2',
        ),
      ];
      builder.addSpan(match, 'relation', EvidenceKind.relationship, 'parents');
      for (final parentRef in refs) {
        builder.addRelationship(
          CandidateRelationshipType.parentChild,
          parentRef,
          subjectRef,
          match.group(0)!,
        );
      }
    }

    final siblings = RegExp(
      '(?<subject>(?:La|El)\\s+$_properName)\\s+'
      '(?<relation>tenia\\s+(?:dos|dues|\\d+)\\s+germans?)\\s*:\\s*'
      '(?:en\\s+|la\\s+|el\\s+|l[’\'])?(?<name1>$_properName)'
      '(?:,\\s*que[^,.;:]+,)?\\s+i\\s+'
      '(?:en\\s+|la\\s+|el\\s+|l[’\'])?(?<name2>$_properName)',
      unicode: true,
    );
    for (final match in siblings.allMatches(text)) {
      final ownerRef = builder.findPersonRef(match.namedGroup('subject')!);
      if (ownerRef == null) continue;
      builder.addSpan(match, 'subject', EvidenceKind.person, ownerRef);
      builder.addSpan(match, 'relation', EvidenceKind.relationship, 'siblings');
      for (final group in ['name1', 'name2']) {
        final siblingRef = builder.addPerson(
          match.namedGroup(group)!,
          match,
          groupName: group,
        );
        builder.addRelationship(
          CandidateRelationshipType.sibling,
          ownerRef,
          siblingRef,
          match.group(0)!,
        );
      }
    }

    final grandparentPatterns = <(RegExp, String)>[
      (
        RegExp(
          '(?<relation>Els seus avis materns es deien)\\s+'
          '(?<name1>$_properName)\\s+i\\s+(?<name2>$_properName)',
          unicode: true,
        ),
        'materna',
      ),
      (
        RegExp(
          '(?<relation>(?:mentre que\\s+)?els avis paterns es deien)\\s+'
          '(?<name1>$_properName)\\s+i\\s+(?<name2>$_properName)',
          caseSensitive: false,
          unicode: true,
        ),
        'paterna',
      ),
    ];
    for (final (pattern, branch) in grandparentPatterns) {
      for (final match in pattern.allMatches(text)) {
        _addAncestorPair(match, builder, branch: branch);
      }
    }

    final greatGrandmother = RegExp(
      '(?<relation>una de les seves besàvies),?\\s+(?<name>$_properName)',
      caseSensitive: false,
      unicode: true,
    );
    for (final match in greatGrandmother.allMatches(text)) {
      builder.addPerson(
        match.namedGroup('name')!,
        match,
        groupName: 'name',
        sex: PersonSex.female,
      );
      builder.addSpan(
        match,
        'relation',
        EvidenceKind.relationship,
        'great-grandparent',
      );
      builder.ambiguities.add(
        'S’ha detectat una besàvia, però no la cadena exacta de filiacions.',
      );
    }

    final marriage = RegExp(
      '(?<subject>(?:la|el)\\s+$_properName)\\s+es va fer gran,\\s+'
      '(?<relation>es va casar amb)\\s+(?<name>$_properName)',
      caseSensitive: false,
      unicode: true,
    );
    for (final match in marriage.allMatches(text)) {
      final ownerRef = builder.findPersonRef(match.namedGroup('subject')!);
      if (ownerRef == null) continue;
      builder.addSpan(match, 'subject', EvidenceKind.person, ownerRef);
      final spouseRef = builder.addPerson(
        match.namedGroup('name')!,
        match,
        groupName: 'name',
      );
      builder.addSpan(
        match,
        'relation',
        EvidenceKind.relationship,
        'partnership',
      );
      builder.addRelationship(
        CandidateRelationshipType.partnership,
        ownerRef,
        spouseRef,
        match.group(0)!,
      );
    }

    final children = RegExp(
      '(?<relation>La parella va tenir\\s+(?:tres|3)\\s+fills?)\\s*:\\s*'
      '(?<name1>$_properName),\\s*(?<name2>$_properName)\\s+i\\s+'
      '(?<name3>$_properName)',
      unicode: true,
    );
    for (final match in children.allMatches(text)) {
      builder.addSpan(match, 'relation', EvidenceKind.relationship, 'children');
      final parentRefs = [subjectRef, ...builder.partnerRefsOf(subjectRef)];
      for (final group in ['name1', 'name2', 'name3']) {
        final childRef = builder.addPerson(
          match.namedGroup(group)!,
          match,
          groupName: group,
        );
        for (final parentRef in parentRefs) {
          builder.addRelationship(
            CandidateRelationshipType.parentChild,
            parentRef,
            childRef,
            match.group(0)!,
          );
        }
      }
    }

    final unnamedGrandchildren = RegExp(
      r'(?<relation>(?:Actualment,\s+)?(?:la|el)\s+[A-ZÀ-ÖØ-Þ][A-Za-zÀ-ÖØ-öø-ÿ·’\-]+\s+té\s+(?<count>diversos|diverses|\d+)\s+nets?)',
      caseSensitive: false,
      unicode: true,
    );
    for (final match in unnamedGrandchildren.allMatches(text)) {
      builder.addSpan(
        match,
        'relation',
        EvidenceKind.relationship,
        'unnamed-descendants',
      );
      builder.ambiguities.add(
        '${match.group(0)}: no es poden crear persones ni relacions sense noms.',
      );
    }
  }

  bool _containsFirstPersonFamilyContext(String text) => RegExp(
    r"\b(?:els meus|les meves|el meu|la meva|jo tenia|em vaig|vam tenir|vàrem tenir|tinc)\b",
    caseSensitive: false,
    unicode: true,
  ).hasMatch(text);

  void _extractPluralParents(String text, _ExtractionBuilder builder) {
    final pattern = RegExp(
      '(?<relation>[Ee]ls meus pares)\\s+(?:es deien|es diuen|eren)\\s+(?<name1>$_name)\\s+i\\s+(?<name2>$_name)',
      unicode: true,
    );
    for (final match in pattern.allMatches(text)) {
      final first = builder.addPerson(
        match.namedGroup('name1')!,
        match,
        groupName: 'name1',
      );
      final second = builder.addPerson(
        match.namedGroup('name2')!,
        match,
        groupName: 'name2',
      );
      builder.addSpan(match, 'relation', EvidenceKind.relationship, 'parents');
      final narrator = builder.narratorRef;
      if (narrator == null) continue;
      for (final parent in [first, second]) {
        builder.relationships.add(
          CandidateRelationship(
            ref: 'relationship-${builder.relationships.length + 1}',
            type: CandidateRelationshipType.parentChild,
            personARef: parent,
            personBRef: narrator,
            evidence: match.group(0)!,
          ),
        );
      }
    }
  }

  void _extractSiblingLists(String text, _ExtractionBuilder builder) {
    final pattern = RegExp(
      '(?<relation>[Jj]o\\s+tenia\\s+(?:dos|dues|\\d+)\\s+germans?)\\s*:\\s*(?<article1>en|la)?\\s*(?<name1>$_name)(?:,\\s*que[^,.;:]+,)?\\s+i\\s+(?<article2>en|la)?\\s*(?<name2>$_name)',
      unicode: true,
    );
    for (final match in pattern.allMatches(text)) {
      final first = builder.addPerson(
        match.namedGroup('name1')!,
        match,
        groupName: 'name1',
        sex: _articleSex(match.namedGroup('article1')),
      );
      final second = builder.addPerson(
        match.namedGroup('name2')!,
        match,
        groupName: 'name2',
        sex: _articleSex(match.namedGroup('article2')),
      );
      builder.addSpan(match, 'relation', EvidenceKind.relationship, 'siblings');
      final narrator = builder.narratorRef;
      if (narrator == null) continue;
      for (final sibling in [first, second]) {
        builder.relationships.add(
          CandidateRelationship(
            ref: 'relationship-${builder.relationships.length + 1}',
            type: CandidateRelationshipType.sibling,
            personARef: narrator,
            personBRef: sibling,
            evidence: match.group(0)!,
          ),
        );
      }
    }
  }

  void _extractGrandparents(String text, _ExtractionBuilder builder) {
    final maternal = RegExp(
      '(?<relation>[Pp]er part de mare,\\s+els meus avis es deien)\\s+(?<name1>$_name)\\s+i\\s+(?<name2>$_name)',
      unicode: true,
    );
    for (final match in maternal.allMatches(text)) {
      _addAncestorPair(match, builder, branch: 'materna');
    }
    final paternal = RegExp(
      '(?<relation>(?:i\\s+)?per part de pare,)\\s+(?<name1>$_name)\\s+i\\s+(?<name2>$_name)',
      unicode: true,
    );
    for (final match in paternal.allMatches(text)) {
      _addAncestorPair(match, builder, branch: 'paterna');
    }
  }

  void _addAncestorPair(
    RegExpMatch match,
    _ExtractionBuilder builder, {
    required String branch,
  }) {
    builder.addPerson(match.namedGroup('name1')!, match, groupName: 'name1');
    builder.addPerson(match.namedGroup('name2')!, match, groupName: 'name2');
    builder.addSpan(
      match,
      'relation',
      EvidenceKind.relationship,
      'grandparents-$branch',
    );
    builder.ambiguities.add(
      'S’han detectat els avis de la branca $branch, però el text no identifica '
      'de manera inequívoca quin dels pares n’és el fill o la filla.',
    );
  }

  void _extractGreatGrandparents(String text, _ExtractionBuilder builder) {
    final pattern = RegExp(
      '(?<relation>[Uu]na de les meves besàvies),?\\s+(?:la\\s+)?(?<name>$_name)',
      unicode: true,
    );
    for (final match in pattern.allMatches(text)) {
      builder.addPerson(
        match.namedGroup('name')!,
        match,
        groupName: 'name',
        sex: PersonSex.female,
      );
      builder.addSpan(
        match,
        'relation',
        EvidenceKind.relationship,
        'great-grandparent',
      );
      builder.ambiguities.add(
        'S’ha detectat una besàvia, però no la cadena exacta de filiacions.',
      );
    }
  }

  void _extractUnnamedDescendants(String text, _ExtractionBuilder builder) {
    final patterns = [
      RegExp(
        r'(?<relation>[Jj]unts vam tenir\s+(?<count>\w+)\s+fills?)',
        unicode: true,
      ),
      RegExp(
        r'(?<relation>[Aa]ra tinc\s+(?<count>diversos|diverses|\d+)\s+nets?)',
        unicode: true,
      ),
    ];
    for (final pattern in patterns) {
      for (final match in pattern.allMatches(text)) {
        builder.addSpan(
          match,
          'relation',
          EvidenceKind.relationship,
          'unnamed-descendants',
        );
        builder.ambiguities.add(
          '${match.group(0)}: no es poden crear persones ni relacions sense noms.',
        );
      }
    }
  }

  PersonSex _articleSex(String? article) => switch (article?.toLowerCase()) {
    'en' => PersonSex.male,
    'la' => PersonSex.female,
    _ => PersonSex.unknown,
  };

  void _extractParents(String text, _ExtractionBuilder builder) {
    final patterns = <(RegExp, PersonSex)>[
      (
        RegExp(
          '(?<relation>(?:La|la) meva mare)(?:,\\s*|\\s+(?:es diu|era)(?:\\s+la)?)\\s*(?<name>$_name)',
          unicode: true,
        ),
        PersonSex.female,
      ),
      (
        RegExp(
          '(?<relation>(?:El|el) meu pare)(?:,\\s*|\\s+(?:es diu|era)(?:\\s+en)?)\\s*(?<name>$_name)',
          unicode: true,
        ),
        PersonSex.male,
      ),
    ];
    for (final (pattern, sex) in patterns) {
      for (final match in pattern.allMatches(text)) {
        final parentRef = builder.addPerson(
          match.namedGroup('name')!,
          match,
          groupName: 'name',
          sex: sex,
        );
        builder.addSpan(match, 'relation', EvidenceKind.relationship, 'parent');
        final narratorRef = builder.narratorRef;
        if (narratorRef == null) {
          builder.ambiguities.add(
            'S\'ha detectat un pare o una mare, però no la persona narradora.',
          );
          continue;
        }
        builder.relationships.add(
          CandidateRelationship(
            ref: 'relationship-${builder.relationships.length + 1}',
            type: CandidateRelationshipType.parentChild,
            personARef: parentRef,
            personBRef: narratorRef,
            evidence: match.group(0)!,
          ),
        );
      }
    }
  }

  void _extractBirths(String text, _ExtractionBuilder builder) {
    final ownBirth = RegExp(
      r'(?<event>[Vv]aig néixer)\s+a\s+(?<place>.+?)\s+el\s+(?<date>\d{1,2}\s+de\s+[A-Za-zÀ-ÖØ-öø-ÿçÇ]+\s+de\s+\d{4})(?=[.,;!?])',
      unicode: true,
    );
    for (final match in ownBirth.allMatches(text)) {
      final narratorRef = builder.narratorRef;
      if (narratorRef == null) continue;
      final placeRef = builder.addPlace(
        match.namedGroup('place')!,
        match,
        groupName: 'place',
      );
      final date = _parseCatalanDate(match.namedGroup('date')!);
      builder.addSpan(match, 'event', EvidenceKind.relationship, 'birth');
      builder.addSpan(match, 'date', EvidenceKind.date, 'date');
      builder.events.add(
        CandidateEvent(
          ref: 'event-${builder.events.length + 1}',
          type: EventType.birth,
          personRef: narratorRef,
          placeRef: placeRef,
          date: date,
          title: 'Naixement',
          evidence: match.group(0)!,
        ),
      );
    }

    final namedBirth = RegExp(
      '(?<name>$_name),?\\s+(?<event>havia nascut|va néixer)\\s+a\\s+(?<place>[^,.;!?]+)',
      unicode: true,
    );
    for (final match in namedBirth.allMatches(text)) {
      final personRef = builder.findPersonRef(match.namedGroup('name')!);
      if (personRef == null) continue;
      builder.addSpan(match, 'name', EvidenceKind.person, personRef);
      builder.addSpan(match, 'event', EvidenceKind.relationship, 'birth');
      final placeRef = builder.addPlace(
        match.namedGroup('place')!,
        match,
        groupName: 'place',
      );
      builder.events.add(
        CandidateEvent(
          ref: 'event-${builder.events.length + 1}',
          type: EventType.birth,
          personRef: personRef,
          placeRef: placeRef,
          title: 'Naixement',
          evidence: match.group(0)!,
        ),
      );
    }
  }

  void _extractResidences(String text, _ExtractionBuilder builder) {
    final pattern = RegExp(
      r"(?<subjects>Els meus pares|La meva mare|El meu pare|Jo)(?<relation>\s+(?:van|vaig) viure)\s+(?:al|a la|a l[’'])\s+(?<place>.+?)\s+des de\s+(?<start>\d{4})\s+fins\s+(?<approx>aproximadament\s+)?(?:al\s+)?(?<end>\d{4})(?=[.,;!?])",
      unicode: true,
    );
    for (final match in pattern.allMatches(text)) {
      final placeName = match.namedGroup('place')!;
      final placeRef = builder.addPlace(
        placeName,
        match,
        groupName: 'place',
        type: _placeType(placeName),
      );
      builder.addSpan(
        match,
        'relation',
        EvidenceKind.relationship,
        'residence',
      );
      builder.addSpan(
        match,
        'subjects',
        EvidenceKind.relationship,
        'residence-subjects',
      );
      builder.addSpan(match, 'start', EvidenceKind.date, 'date');
      builder.addSpan(match, 'end', EvidenceKind.date, 'date');
      final people = switch (match.namedGroup('subjects')!.toLowerCase()) {
        'els meus pares' => builder.parentRefs,
        'la meva mare' => builder.refsBySex(PersonSex.female),
        'el meu pare' => builder.refsBySex(PersonSex.male),
        _ => [if (builder.narratorRef != null) builder.narratorRef!],
      };
      if (people.isEmpty) {
        builder.ambiguities.add(
          'S\'ha detectat una residència sense poder identificar-ne la persona.',
        );
      }
      for (final personRef in people) {
        builder.residences.add(
          CandidateResidence(
            ref: 'residence-${builder.residences.length + 1}',
            personRef: personRef,
            placeRef: placeRef,
            startDate: HistoricalDate.year(
              int.parse(match.namedGroup('start')!),
            ),
            endDate: match.namedGroup('approx') == null
                ? HistoricalDate.year(int.parse(match.namedGroup('end')!))
                : HistoricalDate.approximate(
                    DateTime.utc(int.parse(match.namedGroup('end')!)),
                    displayText: 'aproximadament ${match.namedGroup('end')!}',
                  ),
            evidence: match.group(0)!,
          ),
        );
      }
    }

    final alsoThere = RegExp(
      r'(?<subject>Jo)\s+(?<relation>també\s+hi vaig viure)(?<tail>[^.!?]*)',
      unicode: true,
    );
    for (final match in alsoThere.allMatches(text)) {
      final narratorRef = builder.narratorRef;
      final previous = builder.residences.lastOrNull;
      if (narratorRef == null || previous == null) continue;
      builder.addSpan(
        match,
        'relation',
        EvidenceKind.relationship,
        'residence',
      );
      builder.residences.add(
        CandidateResidence(
          ref: 'residence-${builder.residences.length + 1}',
          personRef: narratorRef,
          placeRef: previous.placeRef,
          startDate: previous.startDate,
          endDate: previous.endDate,
          evidence: match.group(0)!,
          uncertain: true,
        ),
      );
      builder.ambiguities.add(
        '«Hi» s\'ha vinculat a l\'últim lloc esmentat; cal confirmar-ho.',
      );
    }
  }

  void _extractMarriage(String text, _ExtractionBuilder builder) {
    final pattern = RegExp(
      '(?:(?<datePrefix>L[’\']any)\\s+(?<year>\\d{4})\\s+)?(?<relation>[Ee]m\\s+vaig\\s+casar\\s+amb)\\s+(?:l[’\']|el\\s+|la\\s+)?(?<name>$_name)(?:\\s+a\\s+(?<place>[^.,;!?]+))?',
      unicode: true,
    );
    for (final match in pattern.allMatches(text)) {
      final narratorRef = builder.narratorRef;
      if (narratorRef == null) continue;
      final spouseRef = builder.addPerson(
        match.namedGroup('name')!,
        match,
        groupName: 'name',
      );
      final placeName = match.namedGroup('place');
      final placeRef = placeName == null
          ? null
          : builder.addPlace(placeName, match, groupName: 'place');
      builder.addSpan(
        match,
        'relation',
        EvidenceKind.relationship,
        'partnership',
      );
      if (match.namedGroup('year') != null) {
        builder.addSpan(match, 'year', EvidenceKind.date, 'date');
      }
      final date = match.namedGroup('year') == null
          ? null
          : HistoricalDate.year(int.parse(match.namedGroup('year')!));
      builder.relationships.add(
        CandidateRelationship(
          ref: 'relationship-${builder.relationships.length + 1}',
          type: CandidateRelationshipType.partnership,
          personARef: narratorRef,
          personBRef: spouseRef,
          placeRef: placeRef,
          date: date,
          evidence: match.group(0)!,
        ),
      );
    }
  }

  void _extractSiblings(String text, _ExtractionBuilder builder) {
    final pattern = RegExp(
      '(?<uncertain>[Ee]m\\s+sembla\\s+que\\s+)?(?:l[’\']|el\\s+|la\\s+)?(?<subject>$_name)\\s+(?<relation>tenia\\s+una\\s+germana\\s+que\\s+es\\s+deia)\\s+(?<name>$_name)',
      unicode: true,
    );
    for (final match in pattern.allMatches(text)) {
      final subjectRef = builder.findPersonRef(match.namedGroup('subject')!);
      if (subjectRef == null) continue;
      builder.addSpan(match, 'subject', EvidenceKind.person, subjectRef);
      final siblingRef = builder.addPerson(
        match.namedGroup('name')!,
        match,
        groupName: 'name',
        sex: PersonSex.female,
        uncertain: match.namedGroup('uncertain') != null,
      );
      builder.addSpan(match, 'relation', EvidenceKind.relationship, 'sibling');
      builder.relationships.add(
        CandidateRelationship(
          ref: 'relationship-${builder.relationships.length + 1}',
          type: CandidateRelationshipType.sibling,
          personARef: subjectRef,
          personBRef: siblingRef,
          evidence: match.group(0)!,
          uncertain: true,
        ),
      );
      builder.ambiguities.add(
        'La germandat de ${match.namedGroup('subject')} i ${match.namedGroup('name')} és incerta.',
      );
    }
  }

  HistoricalDate? _parseCatalanDate(String input) {
    final match = RegExp(
      r'^(\d{1,2})\s+de\s+([A-Za-zÀ-ÖØ-öø-ÿçÇ]+)\s+de\s+(\d{4})$',
      caseSensitive: false,
      unicode: true,
    ).firstMatch(input.trim());
    if (match == null) return null;
    const months = {
      'gener': 1,
      'febrer': 2,
      'març': 3,
      'abril': 4,
      'maig': 5,
      'juny': 6,
      'juliol': 7,
      'agost': 8,
      'setembre': 9,
      'octubre': 10,
      'novembre': 11,
      'desembre': 12,
    };
    final month = months[match.group(2)!.toLowerCase()];
    if (month == null) return null;
    return HistoricalDate.exactDay(
      int.parse(match.group(3)!),
      month,
      int.parse(match.group(1)!),
      displayText: input,
    );
  }

  PlaceType _placeType(String name) {
    final lower = name.toLowerCase();
    if (lower.startsWith('carrer ') || lower.startsWith('avinguda ')) {
      return PlaceType.street;
    }
    return PlaceType.other;
  }
}

final class _ExtractionBuilder {
  _ExtractionBuilder(this.text);
  final String text;
  final people = <CandidatePerson>[];
  final places = <CandidatePlace>[];
  final relationships = <CandidateRelationship>[];
  final residences = <CandidateResidence>[];
  final events = <CandidateEvent>[];
  final spans = <EvidenceSpan>[];
  final ambiguities = <String>[];
  String? narratorRef;

  List<String> get parentRefs => relationships
      .where((item) => item.type == CandidateRelationshipType.parentChild)
      .map((item) => item.personARef)
      .toSet()
      .toList();

  List<String> refsBySex(PersonSex sex) => people
      .where((person) => person.sex == sex)
      .map((person) => person.ref)
      .toList();

  bool hasBirthEvent(String personRef) => events.any(
    (item) => item.type == EventType.birth && item.personRef == personRef,
  );

  String personName(String personRef) =>
      people.singleWhere((item) => item.ref == personRef).displayName;

  List<String> partnerRefsOf(String personRef) => relationships
      .where(
        (item) =>
            item.type == CandidateRelationshipType.partnership &&
            (item.personARef == personRef || item.personBRef == personRef),
      )
      .map(
        (item) =>
            item.personARef == personRef ? item.personBRef : item.personARef,
      )
      .toSet()
      .toList();

  void addRelationship(
    CandidateRelationshipType type,
    String personARef,
    String personBRef,
    String evidence,
  ) {
    final exists = relationships.any(
      (item) =>
          item.type == type &&
          item.personARef == personARef &&
          item.personBRef == personBRef,
    );
    if (exists) return;
    relationships.add(
      CandidateRelationship(
        ref: 'relationship-${relationships.length + 1}',
        type: type,
        personARef: personARef,
        personBRef: personBRef,
        evidence: evidence,
      ),
    );
  }

  void addNarrator(String? rawName) {
    final name = rawName?.trim() ?? '';
    narratorRef = 'narrator';
    people.add(
      CandidatePerson(
        ref: narratorRef!,
        displayName: name.isEmpty ? 'Persona narradora' : name,
        evidence: 'Context en primera persona',
        requiresName: name.isEmpty,
      ),
    );
    if (name.isEmpty) {
      ambiguities.add(
        'El text està escrit en primera persona, però no diu el nom de la '
        'persona narradora. Cal identificar-la per crear les seves relacions.',
      );
    }
  }

  String addPerson(
    String rawName,
    RegExpMatch match, {
    required String groupName,
    String? refHint,
    PersonSex sex = PersonSex.unknown,
    bool uncertain = false,
  }) {
    final name = _cleanPersonName(rawName);
    final existing = people.where(
      (person) => _normalize(person.displayName) == _normalize(name),
    );
    final ref =
        existing.firstOrNull?.ref ?? (refHint ?? 'person-${people.length + 1}');
    if (existing.isEmpty) {
      people.add(
        CandidatePerson(
          ref: ref,
          displayName: name,
          evidence: match.group(0)!,
          sex: sex,
          uncertain: uncertain,
        ),
      );
    }
    if (refHint == 'narrator') narratorRef = ref;
    addSpan(match, groupName, EvidenceKind.person, ref);
    return ref;
  }

  String addPlace(
    String rawName,
    RegExpMatch match, {
    required String groupName,
    PlaceType type = PlaceType.other,
  }) {
    final name = _clean(rawName);
    final existing = places.where(
      (place) => _normalize(place.preferredName) == _normalize(name),
    );
    final ref = existing.firstOrNull?.ref ?? 'place-${places.length + 1}';
    if (existing.isEmpty) {
      places.add(
        CandidatePlace(
          ref: ref,
          preferredName: name,
          evidence: match.group(0)!,
          type: type,
        ),
      );
    }
    addSpan(match, groupName, EvidenceKind.place, ref);
    return ref;
  }

  String? findPersonRef(String name) {
    final normalized = _normalize(
      name
          .trim()
          .replaceFirst(
            RegExp(r"^(?:en|la|el|l[’'])\s*", caseSensitive: false),
            '',
          )
          .trim(),
    );
    final exact = people.where(
      (person) => _normalize(person.displayName) == normalized,
    );
    if (exact.length == 1) return exact.single.ref;
    final uniqueGivenName = people.where(
      (person) => _normalize(person.displayName).split(' ').first == normalized,
    );
    return uniqueGivenName.length == 1 ? uniqueGivenName.single.ref : null;
  }

  void addSpan(
    RegExpMatch match,
    String groupName,
    EvidenceKind kind,
    String key,
  ) {
    final fullMatch = match.group(0)!;
    var cursor = 0;
    var start = -1;
    var end = -1;
    for (final name in match.groupNames) {
      final value = match.namedGroup(name);
      if (value == null || value.isEmpty) continue;
      final relativeStart = fullMatch.indexOf(value, cursor);
      if (relativeStart < 0) continue;
      if (name == groupName) {
        start = match.start + relativeStart;
        end = start + value.length;
        break;
      }
      cursor = relativeStart + value.length;
    }
    if (start < 0 || end <= start) return;
    final candidate = EvidenceSpan(
      start: start,
      end: end,
      kind: kind,
      key: key,
    );
    if (!spans.any(
      (span) =>
          span.start == start &&
          span.end == end &&
          span.kind == kind &&
          span.key == key,
    )) {
      spans.add(candidate);
    }
  }

  ExtractionResult build() {
    spans.sort((a, b) => a.start.compareTo(b.start));
    return ExtractionResult(
      text: text,
      people: List.unmodifiable(people),
      places: List.unmodifiable(places),
      relationships: List.unmodifiable(relationships),
      residences: List.unmodifiable(residences),
      events: List.unmodifiable(events),
      evidenceSpans: List.unmodifiable(spans),
      ambiguities: List.unmodifiable(ambiguities),
    );
  }

  static String _clean(String value) => value
      .trim()
      .replaceFirst(RegExp(r"^(?:en|la|el|l[’'])\s*", caseSensitive: false), '')
      .trim();

  static String _normalize(String value) => value.toLowerCase().trim();

  static String _cleanPersonName(String value) => value
      .trim()
      .replaceFirst(
        RegExp(r"^(?:en|la|el)\s+|^l[’']", caseSensitive: false),
        '',
      )
      .trim();
}
