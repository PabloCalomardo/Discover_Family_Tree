import 'package:family_history/app/providers.dart';
import 'package:family_history/components/historical_date_field.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/domain/event/event.dart';
import 'package:family_history/domain/extraction/extraction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum _ExtractionStage { input, evidence, review }

class TextExtractionScreen extends ConsumerStatefulWidget {
  const TextExtractionScreen({required this.sourceId, super.key});
  final SourceId sourceId;

  @override
  ConsumerState<TextExtractionScreen> createState() =>
      _TextExtractionScreenState();
}

class _TextExtractionScreenState extends ConsumerState<TextExtractionScreen> {
  static const _relationshipColor = Color(0xFFEF6C00);
  static const _placeColor = Color(0xFF2E7D32);
  static const _dateColor = Color(0xFF546E7A);

  static Color _personColor(int index) => HSLColor.fromAHSL(
    1,
    (index * 137.508) % 360,
    0.68,
    0.38 + (index % 3) * 0.08,
  ).toColor();

  final _text = TextEditingController();
  final _narratorName = TextEditingController();
  _ExtractionStage _stage = _ExtractionStage.input;
  ExtractionResult? _result;
  Set<String> _selected = {};
  bool _busy = false;

  @override
  void dispose() {
    _text.dispose();
    _narratorName.dispose();
    super.dispose();
  }

