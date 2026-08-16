import 'package:family_history/app/app_strings.dart';
import 'package:family_history/app/providers.dart';
import 'package:family_history/components/historical_date_field.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/domain/event/event.dart';
import 'package:family_history/domain/claim/claim.dart';
import 'package:family_history/domain/person/person.dart';
import 'package:family_history/domain/place/residence.dart';
import 'package:family_history/domain/relationship/parent_child_relationship.dart';
import 'package:family_history/domain/relationship/partnership.dart';
import 'package:family_history/domain/relationship/sibling_relationship.dart';
import 'package:family_history/features/people/person_action_dialogs.dart';
import 'package:family_history/features/sources/source_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PersonDetailScreen extends ConsumerWidget {
  const PersonDetailScreen({required this.personId, super.key});

  final PersonId personId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final person = ref.watch(personProvider(personId));
    final names = ref.watch(personNamesProvider(personId));
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
        final displayName =
            names.value
                ?.where((name) => name.isPreferred)
                .firstOrNull
                ?.displayName ??
            names.value?.firstOrNull?.displayName ??
            'Persona sense nom';
        return Scaffold(
          appBar: AppBar(
            title: Text(displayName),
            actions: [
              TextButton.icon(
                onPressed: () => context.go('/people/${personId.value}/edit'),
                icon: const Icon(Icons.edit),
                label: const Text(AppStrings.edit),
              ),
              TextButton.icon(
                onPressed: () => _deletePerson(context, ref),
                icon: const Icon(Icons.delete_outline),
                label: const Text(AppStrings.delete),
              ),
              const SizedBox(width: 12),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(32),
            children: [
              _PersonOverview(person: value),
              const SizedBox(height: 32),
              _EvidenceSection(personId: personId),
              const SizedBox(height: 32),
              _RelationshipsSection(personId: personId),
              const SizedBox(height: 32),
              _ResidencesSection(personId: personId),
              const SizedBox(height: 32),
              _EventsSection(personId: personId),
            ],
          ),
        );
      },
    );
  }

  Future<void> _deletePerson(BuildContext context, WidgetRef ref) async {
    final controller = ref.read(peopleControllerProvider);
    final blockers = await controller.deletionBlockers(personId);
    if (!context.mounted) return;
    if (!blockers.canDelete) {
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('No es pot eliminar'),
          content: Text(
            'Revisa abans ${blockers.familyRelationships} relacions familiars, '
            '${blockers.residences} residències i '
            '${blockers.eventParticipations} participacions en esdeveniments.',
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Entesos'),
            ),
          ],
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar persona?'),
        content: const Text(
          'La persona quedarà arxivada mitjançant soft delete.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(AppStrings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(AppStrings.delete),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await controller.deletePerson(personId);
      if (context.mounted) context.go('/people');
    }
  }
}

class _EvidenceSection extends ConsumerWidget {
  const _EvidenceSection({required this.personId});
  final PersonId personId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final claims = ref.watch(
      subjectClaimsProvider((ClaimSubjectType.person, personId.value)),
    );
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Evidència',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () => context.go('/sources'),
                  icon: const Icon(Icons.source_outlined),
                  label: const Text('Fonts'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            claims.when(
              loading: () => const LinearProgressIndicator(),
              error: (error, _) => Text('$error'),
              data: (items) => items.isEmpty
                  ? const Text('Cap afirmació documentada.')
                  : Column(
                      children: items
                          .map(
                            (claim) => ListTile(
                              dense: true,
                              leading: Icon(
                                claim.status == ClaimStatus.disputed
                                    ? Icons.warning_amber
                                    : Icons.fact_check_outlined,
                              ),
                              title: Text(claimPropertyLabel(claim.property)),
                              subtitle: Text(claimValueLabel(claim.value)),
                            ),
                          )
                          .toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PersonOverview extends StatelessWidget {
  const _PersonOverview({required this.person});

  final Person person;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 32,
              runSpacing: 12,
              children: [
                _Fact(
                  label: 'Naixement',
                  value: historicalDateLabel(person.birthDate),
                ),
                _Fact(
                  label: 'Defunció',
                  value: historicalDateLabel(person.deathDate),
                ),
                _Fact(label: 'Sexe', value: _sexLabel(person.sex)),
              ],
            ),
            if (person.biography case final biography?) ...[
              const SizedBox(height: 20),
              Text(biography),
            ],
            if (person.notes case final notes?) ...[
              const SizedBox(height: 12),
              Text('Notes: $notes'),
            ],
          ],
        ),
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: Theme.of(context).textTheme.labelMedium),
      Text(value, style: Theme.of(context).textTheme.titleMedium),
    ],
  );
}

