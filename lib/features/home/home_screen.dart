import 'dart:io';

import 'package:family_history/app/app_strings.dart';
import 'package:family_history/app/providers.dart';
import 'package:family_history/services/project/project_workspace_controller.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;

const _familyHistoryType = XTypeGroup(
  label: 'Projecte FamilyHistory',
  extensions: ['famhistory'],
);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final people = ref.watch(peopleProvider).value;
    final places = ref.watch(placesProvider).value;
    final projects = ref.watch(projectWorkspaceControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.appName)),
      body: ListView(
        padding: const EdgeInsets.all(32),
        children: [
          Text(
            'Història familiar',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Preserva persones, llocs i records en una base local.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 32),
          _ProjectCard(projects: projects),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _SummaryCard(
                icon: Icons.people,
                label: AppStrings.people,
                value: people?.length.toString() ?? '—',
              ),
              _SummaryCard(
                icon: Icons.place,
                label: AppStrings.places,
                value: places?.length.toString() ?? '—',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.projects});

  final ProjectWorkspaceController projects;

  @override
  Widget build(BuildContext context) {
    final manifest = projects.manifest;
    final enabled = projects.isAvailable && !projects.isBusy;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.folder_copy_outlined, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        manifest?.name ?? 'Projecte local',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        projects.archiveFile == null
                            ? 'Encara no s’ha desat com a .famhistory'
                            : p.basename(projects.archiveFile!.path),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (projects.isBusy) ...[
              const SizedBox(height: 16),
              const LinearProgressIndicator(),
            ],
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                FilledButton.icon(
                  onPressed: enabled ? () => _newProject(context) : null,
                  icon: const Icon(Icons.create_new_folder_outlined),
                  label: const Text('Nou projecte'),
                ),
                OutlinedButton.icon(
                  onPressed: enabled ? () => _openProject(context) : null,
                  icon: const Icon(Icons.folder_open),
                  label: const Text('Obrir'),
                ),
                OutlinedButton.icon(
                  onPressed: enabled ? () => _save(context) : null,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Desar'),
                ),
                OutlinedButton.icon(
                  onPressed: enabled ? () => _saveAs(context) : null,
                  icon: const Icon(Icons.save_as_outlined),
                  label: const Text('Desar com'),
                ),
                OutlinedButton.icon(
                  onPressed: enabled ? () => _backup(context) : null,
                  icon: const Icon(Icons.backup_outlined),
                  label: const Text('Crear backup'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _newProject(BuildContext context) async {
    final name = await _askProjectName(context);
    if (name == null || !context.mounted) return;
    final location = await getSaveLocation(
      acceptedTypeGroups: const [_familyHistoryType],
      suggestedName: '${_safeFileName(name)}.famhistory',
      confirmButtonText: 'Crear',
    );
    if (location == null || !context.mounted) return;
    await _run(
      context,
      () =>
          projects.createProject(name: name, destination: File(location.path)),
      'Projecte creat.',
    );
  }

  Future<void> _openProject(BuildContext context) async {
    final selected = await openFile(
      acceptedTypeGroups: const [_familyHistoryType],
      confirmButtonText: 'Obrir',
    );
    if (selected == null || !context.mounted) return;
    await _run(
      context,
      () => projects.openProject(File(selected.path)),
      'Projecte obert i verificat.',
    );
  }

  Future<void> _save(BuildContext context) async {
    if (!projects.hasArchive) {
      await _saveAs(context);
      return;
    }
    await _run(context, projects.save, 'Projecte desat.');
  }

  Future<void> _saveAs(BuildContext context) async {
    final location = await getSaveLocation(
      acceptedTypeGroups: const [_familyHistoryType],
      suggestedName: '${_safeFileName(projects.manifest!.name)}.famhistory',
      confirmButtonText: 'Desar',
    );
    if (location == null || !context.mounted) return;
    await _run(
      context,
      () => projects.saveAs(File(location.path)),
      'Projecte desat.',
    );
  }

  Future<void> _backup(BuildContext context) async {
    final now = DateTime.now();
    String two(int value) => value.toString().padLeft(2, '0');
    final date = '${now.year}-${two(now.month)}-${two(now.day)}';
    final location = await getSaveLocation(
      acceptedTypeGroups: const [_familyHistoryType],
      suggestedName:
          '${_safeFileName(projects.manifest!.name)}_backup_$date.famhistory',
      confirmButtonText: 'Crear backup',
    );
    if (location == null || !context.mounted) return;
    await _run(
      context,
      () => projects.createBackup(File(location.path)),
      'Backup creat.',
    );
  }

  Future<void> _run(
    BuildContext context,
    Future<void> Function() action,
    String success,
  ) async {
    try {
      await action();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(success)));
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No s’ha pogut completar l’operació: $error')),
      );
    }
  }

  Future<String?> _askProjectName(BuildContext context) async {
    return showDialog<String>(
      context: context,
      builder: (context) => const ProjectNameDialog(),
    );
  }

  String _safeFileName(String value) {
    final sanitized = value
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9à-ÿ]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
    return sanitized.isEmpty ? 'familia' : sanitized;
  }
}

class ProjectNameDialog extends StatefulWidget {
  const ProjectNameDialog({super.key});

  @override
  State<ProjectNameDialog> createState() => _ProjectNameDialogState();
}

class _ProjectNameDialogState extends State<ProjectNameDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: 'La meva família');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final value = _controller.text.trim();
    if (value.isNotEmpty) Navigator.pop(context, value);
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Nou projecte'),
    content: TextField(
      controller: _controller,
      autofocus: true,
      decoration: const InputDecoration(labelText: 'Nom del projecte'),
      onSubmitted: (_) => _submit(),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel·lar'),
      ),
      FilledButton(onPressed: _submit, child: const Text('Continuar')),
    ],
  );
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        width: 220,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Icon(icon, size: 36),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(label),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
