import 'package:family_history/core/dates/historical_date.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/domain/event/event.dart';
import 'package:family_history/domain/person/person.dart';
import 'package:family_history/domain/place/place.dart';

enum EvidenceKind { person, relationship, place, date }

final class EvidenceSpan {
  const EvidenceSpan({
    required this.start,
    required this.end,
    required this.kind,
    required this.key,
  });

  final int start;
  final int end;
  final EvidenceKind kind;
  final String key;
}

final class ExtractionRequest {
  const ExtractionRequest({
    required this.text,
    this.narratorName,
    this.referenceDate,
  });
  final String text;
  final String? narratorName;
  final DateTime? referenceDate;
}

final class CandidatePerson {
  const CandidatePerson({
    required this.ref,
    required this.displayName,
    required this.evidence,
    this.sex = PersonSex.unknown,
    this.uncertain = false,
    this.requiresName = false,
    this.resolutionAmbiguous = false,
    this.resolvedId,
  });

  final String ref;
  final String displayName;
  final String evidence;
  final PersonSex sex;
  final bool uncertain;
  final bool requiresName;
  final bool resolutionAmbiguous;
  final PersonId? resolvedId;

  CandidatePerson copyWith({
    PersonId? resolvedId,
    String? displayName,
    bool? requiresName,
    bool? resolutionAmbiguous,
  }) => CandidatePerson(
    ref: ref,
    displayName: displayName ?? this.displayName,
    evidence: evidence,
    sex: sex,
    uncertain: uncertain,
    requiresName: requiresName ?? this.requiresName,
    resolutionAmbiguous: resolutionAmbiguous ?? this.resolutionAmbiguous,
    resolvedId: resolvedId ?? this.resolvedId,
  );
}

final class CandidatePlace {
  const CandidatePlace({
    required this.ref,
    required this.preferredName,
    required this.evidence,
    this.type = PlaceType.other,
    this.resolutionAmbiguous = false,
    this.resolvedId,
  });

  final String ref;
  final String preferredName;
  final String evidence;
  final PlaceType type;
  final bool resolutionAmbiguous;
  final PlaceId? resolvedId;

  CandidatePlace copyWith({PlaceId? resolvedId, bool? resolutionAmbiguous}) =>
      CandidatePlace(
        ref: ref,
        preferredName: preferredName,
        evidence: evidence,
        type: type,
        resolutionAmbiguous: resolutionAmbiguous ?? this.resolutionAmbiguous,
        resolvedId: resolvedId ?? this.resolvedId,
      );
}

enum CandidateRelationshipType { parentChild, partnership, sibling }

final class CandidateRelationship {
  const CandidateRelationship({
    required this.ref,
    required this.type,
    required this.personARef,
    required this.personBRef,
    required this.evidence,
    this.uncertain = false,
    this.placeRef,
    this.date,
  });

  final String ref;
  final CandidateRelationshipType type;
  final String personARef;
  final String personBRef;
  final String evidence;
  final bool uncertain;
  final String? placeRef;
  final HistoricalDate? date;
}

final class CandidateResidence {
  const CandidateResidence({
    required this.ref,
    required this.personRef,
    required this.placeRef,
    required this.evidence,
    this.startDate,
    this.endDate,
    this.uncertain = false,
  });

  final String ref;
  final String personRef;
  final String placeRef;
  final String evidence;
  final HistoricalDate? startDate;
  final HistoricalDate? endDate;
  final bool uncertain;
}

final class CandidateEvent {
  const CandidateEvent({
    required this.ref,
    required this.type,
    required this.personRef,
    required this.evidence,
    this.date,
    this.placeRef,
    this.title,
    this.uncertain = false,
  });

  final String ref;
  final EventType type;
  final String personRef;
  final String evidence;
  final HistoricalDate? date;
  final String? placeRef;
  final String? title;
  final bool uncertain;
}

final class ExtractionResult {
  const ExtractionResult({
    required this.text,
    this.people = const [],
    this.places = const [],
    this.relationships = const [],
    this.residences = const [],
    this.events = const [],
    this.evidenceSpans = const [],
    this.ambiguities = const [],
  });

  final String text;
  final List<CandidatePerson> people;
  final List<CandidatePlace> places;
  final List<CandidateRelationship> relationships;
  final List<CandidateResidence> residences;
  final List<CandidateEvent> events;
  final List<EvidenceSpan> evidenceSpans;
  final List<String> ambiguities;

  ExtractionResult copyWith({
    List<CandidatePerson>? people,
    List<CandidatePlace>? places,
  }) => ExtractionResult(
    text: text,
    people: people ?? this.people,
    places: places ?? this.places,
    relationships: relationships,
    residences: residences,
    events: events,
    evidenceSpans: evidenceSpans,
    ambiguities: ambiguities,
  );
}

abstract interface class ExtractionProvider {
  Future<ExtractionResult> extract(ExtractionRequest request);
}
