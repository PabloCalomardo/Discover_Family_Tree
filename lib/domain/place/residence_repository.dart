import 'package:family_history/core/dates/historical_period.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/domain/place/residence.dart';

abstract interface class ResidenceRepository {
  Stream<List<Residence>> watchForPerson(PersonId personId);

  Stream<List<Residence>> watchResidentsAtPlace(
    PlaceId placeId, {
    HistoricalPeriod? period,
  });

  Future<void> create(Residence residence);
  Future<void> update(Residence residence);
  Future<void> delete(ResidenceId id);
}
