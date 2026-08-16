import 'package:family_history/app/providers.dart';
import 'package:family_history/core/dates/historical_date.dart';
import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/domain/claim/claim.dart';
import 'package:family_history/domain/event/event.dart';
import 'package:family_history/domain/event/event_participant.dart';
import 'package:family_history/domain/person/person.dart';
import 'package:family_history/domain/person/person_name.dart';
import 'package:family_history/domain/place/place.dart';
import 'package:family_history/domain/relationship/parent_child_relationship.dart';
import 'package:family_history/domain/relationship/partnership.dart';
import 'package:family_history/domain/relationship/sibling_relationship.dart';
import 'package:family_history/features/places/places_screen.dart'
    show placeTypeLabel;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum _ClaimOperation {
  createPerson,
  updatePerson,
  createPlace,
  updatePlace,
  parentChild,
  sibling,
  partnership,
  residence,
  event,
}

Future<void> showClaimFormDialog(
  BuildContext context,
  WidgetRef ref,
  SourceId sourceId,
) async {
  final values = await Future.wait([
    ref.read(personRepositoryProvider).listAll(),
    ref.read(personNameRepositoryProvider).listAll(),
    ref.read(placeRepositoryProvider).listAll(),
  ]);
  if (!context.mounted) return;
  await showDialog<void>(
    context: context,
    builder: (_) => _ClaimFormDialog(
      sourceId: sourceId,
      people: values[0] as List<Person>,
      names: values[1] as List<PersonName>,
      places: values[2] as List<Place>,
    ),
  );
}

class _ClaimFormDialog extends ConsumerStatefulWidget {
  const _ClaimFormDialog({
    required this.sourceId,
    required this.people,
    required this.names,
    required this.places,
  });

  final SourceId sourceId;
  final List<Person> people;
  final List<PersonName> names;
  final List<Place> places;

  @override
  ConsumerState<_ClaimFormDialog> createState() => _ClaimFormDialogState();
}

class _ClaimFormDialogState extends ConsumerState<_ClaimFormDialog> {
  _ClaimOperation operation = _ClaimOperation.createPerson;
  ClaimProperty personProperty = ClaimProperty.personPreferredName;
  ClaimProperty placeProperty = ClaimProperty.placePreferredName;
  PersonSex sex = PersonSex.unknown;
  PlaceType placeType = PlaceType.other;
  ParentChildNature nature = ParentChildNature.biological;
  SiblingKind siblingKind = SiblingKind.unspecified;
  PartnershipType partnershipType = PartnershipType.unknown;
  EventType eventType = EventType.custom;
  Person? firstPerson;
  Person? secondPerson;
  Place? place;
  final value = TextEditingController();
  final secondValue = TextEditingController();
  final locator = TextEditingController();
  bool saving = false;

  @override
  void initState() {
    super.initState();
    firstPerson = widget.people.firstOrNull;
    secondPerson =
        widget.people.skip(1).firstOrNull ?? widget.people.firstOrNull;
    place = widget.places.firstOrNull;
  }

