import 'package:family_history/app/app.dart';
import 'package:family_history/app/providers.dart';
import 'package:family_history/services/project/project_workspace_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final projects = await ProjectWorkspaceController.initialize();
  runApp(
    ProviderScope(
      overrides: [
        projectWorkspaceControllerProvider.overrideWith(
          (ref) => projects,
          disposeNotifier: true,
        ),
      ],
      child: const FamilyHistoryApp(),
    ),
  );
}
