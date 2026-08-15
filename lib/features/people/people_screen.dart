import 'package:family_history/app/app_strings.dart';
import 'package:family_history/app/providers.dart';
import 'package:family_history/domain/person/person.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PeopleScreen extends ConsumerWidget {
  const PeopleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final people = ref.watch(peopleProvider);
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.people)),
      body: people.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text(error.toString())),
        data: (items) => items.isEmpty
            ? const Center(child: Text(AppStrings.noData))
            : ListView.separated(
                padding: const EdgeInsets.all(24),
                itemCount: items.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) =>
                    _PersonTile(person: items[index]),
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/people/new'),
        icon: const Icon(Icons.person_add),
        label: const Text(AppStrings.newPerson),
      ),
    );
  }
}

class _PersonTile extends ConsumerWidget {
  const _PersonTile({required this.person});

  final Person person;

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
      leading: const CircleAvatar(child: Icon(Icons.person)),
      title: Text(displayName),
      subtitle: Text(_sexLabel(person.sex)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => context.go('/people/${person.id.value}'),
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