  @override
  void dispose() {
    value.dispose();
    secondValue.dispose();
    locator.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Nova afirmació'),
    content: SizedBox(
      width: 600,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<_ClaimOperation>(
              initialValue: operation,
              decoration: const InputDecoration(
                labelText: 'Operació proposada',
              ),
              items: _ClaimOperation.values
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Text(_operationLabel(item)),
                    ),
                  )
                  .toList(),
              onChanged: (item) => setState(() => operation = item!),
            ),
            const SizedBox(height: 12),
            ..._operationFields(),
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
    ),
    actions: [
      TextButton(
        onPressed: saving ? null : () => Navigator.pop(context),
        child: const Text('Cancel·la'),
      ),
      FilledButton(
        onPressed: saving ? null : _save,
        child: Text(saving ? 'Desant…' : 'Crea'),
      ),
    ],
  );

  List<Widget> _operationFields() => switch (operation) {
    _ClaimOperation.createPerson => [
      _textField(value, 'Nom preferit'),
      const SizedBox(height: 12),
      _enumField<PersonSex>(
        'Sexe',
        sex,
        PersonSex.values,
        (item) => sex = item,
        label: _personSexLabel,
      ),
    ],
    _ClaimOperation.updatePerson => [
      _personField('Persona', firstPerson, (item) => firstPerson = item),
      const SizedBox(height: 12),
      _enumField<ClaimProperty>(
        'Camp',
        personProperty,
        const [
          ClaimProperty.personPreferredName,
          ClaimProperty.personSex,
          ClaimProperty.personBirthDate,
          ClaimProperty.personDeathDate,
          ClaimProperty.personBiography,
          ClaimProperty.personNotes,
        ],
        (item) => personProperty = item,
        label: claimPropertyLabel,
      ),
      const SizedBox(height: 12),
      if (personProperty == ClaimProperty.personSex)
        _enumField<PersonSex>(
          'Valor',
          sex,
          PersonSex.values,
          (item) => sex = item,
          label: _personSexLabel,
        )
      else
        _textField(value, _isDate(personProperty) ? 'Valor (any)' : 'Valor'),
    ],
    _ClaimOperation.createPlace => [
      _textField(value, 'Nom preferit'),
      const SizedBox(height: 12),
      _enumField<PlaceType>(
        'Tipus',
        placeType,
        PlaceType.values,
        (item) => placeType = item,
        label: placeTypeLabel,
      ),
    ],
    _ClaimOperation.updatePlace => [
      _placeField('Lloc', place, (item) => place = item),
      const SizedBox(height: 12),
      _enumField<ClaimProperty>(
        'Camp',
        placeProperty,
        const [
          ClaimProperty.placePreferredName,
          ClaimProperty.placeType,
          ClaimProperty.placeCoordinates,
          ClaimProperty.placeDescription,
          ClaimProperty.placeNotes,
        ],
        (item) => placeProperty = item,
        label: claimPropertyLabel,
      ),
      const SizedBox(height: 12),
      if (placeProperty == ClaimProperty.placeType)
        _enumField<PlaceType>(
          'Valor',
          placeType,
          PlaceType.values,
          (item) => placeType = item,
          label: placeTypeLabel,
        )
      else
        _textField(
          value,
          placeProperty == ClaimProperty.placeCoordinates ? 'Latitud' : 'Valor',
        ),
      if (placeProperty == ClaimProperty.placeCoordinates) ...[
        const SizedBox(height: 12),
        _textField(secondValue, 'Longitud'),
      ],
    ],
    _ClaimOperation.parentChild => [
      _personField('Pare o mare', firstPerson, (item) => firstPerson = item),
      const SizedBox(height: 12),
      _personField('Fill o filla', secondPerson, (item) => secondPerson = item),
      const SizedBox(height: 12),
      _enumField<ParentChildNature>(
        'Naturalesa',
        nature,
        ParentChildNature.values,
        (item) => nature = item,
        label: _parentChildNatureLabel,
      ),
    ],
    _ClaimOperation.sibling => [
      _personField(
        'Primera persona',
        firstPerson,
        (item) => firstPerson = item,
      ),
      const SizedBox(height: 12),
      _personField(
        'Segona persona',
        secondPerson,
        (item) => secondPerson = item,
      ),
      const SizedBox(height: 12),
      _enumField<SiblingKind>(
        'Tipus de germanor',
        siblingKind,
        SiblingKind.values,
        (item) => siblingKind = item,
        label: _siblingKindLabel,
      ),
    ],
    _ClaimOperation.partnership => [
      _personField(
        'Primera persona',
        firstPerson,
        (item) => firstPerson = item,
      ),
      const SizedBox(height: 12),
      _personField(
        'Segona persona',
        secondPerson,
        (item) => secondPerson = item,
      ),
      const SizedBox(height: 12),
      _enumField<PartnershipType>(
        'Tipus',
        partnershipType,
        PartnershipType.values,
        (item) => partnershipType = item,
        label: _partnershipTypeLabel,
      ),
    ],
    _ClaimOperation.residence => [
      _personField('Persona', firstPerson, (item) => firstPerson = item),
      const SizedBox(height: 12),
      _placeField('Lloc', place, (item) => place = item),
      const SizedBox(height: 12),
      _textField(value, 'Motiu (opcional)'),
    ],
    _ClaimOperation.event => [
      _personField('Participant', firstPerson, (item) => firstPerson = item),
      const SizedBox(height: 12),
      _enumField<EventType>(
        'Tipus',
        eventType,
        EventType.values,
        (item) => eventType = item,
        label: _eventTypeLabel,
      ),
      const SizedBox(height: 12),
      _placeField(
        'Lloc (opcional)',
        place,
        (item) => place = item,
        allowEmpty: true,
      ),
      const SizedBox(height: 12),
      _textField(value, 'Títol (opcional)'),
    ],
  };

  Widget _textField(TextEditingController controller, String label) =>
      TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
      );

  Widget _personField(
    String label,
    Person? selected,
    ValueChanged<Person> change,
  ) {
    if (widget.people.isEmpty) {
      return const Text('Primer cal crear una persona.');
    }
    return DropdownButtonFormField<Person>(
      initialValue: selected,
      decoration: InputDecoration(labelText: label),
      items: widget.people
          .map(
            (item) => DropdownMenuItem(
              value: item,
              child: Text(_personLabel(item.id)),
            ),
          )
          .toList(),
      onChanged: (item) => setState(() => change(item!)),
    );
  }

  Widget _placeField(
    String label,
    Place? selected,
    ValueChanged<Place?> change, {
    bool allowEmpty = false,
  }) {
    if (widget.places.isEmpty && !allowEmpty) {
      return const Text('Primer cal crear un lloc.');
    }
    return DropdownButtonFormField<Place?>(
      initialValue: selected,
      decoration: InputDecoration(labelText: label),
      items: [
        if (allowEmpty)
          const DropdownMenuItem<Place?>(
            value: null,
            child: Text('Sense lloc'),
          ),
        ...widget.places.map(
          (item) => DropdownMenuItem<Place?>(
            value: item,
            child: Text(item.preferredName),
          ),
        ),
      ],
      onChanged: (item) => setState(() => change(item)),
    );
  }

  Widget _enumField<T>(
    String fieldLabel,
    T selected,
    List<T> values,
    ValueChanged<T> change, {
    String Function(T)? label,
  }) => DropdownButtonFormField<T>(
    initialValue: selected,
    decoration: InputDecoration(labelText: fieldLabel),
    items: values
        .map(
          (item) => DropdownMenuItem(
            value: item,
            child: Text(label?.call(item) ?? (item as Enum).name),
          ),
        )
        .toList(),
    onChanged: (item) => setState(() => change(item as T)),
  );

  String _personLabel(PersonId id) =>
      widget.names
          .where((name) => name.personId == id)
          .map((name) => name.displayName)
          .firstOrNull ??
      id.value;

  Future<void> _save() async {
    setState(() => saving = true);
    try {
      final now = DateTime.now().toUtc();
      final claim = _buildClaim(now);
      await ref.read(claimServiceProvider).create(claim);
      if (mounted) Navigator.pop(context);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$error')));
        setState(() => saving = false);
      }
    }
  }

  Claim _buildClaim(DateTime now) {
    final result = switch (operation) {
      _ClaimOperation.createPerson => _claimParts(
        ClaimSubjectType.person,
        ClaimProperty.personCreation,
        PersonCreationClaimValue(
          personId: PersonId.generate(),
          preferredName: _required(value.text, 'nom'),
          sex: sex,
        ),
      ),
      _ClaimOperation.updatePerson => _claimParts(
        ClaimSubjectType.person,
        personProperty,
        _personScalarValue(personProperty),
        subjectId: _requiredPerson().id.value,
      ),
      _ClaimOperation.createPlace => _claimParts(
        ClaimSubjectType.place,
        ClaimProperty.placeCreation,
        PlaceCreationClaimValue(
          placeId: PlaceId.generate(),
          preferredName: _required(value.text, 'nom'),
          placeType: placeType,
        ),
      ),
      _ClaimOperation.updatePlace => _claimParts(
        ClaimSubjectType.place,
        placeProperty,
        _placeScalarValue(placeProperty),
        subjectId: _requiredPlace().id.value,
      ),
      _ClaimOperation.parentChild => _claimParts(
        ClaimSubjectType.relationship,
        ClaimProperty.parentChildRelationship,
        ParentChildClaimValue(
          relationshipId: ParentChildRelationshipId.generate(),
          parentId: _requiredPerson().id,
          childId: _requiredSecondPerson().id,
          nature: nature,
        ),
      ),
      _ClaimOperation.sibling => _claimParts(
        ClaimSubjectType.relationship,
        ClaimProperty.siblingRelationship,
        SiblingClaimValue(
          relationshipId: SiblingRelationshipId.generate(),
          personAId: _requiredPerson().id,
          personBId: _requiredSecondPerson().id,
          kind: siblingKind,
        ),
      ),
      _ClaimOperation.partnership => _claimParts(
        ClaimSubjectType.relationship,
        ClaimProperty.partnership,
        PartnershipClaimValue(
          partnershipId: PartnershipId.generate(),
          personAId: _requiredPerson().id,
          personBId: _requiredSecondPerson().id,
          partnershipType: partnershipType,
        ),
      ),
      _ClaimOperation.residence => _claimParts(
        ClaimSubjectType.residence,
        ClaimProperty.residence,
        ResidenceClaimValue(
          residenceId: ResidenceId.generate(),
          personId: _requiredPerson().id,
          placeId: _requiredPlace().id,
          reason: value.text,
        ),
      ),
      _ClaimOperation.event => _claimParts(
        ClaimSubjectType.event,
        ClaimProperty.event,
        EventClaimValue(
          eventId: EventId.generate(),
          eventType: eventType,
          participantId: _requiredPerson().id,
          participantRole: EventParticipantRole.subject,
          placeId: place?.id,
          title: value.text,
        ),
      ),
    };
    final subjectId =
        result.subjectId ??
        switch (result.value) {
          PersonCreationClaimValue(:final personId) => personId.value,
          PlaceCreationClaimValue(:final placeId) => placeId.value,
          ParentChildClaimValue(:final relationshipId) => relationshipId.value,
          SiblingClaimValue(:final relationshipId) => relationshipId.value,
          PartnershipClaimValue(:final partnershipId) => partnershipId.value,
          ResidenceClaimValue(:final residenceId) => residenceId.value,
          EventClaimValue(:final eventId) => eventId.value,
          _ => throw StateError('Subjecte no determinat.'),
        };
    return Claim(
      id: ClaimId.generate(),
      subjectType: result.subjectType,
      subjectId: subjectId,
      property: result.property,
      value: result.value,
      sourceId: widget.sourceId,
      sourceLocator: locator.text,
      status: ClaimStatus.unreviewed,
      createdAt: now,
      modifiedAt: now,
    );
  }

  ({
    ClaimSubjectType subjectType,
    ClaimProperty property,
    ClaimValue value,
    String? subjectId,
  })
  _claimParts(
    ClaimSubjectType type,
    ClaimProperty property,
    ClaimValue value, {
    String? subjectId,
  }) => (
    subjectType: type,
    property: property,
    value: value,
    subjectId: subjectId,
  );

  ClaimValue _personScalarValue(ClaimProperty property) => switch (property) {
    ClaimProperty.personSex => EnumClaimValue(sex.name),
    ClaimProperty.personBirthDate ||
    ClaimProperty.personDeathDate => HistoricalDateClaimValue(
      HistoricalDate.year(int.parse(_required(value.text, 'any'))),
    ),
    _ => TextClaimValue(_required(value.text, 'valor')),
  };

  ClaimValue _placeScalarValue(ClaimProperty property) => switch (property) {
    ClaimProperty.placeType => EnumClaimValue(placeType.name),
    ClaimProperty.placeCoordinates => CoordinatesClaimValue(
      latitude: double.parse(_required(value.text, 'latitud')),
      longitude: double.parse(_required(secondValue.text, 'longitud')),
    ),
    _ => TextClaimValue(_required(value.text, 'valor')),
  };

  Person _requiredPerson() =>
      firstPerson ?? (throw StateError('Cal seleccionar una persona.'));
  Person _requiredSecondPerson() =>
      secondPerson ?? (throw StateError('Cal seleccionar una segona persona.'));
  Place _requiredPlace() =>
      place ?? (throw StateError('Cal seleccionar un lloc.'));
  String _required(String text, String field) {
    final result = text.trim();
    if (result.isEmpty) throw StateError('El camp $field és obligatori.');
    return result;
  }
}

