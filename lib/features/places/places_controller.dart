import 'package:family_history/domain/place/place.dart';
import 'package:family_history/domain/place/place_repository.dart';

final class PlacesController {
  const PlacesController(this._places);

  final PlaceRepository _places;

  Future<void> create(Place place) => _places.create(place);
  Future<void> update(Place place) => _places.update(place);
}
