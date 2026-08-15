import 'dart:async';

import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/database/database.dart' as db;
import 'package:family_history/database/repositories/drift_event_repository.dart';
import 'package:family_history/database/repositories/drift_parent_child_relationship_repository.dart';
import 'package:family_history/database/repositories/drift_partnership_repository.dart';
import 'package:family_history/database/repositories/drift_person_name_repository.dart';
import 'package:family_history/database/repositories/drift_person_repository.dart';
import 'package:family_history/database/repositories/drift_place_repository.dart';
import 'package:family_history/database/repositories/drift_residence_repository.dart';
import 'package:family_history/domain/event/event.dart';
import 'package:family_history/domain/event/event_repository.dart';
import 'package:family_history/domain/person/person.dart';
import 'package:family_history/domain/person/person_name.dart';
import 'package:family_history/domain/person/person_name_repository.dart';
import 'package:family_history/domain/person/person_repository.dart';
import 'package:family_history/domain/place/place.dart';
import 'package:family_history/domain/place/place_repository.dart';
import 'package:family_history/domain/place/residence.dart';
import 'package:family_history/domain/place/residence_repository.dart';
import 'package:family_history/domain/relationship/parent_child_relationship.dart';
import 'package:family_history/domain/relationship/parent_child_relationship_repository.dart';
import 'package:family_history/domain/relationship/partnership.dart';
import 'package:family_history/domain/relationship/partnership_repository.dart';
import 'package:family_history/features/people/people_controller.dart';
import 'package:family_history/features/places/places_controller.dart';
import 'package:family_history/services/event/event_editor_service.dart';
import 'package:family_history/services/kinship/kinship_service.dart';
import 'package:family_history/services/person/person_editor_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final databaseProvider = Provider<db.AppDatabase>((ref) {
  final database = db.AppDatabase.defaults();
  ref.onDispose(() => unawaited(database.close()));
  return database;
});

final personRepositoryProvider = Provider<PersonRepository>(
  (ref) => DriftPersonRepository(ref.watch(databaseProvider)),
);
final personNameRepositoryProvider = Provider<PersonNameRepository>(
  (ref) => DriftPersonNameRepository(ref.watch(databaseProvider)),
);
final parentChildRepositoryProvider =
    Provider<ParentChildRelationshipRepository>(
      (ref) =>
          DriftParentChildRelationshipRepository(ref.watch(databaseProvider)),
    );
final partnershipRepositoryProvider = Provider<PartnershipRepository>(
  (ref) => DriftPartnershipRepository(ref.watch(databaseProvider)),
);
final placeRepositoryProvider = Provider<PlaceRepository>(
  (ref) => DriftPlaceRepository(ref.watch(databaseProvider)),
);
final residenceRepositoryProvider = Provider<ResidenceRepository>(
  (ref) => DriftResidenceRepository(ref.watch(databaseProvider)),
);
final eventRepositoryProvider = Provider<EventRepository>(
  (ref) => DriftEventRepository(ref.watch(databaseProvider)),
);

final personEditorServiceProvider = Provider<PersonEditorService>(
  (ref) => PersonEditorService(
    ref.watch(databaseProvider),
    ref.watch(personRepositoryProvider),
    ref.watch(personNameRepositoryProvider),
  ),
);
final eventEditorServiceProvider = Provider<EventEditorService>(
  (ref) => EventEditorService(
    ref.watch(databaseProvider),
    ref.watch(eventRepositoryProvider),
  ),
);

final peopleControllerProvider = Provider<PeopleController>(
  (ref) => PeopleController(
    ref.watch(personEditorServiceProvider),
    ref.watch(parentChildRepositoryProvider),
    ref.watch(partnershipRepositoryProvider),
    ref.watch(residenceRepositoryProvider),
    ref.watch(eventRepositoryProvider),
    ref.watch(eventEditorServiceProvider),
  ),
);
final placesControllerProvider = Provider<PlacesController>(
  (ref) => PlacesController(ref.watch(placeRepositoryProvider)),
);

final peopleProvider = StreamProvider<List<Person>>(
  (ref) => ref.watch(personRepositoryProvider).watchAll(),
);
final personProvider = FutureProvider.family<Person?, PersonId>(
  (ref, id) => ref.watch(personRepositoryProvider).get(id),
);
final personNamesProvider = StreamProvider.family<List<PersonName>, PersonId>(
  (ref, id) => ref.watch(personNameRepositoryProvider).watchForPerson(id),
);
final allPersonNamesProvider = StreamProvider<List<PersonName>>(
  (ref) => ref.watch(personNameRepositoryProvider).watchAll(),
);
final parentChildRelationshipsProvider =
    StreamProvider<List<ParentChildRelationship>>(
      (ref) => ref.watch(parentChildRepositoryProvider).watchAll(),
    );
final partnershipsProvider = StreamProvider<List<Partnership>>(
  (ref) => ref.watch(partnershipRepositoryProvider).watchAll(),
);
final placesProvider = StreamProvider<List<Place>>(
  (ref) => ref.watch(placeRepositoryProvider).watchAll(),
);
final placeProvider = FutureProvider.family<Place?, PlaceId>(
  (ref, id) => ref.watch(placeRepositoryProvider).get(id),
);
final personResidencesProvider =
    StreamProvider.family<List<Residence>, PersonId>(
      (ref, id) => ref.watch(residenceRepositoryProvider).watchForPerson(id),
    );
final placeResidencesProvider = StreamProvider.family<List<Residence>, PlaceId>(
  (ref, id) => ref.watch(residenceRepositoryProvider).watchResidentsAtPlace(id),
);
final personEventsProvider = StreamProvider.family<List<FamilyEvent>, PersonId>(
  (ref, id) => ref.watch(eventRepositoryProvider).watchForPerson(id),
);
final kinshipServiceProvider = Provider<KinshipService>(
  (ref) => const KinshipService(),
);