class _RelationshipsSection extends ConsumerWidget {
  const _RelationshipsSection({required this.personId});
  final PersonId personId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parentChild =
        ref.watch(parentChildRelationshipsProvider).value ??
        const <ParentChildRelationship>[];
    final partnerships =
        ref.watch(partnershipsProvider).value ?? const <Partnership>[];
    final siblings =
        ref.watch(siblingRelationshipsProvider).value ??
        const <SiblingRelationship>[];
    final relatedParentChild = parentChild
        .where((item) => item.parentId == personId || item.childId == personId)
        .toList();
    final relatedPartnerships = partnerships
        .where(
          (item) => item.personAId == personId || item.personBId == personId,
        )
        .toList();
    final relatedSiblings = siblings
        .where((item) => item.involves(personId))
        .toList();
    return _Section(
      title: 'Relacions familiars',
      actionLabel: 'Afegir relació',
      onAction: () => showDialog<void>(
        context: context,
        builder: (context) => AddRelationshipDialog(personId: personId),
      ),
      children: [
        if (relatedParentChild.isEmpty &&
            relatedSiblings.isEmpty &&
            relatedPartnerships.isEmpty)
          const Text('No hi ha relacions registrades.'),
        ...relatedParentChild.map((relationship) {
          final currentIsParent = relationship.parentId == personId;
          final otherId = currentIsParent
              ? relationship.childId
              : relationship.parentId;
          final role = currentIsParent ? 'Fill/a' : 'Pare/mare';
          final nature = relationship.nature == ParentChildNature.biological
              ? 'biològica'
              : 'adoptiva';
          return ListTile(
            leading: const Icon(Icons.account_tree_outlined),
            title: _PersonNameText(personId: otherId),
            subtitle: Text('$role · $nature'),
            trailing: IconButton(
              tooltip: 'Eliminar relació',
              onPressed: () => ref
                  .read(peopleControllerProvider)
                  .removeParentChild(relationship.id),
              icon: const Icon(Icons.delete_outline),
            ),
          );
        }),
        ...relatedSiblings.map((relationship) {
          return ListTile(
            leading: const Icon(Icons.people_outline),
            title: _PersonNameText(personId: relationship.other(personId)),
            subtitle: Text(_siblingRelationshipLabel(relationship.kind)),
            trailing: IconButton(
              tooltip: 'Eliminar germanor',
              onPressed: () => ref
                  .read(peopleControllerProvider)
                  .removeSibling(relationship.id),
              icon: const Icon(Icons.delete_outline),
            ),
          );
        }),
        ...relatedPartnerships.map((partnership) {
          final otherId = partnership.personAId == personId
              ? partnership.personBId
              : partnership.personAId;
          return ListTile(
            leading: const Icon(Icons.favorite_outline),
            title: _PersonNameText(personId: otherId),
            subtitle: Text(_partnershipLabel(partnership.type)),
            trailing: IconButton(
              tooltip: 'Eliminar relació',
              onPressed: () => ref
                  .read(peopleControllerProvider)
                  .removePartnership(partnership.id),
              icon: const Icon(Icons.delete_outline),
            ),
          );
        }),
      ],
    );
  }
}

String _siblingRelationshipLabel(SiblingKind kind) => switch (kind) {
  SiblingKind.unspecified => 'Germà/germana · tipus no especificat',
  SiblingKind.full => 'Germà/germana de pare i mare',
  SiblingKind.half => 'Germanastre/germanastra · un progenitor comú',
  SiblingKind.adoptive => 'Germà/germana adoptiu/va',
  SiblingKind.step => 'Germanor política',
};

