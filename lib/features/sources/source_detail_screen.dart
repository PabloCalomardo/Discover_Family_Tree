import 'dart:io';

import 'package:family_history/app/providers.dart';
import 'package:family_history/components/historical_date_field.dart';
import 'package:family_history/core/dates/historical_date.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/domain/claim/claim.dart';
import 'package:family_history/domain/person/person.dart';
import 'package:family_history/domain/person/person_name.dart';
import 'package:family_history/domain/source/media_asset.dart';
import 'package:family_history/domain/source/source.dart';
import 'package:family_history/features/sources/sources_screen.dart';
import 'package:family_history/features/sources/claim_form_dialog.dart'
    show showClaimFormDialog;
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SourceDetailScreen extends ConsumerWidget {
  const SourceDetailScreen({required this.sourceId, super.key});
  final SourceId sourceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) => ref
      .watch(sourceProvider(sourceId))
      .when(
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (error, _) =>
            Scaffold(body: Center(child: Text(error.toString()))),
        data: (source) => source == null
            ? const Scaffold(body: Center(child: Text('Font no trobada.')))
            : Scaffold(
                appBar: AppBar(
                  title: Text(source.title),
                  actions: [
                    IconButton(
                      tooltip: 'Edita',
                      onPressed: () =>
                          context.go('/sources/${source.id.value}/edit'),
                      icon: const Icon(Icons.edit_outlined),
                    ),
                  ],
                ),
                body: ListView(
                  padding: const EdgeInsets.all(32),
                  children: [
                    _SourceSummary(source: source),
                    const SizedBox(height: 32),
                    _MediaSection(sourceId: source.id),
                    const SizedBox(height: 32),
                    _ClaimsSection(sourceId: source.id),
                  ],
                ),
              ),
      );
}

class _SourceSummary extends StatelessWidget {
  const _SourceSummary({required this.source});
  final Source source;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sourceTypeLabel(source.type),
            style: Theme.of(context).textTheme.labelLarge,
          ),
          if (source.creator != null) Text('Autor: ${source.creator}'),
          if (source.sourceDate != null)
            Text('Data: ${historicalDateLabel(source.sourceDate)}'),
          if (source.repositoryName != null)
            Text('Repositori: ${source.repositoryName}'),
          if (source.referenceCode != null)
            Text('Referència: ${source.referenceCode}'),
          if (source.description != null) ...[
            const SizedBox(height: 12),
            Text(source.description!),
          ],
        ],
      ),
    ),
  );
}

class _MediaSection extends ConsumerWidget {
  const _MediaSection({required this.sourceId});
  final SourceId sourceId;

  Future<void> _attach(BuildContext context, WidgetRef ref) async {
    final selected = await openFile();
    if (selected == null) return;
    if (!context.mounted) return;
    final workspace = ref.read(projectWorkspaceControllerProvider).workspace;
    if (workspace == null) return;
    final extension = selected.name.toLowerCase().split('.').last;
    final type = {'jpg', 'jpeg', 'png', 'gif', 'webp'}.contains(extension)
        ? MediaType.image
        : {'mp3', 'm4a', 'wav', 'flac'}.contains(extension)
        ? MediaType.audio
        : MediaType.document;
    var role = SourceMediaRole.attachment;
    final caption = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(selected.name),
          content: SizedBox(
            width: 440,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<SourceMediaRole>(
                  initialValue: role,
                  decoration: const InputDecoration(labelText: 'Rol'),
                  items: SourceMediaRole.values
                      .map(
                        (item) => DropdownMenuItem(
                          value: item,
                          child: Text(switch (item) {
                            SourceMediaRole.primary => 'Principal',
                            SourceMediaRole.attachment => 'Adjunt',
                            SourceMediaRole.supplement => 'Suplement',
                          }),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => role = value!),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: caption,
                  decoration: const InputDecoration(
                    labelText: 'Peu o descripció',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel·la'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Adjunta'),
            ),
          ],
        ),
      ),
    );
    final captionText = caption.text;
    caption.dispose();
    if (confirmed != true) return;
    try {
      await ref
          .read(sourcesControllerProvider)
          .attachFile(
            sourceId: sourceId,
            input: File(selected.path),
            workspace: workspace,
            type: type,
            role: role,
            caption: captionText,
          );
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$error')));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Text('Fitxers', style: Theme.of(context).textTheme.headlineSmall),
          const Spacer(),
          FilledButton.tonalIcon(
            onPressed: () => _attach(context, ref),
            icon: const Icon(Icons.attach_file),
            label: const Text('Adjunta'),
          ),
        ],
      ),
      ref
          .watch(sourceMediaProvider(sourceId))
          .when(
            loading: () => const LinearProgressIndicator(),
            error: (error, _) => Text('$error'),
            data: (media) => media.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Cap fitxer adjunt.'),
                  )
                : Column(
                    children: media
                        .map(
                          (item) => ListTile(
                            leading: Icon(switch (item.type) {
                              MediaType.image => Icons.image_outlined,
                              MediaType.audio => Icons.audio_file_outlined,
                              _ => Icons.description_outlined,
                            }),
                            title: Text(
                              item.originalFilename ?? item.relativePath,
                            ),
                            subtitle: Text(
                              '${item.fileSize} bytes · ${item.checksumSha256.substring(0, 12)}…',
                            ),
                          ),
                        )
                        .toList(),
                  ),
          ),
    ],
  );
}

