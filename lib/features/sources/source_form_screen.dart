import 'package:family_history/app/providers.dart';
import 'package:family_history/components/historical_date_field.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/domain/source/source.dart';
import 'package:family_history/features/sources/sources_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SourceFormScreen extends ConsumerWidget {
  const SourceFormScreen({this.sourceId, super.key});
  final SourceId? sourceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = sourceId;
    if (id == null) return const _SourceForm();
    return ref
        .watch(sourceProvider(id))
        .when(
          loading: () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (error, _) =>
              Scaffold(body: Center(child: Text(error.toString()))),
          data: (source) => source == null
              ? const Scaffold(body: Center(child: Text('Font no trobada.')))
              : _SourceForm(key: ValueKey(id), initial: source),
        );
  }
}

class _SourceForm extends ConsumerStatefulWidget {
  const _SourceForm({this.initial, super.key});
  final Source? initial;

  @override
  ConsumerState<_SourceForm> createState() => _SourceFormState();
}

class _SourceFormState extends ConsumerState<_SourceForm> {
  final _formKey = GlobalKey<FormState>();
  final _dateKey = GlobalKey<HistoricalDateFieldState>();
  late SourceType _type;
  late final Map<String, TextEditingController> _fields;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final source = widget.initial;
    _type = source?.type ?? SourceType.document;
    _fields = {
      'title': TextEditingController(text: source?.title ?? ''),
      'description': TextEditingController(text: source?.description ?? ''),
      'creator': TextEditingController(text: source?.creator ?? ''),
      'repository': TextEditingController(text: source?.repositoryName ?? ''),
      'reference': TextEditingController(text: source?.referenceCode ?? ''),
      'location': TextEditingController(text: source?.originalLocation ?? ''),
      'url': TextEditingController(text: source?.url ?? ''),
      'accessed': TextEditingController(
        text: source?.accessedAt?.toIso8601String().split('T').first ?? '',
      ),
      'notes': TextEditingController(text: source?.notes ?? ''),
    };
  }

  @override
  void dispose() {
    for (final controller in _fields.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final existing = widget.initial;
      final now = DateTime.now().toUtc();
      final source = Source(
        id: existing?.id ?? SourceId.generate(),
        type: _type,
        title: _fields['title']!.text,
        description: _fields['description']!.text,
        sourceDate: _dateKey.currentState?.buildValue(),
        creator: _fields['creator']!.text,
        repositoryName: _fields['repository']!.text,
        referenceCode: _fields['reference']!.text,
        originalLocation: _fields['location']!.text,
        url: _fields['url']!.text,
        accessedAt: _fields['accessed']!.text.trim().isEmpty
            ? null
            : DateTime.parse(_fields['accessed']!.text).toUtc(),
        notes: _fields['notes']!.text,
        createdAt: existing?.createdAt ?? now,
        modifiedAt: now,
        deletedAt: existing?.deletedAt,
      );
      final controller = ref.read(sourcesControllerProvider);
      if (existing == null) {
        await controller.create(source);
      } else {
        await controller.update(source);
        ref.invalidate(sourceProvider(source.id));
      }
      if (mounted) context.go('/sources/${source.id.value}');
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
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(widget.initial == null ? 'Nova font' : 'Editar font'),
    ),
    body: Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(32),
        children: [
          TextFormField(
            controller: _fields['title'],
            decoration: const InputDecoration(labelText: 'Títol *'),
            validator: (value) => value == null || value.trim().isEmpty
                ? 'El títol és obligatori.'
                : null,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<SourceType>(
            initialValue: _type,
            decoration: const InputDecoration(labelText: 'Tipus'),
            items: SourceType.values
                .map(
                  (type) => DropdownMenuItem(
                    value: type,
                    child: Text(sourceTypeLabel(type)),
                  ),
                )
                .toList(),
            onChanged: (value) => setState(() => _type = value!),
          ),
          const SizedBox(height: 16),
          HistoricalDateField(
            key: _dateKey,
            label: 'Data de la font',
            initialValue: widget.initial?.sourceDate,
          ),
          const SizedBox(height: 16),
          _field('creator', 'Autor o creador'),
          _field('repository', 'Arxiu o repositori'),
          _field('reference', 'Codi de referència'),
          _field('location', 'Localització original'),
          _field('url', 'URL'),
          TextFormField(
            controller: _fields['accessed'],
            decoration: const InputDecoration(
              labelText: 'Data de consulta (AAAA-MM-DD)',
            ),
            validator: (value) =>
                value == null ||
                    value.trim().isEmpty ||
                    DateTime.tryParse(value) != null
                ? null
                : 'Data no vàlida.',
          ),
          const SizedBox(height: 16),
          _field('description', 'Descripció', lines: 3),
          _field('notes', 'Notes', lines: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: _saving ? null : () => context.pop(),
                child: const Text('Cancel·la'),
              ),
              const SizedBox(width: 12),
              FilledButton.icon(
                onPressed: _saving ? null : _save,
                icon: const Icon(Icons.save),
                label: const Text('Desa'),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  Widget _field(String key, String label, {int lines = 1}) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: TextFormField(
      controller: _fields[key],
      decoration: InputDecoration(labelText: label),
      minLines: lines,
      maxLines: lines == 1 ? 1 : lines + 2,
    ),
  );
}
