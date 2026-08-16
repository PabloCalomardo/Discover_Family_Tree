import 'dart:ui' show PointerDeviceKind;

import 'package:drift/native.dart';
import 'package:family_history/app/app.dart';
import 'package:family_history/app/app_strings.dart';
import 'package:family_history/app/providers.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/database/database.dart' as db;
import 'package:family_history/database/repositories/drift_person_name_repository.dart';
import 'package:family_history/database/repositories/drift_person_repository.dart';
import 'package:family_history/database/repositories/drift_parent_child_relationship_repository.dart';
import 'package:family_history/database/repositories/drift_partnership_repository.dart';
import 'package:family_history/database/repositories/drift_place_repository.dart';
import 'package:family_history/database/repositories/drift_source_repository.dart';
import 'package:family_history/domain/person/person.dart';
import 'package:family_history/domain/person/person_name.dart';
import 'package:family_history/domain/place/place.dart';
import 'package:family_history/domain/relationship/parent_child_relationship.dart';
import 'package:family_history/domain/relationship/partnership.dart';
import 'package:family_history/domain/source/source.dart';
import 'package:family_history/features/sources/claim_form_dialog.dart';
import 'package:family_history/features/people/people_screen.dart';
import 'package:family_history/features/home/home_screen.dart';
import 'package:family_history/services/person/person_editor_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:graphview/GraphView.dart' as gv;