class _ClaimsSection extends ConsumerWidget {
  const _ClaimsSection({required this.sourceId});
  final SourceId sourceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Text('Afirmacions', style: Theme.of(context).textTheme.headlineSmall),
          const Spacer(),
          FilledButton.tonalIcon(
            onPressed: () => showClaimFormDialog(context, ref, sourceId),
            icon: const Icon(Icons.add),
            label: const Text('Afegeix'),
          ),
        ],
      ),
      ref
          .watch(sourceClaimsProvider(sourceId))
          .when(
            loading: () => const LinearProgressIndicator(),
            error: (error, _) => Text('$error'),
            data: (claims) => claims.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Cap afirmació.'),
                  )
                : Column(
                    children: claims
                        .map((claim) => _ClaimTile(claim: claim))
                        .toList(),
                  ),
          ),
    ],
  );
}

class _ClaimTile extends ConsumerWidget {
  const _ClaimTile({required this.claim});
  final Claim claim;
  @override
  Widget build(BuildContext context, WidgetRef ref) => ListTile(
    leading: Icon(
      claim.status == ClaimStatus.disputed
          ? Icons.warning_amber
          : Icons.fact_check_outlined,
    ),
    title: Text(claimPropertyLabel(claim.property)),
    subtitle: Text('${claimValueLabel(claim.value)} · ${claim.status.name}'),
    trailing: FilledButton.tonal(
      onPressed: claim.status == ClaimStatus.rejected
          ? null
          : () async {
              try {
                await ref.read(claimServiceProvider).acceptAndApply(claim);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Afirmació acceptada i aplicada.'),
                    ),
                  );
                }
              } catch (error) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('$error')));
                }
              }
            },
      child: const Text('Accepta i aplica'),
    ),
  );
}

