import 'package:family_history/app/app_strings.dart';
import 'package:family_history/app/navigation.dart';
import 'package:family_history/app/providers.dart';
import 'package:family_history/components/historical_date_field.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/domain/person/person.dart';
import 'package:family_history/domain/person/person_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PersonFormScreen extends ConsumerWidget {
  const PersonFormScreen({this.personId, super.key});

  final PersonId? personId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = personId;
    if (id == null) return const _PersonForm();

    final person = ref.watch(personProvider(id));
    final names = ref.watch(personNamesProvider(id));
    return person.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) =>
          Scaffold(body: Center(child: Text(error.toString()))),
      data: (value) {
        if (value == null) {
          return const Scaffold(
            body: Center(child: Text('Persona no trobada.')),
          );
        }
        return names.when(
          loading: () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (error, stackTrace) =>
              Scaffold(body: Center(child: Text(error.toString()))),
          data: (items) => _PersonForm(
            key: ValueKey(id),
            initialPerson: value,
            initialName:
                items.where((name) => name.isPreferred).firstOrNull ??
                items.firstOrNull,
          ),
        );
      },
    );
  }
}

class _PersonForm extends ConsumerStatefulWidget {
  const _PersonForm({super.key, this.initialPerson, this.initialName});

  final Person? initialPerson;
  final PersonName? initialName;

  @override
  ConsumerState<_PersonForm> createState() => _PersonFormState();
}

class _PersonFormState extends ConsumerState<_PersonForm> {
  final _formKey = GlobalKey<FormState>();
  final _birthDateKey = GlobalKey<HistoricalDateFieldState>();
  final _deathDateKey = GlobalKey<HistoricalDateFieldState>();
  late final TextEditingController _displayName;
  late final TextEditingController _givenNames;
  late final TextEditingController _familyNames;
  late final TextEditingController _biography;
  late final TextEditingController _notes;
  late PersonSex _sex;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final person = widget.initialPerson;
    final name = widget.initialName;
    _displayName = TextEditingController(text: name?.displayName ?? '');
    _givenNames = TextEditingController(text: name?.givenNames ?? '');
    _familyNames = TextEditingController(text: name?.familyNames ?? '');
    _biography = TextEditingController(text: person?.biography ?? '');
    _notes = TextEditingController(text: person?.notes ?? '');
    _sex = person?.sex ?? PersonSex.unspecified;
  }

  @override
  void dispose() {
    _displayName.dispose();
    _givenNames.dispose();
    _familyNames.dispose();
    _biography.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final now = DateTime.now().toUtc();
      final existingPerson = widget.initialPerson;
      final existingName = widget.initialName;
      final personId = existingPerson?.id ?? PersonId.generate();
      final person = Person(
        id: personId,
        sex: _sex,
        birthDate: _birthDateKey.currentState!.buildValue(),
        deathDate: _deathDateKey.currentState!.buildValue(),
        biography: _biography.text,
        notes: _notes.text,
        createdAt: existingPerson?.createdAt ?? now,
        modifiedAt: now,
        deletedAt: existingPerson?.deletedAt,
      );
      final name = PersonName(
        id: existingName?.id ?? PersonNameId.generate(),
        personId: personId,
        givenNames: _givenNames.text,
        familyNames: _familyNames.text,
        displayName: _displayName.text,
        type: existingName?.type ?? PersonNameType.birth,
        isPreferred: true,
        createdAt: existingName?.createdAt ?? now,
        modifiedAt: now,
        deletedAt: existingName?.deletedAt,
      );
      final controller = ref.read(peopleControllerProvider);
      if (existingPerson == null) {
        await controller.createPerson(person, name);
      } else {
        await controller.updatePerson(person, name);
        ref.invalidate(personProvider(personId));
      }
      if (mounted) context.go('/people/${personId.value}');
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
    final isEditing = widget.initialPerson != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar persona' : AppStrings.newPerson),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(32),
          children: [
            TextFormField(
              controller: _displayName,
              decoration: const InputDecoration(labelText: 'Nom visible *'),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'El nom visible és obligatori.'
                  : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _givenNames,
                    decoration: const InputDecoration(labelText: 'Noms'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _familyNames,
                    decoration: const InputDecoration(labelText: 'Cognoms'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<PersonSex>(
              initialValue: _sex,
              decoration: const InputDecoration(labelText: 'Sexe'),
              items: PersonSex.values
                  .map(
                    (sex) => DropdownMenuItem(
                      value: sex,
                      child: Text(_sexLabel(sex)),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _sex = value!),
            ),
            const SizedBox(height: 20),
            HistoricalDateField(
              key: _birthDateKey,
              label: 'Data de naixement',
              initialValue: widget.initialPerson?.birthDate,
            ),
            const SizedBox(height: 20),
            HistoricalDateField(
              key: _deathDateKey,
              label: 'Data de defunció',
              initialValue: widget.initialPerson?.deathDate,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _biography,
              decoration: const InputDecoration(labelText: 'Biografia'),
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
                  onPressed: _saving
                      ? null
                      : () => popOrGo(
                          context,
                          widget.initialPerson == null
                              ? '/people'
                              : '/people/${widget.initialPerson!.id.value}',
                        ),
                  child: const Text(AppStrings.cancel),
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  onPressed: _saving ? null : _save,
                  icon: _saving
                      ? const SizedBox.square(
                          dimension: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save),
                  label: const Text(AppStrings.save),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _sexLabel(PersonSex sex) => switch (sex) {
    PersonSex.male => 'Home',
    PersonSex.female => 'Dona',
    PersonSex.intersex => 'Intersexual',
    PersonSex.unknown => 'Desconegut',
    PersonSex.unspecified => 'No especificat',
  };
}
