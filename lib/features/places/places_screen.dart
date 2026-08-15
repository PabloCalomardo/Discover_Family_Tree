import 'package:family_history/app/app_strings.dart';
import 'package:family_history/app/providers.dart';
import 'package:family_history/domain/place/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PlacesScreen extends ConsumerWidget {
  const PlacesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final places = ref.watch(placesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.places)),
      body: places.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text(error.toString())),
        data: (items) => items.isEmpty
            ? const Center(child: Text(AppStrings.noData))
            : ListView.separated(
                padding: const EdgeInsets.all(24),
                itemCount: items.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final place = items[index];
                  return ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.place)),
                    title: Text(place.preferredName),
                    subtitle: Text(_placeTypeLabel(place.type)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.go('/places/${place.id.value}'),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/places/new'),
        icon: const Icon(Icons.add_location_alt),
        label: const Text(AppStrings.newPlace),
      ),
    );
  }
}

String placeTypeLabel(PlaceType type) => _placeTypeLabel(type);

String _placeTypeLabel(PlaceType type) => switch (type) {
  PlaceType.house => 'Casa',
  PlaceType.farmhouse => 'Mas',
  PlaceType.apartment => 'Pis',
  PlaceType.building => 'Edifici',
  PlaceType.street => 'Carrer',
  PlaceType.neighborhood => 'Barri',
  PlaceType.village => 'Poble',
  PlaceType.town => 'Vila',
  PlaceType.city => 'Ciutat',
  PlaceType.municipality => 'Municipi',
  PlaceType.region => 'Regió',
  PlaceType.country => 'País',
  PlaceType.church => 'Església',
  PlaceType.cemetery => 'Cementiri',
  PlaceType.hospital => 'Hospital',
  PlaceType.school => 'Escola',
  PlaceType.workplace => 'Lloc de treball',
  PlaceType.other => 'Altres',
  PlaceType.custom => 'Personalitzat',
};