bool _isDate(ClaimProperty property) =>
    property == ClaimProperty.personBirthDate ||
    property == ClaimProperty.personDeathDate;

String _operationLabel(_ClaimOperation operation) => switch (operation) {
  _ClaimOperation.createPerson => 'Crear persona',
  _ClaimOperation.updatePerson => 'Modificar persona',
  _ClaimOperation.createPlace => 'Crear lloc',
  _ClaimOperation.updatePlace => 'Modificar lloc',
  _ClaimOperation.parentChild => 'Crear parentesc',
  _ClaimOperation.sibling => 'Crear germanor',
  _ClaimOperation.partnership => 'Crear parella',
  _ClaimOperation.residence => 'Crear residència',
  _ClaimOperation.event => 'Crear esdeveniment',
};

String claimPropertyLabel(ClaimProperty property) => switch (property) {
  ClaimProperty.personCreation => 'Creació de persona',
  ClaimProperty.personPreferredName => 'Nom preferit',
  ClaimProperty.personSex => 'Sexe',
  ClaimProperty.personBirthDate => 'Data de naixement',
  ClaimProperty.personDeathDate => 'Data de defunció',
  ClaimProperty.personBiography => 'Biografia',
  ClaimProperty.personNotes => 'Notes de persona',
  ClaimProperty.placeCreation => 'Creació de lloc',
  ClaimProperty.placePreferredName => 'Nom del lloc',
  ClaimProperty.placeType => 'Tipus de lloc',
  ClaimProperty.placeCoordinates => 'Coordenades',
  ClaimProperty.placeDescription => 'Descripció del lloc',
  ClaimProperty.placeNotes => 'Notes del lloc',
  ClaimProperty.parentChildRelationship => 'Relació pare/mare-fill/a',
  ClaimProperty.siblingRelationship => 'Germanor',
  ClaimProperty.partnership => 'Parella',
  ClaimProperty.residence => 'Residència',
  ClaimProperty.event => 'Esdeveniment',
};

