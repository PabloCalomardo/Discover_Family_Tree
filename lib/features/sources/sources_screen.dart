import 'package:family_history/app/providers.dart';
import 'package:family_history/domain/source/source.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SourcesScreen extends ConsumerWidget {
  const SourcesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    appBar: AppBar(
      title: const Text('Fonts'),
      actions: [
        IconButton(
          tooltip: 'Nova font',
          onPressed: () => context.go('/sources/new'),
          icon: const Icon(Icons.add),
        ),
      ],
    ),
    body: ref
        .watch(sourcesProvider)
        .when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text(error.toString())),
          data: (sources) => sources.isEmpty
              ? const Center(child: Text('Encara no hi ha fonts.'))
              : ListView.separated(
                  padding: const EdgeInsets.all(24),
                  itemCount: sources.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final source = sources[index];
                    return ListTile(
                      leading: Icon(sourceTypeIcon(source.type)),
                      title: Text(source.title),
                      subtitle: Text(sourceTypeLabel(source.type)),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.go('/sources/${source.id.value}'),
                    );
                  },
                ),
        ),
    floatingActionButton: FloatingActionButton.extended(
      onPressed: () => context.go('/sources/new'),
      icon: const Icon(Icons.add),
      label: const Text('Nova font'),
    ),
  );
}

String sourceTypeLabel(SourceType type) => switch (type) {
  SourceType.interview => 'Entrevista',
  SourceType.document => 'Document',
  SourceType.photo => 'Fotografia',
  SourceType.letter => 'Carta',
  SourceType.book => 'Llibre',
  SourceType.registry => 'Registre',
  SourceType.website => 'Web',
  SourceType.personalKnowledge => 'Coneixement personal',
  SourceType.other => 'Altra',
};

IconData sourceTypeIcon(SourceType type) => switch (type) {
  SourceType.interview => Icons.mic_outlined,
  SourceType.photo => Icons.photo_outlined,
  SourceType.website => Icons.public,
  SourceType.book => Icons.menu_book_outlined,
  SourceType.letter => Icons.mail_outline,
  _ => Icons.description_outlined,
};
