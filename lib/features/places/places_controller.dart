import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/domain/audit/audit_entry.dart';
import 'package:family_history/domain/place/place.dart';
import 'package:family_history/domain/place/place_repository.dart';
import 'package:family_history/domain/place/residence.dart';
import 'package:family_history/domain/place/residence_repository.dart';
import 'package:family_history/services/audit/audit_service.dart';
import 'package:family_history/services/transaction_runner.dart';

final class PlacesController {
  const PlacesController(
    this._places,
    this._residences,
    this._audit,
    this._transactions,
  );

  final PlaceRepository _places;
  final ResidenceRepository _residences;
  final AuditService _audit;
  final TransactionRunner _transactions;

  Future<void> create(Place place) => _transactions.run(() async {
    await _places.create(place);
    await _record(AuditType.placeCreated, place, 'CREATED');
  });
  Future<void> update(Place place) => _transactions.run(() async {
    await _places.update(place);
    await _record(AuditType.placeUpdated, place, 'UPDATED');
  });

  Future<void> updateWithResidents(Place place, Set<PersonId> residentIds) =>
      _transactions.run(() async {
        final existing = await _residences.listResidentsAtPlace(place.id);
        final existingPeople = existing.map((item) => item.personId).toSet();
        await _places.update(place);
        await _record(AuditType.placeUpdated, place, 'UPDATED');

        final now = DateTime.now().toUtc();
        for (final personId in residentIds.difference(existingPeople)) {
          final residence = Residence(
            id: ResidenceId.generate(),
            personId: personId,
            placeId: place.id,
            createdAt: now,
            modifiedAt: now,
          );
          await _residences.create(residence);
          await _recordResidence(residence, created: true);
        }
        for (final residence in existing.where(
          (item) => !residentIds.contains(item.personId),
        )) {
          await _residences.delete(residence.id);
          await _recordResidence(residence, created: false);
        }
      });

  Future<void> _recordResidence(Residence residence, {required bool created}) =>
      _audit.record(
        type: created ? AuditType.residenceCreated : AuditType.residenceDeleted,
        payload: {'placeId': residence.placeId.value},
        targets: [
          AuditTarget(
            entityType: 'RESIDENCE',
            entityId: residence.id.value,
            role: created ? 'CREATED' : 'DELETED',
          ),
          AuditTarget(
            entityType: 'PERSON',
            entityId: residence.personId.value,
            role: 'RESIDENT',
          ),
          AuditTarget(
            entityType: 'PLACE',
            entityId: residence.placeId.value,
            role: 'RESIDENCE_PLACE',
          ),
        ],
      );

  Future<void> _record(AuditType type, Place place, String role) =>
      _audit.record(
        type: type,
        payload: {'name': place.preferredName, 'type': place.type.name},
        targets: [
          AuditTarget(
            entityType: 'PLACE',
            entityId: place.id.value,
            role: role,
          ),
        ],
      );
}