String claimValueLabel(ClaimValue value) => switch (value) {
  TextClaimValue() => value.value,
  EnumClaimValue() => _enumClaimLabel(value.value),
  HistoricalDateClaimValue() =>
    value.value.displayText ??
        value.value.startDate?.year.toString() ??
        'Data desconeguda',
  PersonReferenceClaimValue() => value.personId.value,
  RelationshipClaimValue() =>
    '${value.relationshipType}: ${value.personId.value}',
  CoordinatesClaimValue() => '${value.latitude}, ${value.longitude}',
  PersonCreationClaimValue() => 'Crear ${value.preferredName}',
  PlaceCreationClaimValue() => 'Crear ${value.preferredName}',
  ParentChildClaimValue() => '${value.parentId.value} → ${value.childId.value}',
  SiblingClaimValue() => '${value.personAId.value} ↔ ${value.personBId.value}',
  PartnershipClaimValue() =>
    '${value.personAId.value} ↔ ${value.personBId.value}',
  ResidenceClaimValue() => '${value.personId.value} a ${value.placeId.value}',
  EventClaimValue() =>
    '${value.eventType.name}: ${value.title ?? value.participantId.value}',
};

String _personSexLabel(PersonSex sex) => switch (sex) {
  PersonSex.male => 'Home',
  PersonSex.female => 'Dona',
  PersonSex.intersex => 'Intersexual',
  PersonSex.unknown => 'Desconegut',
  PersonSex.unspecified => 'No especificat',
};

String _parentChildNatureLabel(ParentChildNature nature) => switch (nature) {
  ParentChildNature.biological => 'Biològic',
  ParentChildNature.adoptive => 'Adoptiu',
};

String _siblingKindLabel(SiblingKind kind) => switch (kind) {
  SiblingKind.unspecified => 'No especificada',
  SiblingKind.full => 'Mateix pare i mare',
  SiblingKind.half => 'Un progenitor comú',
  SiblingKind.adoptive => 'Adoptiva',
  SiblingKind.step => 'Política',
};

String _partnershipTypeLabel(PartnershipType type) => switch (type) {
  PartnershipType.marriage => 'Matrimoni',
  PartnershipType.partnership => 'Parella',
  PartnershipType.unknown => 'Desconeguda',
};

String _eventTypeLabel(EventType type) => switch (type) {
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

String _enumClaimLabel(String value) {
  for (final sex in PersonSex.values) {
    if (sex.name.toUpperCase() == value) return _personSexLabel(sex);
  }
  for (final type in PlaceType.values) {
    if (type.name.toUpperCase() == value) return placeTypeLabel(type);
  }
  return value;
}
