import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/domain/person/person_name.dart';

abstract interface class PersonNameRepository {
  Future<List<PersonName>> listAll();
  Stream<List<PersonName>> watchAll();
  Stream<List<PersonName>> watchForPerson(PersonId personId);
  Future<void> create(PersonName name);
  Future<void> update(PersonName name);
  Future<void> delete(PersonNameId id);
}