class _ResidencesSection extends ConsumerWidget {
  const _ResidencesSection({required this.personId});
  final PersonId personId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final residences = ref.watch(personResidencesProvider(personId));
    return _Section(
      title: 'Residències',
      actionLabel: 'Afegir residència',
      onAction: () => showDialog<void>(
        context: context,
        builder: (context) => AddResidenceDialog(personId: personId),
      ),
      children: [
        residences.when(
          loading: () => const LinearProgressIndicator(),
          error: (error, stackTrace) => Text(error.toString()),
          data: (items) => items.isEmpty
              ? const Text('No hi ha residències registrades.')
              : Column(
                  children: items
                      .map((item) => _ResidenceTile(residence: item))
                      .toList(),
                ),
        ),
      ],
    );
  }
}

class _ResidenceTile extends ConsumerWidget {
  const _ResidenceTile({required this.residence});
  final Residence residence;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final place = ref.watch(placeProvider(residence.placeId)).value;
    return ListTile(
      leading: const Icon(Icons.home_outlined),
      title: Text(place?.preferredName ?? 'Lloc'),
      subtitle: Text(
        '${historicalDateLabel(residence.startDate)} – '
        '${historicalDateLabel(residence.endDate)}',
      ),
      trailing: IconButton(
        tooltip: 'Eliminar residència',
        onPressed: () =>
            ref.read(peopleControllerProvider).removeResidence(residence.id),
        icon: const Icon(Icons.delete_outline),
      ),
      onTap: () => context.go('/places/${residence.placeId.value}'),
    );
  }
}

class _EventsSection extends ConsumerWidget {
  const _EventsSection({required this.personId});
  final PersonId personId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(personEventsProvider(personId));
    return _Section(
      title: 'Esdeveniments',
      actionLabel: 'Afegir esdeveniment',
      onAction: () => showDialog<void>(
        context: context,
        builder: (context) => AddEventDialog(personId: personId),
      ),
      children: [
        events.when(
          loading: () => const LinearProgressIndicator(),
          error: (error, stackTrace) => Text(error.toString()),
          data: (items) => items.isEmpty
              ? const Text('No hi ha esdeveniments registrats.')
              : Column(
                  children: items
                      .map((event) => _EventTile(event: event))
                      .toList(),
                ),
        ),
      ],
    );
  }
}

class _EventTile extends ConsumerWidget {
  const _EventTile({required this.event});
  final FamilyEvent event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.event_outlined),
      title: Text(event.title ?? eventTypeLabel(event.type)),
      subtitle: Text(historicalDateLabel(event.date)),
      trailing: IconButton(
        tooltip: 'Eliminar esdeveniment',
        onPressed: () =>
            ref.read(peopleControllerProvider).removeEvent(event.id),
        icon: const Icon(Icons.delete_outline),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.actionLabel,
    required this.onAction,
    required this.children,
  });
  final String title;
  final String actionLabel;
  final VoidCallback onAction;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              OutlinedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add),
                label: Text(actionLabel),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    ),
  );
}

class _PersonNameText extends ConsumerWidget {
  const _PersonNameText({required this.personId});
  final PersonId personId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final names = ref.watch(personNamesProvider(personId)).value;
    return Text(
      names?.where((name) => name.isPreferred).firstOrNull?.displayName ??
          names?.firstOrNull?.displayName ??
          'Persona',
    );
  }
}

String _sexLabel(PersonSex sex) => switch (sex) {
  PersonSex.male => 'Home',
  PersonSex.female => 'Dona',
  PersonSex.intersex => 'Intersexual',
  PersonSex.unknown => 'Desconegut',
  PersonSex.unspecified => 'No especificat',
};

String _partnershipLabel(PartnershipType type) => switch (type) {
  PartnershipType.marriage => 'Matrimoni',
  PartnershipType.partnership => 'Parella',
  PartnershipType.unknown => 'Desconeguda',
};
