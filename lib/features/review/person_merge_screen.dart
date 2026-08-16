import 'package:family_history/app/providers.dart';
import 'package:family_history/components/historical_date_field.dart';
import 'package:family_history/core/dates/historical_date.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/domain/person/person.dart';
import 'package:family_history/domain/person/person_name.dart';
import 'package:family_history/services/merge/person_merge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum _FieldChoice { a, b, custom }

class PersonMergeScreen extends ConsumerStatefulWidget {
  const PersonMergeScreen({
    required this.personAId,
    required this.personBId,
    super.key,
  });
  final PersonId personAId;
  final PersonId personBId;

  @override
  ConsumerState<PersonMergeScreen> createState() => _PersonMergeScreenState();
}

class _PersonMergeScreenState extends ConsumerState<PersonMergeScreen> {
  bool _aSurvives = true;
  bool _saving = false;
  final _choices = <String, _FieldChoice>{
    'sex': _FieldChoice.a,
    'birth': _FieldChoice.a,
    'death': _FieldChoice.a,
    'biography': _FieldChoice.a,
    'notes': _FieldChoice.a,
  };
  final _convertedRelations = <String>{};
  PersonNameId? _preferredNameId;
  final _customBirth = TextEditingController();
  final _customDeath = TextEditingController();
  final _customBiography = TextEditingController();
  final _customNotes = TextEditingController();
  PersonSex _customSex = PersonSex.unknown;