Future<void> showLegacyClaimDialog(
  BuildContext context,
  WidgetRef ref,
  SourceId sourceId,
) async {
  final people = await ref.read(peopleProvider.future);
  final names = await ref.read(allPersonNamesProvider.future);
  if (!context.mounted || people.isEmpty) return;
  var person = people.first;
  var property = ClaimProperty.personPreferredName;
  final value = TextEditingController();
  final locator = TextEditingController();
  await showDialog<void>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: const Text('Nova afirmació'),
        content: SizedBox(
          width: 520,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<Person>(
                initialValue: person,
                decoration: const InputDecoration(labelText: 'Persona'),
                items: people
                    .map(
                      (item) => DropdownMenuItem(
                        value: item,
                        child: Text(legacyPersonLabel(item.id, names)),
                      ),
                    )
                    .toList(),
                onChanged: (item) => setState(() => person = item!),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<ClaimProperty>(
                initialValue: property,
                decoration: const InputDecoration(labelText: 'Propietat'),
                items:
                    const [
                          ClaimProperty.personPreferredName,
                          ClaimProperty.personSex,
                          ClaimProperty.personBirthDate,
                          ClaimProperty.personDeathDate,
                          ClaimProperty.personBiography,
                          ClaimProperty.personNotes,
                        ]
                        .map(
                          (item) => DropdownMenuItem(
                            value: item,
                            child: Text(claimPropertyLabel(item)),
                          ),
                        )
                        .toList(),
                onChanged: (item) => setState(() => property = item!),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: value,
                decoration: InputDecoration(
                  labelText:
                      property == ClaimProperty.personBirthDate ||
                          property == ClaimProperty.personDeathDate
                      ? 'Valor (any)'
                      : 'Valor',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: locator,
                decoration: const InputDecoration(
                  labelText: 'Pàgina, foli o minut',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel·la'),
          ),
          FilledButton(
            onPressed: () async {
              final now = DateTime.now().toUtc();
              final claimValue = legacyClaimValue(property, value.text);
              final claim = Claim(
                id: ClaimId.generate(),
                subjectType: ClaimSubjectType.person,
                subjectId: person.id.value,
                property: property,
                value: claimValue,
                sourceId: sourceId,
                sourceLocator: locator.text,
                status: ClaimStatus.unreviewed,
                createdAt: now,
                modifiedAt: now,
              );
              await ref.read(claimServiceProvider).create(claim);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Crea'),
          ),
        ],
      ),
    ),
  );
  value.dispose();
  locator.dispose();
}

ClaimValue legacyClaimValue(ClaimProperty property, String input) =>
    switch (property) {
      ClaimProperty.personSex => EnumClaimValue(input),
      ClaimProperty.personBirthDate || ClaimProperty.personDeathDate =>
        HistoricalDateClaimValue(HistoricalDate.year(int.parse(input))),
      _ => TextClaimValue(input),
    };

String legacyPersonLabel(PersonId id, List<PersonName> names) =>
    names
        .where((name) => name.personId == id)
        .map((name) => name.displayName)
        .firstOrNull ??
    id.value;

String claimPropertyLabel(ClaimProperty property) => switch (property) {
  ClaimProperty.personCreation => 'Creació de persona',
  ClaimProperty.personPreferredName => 'Nom preferit',
  ClaimProperty.personSex => 'Sexe',
  ClaimProperty.personBirthDate => 'Data de naixement',
  ClaimProperty.personDeathDate => 'Data de defunció',
  ClaimProperty.personBiography => 'Biografia',
  ClaimProperty.personNotes => 'Notes',
  ClaimProperty.placeCreation => 'Creació de lloc',
  ClaimProperty.placePreferredName => 'Nom del lloc',
  ClaimProperty.placeType => 'Tipus de lloc',
  ClaimProperty.placeCoordinates => 'Coordenades',
  ClaimProperty.placeDescription => 'Descripció del lloc',
  ClaimProperty.placeNotes => 'Notes del lloc',
  ClaimProperty.parentChildRelationship => 'Relació pare/mare-fill/a',
  ClaimProperty.partnership => 'Parella',
  ClaimProperty.residence => 'Residència',
  ClaimProperty.event => 'Esdeveniment',
};

String claimValueLabel(ClaimValue value) => switch (value) {
  TextClaimValue() => value.value,
  EnumClaimValue() => value.value,
  HistoricalDateClaimValue() => historicalDateLabel(value.value),
  PersonReferenceClaimValue() => value.personId.value,
  RelationshipClaimValue() =>
    '${value.relationshipType}: ${value.personId.value}',
  CoordinatesClaimValue() => '${value.latitude}, ${value.longitude}',
  PersonCreationClaimValue() => 'Crear ${value.preferredName}',
  PlaceCreationClaimValue() => 'Crear ${value.preferredName}',
  ParentChildClaimValue() => '${value.parentId.value} → ${value.childId.value}',
  PartnershipClaimValue() =>
    '${value.personAId.value} ↔ ${value.personBId.value}',
  ResidenceClaimValue() => '${value.personId.value} a ${value.placeId.value}',
  EventClaimValue() =>
    '${value.eventType.name}: ${value.title ?? value.participantId.value}',
};