void main() {
  testWidgets('shows the application name', (tester) async {
    final database = db.AppDatabase(NativeDatabase.memory());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(database)],
        child: const FamilyHistoryApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('FamilyHistory'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await database.close();
  });

  testWidgets('new-project dialog owns its text controller until removed', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => FilledButton(
            onPressed: () => showDialog<String>(
              context: context,
              builder: (_) => const ProjectNameDialog(),
            ),
            child: const Text('Obre diàleg'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Obre diàleg'));
    await tester.pumpAndSettle();
    expect(find.text('Nom del projecte'), findsOneWidget);
    await tester.tap(find.text('Cancel·lar'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  testWidgets('creates a person from the user interface', (tester) async {
    final database = db.AppDatabase(NativeDatabase.memory());
    await tester.binding.setSurfaceSize(const Size(1280, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(database)],
        child: const FamilyHistoryApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));

    GoRouter.of(tester.element(find.byType(NavigationRail))).go('/people');
    await tester.pumpAndSettle();
    GoRouter.of(tester.element(find.byType(NavigationRail))).go('/people/new');
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'Joana Puig');
    await tester.scrollUntilVisible(
      find.text('Desar'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -200));
    await tester.pump();
    await tester.tap(find.text('Desar'));
    await tester.pumpAndSettle();

    expect(find.text('Joana Puig'), findsWidgets);
    expect(await database.select(database.persons).get(), hasLength(1));
    expect(await database.select(database.personNames).get(), hasLength(1));
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await database.close();
  });

  testWidgets('creates a source through the phase 6 user interface', (
    tester,
  ) async {
    final database = db.AppDatabase(NativeDatabase.memory());
    await tester.binding.setSurfaceSize(const Size(1280, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(database)],
        child: const FamilyHistoryApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));
    GoRouter.of(tester.element(find.byType(NavigationRail))).go('/sources/new');
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'Registre civil');
    await tester.scrollUntilVisible(
      find.text('Desa'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -200));
    await tester.pump();
    await tester.tap(find.text('Desa'));
    await tester.pumpAndSettle();

    expect(find.text('Registre civil'), findsWidgets);
    expect(await database.select(database.sources).get(), hasLength(1));
    expect(await database.select(database.auditEntries).get(), hasLength(1));
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await database.close();
  });

  testWidgets('cancel returns safely from forms opened with go', (
    tester,
  ) async {
    final database = db.AppDatabase(NativeDatabase.memory());
    final now = DateTime.utc(2026, 8, 16);
    final personId = PersonId.generate();
    await DriftPersonRepository(database).create(
      Person(
        id: personId,
        sex: PersonSex.unspecified,
        createdAt: now,
        modifiedAt: now,
      ),
    );
    await DriftPersonNameRepository(database).create(
      PersonName(
        id: PersonNameId.generate(),
        personId: personId,
        displayName: 'Persona de prova',
        type: PersonNameType.birth,
        isPreferred: true,
        createdAt: now,
        modifiedAt: now,
      ),
    );
    final placeId = PlaceId.generate();
    await DriftPlaceRepository(database).create(
      Place(
        id: placeId,
        preferredName: 'Lloc de prova',
        type: PlaceType.other,
        createdAt: now,
        modifiedAt: now,
      ),
    );
    final sourceId = SourceId.generate();
    await DriftSourceRepository(database).create(
      Source(
        id: sourceId,
        type: SourceType.document,
        title: 'Font de prova',
        createdAt: now,
        modifiedAt: now,
      ),
    );
    await tester.binding.setSurfaceSize(const Size(1280, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(database)],
        child: const FamilyHistoryApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));
    final router = GoRouter.of(tester.element(find.byType(NavigationRail)));

    Future<void> verifyCancel({
      required String formPath,
      required String cancelLabel,
      required String expectedPath,
    }) async {
      router.go(formPath);
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text(cancelLabel),
        300,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.drag(find.byType(Scrollable).last, const Offset(0, -120));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, cancelLabel));
      await tester.pumpAndSettle();
      expect(router.routerDelegate.currentConfiguration.uri.path, expectedPath);
      expect(tester.takeException(), isNull);
    }

    await verifyCancel(
      formPath: '/sources/new',
      cancelLabel: 'Cancel·la',
      expectedPath: '/sources',
    );
    await verifyCancel(
      formPath: '/people/new',
      cancelLabel: AppStrings.cancel,
      expectedPath: '/people',
    );
    await verifyCancel(
      formPath: '/places/new',
      cancelLabel: AppStrings.cancel,
      expectedPath: '/places',
    );
    await verifyCancel(
      formPath: '/sources/${sourceId.value}/edit',
      cancelLabel: 'Cancel·la',
      expectedPath: '/sources/${sourceId.value}',
    );
    await verifyCancel(
      formPath: '/people/${personId.value}/edit',
      cancelLabel: AppStrings.cancel,
      expectedPath: '/people/${personId.value}',
    );
    await verifyCancel(
      formPath: '/places/${placeId.value}/edit',
      cancelLabel: AppStrings.cancel,
      expectedPath: '/places/${placeId.value}',
    );

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await database.close();
  });

  testWidgets('opens claim operations without visiting the people tab', (
    tester,
  ) async {
    final database = db.AppDatabase(NativeDatabase.memory());
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(database)],
        child: MaterialApp(
          home: Consumer(
            builder: (context, ref, _) => Scaffold(
              body: FilledButton(
                onPressed: () =>
                    showClaimFormDialog(context, ref, SourceId.generate()),
                child: const Text('Afegeix afirmació'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Afegeix afirmació'));
    await tester.pumpAndSettle();
    expect(find.text('Nova afirmació'), findsOneWidget);
    expect(find.text('Crear persona'), findsOneWidget);

    await tester.tap(find.text('Crear persona'));
    await tester.pumpAndSettle();
    expect(find.text('Crear parentesc'), findsOneWidget);
    expect(find.text('Crear germanor'), findsOneWidget);
    await tester.tap(find.text('Crear lloc'));
    await tester.pumpAndSettle();
    expect(find.text('Altres'), findsOneWidget);
    expect(find.text('other'), findsNothing);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await database.close();
  });

  testWidgets('assigns a resident while editing a place', (tester) async {
    final database = db.AppDatabase(NativeDatabase.memory());
    final now = DateTime.utc(2026, 8, 16);
    final personId = PersonId.generate();
    await DriftPersonRepository(database).create(
      Person(
        id: personId,
        sex: PersonSex.unknown,
        createdAt: now,
        modifiedAt: now,
      ),
    );
    await DriftPersonNameRepository(database).create(
      PersonName(
        id: PersonNameId.generate(),
        personId: personId,
        displayName: 'Maria Resident',
        type: PersonNameType.birth,
        isPreferred: true,
        createdAt: now,
        modifiedAt: now,
      ),
    );
    final placeId = PlaceId.generate();
    await DriftPlaceRepository(database).create(
      Place(
        id: placeId,
        preferredName: 'Casa familiar',
        type: PlaceType.house,
        createdAt: now,
        modifiedAt: now,
      ),
    );
    await tester.binding.setSurfaceSize(const Size(1280, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(database)],
        child: const FamilyHistoryApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));

    GoRouter.of(tester.element(find.byType(NavigationRail)))
        .go('/places/${placeId.value}/edit');
    await tester.pumpAndSettle();
    expect(find.text('Residents del lloc'), findsOneWidget);
    expect(find.text('Maria Resident'), findsOneWidget);
    await tester.tap(find.text('Maria Resident'));
    await tester.scrollUntilVisible(
      find.text(AppStrings.save),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text(AppStrings.save));
    await tester.pumpAndSettle();

    final residences = await database.select(database.residences).get();
    expect(residences, hasLength(1));
    expect(residences.single.personId, personId.value);
    expect(residences.single.placeId, placeId.value);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await database.close();
  });

  testWidgets('bulk-selects and cascade-deletes people from the list', (
    tester,
  ) async {
    final database = db.AppDatabase(NativeDatabase.memory());
    final people = DriftPersonRepository(database);
    final names = DriftPersonNameRepository(database);
    final now = DateTime.utc(2026, 8, 16);
    for (final label in ['Maria', 'Joan', 'Teresa']) {
      final id = PersonId.generate();
      await people.create(
        Person(id: id, sex: PersonSex.unknown, createdAt: now, modifiedAt: now),
      );
      await names.create(
        PersonName(
          id: PersonNameId.generate(),
          personId: id,
          displayName: label,
          type: PersonNameType.birth,
          isPreferred: true,
          createdAt: now,
          modifiedAt: now,
        ),
      );
    }
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(database)],
        child: const MaterialApp(home: PeopleScreen()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.longPress(find.text('Maria'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Joan'));
    await tester.pumpAndSettle();
    expect(find.text('2 seleccionades'), findsOneWidget);
    await tester.tap(find.byTooltip('Eliminar persones seleccionades'));
    await tester.pumpAndSettle();
    expect(find.text('Eliminar 2 persones?'), findsOneWidget);
    await tester.tap(find.text('Elimina en cascada'));
    await tester.pumpAndSettle();

    expect(find.text('Maria'), findsNothing);
    expect(find.text('Joan'), findsNothing);
    expect(find.text('Teresa'), findsOneWidget);
    expect(await database.select(database.auditEntries).get(), hasLength(1));
    expect(await database.select(database.auditTargets).get(), hasLength(2));

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await database.close();
  });

  testWidgets('renders a stored person in the family tree', (tester) async {
    final database = db.AppDatabase(NativeDatabase.memory());
    final people = DriftPersonRepository(database);
    final names = DriftPersonNameRepository(database);
    final parentChild = DriftParentChildRelationshipRepository(database);
    final partnerships = DriftPartnershipRepository(database);
    final editor = PersonEditorService(database, people, names);
    final now = DateTime.utc(2026, 8, 15);
    final personId = PersonId.generate();
    await editor.create(
      Person(
        id: personId,
        sex: PersonSex.unspecified,
        createdAt: now,
        modifiedAt: now,
      ),
      PersonName(
        id: PersonNameId.generate(),
        personId: personId,
        displayName: 'Joana Puig',
        type: PersonNameType.birth,
        isPreferred: true,
        createdAt: now,
        modifiedAt: now,
      ),
    );
    final secondPersonId = PersonId.generate();
    await editor.create(
      Person(
        id: secondPersonId,
        sex: PersonSex.unspecified,
        createdAt: now,
        modifiedAt: now,
      ),
      PersonName(
        id: PersonNameId.generate(),
        personId: secondPersonId,
        displayName: 'Marc Puig',
        type: PersonNameType.birth,
        isPreferred: true,
        createdAt: now,
        modifiedAt: now,
      ),
    );
    await parentChild.create(
      ParentChildRelationship(
        id: ParentChildRelationshipId.generate(),
        parentId: personId,
        childId: secondPersonId,
        nature: ParentChildNature.biological,
        createdAt: now,
        modifiedAt: now,
      ),
    );
    await parentChild.create(
      ParentChildRelationship(
        id: ParentChildRelationshipId.generate(),
        parentId: personId,
        childId: secondPersonId,
        nature: ParentChildNature.adoptive,
        createdAt: now,
        modifiedAt: now,
      ),
    );
    final partnerId = PersonId.generate();
    await editor.create(
      Person(
        id: partnerId,
        sex: PersonSex.unspecified,
        createdAt: now,
        modifiedAt: now,
      ),
      PersonName(
        id: PersonNameId.generate(),
        personId: partnerId,
        displayName: 'Lluís Puig',
        type: PersonNameType.birth,
        isPreferred: true,
        createdAt: now,
        modifiedAt: now,
      ),
    );
    await partnerships.create(
      Partnership(
        id: PartnershipId.generate(),
        personAId: secondPersonId,
        personBId: partnerId,
        type: PartnershipType.unknown,
        createdAt: now,
        modifiedAt: now,
      ),
    );
    final coupleChildIds = <PersonId>[];
    for (final childName in ['Néta A', 'Nét B']) {
      final childId = PersonId.generate();
      coupleChildIds.add(childId);
      await editor.create(
        Person(
          id: childId,
          sex: PersonSex.unspecified,
          createdAt: now,
          modifiedAt: now,
        ),
        PersonName(
          id: PersonNameId.generate(),
          personId: childId,
          displayName: childName,
          type: PersonNameType.birth,
          isPreferred: true,
          createdAt: now,
          modifiedAt: now,
        ),
      );
      for (final parentId in [secondPersonId, partnerId]) {
        await parentChild.create(
          ParentChildRelationship(
            id: ParentChildRelationshipId.generate(),
            parentId: parentId,
            childId: childId,
            nature: ParentChildNature.biological,
            createdAt: now,
            modifiedAt: now,
          ),
        );
      }
    }
    final siblingId = PersonId.generate();
    await editor.create(
      Person(
        id: siblingId,
        sex: PersonSex.unspecified,
        createdAt: now,
        modifiedAt: now,
      ),
      PersonName(
        id: PersonNameId.generate(),
        personId: siblingId,
        displayName: 'Persona intermèdia',
        type: PersonNameType.birth,
        isPreferred: true,
        createdAt: now,
        modifiedAt: now,
      ),
    );
    await parentChild.create(
      ParentChildRelationship(
        id: ParentChildRelationshipId.generate(),
        parentId: personId,
        childId: siblingId,
        nature: ParentChildNature.biological,
        createdAt: now,
        modifiedAt: now,
      ),
    );
    final inLawMotherId = PersonId.generate();
    await editor.create(
      Person(
        id: inLawMotherId,
        sex: PersonSex.unspecified,
        createdAt: now,
        modifiedAt: now,
      ),
      PersonName(
        id: PersonNameId.generate(),
        personId: inLawMotherId,
        displayName: 'Mare de la parella',
        type: PersonNameType.birth,
        isPreferred: true,
        createdAt: now,
        modifiedAt: now,
      ),
    );
    await parentChild.create(
      ParentChildRelationship(
        id: ParentChildRelationshipId.generate(),
        parentId: inLawMotherId,
        childId: partnerId,
        nature: ParentChildNature.biological,
        createdAt: now,
        modifiedAt: now,
      ),
    );
    await tester.binding.setSurfaceSize(const Size(1280, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(database)],
        child: const FamilyHistoryApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));
    GoRouter.of(tester.element(find.byType(NavigationRail))).go('/tree');
    await tester.pumpAndSettle();

    expect(find.text('Arbre familiar'), findsOneWidget);
    expect(find.text('Joana Puig'), findsWidgets);
    expect(find.text('Marc Puig'), findsWidgets);
    expect(find.text('Lluís Puig'), findsWidgets);
    expect(find.text('Néta A'), findsWidgets);
    expect(find.text('Nét B'), findsWidgets);
    expect(find.text('Persona focal'), findsWidgets);

    final graphView = tester.widget<gv.GraphView>(find.byType(gv.GraphView));
    final initialGraphKey = graphView.key;
    double compactnessOverflow(gv.Graph graph) {
      final nodes = graph.nodes
          .where((node) => '${node.key?.value}'.startsWith('person:'))
          .toList();
      final rows = <double, List<gv.Node>>{};
      for (final node in nodes) {
        rows.putIfAbsent(node.position.dy, () => []).add(node);
      }
      final widestPackedRow = rows.values
          .map(
            (row) =>
                row.fold<double>(0, (width, node) => width + node.width) +
                48 * (row.length - 1),
          )
          .reduce((first, second) => first > second ? first : second);
      final left = nodes
          .map((node) => node.position.dx)
          .reduce((first, second) => first < second ? first : second);
      final right = nodes
          .map((node) => node.position.dx + node.width)
          .reduce((first, second) => first > second ? first : second);
      return right - left - widestPackedRow;
    }

    expect(compactnessOverflow(graphView.graph), lessThanOrEqualTo(96));
    for (final node in graphView.graph.nodes) {
      expect(node.position.dx, node.position.dx.roundToDouble());
      expect(node.position.dy, node.position.dy.roundToDouble());
    }
    final parentNode = graphView.graph.getNodeUsingId(
      'person:${personId.value}',
    );
    final childNode = graphView.graph.getNodeUsingId(
      'person:${secondPersonId.value}',
    );
    final partnerNode = graphView.graph.getNodeUsingId(
      'person:${partnerId.value}',
    );
    final siblingNode = graphView.graph.getNodeUsingId(
      'person:${siblingId.value}',
    );
    final firstCoupleChildNode = graphView.graph.getNodeUsingId(
      'person:${coupleChildIds.first.value}',
    );
    final secondCoupleChildNode = graphView.graph.getNodeUsingId(
      'person:${coupleChildIds.last.value}',
    );
    expect(
      graphView.graph.nodes.map((node) => node.key?.value),
      isNot(contains('person:${inLawMotherId.value}')),
    );
    expect(parentNode.position.dy, lessThan(childNode.position.dy));
    expect(
      (childNode.position.dy - partnerNode.position.dy).abs(),
      lessThan(1),
    );
    expect(childNode.position.dy, lessThan(firstCoupleChildNode.position.dy));
    expect(
      (firstCoupleChildNode.position.dy - secondCoupleChildNode.position.dy)
          .abs(),
      lessThan(1),
    );
    final leftSpouse = childNode.position.dx < partnerNode.position.dx
        ? childNode
        : partnerNode;
    final rightSpouse = leftSpouse == childNode ? partnerNode : childNode;
    expect(
      rightSpouse.position.dx - (leftSpouse.position.dx + leftSpouse.width),
      closeTo(48, 0.01),
    );
    final siblingCenter = siblingNode.position.dx + siblingNode.width / 2;
    expect(
      siblingCenter < leftSpouse.position.dx ||
          siblingCenter > rightSpouse.position.dx + rightSpouse.width,
      isTrue,
    );
    expect(find.byIcon(Icons.favorite), findsNothing);
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(
      location: tester.getCenter(find.byType(gv.GraphView)),
    );
    await mouse.moveTo(tester.getCenter(find.byType(gv.GraphView)));
    await tester.pump();
    expect(find.text('Joana Puig'), findsWidgets);

    await tester.tap(find.byType(DropdownButtonFormField<PersonId>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lluís Puig').last);
    await tester.pumpAndSettle();
    final refocusedGraphView = tester.widget<gv.GraphView>(
      find.byType(gv.GraphView),
    );
    expect(refocusedGraphView.key, isNot(initialGraphKey));
    expect(refocusedGraphView.animated, isFalse);
    expect(
      compactnessOverflow(refocusedGraphView.graph),
      lessThanOrEqualTo(96),
    );
    final refocusedPersonNode = refocusedGraphView.graph.getNodeUsingId(
      'person:${partnerId.value}',
    );
    final refocusedSpouseNode = refocusedGraphView.graph.getNodeUsingId(
      'person:${secondPersonId.value}',
    );
    final refocusedMotherNode = refocusedGraphView.graph.getNodeUsingId(
      'person:${inLawMotherId.value}',
    );
    final refocusedChildNode = refocusedGraphView.graph.getNodeUsingId(
      'person:${coupleChildIds.first.value}',
    );
    expect(
      refocusedGraphView.graph.nodes.map((node) => node.key?.value),
      isNot(contains('person:${personId.value}')),
    );
    expect(
      refocusedPersonNode.position.dy - refocusedMotherNode.position.dy,
      closeTo(refocusedMotherNode.height + 88, 0.01),
    );
    expect(
      (refocusedPersonNode.position.dy - refocusedSpouseNode.position.dy).abs(),
      lessThan(0.01),
    );
    expect(
      refocusedChildNode.position.dy - refocusedPersonNode.position.dy,
      closeTo(
        (refocusedPersonNode.height > refocusedSpouseNode.height
                ? refocusedPersonNode.height
                : refocusedSpouseNode.height) +
            88,
        0.01,
      ),
    );
    final focalCanvasPoint = Offset(
      refocusedPersonNode.position.dx + refocusedPersonNode.width / 2,
      refocusedPersonNode.position.dy + refocusedPersonNode.height / 2,
    );
    final focalViewportPoint = MatrixUtils.transformPoint(
      refocusedGraphView.controller!.transformationController!.value,
      focalCanvasPoint,
    );
    final graphViewportSize = tester.getSize(find.byType(gv.GraphView));
    expect(focalViewportPoint.dx, closeTo(graphViewportSize.width / 2, 0.5));
    expect(focalViewportPoint.dy, closeTo(graphViewportSize.height / 2, 0.5));

    await tester.tap(find.widgetWithText(FilterChip, 'Mostra tot'));
    await tester.pumpAndSettle();
    final expandedGraphView = tester.widget<gv.GraphView>(
      find.byType(gv.GraphView),
    );
    final expandedPartnerNode = expandedGraphView.graph.getNodeUsingId(
      'person:${partnerId.value}',
    );
    final expandedSpouseNode = expandedGraphView.graph.getNodeUsingId(
      'person:${secondPersonId.value}',
    );
    final expandedSiblingNode = expandedGraphView.graph.getNodeUsingId(
      'person:${siblingId.value}',
    );
    final expandedParentNode = expandedGraphView.graph.getNodeUsingId(
      'person:${personId.value}',
    );
    final inLawMotherNode = expandedGraphView.graph.getNodeUsingId(
      'person:${inLawMotherId.value}',
    );
    expect(find.text('Mare de la parella'), findsWidgets);
    expect(
      inLawMotherNode.position.dy,
      lessThan(expandedPartnerNode.position.dy),
    );
    final spouseDirection =
        expandedPartnerNode.position.dx - expandedSpouseNode.position.dx;
    final siblingDirection =
        expandedSiblingNode.position.dx - expandedSpouseNode.position.dx;
    expect(spouseDirection * siblingDirection, lessThan(0));

    double centerX(gv.Node node) => node.position.dx + node.width / 2;
    final firstFamilyPoints = [
      centerX(expandedParentNode),
      centerX(expandedSpouseNode),
      centerX(expandedSiblingNode),
    ]..sort();
    final secondFamilyPoints = [
      centerX(inLawMotherNode),
      centerX(expandedPartnerNode),
    ]..sort();
    expect(
      firstFamilyPoints.last < secondFamilyPoints.first ||
          secondFamilyPoints.last < firstFamilyPoints.first,
      isTrue,
    );

    GoRouter.of(tester.element(find.byType(NavigationRail)))
        .go('/people/${personId.value}');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Afegir relació'));
    await tester.pumpAndSettle();
    expect(find.text('La persona'), findsOneWidget);
    expect(find.text('Tria una persona'), findsOneWidget);
    expect(find.text('pare/mare de Joana Puig'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await database.close();
  });
}