  @override
  void dispose() {
    _customBirth.dispose();
    _customDeath.dispose();
    _customBiography.dispose();
    _customNotes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final people = ref.watch(peopleProvider);
    final names = ref.watch(allPersonNamesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Fusió manual de persones')),
      body: people.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('$error')),
        data: (allPeople) => names.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('$error')),
          data: (allNames) {
            final a = allPeople
                .where((person) => person.id == widget.personAId)
                .firstOrNull;
            final b = allPeople
                .where((person) => person.id == widget.personBId)
                .firstOrNull;
            if (a == null || b == null) {
              return const Center(child: Text('Persona no trobada.'));
            }
            final pairNames = allNames
                .where((name) => name.personId == a.id || name.personId == b.id)
                .toList();
            _preferredNameId ??=
                pairNames
                    .where((name) => name.isPreferred && name.personId == a.id)
                    .firstOrNull
                    ?.id ??
                pairNames.firstOrNull?.id;
            return _content(a, b, pairNames);
          },
        ),
      ),
    );
  }

  Widget _content(Person a, Person b, List<PersonName> names) {
    final survivor = _aSurvives ? a : b;
    final absorbed = _aSurvives ? b : a;
    return ref
        .watch(mergePreviewProvider((survivor.id, absorbed.id)))
        .when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('$error')),
          data: (preview) {
            final allResolved = preview.blockingRelations.every(
              (relation) => _convertedRelations.contains(relation.id),
            );
            return ListView(
              padding: const EdgeInsets.all(32),
              children: [
                Text(
                  '1. Persona supervivent',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SegmentedButton<bool>(
                  segments: [
                    ButtonSegment(value: true, label: Text(_name(a.id, names))),
                    ButtonSegment(
                      value: false,
                      label: Text(_name(b.id, names)),
                    ),
                  ],
                  selected: {_aSurvives},
                  onSelectionChanged: (selection) => setState(() {
                    _aSurvives = selection.first;
                    _convertedRelations.clear();
                  }),
                ),
                const SizedBox(height: 28),
                Text(
                  '2. Resolució camp per camp',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                _fieldChoice('Sexe', 'sex', a.sex.name, b.sex.name),
                if (_choices['sex'] == _FieldChoice.custom)
                  DropdownButtonFormField<PersonSex>(
                    initialValue: _customSex,
                    decoration: const InputDecoration(
                      labelText: 'Sexe personalitzat',
                    ),
                    items: PersonSex.values
                        .map(
                          (sex) => DropdownMenuItem(
                            value: sex,
                            child: Text(sex.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => setState(() => _customSex = value!),
                  ),
                _fieldChoice(
                  'Naixement',
                  'birth',
                  historicalDateLabel(a.birthDate),
                  historicalDateLabel(b.birthDate),
                ),
                if (_choices['birth'] == _FieldChoice.custom)
                  TextField(
                    controller: _customBirth,
                    decoration: const InputDecoration(
                      labelText:
                          'Any de naixement personalitzat (buit = desconegut)',
                    ),
                  ),
                _fieldChoice(
                  'Defunció',
                  'death',
                  historicalDateLabel(a.deathDate),
                  historicalDateLabel(b.deathDate),
                ),
                if (_choices['death'] == _FieldChoice.custom)
                  TextField(
                    controller: _customDeath,
                    decoration: const InputDecoration(
                      labelText:
                          'Any de defunció personalitzat (buit = desconegut)',
                    ),
                  ),
                _fieldChoice(
                  'Biografia',
                  'biography',
                  a.biography ?? '—',
                  b.biography ?? '—',
                ),
                if (_choices['biography'] == _FieldChoice.custom)
                  TextField(
                    controller: _customBiography,
                    decoration: const InputDecoration(
                      labelText: 'Biografia combinada',
                    ),
                    minLines: 3,
                    maxLines: 6,
                  ),
                _fieldChoice('Notes', 'notes', a.notes ?? '—', b.notes ?? '—'),
                if (_choices['notes'] == _FieldChoice.custom)
                  TextField(
                    controller: _customNotes,
                    decoration: const InputDecoration(
                      labelText: 'Notes combinades',
                    ),
                    minLines: 2,
                    maxLines: 5,
                  ),
                const SizedBox(height: 16),
                DropdownButtonFormField<PersonNameId>(
                  initialValue: _preferredNameId,
                  decoration: const InputDecoration(
                    labelText: 'Nom preferit final',
                  ),
                  items: names
                      .map(
                        (name) => DropdownMenuItem(
                          value: name.id,
                          child: Text(name.displayName),
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setState(() => _preferredNameId = value),
                ),
                const SizedBox(height: 28),
                Text(
                  '3. Relacions',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  '${preview.reassignedNames} noms, ${preview.reassignedResidences} residències '
                  'i ${preview.reassignedEvents} participacions es reassociaran.',
                ),
                if (preview.blockingRelations.isEmpty)
                  const ListTile(
                    leading: Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                    ),
                    title: Text('Cap relació bloquejant.'),
                  )
                else
                  ...preview.blockingRelations.map(
                    (relation) => CheckboxListTile(
                      value: _convertedRelations.contains(relation.id),
                      title: Text(relation.reason),
                      subtitle: const Text(
                        'Converteix-la en claim abans de retirar-la.',
                      ),
                      onChanged: (value) => setState(() {
                        if (value ?? false) {
                          _convertedRelations.add(relation.id);
                        } else {
                          _convertedRelations.remove(relation.id);
                        }
                      }),
                    ),
                  ),
                const SizedBox(height: 28),
                Card(
                  color: Theme.of(context).colorScheme.errorContainer,
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'La persona absorbida quedarà eliminada lògicament. '
                      'Els valors descartats es conservaran com a claims i tota l’operació quedarà auditada.',
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.icon(
                    onPressed:
                        _saving || !allResolved || _preferredNameId == null
                        ? null
                        : () => _merge(a, b),
                    icon: const Icon(Icons.merge),
                    label: const Text('Confirma la fusió'),
                  ),
                ),
              ],
            );
          },
        );
  }

  Widget _fieldChoice(String label, String key, String a, String b) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: InputDecorator(
      decoration: InputDecoration(labelText: label),
      child: SegmentedButton<_FieldChoice>(
        segments: [
          ButtonSegment(
            value: _FieldChoice.a,
            label: Text(a, overflow: TextOverflow.ellipsis),
          ),
          ButtonSegment(
            value: _FieldChoice.b,
            label: Text(b, overflow: TextOverflow.ellipsis),
          ),
          const ButtonSegment(
            value: _FieldChoice.custom,
            label: Text('Personalitzat'),
          ),
        ],
        selected: {_choices[key]!},
        onSelectionChanged: (selection) =>
            setState(() => _choices[key] = selection.first),
      ),
    ),
  );

  Future<void> _merge(Person a, Person b) async {
    setState(() => _saving = true);
    try {
      final survivor = _aSurvives ? a : b;
      final absorbed = _aSurvives ? b : a;
      T pick<T>(String key, T aValue, T bValue, T customValue) =>
          switch (_choices[key]) {
            _FieldChoice.a => aValue,
            _FieldChoice.b => bValue,
            _FieldChoice.custom => customValue,
            null => aValue,
          };
      HistoricalDate? customDate(TextEditingController controller) {
        final text = controller.text.trim();
        return text.isEmpty ? null : HistoricalDate.year(int.parse(text));
      }

      final merged = Person(
        id: survivor.id,
        sex: pick('sex', a.sex, b.sex, _customSex),
        birthDate: pick(
          'birth',
          a.birthDate,
          b.birthDate,
          customDate(_customBirth),
        ),
        deathDate: pick(
          'death',
          a.deathDate,
          b.deathDate,
          customDate(_customDeath),
        ),
        biography: pick(
          'biography',
          a.biography,
          b.biography,
          _customBiography.text,
        ),
        notes: pick('notes', a.notes, b.notes, _customNotes.text),
        createdAt: survivor.createdAt,
        modifiedAt: DateTime.now().toUtc(),
      );
      await ref
          .read(reviewControllerProvider)
          .merge(
            PersonMergeCommand(
              mergedPerson: merged,
              absorbedId: absorbed.id,
              expectedSurvivorModifiedAt: survivor.modifiedAt,
              expectedAbsorbedModifiedAt: absorbed.modifiedAt,
              preferredNameId: _preferredNameId!,
              relationsToConvertToClaims: _convertedRelations,
            ),
          );
      if (mounted) context.go('/people/${survivor.id.value}');
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No s’ha pogut completar la fusió: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String _name(PersonId id, List<PersonName> names) =>
      names
          .where((name) => name.personId == id)
          .map((name) => name.displayName)
          .firstOrNull ??
      id.value;
}
