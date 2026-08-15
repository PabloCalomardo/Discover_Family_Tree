import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/domain/place/place.dart';

abstract interface class PlaceRepository {
  Future<Place?> get(PlaceId id);
  Stream<List<Place>> watchAll();
  Future<void> create(Place place);
  Future<void> update(Place place);
  Future<void> delete(PlaceId id);
}
