import 'package:family_history/core/ids/domain_id.dart';
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
import 'package:family_history/services/person/person_editor_service.dart';

final class PeopleController {
  const PeopleController(
    this._personEditor,
    this._parentChildRelationships,
    this._partnerships,
    this._residences,
    this._events,
    this._eventEditor,
  );

  final PersonEditorService _personEditor;
  final ParentChildRelationshipRepository _parentChildRelationships;
  final PartnershipRepository _partnerships;
  final ResidenceRepository _residences;
  final EventRepository _events;
  final EventEditorService _eventEditor;

  Future<void> createPerson(Person person, PersonName preferredName) =>
      _personEditor.create(person, preferredName);
  Future<void> updatePerson(Person person, PersonName preferredName) =>
      _personEditor.update(person, preferredName);
  Future<PersonDeletionBlockers> deletionBlockers(PersonId id) =>
      _personEditor.deletionBlockers(id);
  Future<void> deletePerson(PersonId id) => _personEditor.delete(id);

  Future<void> addParentChild(ParentChildRelationship relationship) =>
      _parentChildRelationships.create(relationship);
  Future<void> removeParentChild(ParentChildRelationshipId id) =>
      _parentChildRelationships.delete(id);
  Future<void> addPartnership(Partnership partnership) =>
      _partnerships.create(partnership);
  Future<void> removePartnership(PartnershipId id) => _partnerships.delete(id);
  Future<void> addResidence(Residence residence) =>
      _residences.create(residence);
  Future<void> removeResidence(ResidenceId id) => _residences.delete(id);
  Future<void> createEvent(FamilyEvent event, EventParticipant participant) =>
      _eventEditor.createForPerson(event, participant);
  Future<void> removeEvent(EventId id) => _events.delete(id);
}
