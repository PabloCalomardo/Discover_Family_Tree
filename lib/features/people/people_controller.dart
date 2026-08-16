import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/domain/audit/audit_entry.dart';
import 'package:family_history/domain/event/event.dart';
import 'package:family_history/domain/event/event_participant.dart';
import 'package:family_history/domain/event/event_repository.dart';
import 'package:family_history/domain/person/person.dart';
import 'package:family_history/domain/person/person_name.dart';
import 'package:family_history/domain/place/residence.dart';
import 'package:family_history/domain/place/residence_repository.dart';
import 'package:family_history/domain/relationship/parent_child_relationship.dart';
import 'package:family_history/domain/relationship/parent_child_relationship_repository.dart';
import 'package:family_history/domain/relationship/partnership.dart';
import 'package:family_history/domain/relationship/partnership_repository.dart';
import 'package:family_history/services/event/event_editor_service.dart';
import 'package:family_history/services/audit/audit_service.dart';
import 'package:family_history/services/person/person_editor_service.dart';
import 'package:family_history/services/transaction_runner.dart';

final class PeopleController {
  const PeopleController(
    this._personEditor,
    this._parentChildRelationships,
    this._partnerships,
    this._residences,
    this._events,
    this._eventEditor,
    this._audit,
    this._transactions,
  );

  final PersonEditorService _personEditor;
  final ParentChildRelationshipRepository _parentChildRelationships;
  final PartnershipRepository _partnerships;
  final ResidenceRepository _residences;
  final EventRepository _events;
  final EventEditorService _eventEditor;
  final AuditService _audit;
  final TransactionRunner _transactions;

  Future<void> createPerson(Person person, PersonName preferredName) =>
      _transactions.run(() async {
        await _personEditor.create(person, preferredName);
        await _recordPerson(AuditType.personCreated, person);
      });
  Future<void> updatePerson(Person person, PersonName preferredName) =>
      _transactions.run(() async {
        await _personEditor.update(person, preferredName);
        await _recordPerson(AuditType.personUpdated, person);
      });
  Future<PersonDeletionBlockers> deletionBlockers(PersonId id) =>
      _personEditor.deletionBlockers(id);
  Future<void> deletePerson(PersonId id) => _transactions.run(() async {
    await _personEditor.delete(id);
    await _audit.record(
      type: AuditType.personDeleted,
      payload: const {},
      targets: [
        AuditTarget(entityType: 'PERSON', entityId: id.value, role: 'DELETED'),
      ],
    );
  });

  Future<void> addParentChild(ParentChildRelationship relationship) =>
      _transactions.run(() async {
        await _parentChildRelationships.create(relationship);
        await _recordRelationship('PARENT_CHILD', relationship.id.value, true);
      });
  Future<void> removeParentChild(ParentChildRelationshipId id) =>
      _transactions.run(() async {
        await _parentChildRelationships.delete(id);
        await _recordRelationship('PARENT_CHILD', id.value, false);
      });
  Future<void> addPartnership(Partnership partnership) =>
      _transactions.run(() async {
        await _partnerships.create(partnership);
        await _recordRelationship('PARTNERSHIP', partnership.id.value, true);
      });
  Future<void> removePartnership(PartnershipId id) =>
      _transactions.run(() async {
        await _partnerships.delete(id);
        await _recordRelationship('PARTNERSHIP', id.value, false);
      });
  Future<void> addResidence(Residence residence) => _transactions.run(() async {
    await _residences.create(residence);
    await _audit.record(
      type: AuditType.residenceCreated,
      payload: {'placeId': residence.placeId.value},
      targets: [
        AuditTarget(
          entityType: 'RESIDENCE',
          entityId: residence.id.value,
          role: 'CREATED',
        ),
        AuditTarget(
          entityType: 'PERSON',
          entityId: residence.personId.value,
          role: 'RESIDENT',
        ),
      ],
    );
  });
  Future<void> removeResidence(ResidenceId id) => _transactions.run(() async {
    await _residences.delete(id);
    await _audit.record(
      type: AuditType.residenceDeleted,
      payload: const {},
      targets: [
        AuditTarget(
          entityType: 'RESIDENCE',
          entityId: id.value,
          role: 'DELETED',
        ),
      ],
    );
  });
  Future<void> createEvent(FamilyEvent event, EventParticipant participant) =>
      _transactions.run(() async {
        await _eventEditor.createForPerson(event, participant);
        await _audit.record(
          type: AuditType.eventCreated,
          payload: {'type': event.type.name},
          targets: [
            AuditTarget(
              entityType: 'EVENT',
              entityId: event.id.value,
              role: 'CREATED',
            ),
            AuditTarget(
              entityType: 'PERSON',
              entityId: participant.personId.value,
              role: 'PARTICIPANT',
            ),
          ],
        );
      });
  Future<void> removeEvent(EventId id) => _transactions.run(() async {
    await _events.delete(id);
    await _audit.record(
      type: AuditType.eventDeleted,
      payload: const {},
      targets: [
        AuditTarget(entityType: 'EVENT', entityId: id.value, role: 'DELETED'),
      ],
    );
  });

  Future<void> _recordPerson(AuditType type, Person person) => _audit.record(
    type: type,
    payload: {'sex': person.sex.name},
    targets: [
      AuditTarget(
        entityType: 'PERSON',
        entityId: person.id.value,
        role: type == AuditType.personCreated ? 'CREATED' : 'UPDATED',
      ),
    ],
  );

  Future<void> _recordRelationship(String kind, String id, bool created) =>
      _audit.record(
        type: created
            ? AuditType.relationshipCreated
            : AuditType.relationshipDeleted,
        payload: {'kind': kind},
        targets: [
          AuditTarget(
            entityType: kind,
            entityId: id,
            role: created ? 'CREATED' : 'DELETED',
          ),
        ],
      );
}
