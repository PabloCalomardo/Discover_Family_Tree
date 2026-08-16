import 'package:family_history/domain/extraction/extraction.dart';
import 'package:family_history/domain/person/person_name.dart';
import 'package:family_history/domain/place/place.dart';

final class EntityResolutionService {
  const EntityResolutionService();

  ExtractionResult resolve({
    required ExtractionResult extraction,
    required List<PersonName> knownNames,
    required List<Place> knownPlaces,
  }) {
    final namesByText = <String, List<PersonName>>{};
    for (final name in knownNames) {
      namesByText.putIfAbsent(_normalize(name.displayName), () => []).add(name);
    }
    final placesByText = <String, List<Place>>{};
    for (final place in knownPlaces) {
      placesByText
          .putIfAbsent(_normalize(place.preferredName), () => [])
          .add(place);
    }

    return extraction.copyWith(
      people: extraction.people.map((candidate) {
        if (candidate.requiresName) return candidate;
        final matches =
            namesByText[_normalize(candidate.displayName)] ?? const [];
        return matches.length == 1
            ? candidate.copyWith(resolvedId: matches.single.personId)
            : candidate.copyWith(resolutionAmbiguous: matches.length > 1);
      }).toList(),
      places: extraction.places.map((candidate) {
        final matches =
            placesByText[_normalize(candidate.preferredName)] ?? const [];
        return matches.length == 1
            ? candidate.copyWith(resolvedId: matches.single.id)
            : candidate.copyWith(resolutionAmbiguous: matches.length > 1);
      }).toList(),
    );
  }

  static String _normalize(String value) =>
      value.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
}
