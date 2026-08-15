import 'package:family_history/app/app_strings.dart';
import 'package:family_history/app/providers.dart';
import 'package:family_history/components/historical_date_field.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/domain/place/residence.dart';
import 'package:family_history/features/places/places_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PlaceDetailScreen extends ConsumerWidget {
  const PlaceDetailScreen({required this.placeId, super.key});

  final PlaceId placeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final place = ref.watch(placeProvider(placeId));
    return place.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) =>
          Scaffold(body: Center(child: Text(error.toString()))),
      data: (value) {
        if (value == null) {
          return const Scaffold(body: Center(child: Text('Lloc no trobat.')));
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(value.preferredName),
            actions: [
              TextButton.icon(
                onPressed: () => context.go('/places/${placeId.value}/edit'),
                icon: const Icon(Icons.edit),
                label: const Text(AppStrings.edit),
              ),
              const SizedBox(width: 12),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(32),
            children: [
              Text(
                placeTypeLabel(value.type),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (value.latitude != null) ...[
                const SizedBox(height: 8),
                Text('${value.latitude}, ${value.longitude}'),
              ],
              if (value.description case final description?) ...[
                const SizedBox(height: 16),
                Text(description),
              ],
              const SizedBox(height: 32),
              Text(
                'Residents',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              ref
                  .watch(placeResidencesProvider(placeId))
                  .when(
                    loading: () => const LinearProgressIndicator(),
                    error: (error, stackTrace) => Text(error.toString()),
                    data: (items) => items.isEmpty
                        ? const Text('No hi ha residències registrades.')
                        : Column(
                            children: items
                                .map(
                                  (residence) =>
                                      _ResidentTile(residence: residence),
                                )
                                .toList(),
                          ),
                  ),
            ],
          ),
        );
      },
    );
  }
}

class _ResidentTile extends ConsumerWidget {
  const _ResidentTile({required this.residence});

  final Residence residence;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final names = ref.watch(personNamesProvider(residence.personId)).value;
    final name =
        names?.where((item) => item.isPreferred).firstOrNull?.displayName ??
        names?.firstOrNull?.displayName ??
        'Persona';
    return ListTile(
      leading: const Icon(Icons.person_outline),
      title: Text(name),
      subtitle: Text(
        '${historicalDateLabel(residence.startDate)} – '
        '${historicalDateLabel(residence.endDate)}',
      ),
      onTap: () => context.go('/people/${residence.personId.value}'),
    );
  }
}
