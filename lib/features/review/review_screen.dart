import 'package:family_history/app/providers.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/domain/claim/claim.dart';
import 'package:family_history/domain/duplicate/duplicate_candidate.dart';
import 'package:family_history/domain/person/person_name.dart';
import 'package:family_history/features/sources/source_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ReviewScreen extends ConsumerStatefulWidget {
  const ReviewScreen({super.key});

  @override
  ConsumerState<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends ConsumerState<ReviewScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  bool _scanning = false;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  Future<void> _scan() async {
    setState(() => _scanning = true);
    try {
      final count = await ref.read(reviewControllerProvider).scanDuplicates();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$count coincidències detectades.')),
        );
      }
    } finally {
      if (mounted) setState(() => _scanning = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Revisió'),
      bottom: TabBar(
        controller: _tabs,
        tabs: const [
          Tab(text: 'Contradiccions', icon: Icon(Icons.warning_amber_outlined)),
          Tab(text: 'Possibles duplicats', icon: Icon(Icons.people_outline)),
        ],
      ),
      actions: [
        IconButton(
          tooltip: 'Torna a detectar duplicats',
          onPressed: _scanning ? null : _scan,
          icon: _scanning
              ? const SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.manage_search),
        ),
      ],
    ),
    body: TabBarView(
      controller: _tabs,
      children: const [_ConflictsTab(), _DuplicatesTab()],
    ),
  );
}

class _ConflictsTab extends ConsumerWidget {
  const _ConflictsTab();
  @override
  Widget build(BuildContext context, WidgetRef ref) => ref
      .watch(claimConflictsProvider)
      .when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('$error')),
        data: (conflicts) => conflicts.isEmpty
            ? const Center(child: Text('No hi ha contradiccions detectades.'))
            : ListView.builder(
                padding: const EdgeInsets.all(24),
                itemCount: conflicts.length,
                itemBuilder: (context, index) {
                  final conflict = conflicts[index];
                  return Card(
                    child: ExpansionTile(
                      leading: const Icon(
                        Icons.warning_amber,
                        color: Colors.orange,
                      ),
                      title: Text(claimPropertyLabel(conflict.property)),
                      subtitle: Text(
                        '${conflict.claims.length} valors incompatibles',
                      ),
                      children: conflict.claims
                          .map(
                            (claim) => ListTile(
                              title: Text(claimValueLabel(claim.value)),
                              subtitle: Text(
                                'Estat: ${claim.status.name}'
                                '${claim.sourceLocator == null ? '' : ' · ${claim.sourceLocator}'}',
                              ),
                              trailing: PopupMenuButton<ClaimStatus>(
                                tooltip: 'Canvia l’estat',
                                onSelected: (status) =>
                                    status == ClaimStatus.accepted
                                    ? ref
                                          .read(claimServiceProvider)
                                          .acceptAndApply(claim)
                                    : ref
                                          .read(claimServiceProvider)
                                          .update(
                                            claim.copyWith(
                                              status: status,
                                              modifiedAt: DateTime.now()
                                                  .toUtc(),
                                            ),
                                          ),
                                itemBuilder: (context) => const [
                                  PopupMenuItem(
                                    value: ClaimStatus.accepted,
                                    child: Text('Accepta i aplica'),
                                  ),
                                  PopupMenuItem(
                                    value: ClaimStatus.disputed,
                                    child: Text('Marca disputada'),
                                  ),
                                  PopupMenuItem(
                                    value: ClaimStatus.rejected,
                                    child: Text('Rebutja'),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  );
                },
              ),
      );
}

class _DuplicatesTab extends ConsumerWidget {
  const _DuplicatesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final candidates = ref.watch(duplicateCandidatesProvider);
    final names =
        ref.watch(allPersonNamesProvider).value ?? const <PersonName>[];
    return candidates.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('$error')),
      data: (items) {
        final pending = items
            .where(
              (item) =>
                  item.status == DuplicateCandidateStatus.pending ||
                  item.status == DuplicateCandidateStatus.confirmedSame,
            )
            .toList();
        if (pending.isEmpty) {
          return const Center(
            child: Text(
              'Cap duplicat pendent. Executa la detecció amb la lupa.',
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: pending.length,
          itemBuilder: (context, index) {
            final item = pending[index];
            final a = _name(item.personAId, names);
            final b = _name(item.personBId, names);
            return Card(
              child: ListTile(
                leading: CircleAvatar(child: Text('${item.score}')),
                title: Text('$a ↔ $b'),
                subtitle: Text(item.reasonCodes.join(' · ')),
                trailing: Wrap(
                  spacing: 8,
                  children: [
                    TextButton(
                      onPressed: () => ref
                          .read(reviewControllerProvider)
                          .setStatus(
                            item,
                            DuplicateCandidateStatus.differentPerson,
                          ),
                      child: const Text('Diferents'),
                    ),
                    TextButton(
                      onPressed: () => ref
                          .read(reviewControllerProvider)
                          .setStatus(item, DuplicateCandidateStatus.dismissed),
                      child: const Text('Descarta'),
                    ),
                    FilledButton(
                      onPressed: () async {
                        if (item.status == DuplicateCandidateStatus.pending) {
                          await ref
                              .read(reviewControllerProvider)
                              .setStatus(
                                item,
                                DuplicateCandidateStatus.confirmedSame,
                              );
                        }
                        if (context.mounted) {
                          context.go(
                            '/review/merge/${item.personAId.value}/${item.personBId.value}',
                          );
                        }
                      },
                      child: const Text('Compara i fusiona'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _name(PersonId id, List<PersonName> names) =>
      names
          .where((name) => name.personId == id)
          .map((name) => name.displayName)
          .firstOrNull ??
      id.value;
}
