import 'package:family_history/app/providers.dart';
import 'package:family_history/components/historical_date_field.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/domain/event/event.dart';
import 'package:family_history/domain/event/event_participant.dart';
import 'package:family_history/domain/person/person.dart';
import 'package:family_history/domain/person/person_name.dart';
import 'package:family_history/domain/place/place.dart';
import 'package:family_history/domain/place/residence.dart';
import 'package:family_history/domain/relationship/parent_child_relationship.dart';
import 'package:family_history/domain/relationship/partnership.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum _RelationshipMode { parentOfPerson, childOfPerson, partner }

class AddRelationshipDialog extends ConsumerStatefulWidget {
  const AddRelationshipDialog({required this.personId, super.key});

  final PersonId personId;

  @override
  ConsumerState<AddRelationshipDialog> createState() =>
      _AddRelationshipDialogState();
}

class _AddRelationshipDialogState extends ConsumerState<AddRelationshipDialog> {
  _RelationshipMode _mode = _RelationshipMode.parentOfPerson;
  ParentChildNature _nature = ParentChildNature.biological;
  PartnershipType _partnershipType = PartnershipType.marriage;
  PersonId? _otherPerson;
  bool _saving = false;

  Future<void> _save() async {
    final other = _otherPerson;
    if (other == null) return;
    setState(() => _saving = true);
    try {
      final now = DateTime.now().toUtc();
      final controller = ref.read(peopleControllerProvider);
      switch (_mode) {
        case _RelationshipMode.parentOfPerson:
          await controller.addParentChild(
            ParentChildRelationship(
              id: ParentChildRelationshipId.generate(),
              parentId: other,
              childId: widget.personId,
              nature: _nature,
              createdAt: now,
              modifiedAt: now,
            ),
          );
        case _RelationshipMode.childOfPerson:
          await controller.addParentChild(
            ParentChildRelationship(
              id: ParentChildRelationshipId.generate(),
              parentId: widget.personId,
              childId: other,
              nature: _nature,
              createdAt: now,
              modifiedAt: now,
            ),
          );
        case _RelationshipMode.partner:
          await controller.addPartnership(
            Partnership(
              id: PartnershipId.generate(),
              personAId: widget.personId,
              personBId: other,
              type: _partnershipType,
              createdAt: now,
              modifiedAt: now,
            ),
          );
      }
      if (mounted) Navigator.of(context).pop();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('No s’ha pogut afegir: $error')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final people = ref.watch(peopleProvider).value ?? const <Person>[];
    final currentNames =
        ref.watch(personNamesProvider(widget.personId)).value ??
        const <PersonName>[];
    final currentName =
        currentNames
            .where((name) => name.isPreferred)
            .firstOrNull
            ?.displayName ??
        currentNames.firstOrNull?.displayName ??
        'la persona actual';
    final candidates = people
        .where((person) => person.id != widget.personId)
        .toList();
    return AlertDialog(
      title: const Text('Afegir relació familiar'),
      content: SizedBox(
        width: 520,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Text('La persona'),
                  SizedBox(
                    width: 180,
                    child: DropdownButtonFormField<PersonId>(
                      initialValue: _otherPerson,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        hintText: 'Tria una persona',
                        isDense: true,
                      ),
                      items: candidates
                          .map(
                            (person) => DropdownMenuItem(
                              value: person.id,
                              child: _PersonName(personId: person.id),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _otherPerson = value),
                    ),
                  ),
                  const Text('és'),
                  SizedBox(
                    width: 260,
                    child: DropdownButtonFormField<_RelationshipMode>(
                      initialValue: _mode,
                      isExpanded: true,
                      decoration: const InputDecoration(isDense: true),
                      items: [
                        DropdownMenuItem(
                          value: _RelationshipMode.parentOfPerson,
                          child: Text(
                            'pare/mare de $currentName',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        DropdownMenuItem(
                          value: _RelationshipMode.childOfPerson,
                          child: Text(
                            'fill/filla de $currentName',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        DropdownMenuItem(
                          value: _RelationshipMode.partner,
                          child: Text(
                            'cònjuge o parella de $currentName',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                      onChanged: (value) => setState(() => _mode = value!),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (_mode == _RelationshipMode.partner)
              DropdownButtonFormField<PartnershipType>(
                initialValue: _partnershipType,
                decoration: const InputDecoration(
                  labelText: 'Tipus de parella',
                ),
                items: PartnershipType.values
                    .map(
                      (type) => DropdownMenuItem(
                        value: type,
                        child: Text(_partnershipLabel(type)),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _partnershipType = value!),
              )
            else
              DropdownButtonFormField<ParentChildNature>(
                initialValue: _nature,
                decoration: const InputDecoration(labelText: 'Naturalesa'),
                items: const [
                  DropdownMenuItem(
                    value: ParentChildNature.biological,
                    child: Text('Biològica'),
                  ),
                  DropdownMenuItem(
                    value: ParentChildNature.adoptive,
                    child: Text('Adoptiva'),
                  ),
                ],
                onChanged: (value) => setState(() => _nature = value!),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel·lar'),
        ),
        FilledButton(
          onPressed: _saving || _otherPerson == null ? null : _save,
          child: const Text('Afegir'),
        ),
      ],
    );
  }
}

class AddResidenceDialog extends ConsumerStatefulWidget {
  const AddResidenceDialog({required this.personId, super.key});

  final PersonId personId;

  @override
  ConsumerState<AddResidenceDialog> createState() => _AddResidenceDialogState();
}

class _AddResidenceDialogState extends ConsumerState<AddResidenceDialog> {
  final _formKey = GlobalKey<FormState>();
  final _startKey = GlobalKey<HistoricalDateFieldState>();
  final _endKey = GlobalKey<HistoricalDateFieldState>();
  final _reason = TextEditingController();
  PlaceId? _placeId;
  bool _saving = false;

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _placeId == null) return;
    setState(() => _saving = true);
    try {
      final now = DateTime.now().toUtc();
      await ref
          .read(peopleControllerProvider)
          .addResidence(
            Residence(
              id: ResidenceId.generate(),
              personId: widget.personId,
              placeId: _placeId!,
              startDate: _startKey.currentState!.buildValue(),
              endDate: _endKey.currentState!.buildValue(),
              reason: _reason.text,
              createdAt: now,
              modifiedAt: now,
            ),
          );
      if (mounted) Navigator.of(context).pop();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('No s’ha pogut afegir: $error')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final places = ref.watch(placesProvider).value ?? const <Place>[];
    return AlertDialog(
      title: const Text('Afegir residència'),
      content: SizedBox(
        width: 620,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<PlaceId>(
                  initialValue: _placeId,
                  decoration: const InputDecoration(labelText: 'Lloc *'),
                  items: places
                      .map(
                        (place) => DropdownMenuItem(
                          value: place.id,
                          child: Text(place.preferredName),
                        ),
                      )
                      .toList(),
                  validator: (value) =>
                      value == null ? 'Selecciona un lloc.' : null,
                  onChanged: (value) => setState(() => _placeId = value),
                ),
                const SizedBox(height: 16),
                HistoricalDateField(key: _startKey, label: 'Inici'),
                const SizedBox(height: 16),
                HistoricalDateField(key: _endKey, label: 'Final'),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _reason,
                  decoration: const InputDecoration(labelText: 'Motiu'),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel·lar'),
        ),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: const Text('Afegir'),
        ),
      ],
    );
  }
}

class AddEventDialog extends ConsumerStatefulWidget {
  const AddEventDialog({required this.personId, super.key});

  final PersonId personId;

  @override
  ConsumerState<AddEventDialog> createState() => _AddEventDialogState();
}

class _AddEventDialogState extends ConsumerState<AddEventDialog> {
  final _formKey = GlobalKey<FormState>();
  final _dateKey = GlobalKey<HistoricalDateFieldState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  EventType _type = EventType.custom;
  PlaceId? _placeId;
  bool _saving = false;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final now = DateTime.now().toUtc();
      final eventId = EventId.generate();
      await ref
          .read(peopleControllerProvider)
          .createEvent(
            FamilyEvent(
              id: eventId,
              type: _type,
              date: _dateKey.currentState!.buildValue(),
              placeId: _placeId,
              title: _title.text,
              description: _description.text,
              createdAt: now,
              modifiedAt: now,
            ),
            EventParticipant(
              id: EventParticipantId.generate(),
              eventId: eventId,
              personId: widget.personId,
              role: EventParticipantRole.subject,
              createdAt: now,
              modifiedAt: now,
            ),
          );
      if (mounted) Navigator.of(context).pop();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('No s’ha pogut afegir: $error')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final places = ref.watch(placesProvider).value ?? const <Place>[];
    return AlertDialog(
      title: const Text('Afegir esdeveniment'),
      content: SizedBox(
        width: 620,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<EventType>(
                  initialValue: _type,
                  decoration: const InputDecoration(labelText: 'Tipus'),
                  items: EventType.values
                      .map(
                        (type) => DropdownMenuItem(
                          value: type,
                          child: Text(eventTypeLabel(type)),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => _type = value!),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _title,
                  decoration: const InputDecoration(labelText: 'Títol'),
                ),
                const SizedBox(height: 16),
                HistoricalDateField(key: _dateKey, label: 'Data'),
                const SizedBox(height: 16),
                DropdownButtonFormField<PlaceId?>(
                  initialValue: _placeId,
                  decoration: const InputDecoration(labelText: 'Lloc opcional'),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('Sense lloc'),
                    ),
                    ...places.map(
                      (place) => DropdownMenuItem(
                        value: place.id,
                        child: Text(place.preferredName),
                      ),
                    ),
                  ],
                  onChanged: (value) => setState(() => _placeId = value),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _description,
                  decoration: const InputDecoration(labelText: 'Descripció'),
                  minLines: 2,
                  maxLines: 5,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel·lar'),
        ),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: const Text('Afegir'),
        ),
      ],
    );
  }
}

class _PersonName extends ConsumerWidget {
  const _PersonName({required this.personId});

  final PersonId personId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final names = ref.watch(personNamesProvider(personId)).value;
    return Text(
      names?.where((name) => name.isPreferred).firstOrNull?.displayName ??
          names?.firstOrNull?.displayName ??
          'Persona',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

String _partnershipLabel(PartnershipType type) => switch (type) {
  PartnershipType.marriage => 'Matrimoni',
  PartnershipType.partnership => 'Parella',
  PartnershipType.unknown => 'Desconeguda',
};

String eventTypeLabel(EventType type) => switch (type) {
  EventType.birth => 'Naixement',
  EventType.death => 'Defunció',
  EventType.marriage => 'Matrimoni',
  EventType.separation => 'Separació',
  EventType.move => 'Trasllat',
  EventType.baptism => 'Baptisme',
  EventType.funeral => 'Funeral',
  EventType.education => 'Educació',
  EventType.employment => 'Feina',
  EventType.military => 'Servei militar',
  EventType.war => 'Guerra',
  EventType.purchase => 'Compra',
  EventType.sale => 'Venda',
  EventType.inheritance => 'Herència',
  EventType.travel => 'Viatge',
  EventType.migration => 'Migració',
  EventType.custom => 'Personalitzat',
};
