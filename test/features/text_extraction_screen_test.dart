import 'package:drift/native.dart';
import 'package:family_history/app/providers.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/database/database.dart' as db;
import 'package:family_history/features/extraction/text_extraction_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows highlighted evidence before candidate review', (
    tester,
  ) async {
    final database = db.AppDatabase(NativeDatabase.memory());
    await tester.binding.setSurfaceSize(const Size(1280, 900));
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
      await database.close();
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(database)],
        child: MaterialApp(
          home: TextExtractionScreen(sourceId: SourceId.generate()),
        ),
      ),
    );

    await tester.enterText(
      find.byType(TextField).last,
      'Em dic Clara Vidal. Vaig néixer a Manresa el 12 de març de 1958. '
      'La meva mare, Rosa Puig, havia nascut a Berga.',
    );
    await tester.tap(find.text('Analitza localment'));
    await tester.pumpAndSettle();

    expect(
      find.text('Verifica el text abans de revisar les propostes'),
      findsOneWidget,
    );
    expect(find.text('Continua a la revisió'), findsOneWidget);
    expect(find.byType(SelectionArea), findsOneWidget);

    final richText = tester.widget<RichText>(
      find.descendant(
        of: find.byType(SelectionArea),
        matching: find.byType(RichText),
      ),
    );
    final root = richText.text as TextSpan;
    final highlighted = root.children!
        .whereType<TextSpan>()
        .where((span) => span.style?.decoration == TextDecoration.underline)
        .toList();
    expect(highlighted, isNotEmpty);
    expect(
      highlighted.map((span) => span.style!.decorationColor).toSet().length,
      greaterThanOrEqualTo(5),
      reason: 'two people, relationships, places and dates use distinct colors',
    );

    await tester.tap(find.text('Continua a la revisió'));
    await tester.pumpAndSettle();
    expect(find.text('Revisa les propostes'), findsOneWidget);
    expect(find.byType(CheckboxListTile), findsWidgets);
  });

  testWidgets('shows people from explicit extended-family lists', (
    tester,
  ) async {
    final database = db.AppDatabase(NativeDatabase.memory());
    await tester.binding.setSurfaceSize(const Size(1280, 900));
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
      await database.close();
    });
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(database)],
        child: MaterialApp(
          home: TextExtractionScreen(sourceId: SourceId.generate()),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField).first, 'Mercè Soler');
    await tester.enterText(
      find.byType(TextField).last,
      'Els meus pares es deien Maria i Josep. Jo tenia dos germans: '
      'en Joan, que era el més gran, i la Teresa, que era la més petita. '
      'Per part de mare, els meus avis es deien Rosa i Miquel, i per part '
      'de pare, Anna i Pere. Vaig conèixer una de les meves besàvies, la '
      'Caterina. Em vaig casar amb l’Antoni.',
    );
    await tester.tap(find.text('Analitza localment'));
    await tester.pumpAndSettle();

    for (final name in [
      'Mercè Soler',
      'Maria',
      'Josep',
      'Joan',
      'Teresa',
      'Rosa',
      'Miquel',
      'Anna',
      'Pere',
      'Caterina',
      'Antoni',
    ]) {
      expect(find.text(name), findsOneWidget);
    }
    expect(
      find.text('Verifica el text abans de revisar les propostes'),
      findsOneWidget,
    );
  });

  testWidgets('shows an inferred birth range from an explicit age', (
    tester,
  ) async {
    final database = db.AppDatabase(NativeDatabase.memory());
    await tester.binding.setSurfaceSize(const Size(1280, 900));
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
      await database.close();
    });
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(database)],
        child: MaterialApp(
          home: TextExtractionScreen(sourceId: SourceId.generate()),
        ),
      ),
    );

    await tester.enterText(
      find.byType(TextField).last,
      'La Maria Soler Puig és una dona de 78 anys que explica la seva família.',
    );
    await tester.tap(find.text('Analitza localment'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continua a la revisió'));
    await tester.pumpAndSettle();

    expect(find.textContaining('inferit de 78 anys'), findsOneWidget);
    expect(
      find.textContaining('Data inferida; cal confirmar-la'),
      findsOneWidget,
    );
  });
}
