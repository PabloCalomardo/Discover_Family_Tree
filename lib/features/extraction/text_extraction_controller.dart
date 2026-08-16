import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/domain/extraction/extraction.dart';
import 'package:family_history/domain/person/person_name_repository.dart';
import 'package:family_history/domain/place/place_repository.dart';
import 'package:family_history/services/claim/claim_service.dart';
import 'package:family_history/services/extraction/entity_resolution_service.dart';
import 'package:family_history/services/extraction/extraction_claim_mapper.dart';

final class TextExtractionController {
  const TextExtractionController(
    this._extractor,
    this._resolver,
    this._names,
    this._places,
    this._mapper,
    this._claims,
  );

  final ExtractionProvider _extractor;
  final EntityResolutionService _resolver;
  final PersonNameRepository _names;
  final PlaceRepository _places;
  final ExtractionClaimMapper _mapper;
  final ClaimService _claims;

  Future<ExtractionResult> analyze(String text, {String? narratorName}) async {
    final extraction = await _extractor.extract(
      ExtractionRequest(text: text, narratorName: narratorName),
    );
    final (names, places) = await (_names.listAll(), _places.listAll()).wait;
    return _resolver.resolve(
      extraction: extraction,
      knownNames: names,
      knownPlaces: places,
    );
  }

  Future<int> createClaims({
    required SourceId sourceId,
    required ExtractionResult extraction,
    required Set<String> selectedRefs,
  }) async {
    final claims = _mapper.map(
      extraction: extraction,
      sourceId: sourceId,
      selectedRefs: selectedRefs,
    );
    await _claims.createAll(claims);
    return claims.length;
  }
}
