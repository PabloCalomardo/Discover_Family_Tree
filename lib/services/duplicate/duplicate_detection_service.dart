import 'dart:math';

import 'package:family_history/core/dates/historical_date.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/domain/person/person.dart';
import 'package:family_history/domain/person/person_name.dart';

final class DuplicatePersonRecord {
  const DuplicatePersonRecord({
    required this.person,
    required this.names,
    this.relatedPersonIds = const {},
  });
  final Person person;
  final List<PersonName> names;
  final Set<PersonId> relatedPersonIds;
}

final class DuplicateMatch {
  const DuplicateMatch({
    required this.personAId,
    required this.personBId,
    required this.score,
    required this.reasonCodes,
  });
  final PersonId personAId;
  final PersonId personBId;
  final int score;
  final List<String> reasonCodes;
}

final class DuplicateDetectionService {
  const DuplicateDetectionService({this.threshold = 60});
  static const detectorVersion = 1;
  final int threshold;

  List<DuplicateMatch> detect(Iterable<DuplicatePersonRecord> records) {
    final list = records.toList();
    final matches = <DuplicateMatch>[];
    for (var a = 0; a < list.length; a++) {
      for (var b = a + 1; b < list.length; b++) {
        if (!_sharesBlockingToken(list[a], list[b])) continue;
        final match = _score(list[a], list[b]);
        if (match.score >= threshold) matches.add(match);
      }
    }
    matches.sort((a, b) => b.score.compareTo(a.score));
    return List.unmodifiable(matches);
  }

  bool _sharesBlockingToken(DuplicatePersonRecord a, DuplicatePersonRecord b) {
    final aTokens = _tokens(a.names);
    final bTokens = _tokens(b.names);
    return aTokens.intersection(bTokens).isNotEmpty;
  }

  DuplicateMatch _score(DuplicatePersonRecord a, DuplicatePersonRecord b) {
    var score = 0;
    final reasons = <String>[];
    final aNames = a.names.map((name) => _normalize(name.displayName)).toSet();
    final bNames = b.names.map((name) => _normalize(name.displayName)).toSet();
    if (aNames.intersection(bNames).isNotEmpty) {
      score += 45;
      reasons.add('NAME_EXACT');
    } else {
      final common = _tokens(a.names).intersection(_tokens(b.names)).length;
      final total = max(_tokens(a.names).length, _tokens(b.names).length);
      final points = total == 0 ? 0 : min(30, (30 * common / total).round());
      score += points;
      if (points > 0) reasons.add('NAME_TOKENS:$points');
    }
    final birth = _dateCompatibility(a.person.birthDate, b.person.birthDate);
    score += birth;
    if (birth > 0) reasons.add('BIRTH_COMPATIBLE:$birth');
    if (birth < 0) reasons.add('BIRTH_INCOMPATIBLE');
    final death = _dateCompatibility(a.person.deathDate, b.person.deathDate);
    final deathPoints = death < 0 ? -50 : min(10, death);
    score += deathPoints;
    if (deathPoints > 0) reasons.add('DEATH_COMPATIBLE:$deathPoints');
    if (deathPoints < 0) reasons.add('DEATH_INCOMPATIBLE');
    if (a.person.sex != PersonSex.unknown &&
        b.person.sex != PersonSex.unknown &&
        a.person.sex != PersonSex.unspecified &&
        b.person.sex != PersonSex.unspecified &&
        a.person.sex != b.person.sex) {
      score -= 20;
      reasons.add('SEX_INCOMPATIBLE');
    }
    if (a.relatedPersonIds.intersection(b.relatedPersonIds).isNotEmpty) {
      score += 15;
      reasons.add('SHARED_RELATION');
    }
    return DuplicateMatch(
      personAId: a.person.id,
      personBId: b.person.id,
      score: score.clamp(0, 100),
      reasonCodes: List.unmodifiable(reasons),
    );
  }

  int _dateCompatibility(HistoricalDate? a, HistoricalDate? b) {
    if (a == null || b == null) return 0;
    final aStart = a.startDate;
    final aEnd = a.endDate;
    final bStart = b.startDate;
    final bEnd = b.endDate;
    if (aEnd != null && bStart != null && aEnd.isBefore(bStart)) return -50;
    if (bEnd != null && aStart != null && bEnd.isBefore(aStart)) return -50;
    return aStart == bStart && aEnd == bEnd ? 25 : 15;
  }

  Set<String> _tokens(List<PersonName> names) => names
      .expand((name) => _normalize(name.displayName).split(' '))
      .where((token) => token.length >= 2)
      .toSet();

  String _normalize(String input) {
    const accents = 'àáâäãåèéêëìíîïòóôöõùúûüçñ';
    const plain = 'aaaaaaeeeeiiiiooooouuuucn';
    var value = input.toLowerCase();
    for (var index = 0; index < accents.length; index++) {
      value = value.replaceAll(accents[index], plain[index]);
    }
    return value
        .replaceAll(RegExp(r'[^a-z0-9]+'), ' ')
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ');
  }
}
