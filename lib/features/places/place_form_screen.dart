import 'package:family_history/app/app_strings.dart';
import 'package:family_history/app/providers.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/domain/place/place.dart';
import 'package:family_history/features/places/places_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PlaceFormScreen extends ConsumerWidget {
  const PlaceFormScreen({this.placeId, super.key});

  final PlaceId? placeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = placeId;
    if (id == null) return const _PlaceForm();
    return ref
        .watch(placeProvider(id))
        .when(
          loading: () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (error, stackTrace) =>
              Scaffold(body: Center(child: Text(error.toString()))),
          data: (place) => place == null
              ? const Scaffold(body: Center(child: Text('Lloc no trobat.')))
              : _PlaceForm(key: ValueKey(id), initialPlace: place),
        );
  }
}

class _PlaceForm extends ConsumerStatefulWidget {
  const _PlaceForm({super.key, this.initialPlace});

  final Place? initialPlace;

  @override
  ConsumerState<_PlaceForm> createState() => _PlaceFormState();
}

class _PlaceFormState extends ConsumerState<_PlaceForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _latitude;
  late final TextEditingController _longitude;
  late final TextEditingController _description;
  late final TextEditingController _notes;
  late PlaceType _type;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final place = widget.initialPlace;
    _name = TextEditingController(text: place?.preferredName ?? '');
    _latitude = TextEditingController(text: place?.latitude?.toString() ?? '');
    _longitude = TextEditingController(
      text: place?.longitude?.toString() ?? '',
    );
    _description = TextEditingController(text: place?.description ?? '');
    _notes = TextEditingController(text: place?.notes ?? '');
    _type = place?.type ?? PlaceType.house;
  }

  @override
  void dispose() {
    _name.dispose();
    _latitude.dispose();
    _longitude.dispose();
    _description.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final existing = widget.initialPlace;
      final now = DateTime.now().toUtc();
      final id = existing?.id ?? PlaceId.generate();
      final place = Place(
        id: id,
        preferredName: _name.text,
        type: _type,
        latitude: _latitude.text.trim().isEmpty
            ? null
            : double.parse(_latitude.text),
        longitude: _longitude.text.trim().isEmpty
            ? null
            : double.parse(_longitude.text),
        description: _description.text,
        notes: _notes.text,
        createdAt: existing?.createdAt ?? now,
        modifiedAt: now,
        deletedAt: existing?.deletedAt,
      );
      final controller = ref.read(placesControllerProvider);
      if (existing == null) {
        await controller.create(place);
      } else {
        await controller.update(place);
        ref.invalidate(placeProvider(id));
      }
      if (mounted) context.go('/places/${id.value}');
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('No s’ha pogut desar: $error')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialPlace != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar lloc' : AppStrings.newPlace),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(32),
          children: [
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Nom preferit *'),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'El nom és obligatori.'
                  : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<PlaceType>(
              initialValue: _type,
              decoration: const InputDecoration(labelText: 'Tipus'),
              items: PlaceType.values
                  .map(
                    (type) => DropdownMenuItem(
                      value: type,
                      child: Text(placeTypeLabel(type)),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _type = value!),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _latitude,
                    decoration: const InputDecoration(labelText: 'Latitud'),
                    validator: _optionalDouble,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _longitude,
                    decoration: const InputDecoration(labelText: 'Longitud'),
                    validator: _optionalDouble,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _description,
              decoration: const InputDecoration(labelText: 'Descripció'),
              minLines: 3,
              maxLines: 6,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notes,
              decoration: const InputDecoration(labelText: 'Notes'),
              minLines: 2,
              maxLines: 5,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _saving ? null : () => context.pop(),
                  child: const Text(AppStrings.cancel),
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  onPressed: _saving ? null : _save,
                  icon: const Icon(Icons.save),
                  label: const Text(AppStrings.save),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String? _optionalDouble(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    return double.tryParse(value) == null ? 'Valor numèric no vàlid.' : null;
  }
}
