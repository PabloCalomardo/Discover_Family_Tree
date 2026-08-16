import 'package:family_history/app/app_strings.dart';
import 'package:family_history/app/providers.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/domain/person/person.dart';
import 'package:family_history/services/person/person_editor_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PeopleScreen extends ConsumerStatefulWidget {
  const PeopleScreen({super.key});

  @override
  ConsumerState<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends ConsumerState<PeopleScreen> {
  final _selected = <PersonId>{};
  bool _deleting = false;

  void _toggle(PersonId id) {
    setState(() {
      if (!_selected.add(id)) _selected.remove(id);
    });
  }

  void _clearSelection() => setState(_selected.clear);

  Future<void> _deleteSelected() async {
    final count = _selected.length;
    if (count == 0 || _deleting) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar $count ${count == 1 ? 'persona' : 'persones'}?'),
        content: const Text(
          'També s’eliminaran els seus noms, filiacions, germanors, parelles, '
          'residències i participacions en esdeveniments. Els esdeveniments '
          'compartits es conservaran. Les claims i l’auditoria no s’eliminaran.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel·la'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Elimina en cascada'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _deleting = true);
    try {
      final result = await ref
          .read(peopleControllerProvider)
          .deletePeopleCascade(Set.unmodifiable(_selected));
      if (!mounted) return;
      _clearSelection();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(_deletionSummary(result))));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No s’han pogut eliminar les persones: $error')),
      );
    } finally {
      if (mounted) setState(() => _deleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final people = ref.watch(peopleProvider);
    final selectionMode = _selected.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        leading: selectionMode
            ? IconButton(
                tooltip: 'Cancel·la la selecció',
                onPressed: _deleting ? null : _clearSelection,
                icon: const Icon(Icons.close),
              )
            : null,
        title: Text(
          selectionMode
              ? '${_selected.length} seleccionades'
              : AppStrings.people,
        ),
        actions: [
          if (selectionMode)
            IconButton(
              tooltip: 'Eliminar persones seleccionades',
              onPressed: _deleting ? null : _deleteSelected,
              icon: const Icon(Icons.delete_outline),
            ),
        ],
      ),
      body: people.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text(error.toString())),
        data: (items) {
          final activeIds = items.map((person) => person.id).toSet();
          if (_selected.any((id) => !activeIds.contains(id))) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              setState(
                () => _selected.removeWhere((id) => !activeIds.contains(id)),
              );
            });
          }
          if (items.isEmpty) {
            return const Center(child: Text(AppStrings.noData));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(24),
            itemCount: items.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final person = items[index];
              return _PersonTile(
                person: person,
                selected: _selected.contains(person.id),
                selectionMode: selectionMode,
                onToggle: () => _toggle(person.id),
              );
            },
          );
        },
      ),
      floatingActionButton: selectionMode
          ? null
          : FloatingActionButton.extended(
              onPressed: () => context.go('/people/new'),
              icon: const Icon(Icons.person_add),
              label: const Text(AppStrings.newPerson),
            ),
    );
  }
}

class _PersonTile extends ConsumerWidget {
  const _PersonTile({
    required this.person,
    required this.selected,
    required this.selectionMode,
    required this.onToggle,
  });

  final Person person;
  final bool selected;
  final bool selectionMode;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final names = ref.watch(personNamesProvider(person.id));
    final displayName =
        names.value
            ?.where((name) => name.isPreferred)
            .firstOrNull
            ?.displayName ??
        names.value?.firstOrNull?.displayName ??
        'Persona sense nom';
    return ListTile(
      selected: selected,
      leading: selectionMode
          ? Checkbox(value: selected, onChanged: (_) => onToggle())
          : const CircleAvatar(child: Icon(Icons.person)),
      title: Text(displayName),
      subtitle: Text(_sexLabel(person.sex)),
      trailing: selectionMode ? null : const Icon(Icons.chevron_right),
      onLongPress: onToggle,
      onTap: selectionMode
          ? onToggle
          : () => context.go('/people/${person.id.value}'),
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

String _deletionSummary(PersonCascadeDeletionResult result) =>
    '${result.people} persones i ${result.familyRelationships} relacions '
    'familiars eliminades.';
