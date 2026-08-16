import 'package:family_history/app/app_shell.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/features/home/home_screen.dart';
import 'package:family_history/features/family_tree/family_tree_screen.dart';
import 'package:family_history/features/people/person_detail_screen.dart';
import 'package:family_history/features/people/person_form_screen.dart';
import 'package:family_history/features/people/people_screen.dart';
import 'package:family_history/features/places/place_detail_screen.dart';
import 'package:family_history/features/places/place_form_screen.dart';
import 'package:family_history/features/places/places_screen.dart';
import 'package:family_history/features/review/person_merge_screen.dart';
import 'package:family_history/features/review/review_screen.dart';
import 'package:family_history/features/sources/source_detail_screen.dart';
import 'package:family_history/features/sources/source_form_screen.dart';
import 'package:family_history/features/sources/sources_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    routes: [
      ShellRoute(
        builder: (context, state, child) =>
            AppShell(currentPath: state.uri.path, child: child),
        routes: [
          GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
          GoRoute(
            path: '/tree',
            builder: (context, state) => const FamilyTreeScreen(),
          ),
          GoRoute(
            path: '/people',
            builder: (context, state) => const PeopleScreen(),
          ),
          GoRoute(
            path: '/people/new',
            builder: (context, state) => const PersonFormScreen(),
          ),
          GoRoute(
            path: '/people/:id',
            builder: (context, state) => PersonDetailScreen(
              personId: PersonId(state.pathParameters['id']!),
            ),
          ),
          GoRoute(
            path: '/people/:id/edit',
            builder: (context, state) => PersonFormScreen(
              personId: PersonId(state.pathParameters['id']!),
            ),
          ),
          GoRoute(
            path: '/places',
            builder: (context, state) => const PlacesScreen(),
          ),
          GoRoute(
            path: '/places/new',
            builder: (context, state) => const PlaceFormScreen(),
          ),
          GoRoute(
            path: '/places/:id',
            builder: (context, state) => PlaceDetailScreen(
              placeId: PlaceId(state.pathParameters['id']!),
            ),
          ),
          GoRoute(
            path: '/places/:id/edit',
            builder: (context, state) =>
                PlaceFormScreen(placeId: PlaceId(state.pathParameters['id']!)),
          ),
          GoRoute(
            path: '/sources',
            builder: (context, state) => const SourcesScreen(),
          ),
          GoRoute(
            path: '/sources/new',
            builder: (context, state) => const SourceFormScreen(),
          ),
          GoRoute(
            path: '/sources/:id',
            builder: (context, state) => SourceDetailScreen(
              sourceId: SourceId(state.pathParameters['id']!),
            ),
          ),
          GoRoute(
            path: '/sources/:id/edit',
            builder: (context, state) => SourceFormScreen(
              sourceId: SourceId(state.pathParameters['id']!),
            ),
          ),
          GoRoute(
            path: '/review',
            builder: (context, state) => const ReviewScreen(),
          ),
          GoRoute(
            path: '/review/merge/:a/:b',
            builder: (context, state) => PersonMergeScreen(
              personAId: PersonId(state.pathParameters['a']!),
              personBId: PersonId(state.pathParameters['b']!),
            ),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Ruta no trobada: ${state.uri}'))),
  );
  ref.onDispose(router.dispose);
  return router;
});