  Future<void> _analyze() async {
    final input = _text.text.trim();
    if (input.isEmpty) return;
    setState(() => _busy = true);
    try {
      final result = await ref
          .read(textExtractionControllerProvider)
          .analyze(input, narratorName: _narratorName.text);
      if (!mounted) return;
      setState(() {
        _result = result;
        _selected = {
          ...result.people
              .where(
                (item) =>
                    !item.uncertain &&
                    !item.requiresName &&
                    !item.resolutionAmbiguous,
              )
              .map((item) => item.ref),
          ...result.places
              .where((item) => !item.resolutionAmbiguous)
              .map((item) => item.ref),
          ...result.relationships
              .where(
                (item) =>
                    !item.uncertain &&
                    item.type != CandidateRelationshipType.sibling &&
                    !_relationshipHasAmbiguousDependency(result, item),
              )
              .map((item) => item.ref),
          ...result.residences
              .where(
                (item) =>
                    !item.uncertain &&
                    !_personRefIsAmbiguous(result, item.personRef) &&
                    !_placeRefIsAmbiguous(result, item.placeRef),
              )
              .map((item) => item.ref),
          ...result.events
              .where(
                (item) =>
                    !item.uncertain &&
                    !_personRefIsAmbiguous(result, item.personRef) &&
                    (item.placeRef == null ||
                        !_placeRefIsAmbiguous(result, item.placeRef!)),
              )
              .map((item) => item.ref),
        };
        _stage = _ExtractionStage.evidence;
      });
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No s’ha pogut analitzar el text: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _createClaims() async {
    final result = _result;
    if (result == null || _selected.isEmpty) return;
    setState(() => _busy = true);
    try {
      final count = await ref
          .read(textExtractionControllerProvider)
          .createClaims(
            sourceId: widget.sourceId,
            extraction: result,
            selectedRefs: _selected,
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            count == 1
                ? 'S’ha creat 1 afirmació pendent de revisió.'
                : 'S’han creat $count afirmacions pendents de revisió.',
          ),
        ),
      );
      context.go('/sources/${widget.sourceId.value}');
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No s’han pogut crear les afirmacions: $error'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final result = _result;
    return Scaffold(
      appBar: AppBar(title: const Text('Extreu informació del text')),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(32),
            children: [
              _ProgressHeader(stage: _stage),
              const SizedBox(height: 24),
              if (_stage == _ExtractionStage.input) _buildInput(),
              if (_stage == _ExtractionStage.evidence && result != null)
                _buildEvidence(result),
              if (_stage == _ExtractionStage.review && result != null)
                _buildReview(result),
            ],
          ),
          if (_busy)
            const Positioned.fill(
              child: ColoredBox(
                color: Color(0x22000000),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }

  bool _personRefIsAmbiguous(ExtractionResult result, String ref) =>
      result.people.any(
        (item) =>
            item.ref == ref && (item.resolutionAmbiguous || item.requiresName),
      );

  bool _placeRefIsAmbiguous(ExtractionResult result, String ref) =>
      result.places.any((item) => item.ref == ref && item.resolutionAmbiguous);

  bool _relationshipHasAmbiguousDependency(
    ExtractionResult result,
    CandidateRelationship relationship,
  ) =>
      _personRefIsAmbiguous(result, relationship.personARef) ||
      _personRefIsAmbiguous(result, relationship.personBRef) ||
      (relationship.placeRef != null &&
          _placeRefIsAmbiguous(result, relationship.placeRef!));

  Widget _buildInput() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Enganxa el text o la transcripció',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      const SizedBox(height: 8),
      const Text(
        'L’extractor és local i determinista. Només proposa informació que '
        'coincideix amb patrons catalans explícits; no envia ni memoritza dades.',
      ),
      const SizedBox(height: 16),
      TextField(
        controller: _narratorName,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Nom de la persona narradora (si el text usa «jo»)',
          helperText:
              'Necessari per crear relacions quan el text no diu «Em dic…».',
        ),
      ),
      const SizedBox(height: 16),
      TextField(
        controller: _text,
        minLines: 12,
        maxLines: 24,
        autofocus: true,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Exemple: Em dic Clara Vidal. La meva mare, Rosa Puig…',
        ),
      ),
      const SizedBox(height: 16),
      FilledButton.icon(
        onPressed: _busy ? null : _analyze,
        icon: const Icon(Icons.manage_search),
        label: const Text('Analitza localment'),
      ),
    ],
  );

  Widget _buildEvidence(ExtractionResult result) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Verifica el text abans de revisar les propostes',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      const SizedBox(height: 8),
      const Text(
        'Cada fragment utilitzat està subratllat. Si falta un fragment o el '
        'color no correspon, torna enrere i corregeix el text.',
      ),
      const SizedBox(height: 16),
      _EvidenceLegend(result: result),
      const SizedBox(height: 16),
      Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SelectionArea(
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.8,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                children: _highlightedSpans(result),
              ),
            ),
          ),
        ),
      ),
      if (result.ambiguities.isNotEmpty) ...[
        const SizedBox(height: 16),
        Card(
          color: Theme.of(context).colorScheme.tertiaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Punts que cal confirmar'),
                const SizedBox(height: 8),
                ...result.ambiguities.map((item) => Text('• $item')),
              ],
            ),
          ),
        ),
      ],
      const SizedBox(height: 20),
      Row(
        children: [
          OutlinedButton.icon(
            onPressed: () => setState(() => _stage = _ExtractionStage.input),
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Corregeix el text'),
          ),
          const Spacer(),
          FilledButton.icon(
            onPressed: result.evidenceSpans.isEmpty
                ? null
                : () => setState(() => _stage = _ExtractionStage.review),
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Continua a la revisió'),
          ),
        ],
      ),
    ],
  );

  Widget _buildReview(ExtractionResult result) {
    final items = _reviewItems(result);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Revisa les propostes',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        const Text(
          'Les coincidències incertes estan desmarcades. Les persones i els '
          'llocs necessaris s’afegiran automàticament com a dependències.',
        ),
        const SizedBox(height: 16),
        ...items.map(
          (item) => Card(
            child: CheckboxListTile(
              value: _selected.contains(item.ref),
              onChanged: item.selectable
                  ? (value) => setState(() {
                      if (value == true) {
                        _selected.add(item.ref);
                      } else {
                        _selected.remove(item.ref);
                      }
                    })
                  : null,
              title: Text(item.title),
              subtitle: Text(item.subtitle),
              secondary: Icon(item.icon),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: () =>
                  setState(() => _stage = _ExtractionStage.evidence),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Torna al text'),
            ),
            const Spacer(),
            FilledButton.icon(
              onPressed: _selected.isEmpty || _busy ? null : _createClaims,
              icon: const Icon(Icons.fact_check_outlined),
              label: const Text('Crea afirmacions seleccionades'),
            ),
          ],
        ),
      ],
    );
  }

  List<InlineSpan> _highlightedSpans(ExtractionResult result) {
    final boundaries = <int>{0, result.text.length};
    for (final span in result.evidenceSpans) {
      boundaries.addAll([span.start, span.end]);
    }
    final sorted = boundaries.toList()..sort();
    final output = <InlineSpan>[];
    for (var index = 0; index < sorted.length - 1; index++) {
      final start = sorted[index];
      final end = sorted[index + 1];
      final active = result.evidenceSpans.where(
        (span) => span.start <= start && span.end >= end,
      );
      final evidence = active.firstOrNull;
      final color = evidence == null ? null : _evidenceColor(result, evidence);
      output.add(
        TextSpan(
          text: result.text.substring(start, end),
          style: color == null
              ? null
              : TextStyle(
                  backgroundColor: color.withValues(alpha: 0.12),
                  decoration: TextDecoration.underline,
                  decorationColor: color,
                  decorationThickness: 3,
                ),
        ),
      );
    }
    return output;
  }

  Color _evidenceColor(ExtractionResult result, EvidenceSpan evidence) =>
      switch (evidence.kind) {
        EvidenceKind.person => _personColor(
          result.people.indexWhere((person) => person.ref == evidence.key),
        ),
        EvidenceKind.relationship => _relationshipColor,
        EvidenceKind.place => _placeColor,
        EvidenceKind.date => _dateColor,
      };

  List<_ReviewItem> _reviewItems(ExtractionResult result) => [
    ...result.people.map(
      (item) => _ReviewItem(
        ref: item.ref,
        title: item.displayName,
        subtitle: item.resolvedId == null
            ? item.requiresName
                  ? 'Cal indicar el nom de la persona narradora i tornar a analitzar'
                  : item.resolutionAmbiguous
                  ? 'Coincidència múltiple: cal resoldre-la manualment'
                  : '${item.uncertain ? 'Incerta · ' : ''}Persona nova'
            : 'Coincidència exacta amb una persona existent',
        icon: Icons.person_outline,
        selectable: !item.requiresName && !item.resolutionAmbiguous,
      ),
    ),
    ...result.places.map(
      (item) => _ReviewItem(
        ref: item.ref,
        title: item.preferredName,
        subtitle: item.resolvedId == null
            ? item.resolutionAmbiguous
                  ? 'Coincidència múltiple: cal resoldre-la manualment'
                  : 'Lloc nou'
            : 'Coincidència exacta amb un lloc existent',
        icon: Icons.place_outlined,
        selectable: !item.resolutionAmbiguous,
      ),
    ),
    ...result.relationships.map((item) {
      final unsupported = _relationshipHasAmbiguousDependency(result, item);
      return _ReviewItem(
        ref: item.ref,
        title: switch (item.type) {
          CandidateRelationshipType.parentChild => 'Filiació',
          CandidateRelationshipType.partnership => 'Matrimoni o parella',
          CandidateRelationshipType.sibling =>
            item.uncertain ? 'Germandat incerta' : 'Germandat',
        },
        subtitle: unsupported
            ? 'Bloquejada per una coincidència múltiple'
            : item.evidence,
        icon: Icons.people_outline,
        selectable: !unsupported,
      );
    }),
    ...result.residences.map((item) {
      final ambiguous =
          _personRefIsAmbiguous(result, item.personRef) ||
          _placeRefIsAmbiguous(result, item.placeRef);
      return _ReviewItem(
        ref: item.ref,
        title: item.uncertain ? 'Residència per confirmar' : 'Residència',
        subtitle: ambiguous
            ? 'Bloquejada per una coincidència múltiple'
            : item.evidence,
        icon: Icons.home_outlined,
        selectable: !ambiguous,
      );
    }),
    ...result.events.map((item) {
      final ambiguous =
          _personRefIsAmbiguous(result, item.personRef) ||
          (item.placeRef != null &&
              _placeRefIsAmbiguous(result, item.placeRef!));
      return _ReviewItem(
        ref: item.ref,
        title: switch (item.type) {
          EventType.birth => 'Naixement',
          EventType.marriage => 'Casament',
          _ => 'Esdeveniment: ${item.type.name}',
        },
        subtitle: ambiguous
            ? 'Bloquejat per una coincidència múltiple'
            : item.date == null
            ? item.evidence
            : '${historicalDateLabel(item.date)}'
                  '${item.uncertain ? ' · Data inferida; cal confirmar-la' : ''}'
                  '\n${item.evidence}',
        icon: Icons.event_outlined,
        selectable: !ambiguous,
      );
    }),
  ];
}

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({required this.stage});
  final _ExtractionStage stage;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      _Step(label: '1. Text', active: stage == _ExtractionStage.input),
      const Expanded(child: Divider()),
      _Step(
        label: '2. Verificació visual',
        active: stage == _ExtractionStage.evidence,
      ),
      const Expanded(child: Divider()),
      _Step(label: '3. Revisió', active: stage == _ExtractionStage.review),
    ],
  );
}

class _Step extends StatelessWidget {
  const _Step({required this.label, required this.active});
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) => Chip(
    avatar: Icon(active ? Icons.radio_button_checked : Icons.circle_outlined),
    label: Text(label),
  );
}

class _EvidenceLegend extends StatelessWidget {
  const _EvidenceLegend({required this.result});
  final ExtractionResult result;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: [
      for (var index = 0; index < result.people.length; index++)
        _LegendChip(
          label: result.people[index].displayName,
          color: _TextExtractionScreenState._personColor(index),
        ),
      const _LegendChip(
        label: 'Relacions i accions',
        color: _TextExtractionScreenState._relationshipColor,
      ),
      const _LegendChip(
        label: 'Llocs',
        color: _TextExtractionScreenState._placeColor,
      ),
      const _LegendChip(
        label: 'Dates',
        color: _TextExtractionScreenState._dateColor,
      ),
    ],
  );
}

class _LegendChip extends StatelessWidget {
  const _LegendChip({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Chip(
    avatar: Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    ),
    label: Text(label),
  );
}

final class _ReviewItem {
  const _ReviewItem({
    required this.ref,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.selectable = true,
  });
  final String ref;
  final String title;
  final String subtitle;
  final IconData icon;
  final bool selectable;
}
