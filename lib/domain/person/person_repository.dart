import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/domain/person/person.dart';

abstract interface class PersonRepository {
  Future<Person?> get(PersonId id);
  Stream<List<Person>> watchAll();
  Future<void> create(Person person);
  Future<void> update(Person person);
  Future<void> delete(PersonId id);
}
