// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ProjectsTable extends Projects with TableInfo<$ProjectsTable, Project> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modifiedAtMeta = const VerificationMeta(
    'modifiedAt',
  );
  @override
  late final GeneratedColumn<DateTime> modifiedAt = GeneratedColumn<DateTime>(
    'modified_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    createdAt,
    modifiedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'projects';
  @override
  VerificationContext validateIntegrity(
    Insertable<Project> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('modified_at')) {
      context.handle(
        _modifiedAtMeta,
        modifiedAt.isAcceptableOrUnknown(data['modified_at']!, _modifiedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_modifiedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Project map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Project(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      modifiedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}modified_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $ProjectsTable createAlias(String alias) {
    return $ProjectsTable(attachedDatabase, alias);
  }
}

class Project extends DataClass implements Insertable<Project> {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final DateTime? deletedAt;
  const Project({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.modifiedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['modified_at'] = Variable<DateTime>(modifiedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  ProjectsCompanion toCompanion(bool nullToAbsent) {
    return ProjectsCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: Value(createdAt),
      modifiedAt: Value(modifiedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory Project.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Project(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      modifiedAt: serializer.fromJson<DateTime>(json['modifiedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'modifiedAt': serializer.toJson<DateTime>(modifiedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  Project copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    DateTime? modifiedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => Project(
    id: id ?? this.id,
    name: name ?? this.name,
    createdAt: createdAt ?? this.createdAt,
    modifiedAt: modifiedAt ?? this.modifiedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  Project copyWithCompanion(ProjectsCompanion data) {
    return Project(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      modifiedAt: data.modifiedAt.present
          ? data.modifiedAt.value
          : this.modifiedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Project(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('modifiedAt: $modifiedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, createdAt, modifiedAt, deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Project &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdAt == this.createdAt &&
          other.modifiedAt == this.modifiedAt &&
          other.deletedAt == this.deletedAt);
}

class ProjectsCompanion extends UpdateCompanion<Project> {
  final Value<String> id;
  final Value<String> name;
  final Value<DateTime> createdAt;
  final Value<DateTime> modifiedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const ProjectsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.modifiedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProjectsCompanion.insert({
    required String id,
    required String name,
    required DateTime createdAt,
    required DateTime modifiedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       modifiedAt = Value(modifiedAt);
  static Insertable<Project> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? modifiedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
      if (modifiedAt != null) 'modified_at': modifiedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProjectsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<DateTime>? createdAt,
    Value<DateTime>? modifiedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return ProjectsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (modifiedAt.present) {
      map['modified_at'] = Variable<DateTime>(modifiedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('modifiedAt: $modifiedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PersonsTable extends Persons with TableInfo<$PersonsTable, Person> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PersonsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sexMeta = const VerificationMeta('sex');
  @override
  late final GeneratedColumn<String> sex = GeneratedColumn<String>(
    'sex',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _birthPrecisionMeta = const VerificationMeta(
    'birthPrecision',
  );
  @override
  late final GeneratedColumn<String> birthPrecision = GeneratedColumn<String>(
    'birth_precision',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _birthStartDateMeta = const VerificationMeta(
    'birthStartDate',
  );
  @override
  late final GeneratedColumn<DateTime> birthStartDate =
      GeneratedColumn<DateTime>(
        'birth_start_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _birthEndDateMeta = const VerificationMeta(
    'birthEndDate',
  );
  @override
  late final GeneratedColumn<DateTime> birthEndDate = GeneratedColumn<DateTime>(
    'birth_end_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _birthDisplayTextMeta = const VerificationMeta(
    'birthDisplayText',
  );
  @override
  late final GeneratedColumn<String> birthDisplayText = GeneratedColumn<String>(
    'birth_display_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deathPrecisionMeta = const VerificationMeta(
    'deathPrecision',
  );
  @override
  late final GeneratedColumn<String> deathPrecision = GeneratedColumn<String>(
    'death_precision',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deathStartDateMeta = const VerificationMeta(
    'deathStartDate',
  );
  @override
  late final GeneratedColumn<DateTime> deathStartDate =
      GeneratedColumn<DateTime>(
        'death_start_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _deathEndDateMeta = const VerificationMeta(
    'deathEndDate',
  );
  @override
  late final GeneratedColumn<DateTime> deathEndDate = GeneratedColumn<DateTime>(
    'death_end_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deathDisplayTextMeta = const VerificationMeta(
    'deathDisplayText',
  );
  @override
  late final GeneratedColumn<String> deathDisplayText = GeneratedColumn<String>(
    'death_display_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _biographyMeta = const VerificationMeta(
    'biography',
  );
  @override
  late final GeneratedColumn<String> biography = GeneratedColumn<String>(
    'biography',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modifiedAtMeta = const VerificationMeta(
    'modifiedAt',
  );
  @override
  late final GeneratedColumn<DateTime> modifiedAt = GeneratedColumn<DateTime>(
    'modified_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sex,
    birthPrecision,
    birthStartDate,
    birthEndDate,
    birthDisplayText,
    deathPrecision,
    deathStartDate,
    deathEndDate,
    deathDisplayText,
    biography,
    notes,
    createdAt,
    modifiedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'persons';
  @override
  VerificationContext validateIntegrity(
    Insertable<Person> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('sex')) {
      context.handle(
        _sexMeta,
        sex.isAcceptableOrUnknown(data['sex']!, _sexMeta),
      );
    } else if (isInserting) {
      context.missing(_sexMeta);
    }
    if (data.containsKey('birth_precision')) {
      context.handle(
        _birthPrecisionMeta,
        birthPrecision.isAcceptableOrUnknown(
          data['birth_precision']!,
          _birthPrecisionMeta,
        ),
      );
    }
    if (data.containsKey('birth_start_date')) {
      context.handle(
        _birthStartDateMeta,
        birthStartDate.isAcceptableOrUnknown(
          data['birth_start_date']!,
          _birthStartDateMeta,
        ),
      );
    }
    if (data.containsKey('birth_end_date')) {
      context.handle(
        _birthEndDateMeta,
        birthEndDate.isAcceptableOrUnknown(
          data['birth_end_date']!,
          _birthEndDateMeta,
        ),
      );
    }
    if (data.containsKey('birth_display_text')) {
      context.handle(
        _birthDisplayTextMeta,
        birthDisplayText.isAcceptableOrUnknown(
          data['birth_display_text']!,
          _birthDisplayTextMeta,
        ),
      );
    }
    if (data.containsKey('death_precision')) {
      context.handle(
        _deathPrecisionMeta,
        deathPrecision.isAcceptableOrUnknown(
          data['death_precision']!,
          _deathPrecisionMeta,
        ),
      );
    }
    if (data.containsKey('death_start_date')) {
      context.handle(
        _deathStartDateMeta,
        deathStartDate.isAcceptableOrUnknown(
          data['death_start_date']!,
          _deathStartDateMeta,
        ),
      );
    }
    if (data.containsKey('death_end_date')) {
      context.handle(
        _deathEndDateMeta,
        deathEndDate.isAcceptableOrUnknown(
          data['death_end_date']!,
          _deathEndDateMeta,
        ),
      );
    }
    if (data.containsKey('death_display_text')) {
      context.handle(
        _deathDisplayTextMeta,
        deathDisplayText.isAcceptableOrUnknown(
          data['death_display_text']!,
          _deathDisplayTextMeta,
        ),
      );
    }
    if (data.containsKey('biography')) {
      context.handle(
        _biographyMeta,
        biography.isAcceptableOrUnknown(data['biography']!, _biographyMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('modified_at')) {
      context.handle(
        _modifiedAtMeta,
        modifiedAt.isAcceptableOrUnknown(data['modified_at']!, _modifiedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_modifiedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Person map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Person(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sex'],
      )!,
      birthPrecision: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}birth_precision'],
      ),
      birthStartDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}birth_start_date'],
      ),
      birthEndDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}birth_end_date'],
      ),
      birthDisplayText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}birth_display_text'],
      ),
      deathPrecision: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}death_precision'],
      ),
      deathStartDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}death_start_date'],
      ),
      deathEndDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}death_end_date'],
      ),
      deathDisplayText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}death_display_text'],
      ),
      biography: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}biography'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      modifiedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}modified_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $PersonsTable createAlias(String alias) {
    return $PersonsTable(attachedDatabase, alias);
  }
}

class Person extends DataClass implements Insertable<Person> {
  final String id;
  final String sex;
  final String? birthPrecision;
  final DateTime? birthStartDate;
  final DateTime? birthEndDate;
  final String? birthDisplayText;
  final String? deathPrecision;
  final DateTime? deathStartDate;
  final DateTime? deathEndDate;
  final String? deathDisplayText;
  final String? biography;
  final String? notes;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final DateTime? deletedAt;
  const Person({
    required this.id,
    required this.sex,
    this.birthPrecision,
    this.birthStartDate,
    this.birthEndDate,
    this.birthDisplayText,
    this.deathPrecision,
    this.deathStartDate,
    this.deathEndDate,
    this.deathDisplayText,
    this.biography,
    this.notes,
    required this.createdAt,
    required this.modifiedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['sex'] = Variable<String>(sex);
    if (!nullToAbsent || birthPrecision != null) {
      map['birth_precision'] = Variable<String>(birthPrecision);
    }
    if (!nullToAbsent || birthStartDate != null) {
      map['birth_start_date'] = Variable<DateTime>(birthStartDate);
    }
    if (!nullToAbsent || birthEndDate != null) {
      map['birth_end_date'] = Variable<DateTime>(birthEndDate);
    }
    if (!nullToAbsent || birthDisplayText != null) {
      map['birth_display_text'] = Variable<String>(birthDisplayText);
    }
    if (!nullToAbsent || deathPrecision != null) {
      map['death_precision'] = Variable<String>(deathPrecision);
    }
    if (!nullToAbsent || deathStartDate != null) {
      map['death_start_date'] = Variable<DateTime>(deathStartDate);
    }
    if (!nullToAbsent || deathEndDate != null) {
      map['death_end_date'] = Variable<DateTime>(deathEndDate);
    }
    if (!nullToAbsent || deathDisplayText != null) {
      map['death_display_text'] = Variable<String>(deathDisplayText);
    }
    if (!nullToAbsent || biography != null) {
      map['biography'] = Variable<String>(biography);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['modified_at'] = Variable<DateTime>(modifiedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  PersonsCompanion toCompanion(bool nullToAbsent) {
    return PersonsCompanion(
      id: Value(id),
      sex: Value(sex),
      birthPrecision: birthPrecision == null && nullToAbsent
          ? const Value.absent()
          : Value(birthPrecision),
      birthStartDate: birthStartDate == null && nullToAbsent
          ? const Value.absent()
          : Value(birthStartDate),
      birthEndDate: birthEndDate == null && nullToAbsent
          ? const Value.absent()
          : Value(birthEndDate),
      birthDisplayText: birthDisplayText == null && nullToAbsent
          ? const Value.absent()
          : Value(birthDisplayText),
      deathPrecision: deathPrecision == null && nullToAbsent
          ? const Value.absent()
          : Value(deathPrecision),
      deathStartDate: deathStartDate == null && nullToAbsent
          ? const Value.absent()
          : Value(deathStartDate),
      deathEndDate: deathEndDate == null && nullToAbsent
          ? const Value.absent()
          : Value(deathEndDate),
      deathDisplayText: deathDisplayText == null && nullToAbsent
          ? const Value.absent()
          : Value(deathDisplayText),
      biography: biography == null && nullToAbsent
          ? const Value.absent()
          : Value(biography),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      modifiedAt: Value(modifiedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory Person.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Person(
      id: serializer.fromJson<String>(json['id']),
      sex: serializer.fromJson<String>(json['sex']),
      birthPrecision: serializer.fromJson<String?>(json['birthPrecision']),
      birthStartDate: serializer.fromJson<DateTime?>(json['birthStartDate']),
      birthEndDate: serializer.fromJson<DateTime?>(json['birthEndDate']),
      birthDisplayText: serializer.fromJson<String?>(json['birthDisplayText']),
      deathPrecision: serializer.fromJson<String?>(json['deathPrecision']),
      deathStartDate: serializer.fromJson<DateTime?>(json['deathStartDate']),
      deathEndDate: serializer.fromJson<DateTime?>(json['deathEndDate']),
      deathDisplayText: serializer.fromJson<String?>(json['deathDisplayText']),
      biography: serializer.fromJson<String?>(json['biography']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      modifiedAt: serializer.fromJson<DateTime>(json['modifiedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sex': serializer.toJson<String>(sex),
      'birthPrecision': serializer.toJson<String?>(birthPrecision),
      'birthStartDate': serializer.toJson<DateTime?>(birthStartDate),
      'birthEndDate': serializer.toJson<DateTime?>(birthEndDate),
      'birthDisplayText': serializer.toJson<String?>(birthDisplayText),
      'deathPrecision': serializer.toJson<String?>(deathPrecision),
      'deathStartDate': serializer.toJson<DateTime?>(deathStartDate),
      'deathEndDate': serializer.toJson<DateTime?>(deathEndDate),
      'deathDisplayText': serializer.toJson<String?>(deathDisplayText),
      'biography': serializer.toJson<String?>(biography),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'modifiedAt': serializer.toJson<DateTime>(modifiedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  Person copyWith({
    String? id,
    String? sex,
    Value<String?> birthPrecision = const Value.absent(),
    Value<DateTime?> birthStartDate = const Value.absent(),
    Value<DateTime?> birthEndDate = const Value.absent(),
    Value<String?> birthDisplayText = const Value.absent(),
    Value<String?> deathPrecision = const Value.absent(),
    Value<DateTime?> deathStartDate = const Value.absent(),
    Value<DateTime?> deathEndDate = const Value.absent(),
    Value<String?> deathDisplayText = const Value.absent(),
    Value<String?> biography = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? modifiedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => Person(
    id: id ?? this.id,
    sex: sex ?? this.sex,
    birthPrecision: birthPrecision.present
        ? birthPrecision.value
        : this.birthPrecision,
    birthStartDate: birthStartDate.present
        ? birthStartDate.value
        : this.birthStartDate,
    birthEndDate: birthEndDate.present ? birthEndDate.value : this.birthEndDate,
    birthDisplayText: birthDisplayText.present
        ? birthDisplayText.value
        : this.birthDisplayText,
    deathPrecision: deathPrecision.present
        ? deathPrecision.value
        : this.deathPrecision,
    deathStartDate: deathStartDate.present
        ? deathStartDate.value
        : this.deathStartDate,
    deathEndDate: deathEndDate.present ? deathEndDate.value : this.deathEndDate,
    deathDisplayText: deathDisplayText.present
        ? deathDisplayText.value
        : this.deathDisplayText,
    biography: biography.present ? biography.value : this.biography,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    modifiedAt: modifiedAt ?? this.modifiedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  Person copyWithCompanion(PersonsCompanion data) {
    return Person(
      id: data.id.present ? data.id.value : this.id,
      sex: data.sex.present ? data.sex.value : this.sex,
      birthPrecision: data.birthPrecision.present
          ? data.birthPrecision.value
          : this.birthPrecision,
      birthStartDate: data.birthStartDate.present
          ? data.birthStartDate.value
          : this.birthStartDate,
      birthEndDate: data.birthEndDate.present
          ? data.birthEndDate.value
          : this.birthEndDate,
      birthDisplayText: data.birthDisplayText.present
          ? data.birthDisplayText.value
          : this.birthDisplayText,
      deathPrecision: data.deathPrecision.present
          ? data.deathPrecision.value
          : this.deathPrecision,
      deathStartDate: data.deathStartDate.present
          ? data.deathStartDate.value
          : this.deathStartDate,
      deathEndDate: data.deathEndDate.present
          ? data.deathEndDate.value
          : this.deathEndDate,
      deathDisplayText: data.deathDisplayText.present
          ? data.deathDisplayText.value
          : this.deathDisplayText,
      biography: data.biography.present ? data.biography.value : this.biography,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      modifiedAt: data.modifiedAt.present
          ? data.modifiedAt.value
          : this.modifiedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Person(')
          ..write('id: $id, ')
          ..write('sex: $sex, ')
          ..write('birthPrecision: $birthPrecision, ')
          ..write('birthStartDate: $birthStartDate, ')
          ..write('birthEndDate: $birthEndDate, ')
          ..write('birthDisplayText: $birthDisplayText, ')
          ..write('deathPrecision: $deathPrecision, ')
          ..write('deathStartDate: $deathStartDate, ')
          ..write('deathEndDate: $deathEndDate, ')
          ..write('deathDisplayText: $deathDisplayText, ')
          ..write('biography: $biography, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('modifiedAt: $modifiedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sex,
    birthPrecision,
    birthStartDate,
    birthEndDate,
    birthDisplayText,
    deathPrecision,
    deathStartDate,
    deathEndDate,
    deathDisplayText,
    biography,
    notes,
    createdAt,
    modifiedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Person &&
          other.id == this.id &&
          other.sex == this.sex &&
          other.birthPrecision == this.birthPrecision &&
          other.birthStartDate == this.birthStartDate &&
          other.birthEndDate == this.birthEndDate &&
          other.birthDisplayText == this.birthDisplayText &&
          other.deathPrecision == this.deathPrecision &&
          other.deathStartDate == this.deathStartDate &&
          other.deathEndDate == this.deathEndDate &&
          other.deathDisplayText == this.deathDisplayText &&
          other.biography == this.biography &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.modifiedAt == this.modifiedAt &&
          other.deletedAt == this.deletedAt);
}

class PersonsCompanion extends UpdateCompanion<Person> {
  final Value<String> id;
  final Value<String> sex;
  final Value<String?> birthPrecision;
  final Value<DateTime?> birthStartDate;
  final Value<DateTime?> birthEndDate;
  final Value<String?> birthDisplayText;
  final Value<String?> deathPrecision;
  final Value<DateTime?> deathStartDate;
  final Value<DateTime?> deathEndDate;
  final Value<String?> deathDisplayText;
  final Value<String?> biography;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> modifiedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const PersonsCompanion({
    this.id = const Value.absent(),
    this.sex = const Value.absent(),
    this.birthPrecision = const Value.absent(),
    this.birthStartDate = const Value.absent(),
    this.birthEndDate = const Value.absent(),
    this.birthDisplayText = const Value.absent(),
    this.deathPrecision = const Value.absent(),
    this.deathStartDate = const Value.absent(),
    this.deathEndDate = const Value.absent(),
    this.deathDisplayText = const Value.absent(),
    this.biography = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.modifiedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PersonsCompanion.insert({
    required String id,
    required String sex,
    this.birthPrecision = const Value.absent(),
    this.birthStartDate = const Value.absent(),
    this.birthEndDate = const Value.absent(),
    this.birthDisplayText = const Value.absent(),
    this.deathPrecision = const Value.absent(),
    this.deathStartDate = const Value.absent(),
    this.deathEndDate = const Value.absent(),
    this.deathDisplayText = const Value.absent(),
    this.biography = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime modifiedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sex = Value(sex),
       createdAt = Value(createdAt),
       modifiedAt = Value(modifiedAt);
  static Insertable<Person> custom({
    Expression<String>? id,
    Expression<String>? sex,
    Expression<String>? birthPrecision,
    Expression<DateTime>? birthStartDate,
    Expression<DateTime>? birthEndDate,
    Expression<String>? birthDisplayText,
    Expression<String>? deathPrecision,
    Expression<DateTime>? deathStartDate,
    Expression<DateTime>? deathEndDate,
    Expression<String>? deathDisplayText,
    Expression<String>? biography,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? modifiedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sex != null) 'sex': sex,
      if (birthPrecision != null) 'birth_precision': birthPrecision,
      if (birthStartDate != null) 'birth_start_date': birthStartDate,
      if (birthEndDate != null) 'birth_end_date': birthEndDate,
      if (birthDisplayText != null) 'birth_display_text': birthDisplayText,
      if (deathPrecision != null) 'death_precision': deathPrecision,
      if (deathStartDate != null) 'death_start_date': deathStartDate,
      if (deathEndDate != null) 'death_end_date': deathEndDate,
      if (deathDisplayText != null) 'death_display_text': deathDisplayText,
      if (biography != null) 'biography': biography,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (modifiedAt != null) 'modified_at': modifiedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PersonsCompanion copyWith({
    Value<String>? id,
    Value<String>? sex,
    Value<String?>? birthPrecision,
    Value<DateTime?>? birthStartDate,
    Value<DateTime?>? birthEndDate,
    Value<String?>? birthDisplayText,
    Value<String?>? deathPrecision,
    Value<DateTime?>? deathStartDate,
    Value<DateTime?>? deathEndDate,
    Value<String?>? deathDisplayText,
    Value<String?>? biography,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? modifiedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return PersonsCompanion(
      id: id ?? this.id,
      sex: sex ?? this.sex,
      birthPrecision: birthPrecision ?? this.birthPrecision,
      birthStartDate: birthStartDate ?? this.birthStartDate,
      birthEndDate: birthEndDate ?? this.birthEndDate,
      birthDisplayText: birthDisplayText ?? this.birthDisplayText,
      deathPrecision: deathPrecision ?? this.deathPrecision,
      deathStartDate: deathStartDate ?? this.deathStartDate,
      deathEndDate: deathEndDate ?? this.deathEndDate,
      deathDisplayText: deathDisplayText ?? this.deathDisplayText,
      biography: biography ?? this.biography,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sex.present) {
      map['sex'] = Variable<String>(sex.value);
    }
    if (birthPrecision.present) {
      map['birth_precision'] = Variable<String>(birthPrecision.value);
    }
    if (birthStartDate.present) {
      map['birth_start_date'] = Variable<DateTime>(birthStartDate.value);
    }
    if (birthEndDate.present) {
      map['birth_end_date'] = Variable<DateTime>(birthEndDate.value);
    }
    if (birthDisplayText.present) {
      map['birth_display_text'] = Variable<String>(birthDisplayText.value);
    }
    if (deathPrecision.present) {
      map['death_precision'] = Variable<String>(deathPrecision.value);
    }
    if (deathStartDate.present) {
      map['death_start_date'] = Variable<DateTime>(deathStartDate.value);
    }
    if (deathEndDate.present) {
      map['death_end_date'] = Variable<DateTime>(deathEndDate.value);
    }
    if (deathDisplayText.present) {
      map['death_display_text'] = Variable<String>(deathDisplayText.value);
    }
    if (biography.present) {
      map['biography'] = Variable<String>(biography.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (modifiedAt.present) {
      map['modified_at'] = Variable<DateTime>(modifiedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PersonsCompanion(')
          ..write('id: $id, ')
          ..write('sex: $sex, ')
          ..write('birthPrecision: $birthPrecision, ')
          ..write('birthStartDate: $birthStartDate, ')
          ..write('birthEndDate: $birthEndDate, ')
          ..write('birthDisplayText: $birthDisplayText, ')
          ..write('deathPrecision: $deathPrecision, ')
          ..write('deathStartDate: $deathStartDate, ')
          ..write('deathEndDate: $deathEndDate, ')
          ..write('deathDisplayText: $deathDisplayText, ')
          ..write('biography: $biography, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('modifiedAt: $modifiedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PersonNamesTable extends PersonNames
    with TableInfo<$PersonNamesTable, PersonName> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PersonNamesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _personIdMeta = const VerificationMeta(
    'personId',
  );
  @override
  late final GeneratedColumn<String> personId = GeneratedColumn<String>(
    'person_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES persons (id)',
    ),
  );
  static const VerificationMeta _givenNamesMeta = const VerificationMeta(
    'givenNames',
  );
  @override
  late final GeneratedColumn<String> givenNames = GeneratedColumn<String>(
    'given_names',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _familyNamesMeta = const VerificationMeta(
    'familyNames',
  );
  @override
  late final GeneratedColumn<String> familyNames = GeneratedColumn<String>(
    'family_names',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isPreferredMeta = const VerificationMeta(
    'isPreferred',
  );
  @override
  late final GeneratedColumn<bool> isPreferred = GeneratedColumn<bool>(
    'is_preferred',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_preferred" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modifiedAtMeta = const VerificationMeta(
    'modifiedAt',
  );
  @override
  late final GeneratedColumn<DateTime> modifiedAt = GeneratedColumn<DateTime>(
    'modified_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    personId,
    givenNames,
    familyNames,
    displayName,
    type,
    isPreferred,
    createdAt,
    modifiedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'person_names';
  @override
  VerificationContext validateIntegrity(
    Insertable<PersonName> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('person_id')) {
      context.handle(
        _personIdMeta,
        personId.isAcceptableOrUnknown(data['person_id']!, _personIdMeta),
      );
    } else if (isInserting) {
      context.missing(_personIdMeta);
    }
    if (data.containsKey('given_names')) {
      context.handle(
        _givenNamesMeta,
        givenNames.isAcceptableOrUnknown(data['given_names']!, _givenNamesMeta),
      );
    }
    if (data.containsKey('family_names')) {
      context.handle(
        _familyNamesMeta,
        familyNames.isAcceptableOrUnknown(
          data['family_names']!,
          _familyNamesMeta,
        ),
      );
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('is_preferred')) {
      context.handle(
        _isPreferredMeta,
        isPreferred.isAcceptableOrUnknown(
          data['is_preferred']!,
          _isPreferredMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('modified_at')) {
      context.handle(
        _modifiedAtMeta,
        modifiedAt.isAcceptableOrUnknown(data['modified_at']!, _modifiedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_modifiedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PersonName map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PersonName(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      personId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}person_id'],
      )!,
      givenNames: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}given_names'],
      ),
      familyNames: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}family_names'],
      ),
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      isPreferred: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_preferred'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      modifiedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}modified_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $PersonNamesTable createAlias(String alias) {
    return $PersonNamesTable(attachedDatabase, alias);
  }
}

class PersonName extends DataClass implements Insertable<PersonName> {
  final String id;
  final String personId;
  final String? givenNames;
  final String? familyNames;
  final String displayName;
  final String type;
  final bool isPreferred;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final DateTime? deletedAt;
  const PersonName({
    required this.id,
    required this.personId,
    this.givenNames,
    this.familyNames,
    required this.displayName,
    required this.type,
    required this.isPreferred,
    required this.createdAt,
    required this.modifiedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['person_id'] = Variable<String>(personId);
    if (!nullToAbsent || givenNames != null) {
      map['given_names'] = Variable<String>(givenNames);
    }
    if (!nullToAbsent || familyNames != null) {
      map['family_names'] = Variable<String>(familyNames);
    }
    map['display_name'] = Variable<String>(displayName);
    map['type'] = Variable<String>(type);
    map['is_preferred'] = Variable<bool>(isPreferred);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['modified_at'] = Variable<DateTime>(modifiedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  PersonNamesCompanion toCompanion(bool nullToAbsent) {
    return PersonNamesCompanion(
      id: Value(id),
      personId: Value(personId),
      givenNames: givenNames == null && nullToAbsent
          ? const Value.absent()
          : Value(givenNames),
      familyNames: familyNames == null && nullToAbsent
          ? const Value.absent()
          : Value(familyNames),
      displayName: Value(displayName),
      type: Value(type),
      isPreferred: Value(isPreferred),
      createdAt: Value(createdAt),
      modifiedAt: Value(modifiedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory PersonName.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PersonName(
      id: serializer.fromJson<String>(json['id']),
      personId: serializer.fromJson<String>(json['personId']),
      givenNames: serializer.fromJson<String?>(json['givenNames']),
      familyNames: serializer.fromJson<String?>(json['familyNames']),
      displayName: serializer.fromJson<String>(json['displayName']),
      type: serializer.fromJson<String>(json['type']),
      isPreferred: serializer.fromJson<bool>(json['isPreferred']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      modifiedAt: serializer.fromJson<DateTime>(json['modifiedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'personId': serializer.toJson<String>(personId),
      'givenNames': serializer.toJson<String?>(givenNames),
      'familyNames': serializer.toJson<String?>(familyNames),
      'displayName': serializer.toJson<String>(displayName),
      'type': serializer.toJson<String>(type),
      'isPreferred': serializer.toJson<bool>(isPreferred),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'modifiedAt': serializer.toJson<DateTime>(modifiedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  PersonName copyWith({
    String? id,
    String? personId,
    Value<String?> givenNames = const Value.absent(),
    Value<String?> familyNames = const Value.absent(),
    String? displayName,
    String? type,
    bool? isPreferred,
    DateTime? createdAt,
    DateTime? modifiedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => PersonName(
    id: id ?? this.id,
    personId: personId ?? this.personId,
    givenNames: givenNames.present ? givenNames.value : this.givenNames,
    familyNames: familyNames.present ? familyNames.value : this.familyNames,
    displayName: displayName ?? this.displayName,
    type: type ?? this.type,
    isPreferred: isPreferred ?? this.isPreferred,
    createdAt: createdAt ?? this.createdAt,
    modifiedAt: modifiedAt ?? this.modifiedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  PersonName copyWithCompanion(PersonNamesCompanion data) {
    return PersonName(
      id: data.id.present ? data.id.value : this.id,
      personId: data.personId.present ? data.personId.value : this.personId,
      givenNames: data.givenNames.present
          ? data.givenNames.value
          : this.givenNames,
      familyNames: data.familyNames.present
          ? data.familyNames.value
          : this.familyNames,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      type: data.type.present ? data.type.value : this.type,
      isPreferred: data.isPreferred.present
          ? data.isPreferred.value
          : this.isPreferred,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      modifiedAt: data.modifiedAt.present
          ? data.modifiedAt.value
          : this.modifiedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PersonName(')
          ..write('id: $id, ')
          ..write('personId: $personId, ')
          ..write('givenNames: $givenNames, ')
          ..write('familyNames: $familyNames, ')
          ..write('displayName: $displayName, ')
          ..write('type: $type, ')
          ..write('isPreferred: $isPreferred, ')
          ..write('createdAt: $createdAt, ')
          ..write('modifiedAt: $modifiedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    personId,
    givenNames,
    familyNames,
    displayName,
    type,
    isPreferred,
    createdAt,
    modifiedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PersonName &&
          other.id == this.id &&
          other.personId == this.personId &&
          other.givenNames == this.givenNames &&
          other.familyNames == this.familyNames &&
          other.displayName == this.displayName &&
          other.type == this.type &&
          other.isPreferred == this.isPreferred &&
          other.createdAt == this.createdAt &&
          other.modifiedAt == this.modifiedAt &&
          other.deletedAt == this.deletedAt);
}

class PersonNamesCompanion extends UpdateCompanion<PersonName> {
  final Value<String> id;
  final Value<String> personId;
  final Value<String?> givenNames;
  final Value<String?> familyNames;
  final Value<String> displayName;
  final Value<String> type;
  final Value<bool> isPreferred;
  final Value<DateTime> createdAt;
  final Value<DateTime> modifiedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const PersonNamesCompanion({
    this.id = const Value.absent(),
    this.personId = const Value.absent(),
    this.givenNames = const Value.absent(),
    this.familyNames = const Value.absent(),
    this.displayName = const Value.absent(),
    this.type = const Value.absent(),
    this.isPreferred = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.modifiedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PersonNamesCompanion.insert({
    required String id,
    required String personId,
    this.givenNames = const Value.absent(),
    this.familyNames = const Value.absent(),
    required String displayName,
    required String type,
    this.isPreferred = const Value.absent(),
    required DateTime createdAt,
    required DateTime modifiedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       personId = Value(personId),
       displayName = Value(displayName),
       type = Value(type),
       createdAt = Value(createdAt),
       modifiedAt = Value(modifiedAt);
  static Insertable<PersonName> custom({
    Expression<String>? id,
    Expression<String>? personId,
    Expression<String>? givenNames,
    Expression<String>? familyNames,
    Expression<String>? displayName,
    Expression<String>? type,
    Expression<bool>? isPreferred,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? modifiedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (personId != null) 'person_id': personId,
      if (givenNames != null) 'given_names': givenNames,
      if (familyNames != null) 'family_names': familyNames,
      if (displayName != null) 'display_name': displayName,
      if (type != null) 'type': type,
      if (isPreferred != null) 'is_preferred': isPreferred,
      if (createdAt != null) 'created_at': createdAt,
      if (modifiedAt != null) 'modified_at': modifiedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PersonNamesCompanion copyWith({
    Value<String>? id,
    Value<String>? personId,
    Value<String?>? givenNames,
    Value<String?>? familyNames,
    Value<String>? displayName,
    Value<String>? type,
    Value<bool>? isPreferred,
    Value<DateTime>? createdAt,
    Value<DateTime>? modifiedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return PersonNamesCompanion(
      id: id ?? this.id,
      personId: personId ?? this.personId,
      givenNames: givenNames ?? this.givenNames,
      familyNames: familyNames ?? this.familyNames,
      displayName: displayName ?? this.displayName,
      type: type ?? this.type,
      isPreferred: isPreferred ?? this.isPreferred,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (personId.present) {
      map['person_id'] = Variable<String>(personId.value);
    }
    if (givenNames.present) {
      map['given_names'] = Variable<String>(givenNames.value);
    }
    if (familyNames.present) {
      map['family_names'] = Variable<String>(familyNames.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (isPreferred.present) {
      map['is_preferred'] = Variable<bool>(isPreferred.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (modifiedAt.present) {
      map['modified_at'] = Variable<DateTime>(modifiedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PersonNamesCompanion(')
          ..write('id: $id, ')
          ..write('personId: $personId, ')
          ..write('givenNames: $givenNames, ')
          ..write('familyNames: $familyNames, ')
          ..write('displayName: $displayName, ')
          ..write('type: $type, ')
          ..write('isPreferred: $isPreferred, ')
          ..write('createdAt: $createdAt, ')
          ..write('modifiedAt: $modifiedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ParentChildRelationshipsTable extends ParentChildRelationships
    with TableInfo<$ParentChildRelationshipsTable, ParentChildRelationship> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ParentChildRelationshipsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parentPersonIdMeta = const VerificationMeta(
    'parentPersonId',
  );
  @override
  late final GeneratedColumn<String> parentPersonId = GeneratedColumn<String>(
    'parent_person_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES persons (id)',
    ),
  );
  static const VerificationMeta _childPersonIdMeta = const VerificationMeta(
    'childPersonId',
  );
  @override
  late final GeneratedColumn<String> childPersonId = GeneratedColumn<String>(
    'child_person_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES persons (id)',
    ),
  );
  static const VerificationMeta _natureMeta = const VerificationMeta('nature');
  @override
  late final GeneratedColumn<String> nature = GeneratedColumn<String>(
    'nature',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startPrecisionMeta = const VerificationMeta(
    'startPrecision',
  );
  @override
  late final GeneratedColumn<String> startPrecision = GeneratedColumn<String>(
    'start_precision',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startStartDateMeta = const VerificationMeta(
    'startStartDate',
  );
  @override
  late final GeneratedColumn<DateTime> startStartDate =
      GeneratedColumn<DateTime>(
        'start_start_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _startEndDateMeta = const VerificationMeta(
    'startEndDate',
  );
  @override
  late final GeneratedColumn<DateTime> startEndDate = GeneratedColumn<DateTime>(
    'start_end_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startDisplayTextMeta = const VerificationMeta(
    'startDisplayText',
  );
  @override
  late final GeneratedColumn<String> startDisplayText = GeneratedColumn<String>(
    'start_display_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endPrecisionMeta = const VerificationMeta(
    'endPrecision',
  );
  @override
  late final GeneratedColumn<String> endPrecision = GeneratedColumn<String>(
    'end_precision',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endStartDateMeta = const VerificationMeta(
    'endStartDate',
  );
  @override
  late final GeneratedColumn<DateTime> endStartDate = GeneratedColumn<DateTime>(
    'end_start_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endEndDateMeta = const VerificationMeta(
    'endEndDate',
  );
  @override
  late final GeneratedColumn<DateTime> endEndDate = GeneratedColumn<DateTime>(
    'end_end_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endDisplayTextMeta = const VerificationMeta(
    'endDisplayText',
  );
  @override
  late final GeneratedColumn<String> endDisplayText = GeneratedColumn<String>(
    'end_display_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modifiedAtMeta = const VerificationMeta(
    'modifiedAt',
  );
  @override
  late final GeneratedColumn<DateTime> modifiedAt = GeneratedColumn<DateTime>(
    'modified_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    parentPersonId,
    childPersonId,
    nature,
    startPrecision,
    startStartDate,
    startEndDate,
    startDisplayText,
    endPrecision,
    endStartDate,
    endEndDate,
    endDisplayText,
    notes,
    createdAt,
    modifiedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'parent_child_relationships';
  @override
  VerificationContext validateIntegrity(
    Insertable<ParentChildRelationship> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('parent_person_id')) {
      context.handle(
        _parentPersonIdMeta,
        parentPersonId.isAcceptableOrUnknown(
          data['parent_person_id']!,
          _parentPersonIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_parentPersonIdMeta);
    }
    if (data.containsKey('child_person_id')) {
      context.handle(
        _childPersonIdMeta,
        childPersonId.isAcceptableOrUnknown(
          data['child_person_id']!,
          _childPersonIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_childPersonIdMeta);
    }
    if (data.containsKey('nature')) {
      context.handle(
        _natureMeta,
        nature.isAcceptableOrUnknown(data['nature']!, _natureMeta),
      );
    } else if (isInserting) {
      context.missing(_natureMeta);
    }
    if (data.containsKey('start_precision')) {
      context.handle(
        _startPrecisionMeta,
        startPrecision.isAcceptableOrUnknown(
          data['start_precision']!,
          _startPrecisionMeta,
        ),
      );
    }
    if (data.containsKey('start_start_date')) {
      context.handle(
        _startStartDateMeta,
        startStartDate.isAcceptableOrUnknown(
          data['start_start_date']!,
          _startStartDateMeta,
        ),
      );
    }
    if (data.containsKey('start_end_date')) {
      context.handle(
        _startEndDateMeta,
        startEndDate.isAcceptableOrUnknown(
          data['start_end_date']!,
          _startEndDateMeta,
        ),
      );
    }
    if (data.containsKey('start_display_text')) {
      context.handle(
        _startDisplayTextMeta,
        startDisplayText.isAcceptableOrUnknown(
          data['start_display_text']!,
          _startDisplayTextMeta,
        ),
      );
    }
    if (data.containsKey('end_precision')) {
      context.handle(
        _endPrecisionMeta,
        endPrecision.isAcceptableOrUnknown(
          data['end_precision']!,
          _endPrecisionMeta,
        ),
      );
    }
    if (data.containsKey('end_start_date')) {
      context.handle(
        _endStartDateMeta,
        endStartDate.isAcceptableOrUnknown(
          data['end_start_date']!,
          _endStartDateMeta,
        ),
      );
    }
    if (data.containsKey('end_end_date')) {
      context.handle(
        _endEndDateMeta,
        endEndDate.isAcceptableOrUnknown(
          data['end_end_date']!,
          _endEndDateMeta,
        ),
      );
    }
    if (data.containsKey('end_display_text')) {
      context.handle(
        _endDisplayTextMeta,
        endDisplayText.isAcceptableOrUnknown(
          data['end_display_text']!,
          _endDisplayTextMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('modified_at')) {
      context.handle(
        _modifiedAtMeta,
        modifiedAt.isAcceptableOrUnknown(data['modified_at']!, _modifiedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_modifiedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ParentChildRelationship map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ParentChildRelationship(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      parentPersonId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_person_id'],
      )!,
      childPersonId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}child_person_id'],
      )!,
      nature: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nature'],
      )!,
      startPrecision: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_precision'],
      ),
      startStartDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_start_date'],
      ),
      startEndDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_end_date'],
      ),
      startDisplayText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_display_text'],
      ),
      endPrecision: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_precision'],
      ),
      endStartDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_start_date'],
      ),
      endEndDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_end_date'],
      ),
      endDisplayText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_display_text'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      modifiedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}modified_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $ParentChildRelationshipsTable createAlias(String alias) {
    return $ParentChildRelationshipsTable(attachedDatabase, alias);
  }
}

class ParentChildRelationship extends DataClass
    implements Insertable<ParentChildRelationship> {
  final String id;
  final String parentPersonId;
  final String childPersonId;
  final String nature;
  final String? startPrecision;
  final DateTime? startStartDate;
  final DateTime? startEndDate;
  final String? startDisplayText;
  final String? endPrecision;
  final DateTime? endStartDate;
  final DateTime? endEndDate;
  final String? endDisplayText;
  final String? notes;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final DateTime? deletedAt;
  const ParentChildRelationship({
    required this.id,
    required this.parentPersonId,
    required this.childPersonId,
    required this.nature,
    this.startPrecision,
    this.startStartDate,
    this.startEndDate,
    this.startDisplayText,
    this.endPrecision,
    this.endStartDate,
    this.endEndDate,
    this.endDisplayText,
    this.notes,
    required this.createdAt,
    required this.modifiedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['parent_person_id'] = Variable<String>(parentPersonId);
    map['child_person_id'] = Variable<String>(childPersonId);
    map['nature'] = Variable<String>(nature);
    if (!nullToAbsent || startPrecision != null) {
      map['start_precision'] = Variable<String>(startPrecision);
    }
    if (!nullToAbsent || startStartDate != null) {
      map['start_start_date'] = Variable<DateTime>(startStartDate);
    }
    if (!nullToAbsent || startEndDate != null) {
      map['start_end_date'] = Variable<DateTime>(startEndDate);
    }
    if (!nullToAbsent || startDisplayText != null) {
      map['start_display_text'] = Variable<String>(startDisplayText);
    }
    if (!nullToAbsent || endPrecision != null) {
      map['end_precision'] = Variable<String>(endPrecision);
    }
    if (!nullToAbsent || endStartDate != null) {
      map['end_start_date'] = Variable<DateTime>(endStartDate);
    }
    if (!nullToAbsent || endEndDate != null) {
      map['end_end_date'] = Variable<DateTime>(endEndDate);
    }
    if (!nullToAbsent || endDisplayText != null) {
      map['end_display_text'] = Variable<String>(endDisplayText);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['modified_at'] = Variable<DateTime>(modifiedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  ParentChildRelationshipsCompanion toCompanion(bool nullToAbsent) {
    return ParentChildRelationshipsCompanion(
      id: Value(id),
      parentPersonId: Value(parentPersonId),
      childPersonId: Value(childPersonId),
      nature: Value(nature),
      startPrecision: startPrecision == null && nullToAbsent
          ? const Value.absent()
          : Value(startPrecision),
      startStartDate: startStartDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startStartDate),
      startEndDate: startEndDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startEndDate),
      startDisplayText: startDisplayText == null && nullToAbsent
          ? const Value.absent()
          : Value(startDisplayText),
      endPrecision: endPrecision == null && nullToAbsent
          ? const Value.absent()
          : Value(endPrecision),
      endStartDate: endStartDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endStartDate),
      endEndDate: endEndDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endEndDate),
      endDisplayText: endDisplayText == null && nullToAbsent
          ? const Value.absent()
          : Value(endDisplayText),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      modifiedAt: Value(modifiedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory ParentChildRelationship.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ParentChildRelationship(
      id: serializer.fromJson<String>(json['id']),
      parentPersonId: serializer.fromJson<String>(json['parentPersonId']),
      childPersonId: serializer.fromJson<String>(json['childPersonId']),
      nature: serializer.fromJson<String>(json['nature']),
      startPrecision: serializer.fromJson<String?>(json['startPrecision']),
      startStartDate: serializer.fromJson<DateTime?>(json['startStartDate']),
      startEndDate: serializer.fromJson<DateTime?>(json['startEndDate']),
      startDisplayText: serializer.fromJson<String?>(json['startDisplayText']),
      endPrecision: serializer.fromJson<String?>(json['endPrecision']),
      endStartDate: serializer.fromJson<DateTime?>(json['endStartDate']),
      endEndDate: serializer.fromJson<DateTime?>(json['endEndDate']),
      endDisplayText: serializer.fromJson<String?>(json['endDisplayText']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      modifiedAt: serializer.fromJson<DateTime>(json['modifiedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'parentPersonId': serializer.toJson<String>(parentPersonId),
      'childPersonId': serializer.toJson<String>(childPersonId),
      'nature': serializer.toJson<String>(nature),
      'startPrecision': serializer.toJson<String?>(startPrecision),
      'startStartDate': serializer.toJson<DateTime?>(startStartDate),
      'startEndDate': serializer.toJson<DateTime?>(startEndDate),
      'startDisplayText': serializer.toJson<String?>(startDisplayText),
      'endPrecision': serializer.toJson<String?>(endPrecision),
      'endStartDate': serializer.toJson<DateTime?>(endStartDate),
      'endEndDate': serializer.toJson<DateTime?>(endEndDate),
      'endDisplayText': serializer.toJson<String?>(endDisplayText),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'modifiedAt': serializer.toJson<DateTime>(modifiedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  ParentChildRelationship copyWith({
    String? id,
    String? parentPersonId,
    String? childPersonId,
    String? nature,
    Value<String?> startPrecision = const Value.absent(),
    Value<DateTime?> startStartDate = const Value.absent(),
    Value<DateTime?> startEndDate = const Value.absent(),
    Value<String?> startDisplayText = const Value.absent(),
    Value<String?> endPrecision = const Value.absent(),
    Value<DateTime?> endStartDate = const Value.absent(),
    Value<DateTime?> endEndDate = const Value.absent(),
    Value<String?> endDisplayText = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? modifiedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => ParentChildRelationship(
    id: id ?? this.id,
    parentPersonId: parentPersonId ?? this.parentPersonId,
    childPersonId: childPersonId ?? this.childPersonId,
    nature: nature ?? this.nature,
    startPrecision: startPrecision.present
        ? startPrecision.value
        : this.startPrecision,
    startStartDate: startStartDate.present
        ? startStartDate.value
        : this.startStartDate,
    startEndDate: startEndDate.present ? startEndDate.value : this.startEndDate,
    startDisplayText: startDisplayText.present
        ? startDisplayText.value
        : this.startDisplayText,
    endPrecision: endPrecision.present ? endPrecision.value : this.endPrecision,
    endStartDate: endStartDate.present ? endStartDate.value : this.endStartDate,
    endEndDate: endEndDate.present ? endEndDate.value : this.endEndDate,
    endDisplayText: endDisplayText.present
        ? endDisplayText.value
        : this.endDisplayText,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    modifiedAt: modifiedAt ?? this.modifiedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  ParentChildRelationship copyWithCompanion(
    ParentChildRelationshipsCompanion data,
  ) {
    return ParentChildRelationship(
      id: data.id.present ? data.id.value : this.id,
      parentPersonId: data.parentPersonId.present
          ? data.parentPersonId.value
          : this.parentPersonId,
      childPersonId: data.childPersonId.present
          ? data.childPersonId.value
          : this.childPersonId,
      nature: data.nature.present ? data.nature.value : this.nature,
      startPrecision: data.startPrecision.present
          ? data.startPrecision.value
          : this.startPrecision,
      startStartDate: data.startStartDate.present
          ? data.startStartDate.value
          : this.startStartDate,
      startEndDate: data.startEndDate.present
          ? data.startEndDate.value
          : this.startEndDate,
      startDisplayText: data.startDisplayText.present
          ? data.startDisplayText.value
          : this.startDisplayText,
      endPrecision: data.endPrecision.present
          ? data.endPrecision.value
          : this.endPrecision,
      endStartDate: data.endStartDate.present
          ? data.endStartDate.value
          : this.endStartDate,
      endEndDate: data.endEndDate.present
          ? data.endEndDate.value
          : this.endEndDate,
      endDisplayText: data.endDisplayText.present
          ? data.endDisplayText.value
          : this.endDisplayText,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      modifiedAt: data.modifiedAt.present
          ? data.modifiedAt.value
          : this.modifiedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ParentChildRelationship(')
          ..write('id: $id, ')
          ..write('parentPersonId: $parentPersonId, ')
          ..write('childPersonId: $childPersonId, ')
          ..write('nature: $nature, ')
          ..write('startPrecision: $startPrecision, ')
          ..write('startStartDate: $startStartDate, ')
          ..write('startEndDate: $startEndDate, ')
          ..write('startDisplayText: $startDisplayText, ')
          ..write('endPrecision: $endPrecision, ')
          ..write('endStartDate: $endStartDate, ')
          ..write('endEndDate: $endEndDate, ')
          ..write('endDisplayText: $endDisplayText, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('modifiedAt: $modifiedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    parentPersonId,
    childPersonId,
    nature,
    startPrecision,
    startStartDate,
    startEndDate,
    startDisplayText,
    endPrecision,
    endStartDate,
    endEndDate,
    endDisplayText,
    notes,
    createdAt,
    modifiedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ParentChildRelationship &&
          other.id == this.id &&
          other.parentPersonId == this.parentPersonId &&
          other.childPersonId == this.childPersonId &&
          other.nature == this.nature &&
          other.startPrecision == this.startPrecision &&
          other.startStartDate == this.startStartDate &&
          other.startEndDate == this.startEndDate &&
          other.startDisplayText == this.startDisplayText &&
          other.endPrecision == this.endPrecision &&
          other.endStartDate == this.endStartDate &&
          other.endEndDate == this.endEndDate &&
          other.endDisplayText == this.endDisplayText &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.modifiedAt == this.modifiedAt &&
          other.deletedAt == this.deletedAt);
}

class ParentChildRelationshipsCompanion
    extends UpdateCompanion<ParentChildRelationship> {
  final Value<String> id;
  final Value<String> parentPersonId;
  final Value<String> childPersonId;
  final Value<String> nature;
  final Value<String?> startPrecision;
  final Value<DateTime?> startStartDate;
  final Value<DateTime?> startEndDate;
  final Value<String?> startDisplayText;
  final Value<String?> endPrecision;
  final Value<DateTime?> endStartDate;
  final Value<DateTime?> endEndDate;
  final Value<String?> endDisplayText;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> modifiedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const ParentChildRelationshipsCompanion({
    this.id = const Value.absent(),
    this.parentPersonId = const Value.absent(),
    this.childPersonId = const Value.absent(),
    this.nature = const Value.absent(),
    this.startPrecision = const Value.absent(),
    this.startStartDate = const Value.absent(),
    this.startEndDate = const Value.absent(),
    this.startDisplayText = const Value.absent(),
    this.endPrecision = const Value.absent(),
    this.endStartDate = const Value.absent(),
    this.endEndDate = const Value.absent(),
    this.endDisplayText = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.modifiedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ParentChildRelationshipsCompanion.insert({
    required String id,
    required String parentPersonId,
    required String childPersonId,
    required String nature,
    this.startPrecision = const Value.absent(),
    this.startStartDate = const Value.absent(),
    this.startEndDate = const Value.absent(),
    this.startDisplayText = const Value.absent(),
    this.endPrecision = const Value.absent(),
    this.endStartDate = const Value.absent(),
    this.endEndDate = const Value.absent(),
    this.endDisplayText = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime modifiedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       parentPersonId = Value(parentPersonId),
       childPersonId = Value(childPersonId),
       nature = Value(nature),
       createdAt = Value(createdAt),
       modifiedAt = Value(modifiedAt);
  static Insertable<ParentChildRelationship> custom({
    Expression<String>? id,
    Expression<String>? parentPersonId,
    Expression<String>? childPersonId,
    Expression<String>? nature,
    Expression<String>? startPrecision,
    Expression<DateTime>? startStartDate,
    Expression<DateTime>? startEndDate,
    Expression<String>? startDisplayText,
    Expression<String>? endPrecision,
    Expression<DateTime>? endStartDate,
    Expression<DateTime>? endEndDate,
    Expression<String>? endDisplayText,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? modifiedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (parentPersonId != null) 'parent_person_id': parentPersonId,
      if (childPersonId != null) 'child_person_id': childPersonId,
      if (nature != null) 'nature': nature,
      if (startPrecision != null) 'start_precision': startPrecision,
      if (startStartDate != null) 'start_start_date': startStartDate,
      if (startEndDate != null) 'start_end_date': startEndDate,
      if (startDisplayText != null) 'start_display_text': startDisplayText,
      if (endPrecision != null) 'end_precision': endPrecision,
      if (endStartDate != null) 'end_start_date': endStartDate,
      if (endEndDate != null) 'end_end_date': endEndDate,
      if (endDisplayText != null) 'end_display_text': endDisplayText,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (modifiedAt != null) 'modified_at': modifiedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ParentChildRelationshipsCompanion copyWith({
    Value<String>? id,
    Value<String>? parentPersonId,
    Value<String>? childPersonId,
    Value<String>? nature,
    Value<String?>? startPrecision,
    Value<DateTime?>? startStartDate,
    Value<DateTime?>? startEndDate,
    Value<String?>? startDisplayText,
    Value<String?>? endPrecision,
    Value<DateTime?>? endStartDate,
    Value<DateTime?>? endEndDate,
    Value<String?>? endDisplayText,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? modifiedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return ParentChildRelationshipsCompanion(
      id: id ?? this.id,
      parentPersonId: parentPersonId ?? this.parentPersonId,
      childPersonId: childPersonId ?? this.childPersonId,
      nature: nature ?? this.nature,
      startPrecision: startPrecision ?? this.startPrecision,
      startStartDate: startStartDate ?? this.startStartDate,
      startEndDate: startEndDate ?? this.startEndDate,
      startDisplayText: startDisplayText ?? this.startDisplayText,
      endPrecision: endPrecision ?? this.endPrecision,
      endStartDate: endStartDate ?? this.endStartDate,
      endEndDate: endEndDate ?? this.endEndDate,
      endDisplayText: endDisplayText ?? this.endDisplayText,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (parentPersonId.present) {
      map['parent_person_id'] = Variable<String>(parentPersonId.value);
    }
    if (childPersonId.present) {
      map['child_person_id'] = Variable<String>(childPersonId.value);
    }
    if (nature.present) {
      map['nature'] = Variable<String>(nature.value);
    }
    if (startPrecision.present) {
      map['start_precision'] = Variable<String>(startPrecision.value);
    }
    if (startStartDate.present) {
      map['start_start_date'] = Variable<DateTime>(startStartDate.value);
    }
    if (startEndDate.present) {
      map['start_end_date'] = Variable<DateTime>(startEndDate.value);
    }
    if (startDisplayText.present) {
      map['start_display_text'] = Variable<String>(startDisplayText.value);
    }
    if (endPrecision.present) {
      map['end_precision'] = Variable<String>(endPrecision.value);
    }
    if (endStartDate.present) {
      map['end_start_date'] = Variable<DateTime>(endStartDate.value);
    }
    if (endEndDate.present) {
      map['end_end_date'] = Variable<DateTime>(endEndDate.value);
    }
    if (endDisplayText.present) {
      map['end_display_text'] = Variable<String>(endDisplayText.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (modifiedAt.present) {
      map['modified_at'] = Variable<DateTime>(modifiedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ParentChildRelationshipsCompanion(')
          ..write('id: $id, ')
          ..write('parentPersonId: $parentPersonId, ')
          ..write('childPersonId: $childPersonId, ')
          ..write('nature: $nature, ')
          ..write('startPrecision: $startPrecision, ')
          ..write('startStartDate: $startStartDate, ')
          ..write('startEndDate: $startEndDate, ')
          ..write('startDisplayText: $startDisplayText, ')
          ..write('endPrecision: $endPrecision, ')
          ..write('endStartDate: $endStartDate, ')
          ..write('endEndDate: $endEndDate, ')
          ..write('endDisplayText: $endDisplayText, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('modifiedAt: $modifiedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlacesTable extends Places with TableInfo<$PlacesTable, Place> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlacesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _preferredNameMeta = const VerificationMeta(
    'preferredName',
  );
  @override
  late final GeneratedColumn<String> preferredName = GeneratedColumn<String>(
    'preferred_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modifiedAtMeta = const VerificationMeta(
    'modifiedAt',
  );
  @override
  late final GeneratedColumn<DateTime> modifiedAt = GeneratedColumn<DateTime>(
    'modified_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    preferredName,
    type,
    latitude,
    longitude,
    description,
    notes,
    createdAt,
    modifiedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'places';
  @override
  VerificationContext validateIntegrity(
    Insertable<Place> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('preferred_name')) {
      context.handle(
        _preferredNameMeta,
        preferredName.isAcceptableOrUnknown(
          data['preferred_name']!,
          _preferredNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_preferredNameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('modified_at')) {
      context.handle(
        _modifiedAtMeta,
        modifiedAt.isAcceptableOrUnknown(data['modified_at']!, _modifiedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_modifiedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Place map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Place(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      preferredName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preferred_name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      ),
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      modifiedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}modified_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $PlacesTable createAlias(String alias) {
    return $PlacesTable(attachedDatabase, alias);
  }
}

class Place extends DataClass implements Insertable<Place> {
  final String id;
  final String preferredName;
  final String type;
  final double? latitude;
  final double? longitude;
  final String? description;
  final String? notes;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final DateTime? deletedAt;
  const Place({
    required this.id,
    required this.preferredName,
    required this.type,
    this.latitude,
    this.longitude,
    this.description,
    this.notes,
    required this.createdAt,
    required this.modifiedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['preferred_name'] = Variable<String>(preferredName);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['modified_at'] = Variable<DateTime>(modifiedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  PlacesCompanion toCompanion(bool nullToAbsent) {
    return PlacesCompanion(
      id: Value(id),
      preferredName: Value(preferredName),
      type: Value(type),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      modifiedAt: Value(modifiedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory Place.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Place(
      id: serializer.fromJson<String>(json['id']),
      preferredName: serializer.fromJson<String>(json['preferredName']),
      type: serializer.fromJson<String>(json['type']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      description: serializer.fromJson<String?>(json['description']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      modifiedAt: serializer.fromJson<DateTime>(json['modifiedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'preferredName': serializer.toJson<String>(preferredName),
      'type': serializer.toJson<String>(type),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'description': serializer.toJson<String?>(description),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'modifiedAt': serializer.toJson<DateTime>(modifiedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  Place copyWith({
    String? id,
    String? preferredName,
    String? type,
    Value<double?> latitude = const Value.absent(),
    Value<double?> longitude = const Value.absent(),
    Value<String?> description = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? modifiedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => Place(
    id: id ?? this.id,
    preferredName: preferredName ?? this.preferredName,
    type: type ?? this.type,
    latitude: latitude.present ? latitude.value : this.latitude,
    longitude: longitude.present ? longitude.value : this.longitude,
    description: description.present ? description.value : this.description,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    modifiedAt: modifiedAt ?? this.modifiedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  Place copyWithCompanion(PlacesCompanion data) {
    return Place(
      id: data.id.present ? data.id.value : this.id,
      preferredName: data.preferredName.present
          ? data.preferredName.value
          : this.preferredName,
      type: data.type.present ? data.type.value : this.type,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      description: data.description.present
          ? data.description.value
          : this.description,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      modifiedAt: data.modifiedAt.present
          ? data.modifiedAt.value
          : this.modifiedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Place(')
          ..write('id: $id, ')
          ..write('preferredName: $preferredName, ')
          ..write('type: $type, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('description: $description, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('modifiedAt: $modifiedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    preferredName,
    type,
    latitude,
    longitude,
    description,
    notes,
    createdAt,
    modifiedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Place &&
          other.id == this.id &&
          other.preferredName == this.preferredName &&
          other.type == this.type &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.description == this.description &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.modifiedAt == this.modifiedAt &&
          other.deletedAt == this.deletedAt);
}

class PlacesCompanion extends UpdateCompanion<Place> {
  final Value<String> id;
  final Value<String> preferredName;
  final Value<String> type;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<String?> description;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> modifiedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const PlacesCompanion({
    this.id = const Value.absent(),
    this.preferredName = const Value.absent(),
    this.type = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.description = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.modifiedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlacesCompanion.insert({
    required String id,
    required String preferredName,
    required String type,
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.description = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime modifiedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       preferredName = Value(preferredName),
       type = Value(type),
       createdAt = Value(createdAt),
       modifiedAt = Value(modifiedAt);
  static Insertable<Place> custom({
    Expression<String>? id,
    Expression<String>? preferredName,
    Expression<String>? type,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? description,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? modifiedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (preferredName != null) 'preferred_name': preferredName,
      if (type != null) 'type': type,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (description != null) 'description': description,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (modifiedAt != null) 'modified_at': modifiedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlacesCompanion copyWith({
    Value<String>? id,
    Value<String>? preferredName,
    Value<String>? type,
    Value<double?>? latitude,
    Value<double?>? longitude,
    Value<String?>? description,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? modifiedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return PlacesCompanion(
      id: id ?? this.id,
      preferredName: preferredName ?? this.preferredName,
      type: type ?? this.type,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      description: description ?? this.description,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (preferredName.present) {
      map['preferred_name'] = Variable<String>(preferredName.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (modifiedAt.present) {
      map['modified_at'] = Variable<DateTime>(modifiedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlacesCompanion(')
          ..write('id: $id, ')
          ..write('preferredName: $preferredName, ')
          ..write('type: $type, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('description: $description, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('modifiedAt: $modifiedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PartnershipsTable extends Partnerships
    with TableInfo<$PartnershipsTable, Partnership> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PartnershipsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _personAIdMeta = const VerificationMeta(
    'personAId',
  );
  @override
  late final GeneratedColumn<String> personAId = GeneratedColumn<String>(
    'person_a_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES persons (id)',
    ),
  );
  static const VerificationMeta _personBIdMeta = const VerificationMeta(
    'personBId',
  );
  @override
  late final GeneratedColumn<String> personBId = GeneratedColumn<String>(
    'person_b_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES persons (id)',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startPrecisionMeta = const VerificationMeta(
    'startPrecision',
  );
  @override
  late final GeneratedColumn<String> startPrecision = GeneratedColumn<String>(
    'start_precision',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startStartDateMeta = const VerificationMeta(
    'startStartDate',
  );
  @override
  late final GeneratedColumn<DateTime> startStartDate =
      GeneratedColumn<DateTime>(
        'start_start_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _startEndDateMeta = const VerificationMeta(
    'startEndDate',
  );
  @override
  late final GeneratedColumn<DateTime> startEndDate = GeneratedColumn<DateTime>(
    'start_end_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startDisplayTextMeta = const VerificationMeta(
    'startDisplayText',
  );
  @override
  late final GeneratedColumn<String> startDisplayText = GeneratedColumn<String>(
    'start_display_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endPrecisionMeta = const VerificationMeta(
    'endPrecision',
  );
  @override
  late final GeneratedColumn<String> endPrecision = GeneratedColumn<String>(
    'end_precision',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endStartDateMeta = const VerificationMeta(
    'endStartDate',
  );
  @override
  late final GeneratedColumn<DateTime> endStartDate = GeneratedColumn<DateTime>(
    'end_start_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endEndDateMeta = const VerificationMeta(
    'endEndDate',
  );
  @override
  late final GeneratedColumn<DateTime> endEndDate = GeneratedColumn<DateTime>(
    'end_end_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endDisplayTextMeta = const VerificationMeta(
    'endDisplayText',
  );
  @override
  late final GeneratedColumn<String> endDisplayText = GeneratedColumn<String>(
    'end_display_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _placeIdMeta = const VerificationMeta(
    'placeId',
  );
  @override
  late final GeneratedColumn<String> placeId = GeneratedColumn<String>(
    'place_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES places (id)',
    ),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modifiedAtMeta = const VerificationMeta(
    'modifiedAt',
  );
  @override
  late final GeneratedColumn<DateTime> modifiedAt = GeneratedColumn<DateTime>(
    'modified_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    personAId,
    personBId,
    type,
    startPrecision,
    startStartDate,
    startEndDate,
    startDisplayText,
    endPrecision,
    endStartDate,
    endEndDate,
    endDisplayText,
    placeId,
    notes,
    createdAt,
    modifiedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'partnerships';
  @override
  VerificationContext validateIntegrity(
    Insertable<Partnership> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('person_a_id')) {
      context.handle(
        _personAIdMeta,
        personAId.isAcceptableOrUnknown(data['person_a_id']!, _personAIdMeta),
      );
    } else if (isInserting) {
      context.missing(_personAIdMeta);
    }
    if (data.containsKey('person_b_id')) {
      context.handle(
        _personBIdMeta,
        personBId.isAcceptableOrUnknown(data['person_b_id']!, _personBIdMeta),
      );
    } else if (isInserting) {
      context.missing(_personBIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('start_precision')) {
      context.handle(
        _startPrecisionMeta,
        startPrecision.isAcceptableOrUnknown(
          data['start_precision']!,
          _startPrecisionMeta,
        ),
      );
    }
    if (data.containsKey('start_start_date')) {
      context.handle(
        _startStartDateMeta,
        startStartDate.isAcceptableOrUnknown(
          data['start_start_date']!,
          _startStartDateMeta,
        ),
      );
    }
    if (data.containsKey('start_end_date')) {
      context.handle(
        _startEndDateMeta,
        startEndDate.isAcceptableOrUnknown(
          data['start_end_date']!,
          _startEndDateMeta,
        ),
      );
    }
    if (data.containsKey('start_display_text')) {
      context.handle(
        _startDisplayTextMeta,
        startDisplayText.isAcceptableOrUnknown(
          data['start_display_text']!,
          _startDisplayTextMeta,
        ),
      );
    }
    if (data.containsKey('end_precision')) {
      context.handle(
        _endPrecisionMeta,
        endPrecision.isAcceptableOrUnknown(
          data['end_precision']!,
          _endPrecisionMeta,
        ),
      );
    }
    if (data.containsKey('end_start_date')) {
      context.handle(
        _endStartDateMeta,
        endStartDate.isAcceptableOrUnknown(
          data['end_start_date']!,
          _endStartDateMeta,
        ),
      );
    }
    if (data.containsKey('end_end_date')) {
      context.handle(
        _endEndDateMeta,
        endEndDate.isAcceptableOrUnknown(
          data['end_end_date']!,
          _endEndDateMeta,
        ),
      );
    }
    if (data.containsKey('end_display_text')) {
      context.handle(
        _endDisplayTextMeta,
        endDisplayText.isAcceptableOrUnknown(
          data['end_display_text']!,
          _endDisplayTextMeta,
        ),
      );
    }
    if (data.containsKey('place_id')) {
      context.handle(
        _placeIdMeta,
        placeId.isAcceptableOrUnknown(data['place_id']!, _placeIdMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('modified_at')) {
      context.handle(
        _modifiedAtMeta,
        modifiedAt.isAcceptableOrUnknown(data['modified_at']!, _modifiedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_modifiedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Partnership map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Partnership(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      personAId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}person_a_id'],
      )!,
      personBId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}person_b_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      startPrecision: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_precision'],
      ),
      startStartDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_start_date'],
      ),
      startEndDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_end_date'],
      ),
      startDisplayText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_display_text'],
      ),
      endPrecision: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_precision'],
      ),
      endStartDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_start_date'],
      ),
      endEndDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_end_date'],
      ),
      endDisplayText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_display_text'],
      ),
      placeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}place_id'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      modifiedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}modified_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $PartnershipsTable createAlias(String alias) {
    return $PartnershipsTable(attachedDatabase, alias);
  }
}

class Partnership extends DataClass implements Insertable<Partnership> {
  final String id;
  final String personAId;
  final String personBId;
  final String type;
  final String? startPrecision;
  final DateTime? startStartDate;
  final DateTime? startEndDate;
  final String? startDisplayText;
  final String? endPrecision;
  final DateTime? endStartDate;
  final DateTime? endEndDate;
  final String? endDisplayText;
  final String? placeId;
  final String? notes;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final DateTime? deletedAt;
  const Partnership({
    required this.id,
    required this.personAId,
    required this.personBId,
    required this.type,
    this.startPrecision,
    this.startStartDate,
    this.startEndDate,
    this.startDisplayText,
    this.endPrecision,
    this.endStartDate,
    this.endEndDate,
    this.endDisplayText,
    this.placeId,
    this.notes,
    required this.createdAt,
    required this.modifiedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['person_a_id'] = Variable<String>(personAId);
    map['person_b_id'] = Variable<String>(personBId);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || startPrecision != null) {
      map['start_precision'] = Variable<String>(startPrecision);
    }
    if (!nullToAbsent || startStartDate != null) {
      map['start_start_date'] = Variable<DateTime>(startStartDate);
    }
    if (!nullToAbsent || startEndDate != null) {
      map['start_end_date'] = Variable<DateTime>(startEndDate);
    }
    if (!nullToAbsent || startDisplayText != null) {
      map['start_display_text'] = Variable<String>(startDisplayText);
    }
    if (!nullToAbsent || endPrecision != null) {
      map['end_precision'] = Variable<String>(endPrecision);
    }
    if (!nullToAbsent || endStartDate != null) {
      map['end_start_date'] = Variable<DateTime>(endStartDate);
    }
    if (!nullToAbsent || endEndDate != null) {
      map['end_end_date'] = Variable<DateTime>(endEndDate);
    }
    if (!nullToAbsent || endDisplayText != null) {
      map['end_display_text'] = Variable<String>(endDisplayText);
    }
    if (!nullToAbsent || placeId != null) {
      map['place_id'] = Variable<String>(placeId);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['modified_at'] = Variable<DateTime>(modifiedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  PartnershipsCompanion toCompanion(bool nullToAbsent) {
    return PartnershipsCompanion(
      id: Value(id),
      personAId: Value(personAId),
      personBId: Value(personBId),
      type: Value(type),
      startPrecision: startPrecision == null && nullToAbsent
          ? const Value.absent()
          : Value(startPrecision),
      startStartDate: startStartDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startStartDate),
      startEndDate: startEndDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startEndDate),
      startDisplayText: startDisplayText == null && nullToAbsent
          ? const Value.absent()
          : Value(startDisplayText),
      endPrecision: endPrecision == null && nullToAbsent
          ? const Value.absent()
          : Value(endPrecision),
      endStartDate: endStartDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endStartDate),
      endEndDate: endEndDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endEndDate),
      endDisplayText: endDisplayText == null && nullToAbsent
          ? const Value.absent()
          : Value(endDisplayText),
      placeId: placeId == null && nullToAbsent
          ? const Value.absent()
          : Value(placeId),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      modifiedAt: Value(modifiedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory Partnership.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Partnership(
      id: serializer.fromJson<String>(json['id']),
      personAId: serializer.fromJson<String>(json['personAId']),
      personBId: serializer.fromJson<String>(json['personBId']),
      type: serializer.fromJson<String>(json['type']),
      startPrecision: serializer.fromJson<String?>(json['startPrecision']),
      startStartDate: serializer.fromJson<DateTime?>(json['startStartDate']),
      startEndDate: serializer.fromJson<DateTime?>(json['startEndDate']),
      startDisplayText: serializer.fromJson<String?>(json['startDisplayText']),
      endPrecision: serializer.fromJson<String?>(json['endPrecision']),
      endStartDate: serializer.fromJson<DateTime?>(json['endStartDate']),
      endEndDate: serializer.fromJson<DateTime?>(json['endEndDate']),
      endDisplayText: serializer.fromJson<String?>(json['endDisplayText']),
      placeId: serializer.fromJson<String?>(json['placeId']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      modifiedAt: serializer.fromJson<DateTime>(json['modifiedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'personAId': serializer.toJson<String>(personAId),
      'personBId': serializer.toJson<String>(personBId),
      'type': serializer.toJson<String>(type),
      'startPrecision': serializer.toJson<String?>(startPrecision),
      'startStartDate': serializer.toJson<DateTime?>(startStartDate),
      'startEndDate': serializer.toJson<DateTime?>(startEndDate),
      'startDisplayText': serializer.toJson<String?>(startDisplayText),
      'endPrecision': serializer.toJson<String?>(endPrecision),
      'endStartDate': serializer.toJson<DateTime?>(endStartDate),
      'endEndDate': serializer.toJson<DateTime?>(endEndDate),
      'endDisplayText': serializer.toJson<String?>(endDisplayText),
      'placeId': serializer.toJson<String?>(placeId),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'modifiedAt': serializer.toJson<DateTime>(modifiedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  Partnership copyWith({
    String? id,
    String? personAId,
    String? personBId,
    String? type,
    Value<String?> startPrecision = const Value.absent(),
    Value<DateTime?> startStartDate = const Value.absent(),
    Value<DateTime?> startEndDate = const Value.absent(),
    Value<String?> startDisplayText = const Value.absent(),
    Value<String?> endPrecision = const Value.absent(),
    Value<DateTime?> endStartDate = const Value.absent(),
    Value<DateTime?> endEndDate = const Value.absent(),
    Value<String?> endDisplayText = const Value.absent(),
    Value<String?> placeId = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? modifiedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => Partnership(
    id: id ?? this.id,
    personAId: personAId ?? this.personAId,
    personBId: personBId ?? this.personBId,
    type: type ?? this.type,
    startPrecision: startPrecision.present
        ? startPrecision.value
        : this.startPrecision,
    startStartDate: startStartDate.present
        ? startStartDate.value
        : this.startStartDate,
    startEndDate: startEndDate.present ? startEndDate.value : this.startEndDate,
    startDisplayText: startDisplayText.present
        ? startDisplayText.value
        : this.startDisplayText,
    endPrecision: endPrecision.present ? endPrecision.value : this.endPrecision,
    endStartDate: endStartDate.present ? endStartDate.value : this.endStartDate,
    endEndDate: endEndDate.present ? endEndDate.value : this.endEndDate,
    endDisplayText: endDisplayText.present
        ? endDisplayText.value
        : this.endDisplayText,
    placeId: placeId.present ? placeId.value : this.placeId,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    modifiedAt: modifiedAt ?? this.modifiedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  Partnership copyWithCompanion(PartnershipsCompanion data) {
    return Partnership(
      id: data.id.present ? data.id.value : this.id,
      personAId: data.personAId.present ? data.personAId.value : this.personAId,
      personBId: data.personBId.present ? data.personBId.value : this.personBId,
      type: data.type.present ? data.type.value : this.type,
      startPrecision: data.startPrecision.present
          ? data.startPrecision.value
          : this.startPrecision,
      startStartDate: data.startStartDate.present
          ? data.startStartDate.value
          : this.startStartDate,
      startEndDate: data.startEndDate.present
          ? data.startEndDate.value
          : this.startEndDate,
      startDisplayText: data.startDisplayText.present
          ? data.startDisplayText.value
          : this.startDisplayText,
      endPrecision: data.endPrecision.present
          ? data.endPrecision.value
          : this.endPrecision,
      endStartDate: data.endStartDate.present
          ? data.endStartDate.value
          : this.endStartDate,
      endEndDate: data.endEndDate.present
          ? data.endEndDate.value
          : this.endEndDate,
      endDisplayText: data.endDisplayText.present
          ? data.endDisplayText.value
          : this.endDisplayText,
      placeId: data.placeId.present ? data.placeId.value : this.placeId,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      modifiedAt: data.modifiedAt.present
          ? data.modifiedAt.value
          : this.modifiedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Partnership(')
          ..write('id: $id, ')
          ..write('personAId: $personAId, ')
          ..write('personBId: $personBId, ')
          ..write('type: $type, ')
          ..write('startPrecision: $startPrecision, ')
          ..write('startStartDate: $startStartDate, ')
          ..write('startEndDate: $startEndDate, ')
          ..write('startDisplayText: $startDisplayText, ')
          ..write('endPrecision: $endPrecision, ')
          ..write('endStartDate: $endStartDate, ')
          ..write('endEndDate: $endEndDate, ')
          ..write('endDisplayText: $endDisplayText, ')
          ..write('placeId: $placeId, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('modifiedAt: $modifiedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    personAId,
    personBId,
    type,
    startPrecision,
    startStartDate,
    startEndDate,
    startDisplayText,
    endPrecision,
    endStartDate,
    endEndDate,
    endDisplayText,
    placeId,
    notes,
    createdAt,
    modifiedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Partnership &&
          other.id == this.id &&
          other.personAId == this.personAId &&
          other.personBId == this.personBId &&
          other.type == this.type &&
          other.startPrecision == this.startPrecision &&
          other.startStartDate == this.startStartDate &&
          other.startEndDate == this.startEndDate &&
          other.startDisplayText == this.startDisplayText &&
          other.endPrecision == this.endPrecision &&
          other.endStartDate == this.endStartDate &&
          other.endEndDate == this.endEndDate &&
          other.endDisplayText == this.endDisplayText &&
          other.placeId == this.placeId &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.modifiedAt == this.modifiedAt &&
          other.deletedAt == this.deletedAt);
}

class PartnershipsCompanion extends UpdateCompanion<Partnership> {
  final Value<String> id;
  final Value<String> personAId;
  final Value<String> personBId;
  final Value<String> type;
  final Value<String?> startPrecision;
  final Value<DateTime?> startStartDate;
  final Value<DateTime?> startEndDate;
  final Value<String?> startDisplayText;
  final Value<String?> endPrecision;
  final Value<DateTime?> endStartDate;
  final Value<DateTime?> endEndDate;
  final Value<String?> endDisplayText;
  final Value<String?> placeId;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> modifiedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const PartnershipsCompanion({
    this.id = const Value.absent(),
    this.personAId = const Value.absent(),
    this.personBId = const Value.absent(),
    this.type = const Value.absent(),
    this.startPrecision = const Value.absent(),
    this.startStartDate = const Value.absent(),
    this.startEndDate = const Value.absent(),
    this.startDisplayText = const Value.absent(),
    this.endPrecision = const Value.absent(),
    this.endStartDate = const Value.absent(),
    this.endEndDate = const Value.absent(),
    this.endDisplayText = const Value.absent(),
    this.placeId = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.modifiedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PartnershipsCompanion.insert({
    required String id,
    required String personAId,
    required String personBId,
    required String type,
    this.startPrecision = const Value.absent(),
    this.startStartDate = const Value.absent(),
    this.startEndDate = const Value.absent(),
    this.startDisplayText = const Value.absent(),
    this.endPrecision = const Value.absent(),
    this.endStartDate = const Value.absent(),
    this.endEndDate = const Value.absent(),
    this.endDisplayText = const Value.absent(),
    this.placeId = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime modifiedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       personAId = Value(personAId),
       personBId = Value(personBId),
       type = Value(type),
       createdAt = Value(createdAt),
       modifiedAt = Value(modifiedAt);
  static Insertable<Partnership> custom({
    Expression<String>? id,
    Expression<String>? personAId,
    Expression<String>? personBId,
    Expression<String>? type,
    Expression<String>? startPrecision,
    Expression<DateTime>? startStartDate,
    Expression<DateTime>? startEndDate,
    Expression<String>? startDisplayText,
    Expression<String>? endPrecision,
    Expression<DateTime>? endStartDate,
    Expression<DateTime>? endEndDate,
    Expression<String>? endDisplayText,
    Expression<String>? placeId,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? modifiedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (personAId != null) 'person_a_id': personAId,
      if (personBId != null) 'person_b_id': personBId,
      if (type != null) 'type': type,
      if (startPrecision != null) 'start_precision': startPrecision,
      if (startStartDate != null) 'start_start_date': startStartDate,
      if (startEndDate != null) 'start_end_date': startEndDate,
      if (startDisplayText != null) 'start_display_text': startDisplayText,
      if (endPrecision != null) 'end_precision': endPrecision,
      if (endStartDate != null) 'end_start_date': endStartDate,
      if (endEndDate != null) 'end_end_date': endEndDate,
      if (endDisplayText != null) 'end_display_text': endDisplayText,
      if (placeId != null) 'place_id': placeId,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (modifiedAt != null) 'modified_at': modifiedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PartnershipsCompanion copyWith({
    Value<String>? id,
    Value<String>? personAId,
    Value<String>? personBId,
    Value<String>? type,
    Value<String?>? startPrecision,
    Value<DateTime?>? startStartDate,
    Value<DateTime?>? startEndDate,
    Value<String?>? startDisplayText,
    Value<String?>? endPrecision,
    Value<DateTime?>? endStartDate,
    Value<DateTime?>? endEndDate,
    Value<String?>? endDisplayText,
    Value<String?>? placeId,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? modifiedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return PartnershipsCompanion(
      id: id ?? this.id,
      personAId: personAId ?? this.personAId,
      personBId: personBId ?? this.personBId,
      type: type ?? this.type,
      startPrecision: startPrecision ?? this.startPrecision,
      startStartDate: startStartDate ?? this.startStartDate,
      startEndDate: startEndDate ?? this.startEndDate,
      startDisplayText: startDisplayText ?? this.startDisplayText,
      endPrecision: endPrecision ?? this.endPrecision,
      endStartDate: endStartDate ?? this.endStartDate,
      endEndDate: endEndDate ?? this.endEndDate,
      endDisplayText: endDisplayText ?? this.endDisplayText,
      placeId: placeId ?? this.placeId,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (personAId.present) {
      map['person_a_id'] = Variable<String>(personAId.value);
    }
    if (personBId.present) {
      map['person_b_id'] = Variable<String>(personBId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (startPrecision.present) {
      map['start_precision'] = Variable<String>(startPrecision.value);
    }
    if (startStartDate.present) {
      map['start_start_date'] = Variable<DateTime>(startStartDate.value);
    }
    if (startEndDate.present) {
      map['start_end_date'] = Variable<DateTime>(startEndDate.value);
    }
    if (startDisplayText.present) {
      map['start_display_text'] = Variable<String>(startDisplayText.value);
    }
    if (endPrecision.present) {
      map['end_precision'] = Variable<String>(endPrecision.value);
    }
    if (endStartDate.present) {
      map['end_start_date'] = Variable<DateTime>(endStartDate.value);
    }
    if (endEndDate.present) {
      map['end_end_date'] = Variable<DateTime>(endEndDate.value);
    }
    if (endDisplayText.present) {
      map['end_display_text'] = Variable<String>(endDisplayText.value);
    }
    if (placeId.present) {
      map['place_id'] = Variable<String>(placeId.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (modifiedAt.present) {
      map['modified_at'] = Variable<DateTime>(modifiedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PartnershipsCompanion(')
          ..write('id: $id, ')
          ..write('personAId: $personAId, ')
          ..write('personBId: $personBId, ')
          ..write('type: $type, ')
          ..write('startPrecision: $startPrecision, ')
          ..write('startStartDate: $startStartDate, ')
          ..write('startEndDate: $startEndDate, ')
          ..write('startDisplayText: $startDisplayText, ')
          ..write('endPrecision: $endPrecision, ')
          ..write('endStartDate: $endStartDate, ')
          ..write('endEndDate: $endEndDate, ')
          ..write('endDisplayText: $endDisplayText, ')
          ..write('placeId: $placeId, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('modifiedAt: $modifiedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlaceRelationshipsTable extends PlaceRelationships
    with TableInfo<$PlaceRelationshipsTable, PlaceRelationship> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlaceRelationshipsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourcePlaceIdMeta = const VerificationMeta(
    'sourcePlaceId',
  );
  @override
  late final GeneratedColumn<String> sourcePlaceId = GeneratedColumn<String>(
    'source_place_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES places (id)',
    ),
  );
  static const VerificationMeta _targetPlaceIdMeta = const VerificationMeta(
    'targetPlaceId',
  );
  @override
  late final GeneratedColumn<String> targetPlaceId = GeneratedColumn<String>(
    'target_place_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES places (id)',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modifiedAtMeta = const VerificationMeta(
    'modifiedAt',
  );
  @override
  late final GeneratedColumn<DateTime> modifiedAt = GeneratedColumn<DateTime>(
    'modified_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sourcePlaceId,
    targetPlaceId,
    type,
    createdAt,
    modifiedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'place_relationships';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlaceRelationship> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('source_place_id')) {
      context.handle(
        _sourcePlaceIdMeta,
        sourcePlaceId.isAcceptableOrUnknown(
          data['source_place_id']!,
          _sourcePlaceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourcePlaceIdMeta);
    }
    if (data.containsKey('target_place_id')) {
      context.handle(
        _targetPlaceIdMeta,
        targetPlaceId.isAcceptableOrUnknown(
          data['target_place_id']!,
          _targetPlaceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetPlaceIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('modified_at')) {
      context.handle(
        _modifiedAtMeta,
        modifiedAt.isAcceptableOrUnknown(data['modified_at']!, _modifiedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_modifiedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlaceRelationship map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlaceRelationship(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sourcePlaceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_place_id'],
      )!,
      targetPlaceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_place_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      modifiedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}modified_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $PlaceRelationshipsTable createAlias(String alias) {
    return $PlaceRelationshipsTable(attachedDatabase, alias);
  }
}

class PlaceRelationship extends DataClass
    implements Insertable<PlaceRelationship> {
  final String id;
  final String sourcePlaceId;
  final String targetPlaceId;
  final String type;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final DateTime? deletedAt;
  const PlaceRelationship({
    required this.id,
    required this.sourcePlaceId,
    required this.targetPlaceId,
    required this.type,
    required this.createdAt,
    required this.modifiedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['source_place_id'] = Variable<String>(sourcePlaceId);
    map['target_place_id'] = Variable<String>(targetPlaceId);
    map['type'] = Variable<String>(type);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['modified_at'] = Variable<DateTime>(modifiedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  PlaceRelationshipsCompanion toCompanion(bool nullToAbsent) {
    return PlaceRelationshipsCompanion(
      id: Value(id),
      sourcePlaceId: Value(sourcePlaceId),
      targetPlaceId: Value(targetPlaceId),
      type: Value(type),
      createdAt: Value(createdAt),
      modifiedAt: Value(modifiedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory PlaceRelationship.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlaceRelationship(
      id: serializer.fromJson<String>(json['id']),
      sourcePlaceId: serializer.fromJson<String>(json['sourcePlaceId']),
      targetPlaceId: serializer.fromJson<String>(json['targetPlaceId']),
      type: serializer.fromJson<String>(json['type']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      modifiedAt: serializer.fromJson<DateTime>(json['modifiedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sourcePlaceId': serializer.toJson<String>(sourcePlaceId),
      'targetPlaceId': serializer.toJson<String>(targetPlaceId),
      'type': serializer.toJson<String>(type),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'modifiedAt': serializer.toJson<DateTime>(modifiedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  PlaceRelationship copyWith({
    String? id,
    String? sourcePlaceId,
    String? targetPlaceId,
    String? type,
    DateTime? createdAt,
    DateTime? modifiedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => PlaceRelationship(
    id: id ?? this.id,
    sourcePlaceId: sourcePlaceId ?? this.sourcePlaceId,
    targetPlaceId: targetPlaceId ?? this.targetPlaceId,
    type: type ?? this.type,
    createdAt: createdAt ?? this.createdAt,
    modifiedAt: modifiedAt ?? this.modifiedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  PlaceRelationship copyWithCompanion(PlaceRelationshipsCompanion data) {
    return PlaceRelationship(
      id: data.id.present ? data.id.value : this.id,
      sourcePlaceId: data.sourcePlaceId.present
          ? data.sourcePlaceId.value
          : this.sourcePlaceId,
      targetPlaceId: data.targetPlaceId.present
          ? data.targetPlaceId.value
          : this.targetPlaceId,
      type: data.type.present ? data.type.value : this.type,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      modifiedAt: data.modifiedAt.present
          ? data.modifiedAt.value
          : this.modifiedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlaceRelationship(')
          ..write('id: $id, ')
          ..write('sourcePlaceId: $sourcePlaceId, ')
          ..write('targetPlaceId: $targetPlaceId, ')
          ..write('type: $type, ')
          ..write('createdAt: $createdAt, ')
          ..write('modifiedAt: $modifiedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sourcePlaceId,
    targetPlaceId,
    type,
    createdAt,
    modifiedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlaceRelationship &&
          other.id == this.id &&
          other.sourcePlaceId == this.sourcePlaceId &&
          other.targetPlaceId == this.targetPlaceId &&
          other.type == this.type &&
          other.createdAt == this.createdAt &&
          other.modifiedAt == this.modifiedAt &&
          other.deletedAt == this.deletedAt);
}

class PlaceRelationshipsCompanion extends UpdateCompanion<PlaceRelationship> {
  final Value<String> id;
  final Value<String> sourcePlaceId;
  final Value<String> targetPlaceId;
  final Value<String> type;
  final Value<DateTime> createdAt;
  final Value<DateTime> modifiedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const PlaceRelationshipsCompanion({
    this.id = const Value.absent(),
    this.sourcePlaceId = const Value.absent(),
    this.targetPlaceId = const Value.absent(),
    this.type = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.modifiedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlaceRelationshipsCompanion.insert({
    required String id,
    required String sourcePlaceId,
    required String targetPlaceId,
    required String type,
    required DateTime createdAt,
    required DateTime modifiedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sourcePlaceId = Value(sourcePlaceId),
       targetPlaceId = Value(targetPlaceId),
       type = Value(type),
       createdAt = Value(createdAt),
       modifiedAt = Value(modifiedAt);
  static Insertable<PlaceRelationship> custom({
    Expression<String>? id,
    Expression<String>? sourcePlaceId,
    Expression<String>? targetPlaceId,
    Expression<String>? type,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? modifiedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourcePlaceId != null) 'source_place_id': sourcePlaceId,
      if (targetPlaceId != null) 'target_place_id': targetPlaceId,
      if (type != null) 'type': type,
      if (createdAt != null) 'created_at': createdAt,
      if (modifiedAt != null) 'modified_at': modifiedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlaceRelationshipsCompanion copyWith({
    Value<String>? id,
    Value<String>? sourcePlaceId,
    Value<String>? targetPlaceId,
    Value<String>? type,
    Value<DateTime>? createdAt,
    Value<DateTime>? modifiedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return PlaceRelationshipsCompanion(
      id: id ?? this.id,
      sourcePlaceId: sourcePlaceId ?? this.sourcePlaceId,
      targetPlaceId: targetPlaceId ?? this.targetPlaceId,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sourcePlaceId.present) {
      map['source_place_id'] = Variable<String>(sourcePlaceId.value);
    }
    if (targetPlaceId.present) {
      map['target_place_id'] = Variable<String>(targetPlaceId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (modifiedAt.present) {
      map['modified_at'] = Variable<DateTime>(modifiedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlaceRelationshipsCompanion(')
          ..write('id: $id, ')
          ..write('sourcePlaceId: $sourcePlaceId, ')
          ..write('targetPlaceId: $targetPlaceId, ')
          ..write('type: $type, ')
          ..write('createdAt: $createdAt, ')
          ..write('modifiedAt: $modifiedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ResidencesTable extends Residences
    with TableInfo<$ResidencesTable, Residence> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ResidencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _personIdMeta = const VerificationMeta(
    'personId',
  );
  @override
  late final GeneratedColumn<String> personId = GeneratedColumn<String>(
    'person_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES persons (id)',
    ),
  );
  static const VerificationMeta _placeIdMeta = const VerificationMeta(
    'placeId',
  );
  @override
  late final GeneratedColumn<String> placeId = GeneratedColumn<String>(
    'place_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES places (id)',
    ),
  );
  static const VerificationMeta _startPrecisionMeta = const VerificationMeta(
    'startPrecision',
  );
  @override
  late final GeneratedColumn<String> startPrecision = GeneratedColumn<String>(
    'start_precision',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startStartDateMeta = const VerificationMeta(
    'startStartDate',
  );
  @override
  late final GeneratedColumn<DateTime> startStartDate =
      GeneratedColumn<DateTime>(
        'start_start_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _startEndDateMeta = const VerificationMeta(
    'startEndDate',
  );
  @override
  late final GeneratedColumn<DateTime> startEndDate = GeneratedColumn<DateTime>(
    'start_end_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startDisplayTextMeta = const VerificationMeta(
    'startDisplayText',
  );
  @override
  late final GeneratedColumn<String> startDisplayText = GeneratedColumn<String>(
    'start_display_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endPrecisionMeta = const VerificationMeta(
    'endPrecision',
  );
  @override
  late final GeneratedColumn<String> endPrecision = GeneratedColumn<String>(
    'end_precision',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endStartDateMeta = const VerificationMeta(
    'endStartDate',
  );
  @override
  late final GeneratedColumn<DateTime> endStartDate = GeneratedColumn<DateTime>(
    'end_start_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endEndDateMeta = const VerificationMeta(
    'endEndDate',
  );
  @override
  late final GeneratedColumn<DateTime> endEndDate = GeneratedColumn<DateTime>(
    'end_end_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endDisplayTextMeta = const VerificationMeta(
    'endDisplayText',
  );
  @override
  late final GeneratedColumn<String> endDisplayText = GeneratedColumn<String>(
    'end_display_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modifiedAtMeta = const VerificationMeta(
    'modifiedAt',
  );
  @override
  late final GeneratedColumn<DateTime> modifiedAt = GeneratedColumn<DateTime>(
    'modified_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    personId,
    placeId,
    startPrecision,
    startStartDate,
    startEndDate,
    startDisplayText,
    endPrecision,
    endStartDate,
    endEndDate,
    endDisplayText,
    reason,
    notes,
    createdAt,
    modifiedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'residences';
  @override
  VerificationContext validateIntegrity(
    Insertable<Residence> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('person_id')) {
      context.handle(
        _personIdMeta,
        personId.isAcceptableOrUnknown(data['person_id']!, _personIdMeta),
      );
    } else if (isInserting) {
      context.missing(_personIdMeta);
    }
    if (data.containsKey('place_id')) {
      context.handle(
        _placeIdMeta,
        placeId.isAcceptableOrUnknown(data['place_id']!, _placeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_placeIdMeta);
    }
    if (data.containsKey('start_precision')) {
      context.handle(
        _startPrecisionMeta,
        startPrecision.isAcceptableOrUnknown(
          data['start_precision']!,
          _startPrecisionMeta,
        ),
      );
    }
    if (data.containsKey('start_start_date')) {
      context.handle(
        _startStartDateMeta,
        startStartDate.isAcceptableOrUnknown(
          data['start_start_date']!,
          _startStartDateMeta,
        ),
      );
    }
    if (data.containsKey('start_end_date')) {
      context.handle(
        _startEndDateMeta,
        startEndDate.isAcceptableOrUnknown(
          data['start_end_date']!,
          _startEndDateMeta,
        ),
      );
    }
    if (data.containsKey('start_display_text')) {
      context.handle(
        _startDisplayTextMeta,
        startDisplayText.isAcceptableOrUnknown(
          data['start_display_text']!,
          _startDisplayTextMeta,
        ),
      );
    }
    if (data.containsKey('end_precision')) {
      context.handle(
        _endPrecisionMeta,
        endPrecision.isAcceptableOrUnknown(
          data['end_precision']!,
          _endPrecisionMeta,
        ),
      );
    }
    if (data.containsKey('end_start_date')) {
      context.handle(
        _endStartDateMeta,
        endStartDate.isAcceptableOrUnknown(
          data['end_start_date']!,
          _endStartDateMeta,
        ),
      );
    }
    if (data.containsKey('end_end_date')) {
      context.handle(
        _endEndDateMeta,
        endEndDate.isAcceptableOrUnknown(
          data['end_end_date']!,
          _endEndDateMeta,
        ),
      );
    }
    if (data.containsKey('end_display_text')) {
      context.handle(
        _endDisplayTextMeta,
        endDisplayText.isAcceptableOrUnknown(
          data['end_display_text']!,
          _endDisplayTextMeta,
        ),
      );
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('modified_at')) {
      context.handle(
        _modifiedAtMeta,
        modifiedAt.isAcceptableOrUnknown(data['modified_at']!, _modifiedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_modifiedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Residence map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Residence(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      personId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}person_id'],
      )!,
      placeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}place_id'],
      )!,
      startPrecision: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_precision'],
      ),
      startStartDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_start_date'],
      ),
      startEndDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_end_date'],
      ),
      startDisplayText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_display_text'],
      ),
      endPrecision: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_precision'],
      ),
      endStartDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_start_date'],
      ),
      endEndDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_end_date'],
      ),
      endDisplayText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_display_text'],
      ),
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      modifiedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}modified_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $ResidencesTable createAlias(String alias) {
    return $ResidencesTable(attachedDatabase, alias);
  }
}

class Residence extends DataClass implements Insertable<Residence> {
  final String id;
  final String personId;
  final String placeId;
  final String? startPrecision;
  final DateTime? startStartDate;
  final DateTime? startEndDate;
  final String? startDisplayText;
  final String? endPrecision;
  final DateTime? endStartDate;
  final DateTime? endEndDate;
  final String? endDisplayText;
  final String? reason;
  final String? notes;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final DateTime? deletedAt;
  const Residence({
    required this.id,
    required this.personId,
    required this.placeId,
    this.startPrecision,
    this.startStartDate,
    this.startEndDate,
    this.startDisplayText,
    this.endPrecision,
    this.endStartDate,
    this.endEndDate,
    this.endDisplayText,
    this.reason,
    this.notes,
    required this.createdAt,
    required this.modifiedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['person_id'] = Variable<String>(personId);
    map['place_id'] = Variable<String>(placeId);
    if (!nullToAbsent || startPrecision != null) {
      map['start_precision'] = Variable<String>(startPrecision);
    }
    if (!nullToAbsent || startStartDate != null) {
      map['start_start_date'] = Variable<DateTime>(startStartDate);
    }
    if (!nullToAbsent || startEndDate != null) {
      map['start_end_date'] = Variable<DateTime>(startEndDate);
    }
    if (!nullToAbsent || startDisplayText != null) {
      map['start_display_text'] = Variable<String>(startDisplayText);
    }
    if (!nullToAbsent || endPrecision != null) {
      map['end_precision'] = Variable<String>(endPrecision);
    }
    if (!nullToAbsent || endStartDate != null) {
      map['end_start_date'] = Variable<DateTime>(endStartDate);
    }
    if (!nullToAbsent || endEndDate != null) {
      map['end_end_date'] = Variable<DateTime>(endEndDate);
    }
    if (!nullToAbsent || endDisplayText != null) {
      map['end_display_text'] = Variable<String>(endDisplayText);
    }
    if (!nullToAbsent || reason != null) {
      map['reason'] = Variable<String>(reason);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['modified_at'] = Variable<DateTime>(modifiedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  ResidencesCompanion toCompanion(bool nullToAbsent) {
    return ResidencesCompanion(
      id: Value(id),
      personId: Value(personId),
      placeId: Value(placeId),
      startPrecision: startPrecision == null && nullToAbsent
          ? const Value.absent()
          : Value(startPrecision),
      startStartDate: startStartDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startStartDate),
      startEndDate: startEndDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startEndDate),
      startDisplayText: startDisplayText == null && nullToAbsent
          ? const Value.absent()
          : Value(startDisplayText),
      endPrecision: endPrecision == null && nullToAbsent
          ? const Value.absent()
          : Value(endPrecision),
      endStartDate: endStartDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endStartDate),
      endEndDate: endEndDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endEndDate),
      endDisplayText: endDisplayText == null && nullToAbsent
          ? const Value.absent()
          : Value(endDisplayText),
      reason: reason == null && nullToAbsent
          ? const Value.absent()
          : Value(reason),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      modifiedAt: Value(modifiedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory Residence.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Residence(
      id: serializer.fromJson<String>(json['id']),
      personId: serializer.fromJson<String>(json['personId']),
      placeId: serializer.fromJson<String>(json['placeId']),
      startPrecision: serializer.fromJson<String?>(json['startPrecision']),
      startStartDate: serializer.fromJson<DateTime?>(json['startStartDate']),
      startEndDate: serializer.fromJson<DateTime?>(json['startEndDate']),
      startDisplayText: serializer.fromJson<String?>(json['startDisplayText']),
      endPrecision: serializer.fromJson<String?>(json['endPrecision']),
      endStartDate: serializer.fromJson<DateTime?>(json['endStartDate']),
      endEndDate: serializer.fromJson<DateTime?>(json['endEndDate']),
      endDisplayText: serializer.fromJson<String?>(json['endDisplayText']),
      reason: serializer.fromJson<String?>(json['reason']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      modifiedAt: serializer.fromJson<DateTime>(json['modifiedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'personId': serializer.toJson<String>(personId),
      'placeId': serializer.toJson<String>(placeId),
      'startPrecision': serializer.toJson<String?>(startPrecision),
      'startStartDate': serializer.toJson<DateTime?>(startStartDate),
      'startEndDate': serializer.toJson<DateTime?>(startEndDate),
      'startDisplayText': serializer.toJson<String?>(startDisplayText),
      'endPrecision': serializer.toJson<String?>(endPrecision),
      'endStartDate': serializer.toJson<DateTime?>(endStartDate),
      'endEndDate': serializer.toJson<DateTime?>(endEndDate),
      'endDisplayText': serializer.toJson<String?>(endDisplayText),
      'reason': serializer.toJson<String?>(reason),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'modifiedAt': serializer.toJson<DateTime>(modifiedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  Residence copyWith({
    String? id,
    String? personId,
    String? placeId,
    Value<String?> startPrecision = const Value.absent(),
    Value<DateTime?> startStartDate = const Value.absent(),
    Value<DateTime?> startEndDate = const Value.absent(),
    Value<String?> startDisplayText = const Value.absent(),
    Value<String?> endPrecision = const Value.absent(),
    Value<DateTime?> endStartDate = const Value.absent(),
    Value<DateTime?> endEndDate = const Value.absent(),
    Value<String?> endDisplayText = const Value.absent(),
    Value<String?> reason = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? modifiedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => Residence(
    id: id ?? this.id,
    personId: personId ?? this.personId,
    placeId: placeId ?? this.placeId,
    startPrecision: startPrecision.present
        ? startPrecision.value
        : this.startPrecision,
    startStartDate: startStartDate.present
        ? startStartDate.value
        : this.startStartDate,
    startEndDate: startEndDate.present ? startEndDate.value : this.startEndDate,
    startDisplayText: startDisplayText.present
        ? startDisplayText.value
        : this.startDisplayText,
    endPrecision: endPrecision.present ? endPrecision.value : this.endPrecision,
    endStartDate: endStartDate.present ? endStartDate.value : this.endStartDate,
    endEndDate: endEndDate.present ? endEndDate.value : this.endEndDate,
    endDisplayText: endDisplayText.present
        ? endDisplayText.value
        : this.endDisplayText,
    reason: reason.present ? reason.value : this.reason,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    modifiedAt: modifiedAt ?? this.modifiedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  Residence copyWithCompanion(ResidencesCompanion data) {
    return Residence(
      id: data.id.present ? data.id.value : this.id,
      personId: data.personId.present ? data.personId.value : this.personId,
      placeId: data.placeId.present ? data.placeId.value : this.placeId,
      startPrecision: data.startPrecision.present
          ? data.startPrecision.value
          : this.startPrecision,
      startStartDate: data.startStartDate.present
          ? data.startStartDate.value
          : this.startStartDate,
      startEndDate: data.startEndDate.present
          ? data.startEndDate.value
          : this.startEndDate,
      startDisplayText: data.startDisplayText.present
          ? data.startDisplayText.value
          : this.startDisplayText,
      endPrecision: data.endPrecision.present
          ? data.endPrecision.value
          : this.endPrecision,
      endStartDate: data.endStartDate.present
          ? data.endStartDate.value
          : this.endStartDate,
      endEndDate: data.endEndDate.present
          ? data.endEndDate.value
          : this.endEndDate,
      endDisplayText: data.endDisplayText.present
          ? data.endDisplayText.value
          : this.endDisplayText,
      reason: data.reason.present ? data.reason.value : this.reason,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      modifiedAt: data.modifiedAt.present
          ? data.modifiedAt.value
          : this.modifiedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Residence(')
          ..write('id: $id, ')
          ..write('personId: $personId, ')
          ..write('placeId: $placeId, ')
          ..write('startPrecision: $startPrecision, ')
          ..write('startStartDate: $startStartDate, ')
          ..write('startEndDate: $startEndDate, ')
          ..write('startDisplayText: $startDisplayText, ')
          ..write('endPrecision: $endPrecision, ')
          ..write('endStartDate: $endStartDate, ')
          ..write('endEndDate: $endEndDate, ')
          ..write('endDisplayText: $endDisplayText, ')
          ..write('reason: $reason, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('modifiedAt: $modifiedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    personId,
    placeId,
    startPrecision,
    startStartDate,
    startEndDate,
    startDisplayText,
    endPrecision,
    endStartDate,
    endEndDate,
    endDisplayText,
    reason,
    notes,
    createdAt,
    modifiedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Residence &&
          other.id == this.id &&
          other.personId == this.personId &&
          other.placeId == this.placeId &&
          other.startPrecision == this.startPrecision &&
          other.startStartDate == this.startStartDate &&
          other.startEndDate == this.startEndDate &&
          other.startDisplayText == this.startDisplayText &&
          other.endPrecision == this.endPrecision &&
          other.endStartDate == this.endStartDate &&
          other.endEndDate == this.endEndDate &&
          other.endDisplayText == this.endDisplayText &&
          other.reason == this.reason &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.modifiedAt == this.modifiedAt &&
          other.deletedAt == this.deletedAt);
}

class ResidencesCompanion extends UpdateCompanion<Residence> {
  final Value<String> id;
  final Value<String> personId;
  final Value<String> placeId;
  final Value<String?> startPrecision;
  final Value<DateTime?> startStartDate;
  final Value<DateTime?> startEndDate;
  final Value<String?> startDisplayText;
  final Value<String?> endPrecision;
  final Value<DateTime?> endStartDate;
  final Value<DateTime?> endEndDate;
  final Value<String?> endDisplayText;
  final Value<String?> reason;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> modifiedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const ResidencesCompanion({
    this.id = const Value.absent(),
    this.personId = const Value.absent(),
    this.placeId = const Value.absent(),
    this.startPrecision = const Value.absent(),
    this.startStartDate = const Value.absent(),
    this.startEndDate = const Value.absent(),
    this.startDisplayText = const Value.absent(),
    this.endPrecision = const Value.absent(),
    this.endStartDate = const Value.absent(),
    this.endEndDate = const Value.absent(),
    this.endDisplayText = const Value.absent(),
    this.reason = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.modifiedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ResidencesCompanion.insert({
    required String id,
    required String personId,
    required String placeId,
    this.startPrecision = const Value.absent(),
    this.startStartDate = const Value.absent(),
    this.startEndDate = const Value.absent(),
    this.startDisplayText = const Value.absent(),
    this.endPrecision = const Value.absent(),
    this.endStartDate = const Value.absent(),
    this.endEndDate = const Value.absent(),
    this.endDisplayText = const Value.absent(),
    this.reason = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime modifiedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       personId = Value(personId),
       placeId = Value(placeId),
       createdAt = Value(createdAt),
       modifiedAt = Value(modifiedAt);
  static Insertable<Residence> custom({
    Expression<String>? id,
    Expression<String>? personId,
    Expression<String>? placeId,
    Expression<String>? startPrecision,
    Expression<DateTime>? startStartDate,
    Expression<DateTime>? startEndDate,
    Expression<String>? startDisplayText,
    Expression<String>? endPrecision,
    Expression<DateTime>? endStartDate,
    Expression<DateTime>? endEndDate,
    Expression<String>? endDisplayText,
    Expression<String>? reason,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? modifiedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (personId != null) 'person_id': personId,
      if (placeId != null) 'place_id': placeId,
      if (startPrecision != null) 'start_precision': startPrecision,
      if (startStartDate != null) 'start_start_date': startStartDate,
      if (startEndDate != null) 'start_end_date': startEndDate,
      if (startDisplayText != null) 'start_display_text': startDisplayText,
      if (endPrecision != null) 'end_precision': endPrecision,
      if (endStartDate != null) 'end_start_date': endStartDate,
      if (endEndDate != null) 'end_end_date': endEndDate,
      if (endDisplayText != null) 'end_display_text': endDisplayText,
      if (reason != null) 'reason': reason,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (modifiedAt != null) 'modified_at': modifiedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ResidencesCompanion copyWith({
    Value<String>? id,
    Value<String>? personId,
    Value<String>? placeId,
    Value<String?>? startPrecision,
    Value<DateTime?>? startStartDate,
    Value<DateTime?>? startEndDate,
    Value<String?>? startDisplayText,
    Value<String?>? endPrecision,
    Value<DateTime?>? endStartDate,
    Value<DateTime?>? endEndDate,
    Value<String?>? endDisplayText,
    Value<String?>? reason,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? modifiedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return ResidencesCompanion(
      id: id ?? this.id,
      personId: personId ?? this.personId,
      placeId: placeId ?? this.placeId,
      startPrecision: startPrecision ?? this.startPrecision,
      startStartDate: startStartDate ?? this.startStartDate,
      startEndDate: startEndDate ?? this.startEndDate,
      startDisplayText: startDisplayText ?? this.startDisplayText,
      endPrecision: endPrecision ?? this.endPrecision,
      endStartDate: endStartDate ?? this.endStartDate,
      endEndDate: endEndDate ?? this.endEndDate,
      endDisplayText: endDisplayText ?? this.endDisplayText,
      reason: reason ?? this.reason,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (personId.present) {
      map['person_id'] = Variable<String>(personId.value);
    }
    if (placeId.present) {
      map['place_id'] = Variable<String>(placeId.value);
    }
    if (startPrecision.present) {
      map['start_precision'] = Variable<String>(startPrecision.value);
    }
    if (startStartDate.present) {
      map['start_start_date'] = Variable<DateTime>(startStartDate.value);
    }
    if (startEndDate.present) {
      map['start_end_date'] = Variable<DateTime>(startEndDate.value);
    }
    if (startDisplayText.present) {
      map['start_display_text'] = Variable<String>(startDisplayText.value);
    }
    if (endPrecision.present) {
      map['end_precision'] = Variable<String>(endPrecision.value);
    }
    if (endStartDate.present) {
      map['end_start_date'] = Variable<DateTime>(endStartDate.value);
    }
    if (endEndDate.present) {
      map['end_end_date'] = Variable<DateTime>(endEndDate.value);
    }
    if (endDisplayText.present) {
      map['end_display_text'] = Variable<String>(endDisplayText.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (modifiedAt.present) {
      map['modified_at'] = Variable<DateTime>(modifiedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ResidencesCompanion(')
          ..write('id: $id, ')
          ..write('personId: $personId, ')
          ..write('placeId: $placeId, ')
          ..write('startPrecision: $startPrecision, ')
          ..write('startStartDate: $startStartDate, ')
          ..write('startEndDate: $startEndDate, ')
          ..write('startDisplayText: $startDisplayText, ')
          ..write('endPrecision: $endPrecision, ')
          ..write('endStartDate: $endStartDate, ')
          ..write('endEndDate: $endEndDate, ')
          ..write('endDisplayText: $endDisplayText, ')
          ..write('reason: $reason, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('modifiedAt: $modifiedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EventsTable extends Events with TableInfo<$EventsTable, Event> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _datePrecisionMeta = const VerificationMeta(
    'datePrecision',
  );
  @override
  late final GeneratedColumn<String> datePrecision = GeneratedColumn<String>(
    'date_precision',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateStartDateMeta = const VerificationMeta(
    'dateStartDate',
  );
  @override
  late final GeneratedColumn<DateTime> dateStartDate =
      GeneratedColumn<DateTime>(
        'date_start_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _dateEndDateMeta = const VerificationMeta(
    'dateEndDate',
  );
  @override
  late final GeneratedColumn<DateTime> dateEndDate = GeneratedColumn<DateTime>(
    'date_end_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateDisplayTextMeta = const VerificationMeta(
    'dateDisplayText',
  );
  @override
  late final GeneratedColumn<String> dateDisplayText = GeneratedColumn<String>(
    'date_display_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _placeIdMeta = const VerificationMeta(
    'placeId',
  );
  @override
  late final GeneratedColumn<String> placeId = GeneratedColumn<String>(
    'place_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES places (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modifiedAtMeta = const VerificationMeta(
    'modifiedAt',
  );
  @override
  late final GeneratedColumn<DateTime> modifiedAt = GeneratedColumn<DateTime>(
    'modified_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    datePrecision,
    dateStartDate,
    dateEndDate,
    dateDisplayText,
    placeId,
    title,
    description,
    createdAt,
    modifiedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'events';
  @override
  VerificationContext validateIntegrity(
    Insertable<Event> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('date_precision')) {
      context.handle(
        _datePrecisionMeta,
        datePrecision.isAcceptableOrUnknown(
          data['date_precision']!,
          _datePrecisionMeta,
        ),
      );
    }
    if (data.containsKey('date_start_date')) {
      context.handle(
        _dateStartDateMeta,
        dateStartDate.isAcceptableOrUnknown(
          data['date_start_date']!,
          _dateStartDateMeta,
        ),
      );
    }
    if (data.containsKey('date_end_date')) {
      context.handle(
        _dateEndDateMeta,
        dateEndDate.isAcceptableOrUnknown(
          data['date_end_date']!,
          _dateEndDateMeta,
        ),
      );
    }
    if (data.containsKey('date_display_text')) {
      context.handle(
        _dateDisplayTextMeta,
        dateDisplayText.isAcceptableOrUnknown(
          data['date_display_text']!,
          _dateDisplayTextMeta,
        ),
      );
    }
    if (data.containsKey('place_id')) {
      context.handle(
        _placeIdMeta,
        placeId.isAcceptableOrUnknown(data['place_id']!, _placeIdMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('modified_at')) {
      context.handle(
        _modifiedAtMeta,
        modifiedAt.isAcceptableOrUnknown(data['modified_at']!, _modifiedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_modifiedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Event map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Event(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      datePrecision: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date_precision'],
      ),
      dateStartDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_start_date'],
      ),
      dateEndDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_end_date'],
      ),
      dateDisplayText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date_display_text'],
      ),
      placeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}place_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      modifiedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}modified_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $EventsTable createAlias(String alias) {
    return $EventsTable(attachedDatabase, alias);
  }
}

class Event extends DataClass implements Insertable<Event> {
  final String id;
  final String type;
  final String? datePrecision;
  final DateTime? dateStartDate;
  final DateTime? dateEndDate;
  final String? dateDisplayText;
  final String? placeId;
  final String? title;
  final String? description;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final DateTime? deletedAt;
  const Event({
    required this.id,
    required this.type,
    this.datePrecision,
    this.dateStartDate,
    this.dateEndDate,
    this.dateDisplayText,
    this.placeId,
    this.title,
    this.description,
    required this.createdAt,
    required this.modifiedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || datePrecision != null) {
      map['date_precision'] = Variable<String>(datePrecision);
    }
    if (!nullToAbsent || dateStartDate != null) {
      map['date_start_date'] = Variable<DateTime>(dateStartDate);
    }
    if (!nullToAbsent || dateEndDate != null) {
      map['date_end_date'] = Variable<DateTime>(dateEndDate);
    }
    if (!nullToAbsent || dateDisplayText != null) {
      map['date_display_text'] = Variable<String>(dateDisplayText);
    }
    if (!nullToAbsent || placeId != null) {
      map['place_id'] = Variable<String>(placeId);
    }
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['modified_at'] = Variable<DateTime>(modifiedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  EventsCompanion toCompanion(bool nullToAbsent) {
    return EventsCompanion(
      id: Value(id),
      type: Value(type),
      datePrecision: datePrecision == null && nullToAbsent
          ? const Value.absent()
          : Value(datePrecision),
      dateStartDate: dateStartDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dateStartDate),
      dateEndDate: dateEndDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dateEndDate),
      dateDisplayText: dateDisplayText == null && nullToAbsent
          ? const Value.absent()
          : Value(dateDisplayText),
      placeId: placeId == null && nullToAbsent
          ? const Value.absent()
          : Value(placeId),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      createdAt: Value(createdAt),
      modifiedAt: Value(modifiedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory Event.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Event(
      id: serializer.fromJson<String>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      datePrecision: serializer.fromJson<String?>(json['datePrecision']),
      dateStartDate: serializer.fromJson<DateTime?>(json['dateStartDate']),
      dateEndDate: serializer.fromJson<DateTime?>(json['dateEndDate']),
      dateDisplayText: serializer.fromJson<String?>(json['dateDisplayText']),
      placeId: serializer.fromJson<String?>(json['placeId']),
      title: serializer.fromJson<String?>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      modifiedAt: serializer.fromJson<DateTime>(json['modifiedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<String>(type),
      'datePrecision': serializer.toJson<String?>(datePrecision),
      'dateStartDate': serializer.toJson<DateTime?>(dateStartDate),
      'dateEndDate': serializer.toJson<DateTime?>(dateEndDate),
      'dateDisplayText': serializer.toJson<String?>(dateDisplayText),
      'placeId': serializer.toJson<String?>(placeId),
      'title': serializer.toJson<String?>(title),
      'description': serializer.toJson<String?>(description),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'modifiedAt': serializer.toJson<DateTime>(modifiedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  Event copyWith({
    String? id,
    String? type,
    Value<String?> datePrecision = const Value.absent(),
    Value<DateTime?> dateStartDate = const Value.absent(),
    Value<DateTime?> dateEndDate = const Value.absent(),
    Value<String?> dateDisplayText = const Value.absent(),
    Value<String?> placeId = const Value.absent(),
    Value<String?> title = const Value.absent(),
    Value<String?> description = const Value.absent(),
    DateTime? createdAt,
    DateTime? modifiedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => Event(
    id: id ?? this.id,
    type: type ?? this.type,
    datePrecision: datePrecision.present
        ? datePrecision.value
        : this.datePrecision,
    dateStartDate: dateStartDate.present
        ? dateStartDate.value
        : this.dateStartDate,
    dateEndDate: dateEndDate.present ? dateEndDate.value : this.dateEndDate,
    dateDisplayText: dateDisplayText.present
        ? dateDisplayText.value
        : this.dateDisplayText,
    placeId: placeId.present ? placeId.value : this.placeId,
    title: title.present ? title.value : this.title,
    description: description.present ? description.value : this.description,
    createdAt: createdAt ?? this.createdAt,
    modifiedAt: modifiedAt ?? this.modifiedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  Event copyWithCompanion(EventsCompanion data) {
    return Event(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      datePrecision: data.datePrecision.present
          ? data.datePrecision.value
          : this.datePrecision,
      dateStartDate: data.dateStartDate.present
          ? data.dateStartDate.value
          : this.dateStartDate,
      dateEndDate: data.dateEndDate.present
          ? data.dateEndDate.value
          : this.dateEndDate,
      dateDisplayText: data.dateDisplayText.present
          ? data.dateDisplayText.value
          : this.dateDisplayText,
      placeId: data.placeId.present ? data.placeId.value : this.placeId,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      modifiedAt: data.modifiedAt.present
          ? data.modifiedAt.value
          : this.modifiedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Event(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('datePrecision: $datePrecision, ')
          ..write('dateStartDate: $dateStartDate, ')
          ..write('dateEndDate: $dateEndDate, ')
          ..write('dateDisplayText: $dateDisplayText, ')
          ..write('placeId: $placeId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('modifiedAt: $modifiedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    type,
    datePrecision,
    dateStartDate,
    dateEndDate,
    dateDisplayText,
    placeId,
    title,
    description,
    createdAt,
    modifiedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Event &&
          other.id == this.id &&
          other.type == this.type &&
          other.datePrecision == this.datePrecision &&
          other.dateStartDate == this.dateStartDate &&
          other.dateEndDate == this.dateEndDate &&
          other.dateDisplayText == this.dateDisplayText &&
          other.placeId == this.placeId &&
          other.title == this.title &&
          other.description == this.description &&
          other.createdAt == this.createdAt &&
          other.modifiedAt == this.modifiedAt &&
          other.deletedAt == this.deletedAt);
}

class EventsCompanion extends UpdateCompanion<Event> {
  final Value<String> id;
  final Value<String> type;
  final Value<String?> datePrecision;
  final Value<DateTime?> dateStartDate;
  final Value<DateTime?> dateEndDate;
  final Value<String?> dateDisplayText;
  final Value<String?> placeId;
  final Value<String?> title;
  final Value<String?> description;
  final Value<DateTime> createdAt;
  final Value<DateTime> modifiedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const EventsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.datePrecision = const Value.absent(),
    this.dateStartDate = const Value.absent(),
    this.dateEndDate = const Value.absent(),
    this.dateDisplayText = const Value.absent(),
    this.placeId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.modifiedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EventsCompanion.insert({
    required String id,
    required String type,
    this.datePrecision = const Value.absent(),
    this.dateStartDate = const Value.absent(),
    this.dateEndDate = const Value.absent(),
    this.dateDisplayText = const Value.absent(),
    this.placeId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    required DateTime createdAt,
    required DateTime modifiedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       type = Value(type),
       createdAt = Value(createdAt),
       modifiedAt = Value(modifiedAt);
  static Insertable<Event> custom({
    Expression<String>? id,
    Expression<String>? type,
    Expression<String>? datePrecision,
    Expression<DateTime>? dateStartDate,
    Expression<DateTime>? dateEndDate,
    Expression<String>? dateDisplayText,
    Expression<String>? placeId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? modifiedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (datePrecision != null) 'date_precision': datePrecision,
      if (dateStartDate != null) 'date_start_date': dateStartDate,
      if (dateEndDate != null) 'date_end_date': dateEndDate,
      if (dateDisplayText != null) 'date_display_text': dateDisplayText,
      if (placeId != null) 'place_id': placeId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (createdAt != null) 'created_at': createdAt,
      if (modifiedAt != null) 'modified_at': modifiedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EventsCompanion copyWith({
    Value<String>? id,
    Value<String>? type,
    Value<String?>? datePrecision,
    Value<DateTime?>? dateStartDate,
    Value<DateTime?>? dateEndDate,
    Value<String?>? dateDisplayText,
    Value<String?>? placeId,
    Value<String?>? title,
    Value<String?>? description,
    Value<DateTime>? createdAt,
    Value<DateTime>? modifiedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return EventsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      datePrecision: datePrecision ?? this.datePrecision,
      dateStartDate: dateStartDate ?? this.dateStartDate,
      dateEndDate: dateEndDate ?? this.dateEndDate,
      dateDisplayText: dateDisplayText ?? this.dateDisplayText,
      placeId: placeId ?? this.placeId,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (datePrecision.present) {
      map['date_precision'] = Variable<String>(datePrecision.value);
    }
    if (dateStartDate.present) {
      map['date_start_date'] = Variable<DateTime>(dateStartDate.value);
    }
    if (dateEndDate.present) {
      map['date_end_date'] = Variable<DateTime>(dateEndDate.value);
    }
    if (dateDisplayText.present) {
      map['date_display_text'] = Variable<String>(dateDisplayText.value);
    }
    if (placeId.present) {
      map['place_id'] = Variable<String>(placeId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (modifiedAt.present) {
      map['modified_at'] = Variable<DateTime>(modifiedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('datePrecision: $datePrecision, ')
          ..write('dateStartDate: $dateStartDate, ')
          ..write('dateEndDate: $dateEndDate, ')
          ..write('dateDisplayText: $dateDisplayText, ')
          ..write('placeId: $placeId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('modifiedAt: $modifiedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EventParticipantsTable extends EventParticipants
    with TableInfo<$EventParticipantsTable, EventParticipant> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventParticipantsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventIdMeta = const VerificationMeta(
    'eventId',
  );
  @override
  late final GeneratedColumn<String> eventId = GeneratedColumn<String>(
    'event_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES events (id)',
    ),
  );
  static const VerificationMeta _personIdMeta = const VerificationMeta(
    'personId',
  );
  @override
  late final GeneratedColumn<String> personId = GeneratedColumn<String>(
    'person_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES persons (id)',
    ),
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modifiedAtMeta = const VerificationMeta(
    'modifiedAt',
  );
  @override
  late final GeneratedColumn<DateTime> modifiedAt = GeneratedColumn<DateTime>(
    'modified_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    eventId,
    personId,
    role,
    createdAt,
    modifiedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'event_participants';
  @override
  VerificationContext validateIntegrity(
    Insertable<EventParticipant> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('event_id')) {
      context.handle(
        _eventIdMeta,
        eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta),
      );
    } else if (isInserting) {
      context.missing(_eventIdMeta);
    }
    if (data.containsKey('person_id')) {
      context.handle(
        _personIdMeta,
        personId.isAcceptableOrUnknown(data['person_id']!, _personIdMeta),
      );
    } else if (isInserting) {
      context.missing(_personIdMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('modified_at')) {
      context.handle(
        _modifiedAtMeta,
        modifiedAt.isAcceptableOrUnknown(data['modified_at']!, _modifiedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_modifiedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EventParticipant map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EventParticipant(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      eventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_id'],
      )!,
      personId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}person_id'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      modifiedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}modified_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $EventParticipantsTable createAlias(String alias) {
    return $EventParticipantsTable(attachedDatabase, alias);
  }
}

class EventParticipant extends DataClass
    implements Insertable<EventParticipant> {
  final String id;
  final String eventId;
  final String personId;
  final String role;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final DateTime? deletedAt;
  const EventParticipant({
    required this.id,
    required this.eventId,
    required this.personId,
    required this.role,
    required this.createdAt,
    required this.modifiedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['event_id'] = Variable<String>(eventId);
    map['person_id'] = Variable<String>(personId);
    map['role'] = Variable<String>(role);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['modified_at'] = Variable<DateTime>(modifiedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  EventParticipantsCompanion toCompanion(bool nullToAbsent) {
    return EventParticipantsCompanion(
      id: Value(id),
      eventId: Value(eventId),
      personId: Value(personId),
      role: Value(role),
      createdAt: Value(createdAt),
      modifiedAt: Value(modifiedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory EventParticipant.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EventParticipant(
      id: serializer.fromJson<String>(json['id']),
      eventId: serializer.fromJson<String>(json['eventId']),
      personId: serializer.fromJson<String>(json['personId']),
      role: serializer.fromJson<String>(json['role']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      modifiedAt: serializer.fromJson<DateTime>(json['modifiedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'eventId': serializer.toJson<String>(eventId),
      'personId': serializer.toJson<String>(personId),
      'role': serializer.toJson<String>(role),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'modifiedAt': serializer.toJson<DateTime>(modifiedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  EventParticipant copyWith({
    String? id,
    String? eventId,
    String? personId,
    String? role,
    DateTime? createdAt,
    DateTime? modifiedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => EventParticipant(
    id: id ?? this.id,
    eventId: eventId ?? this.eventId,
    personId: personId ?? this.personId,
    role: role ?? this.role,
    createdAt: createdAt ?? this.createdAt,
    modifiedAt: modifiedAt ?? this.modifiedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  EventParticipant copyWithCompanion(EventParticipantsCompanion data) {
    return EventParticipant(
      id: data.id.present ? data.id.value : this.id,
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      personId: data.personId.present ? data.personId.value : this.personId,
      role: data.role.present ? data.role.value : this.role,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      modifiedAt: data.modifiedAt.present
          ? data.modifiedAt.value
          : this.modifiedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EventParticipant(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('personId: $personId, ')
          ..write('role: $role, ')
          ..write('createdAt: $createdAt, ')
          ..write('modifiedAt: $modifiedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    eventId,
    personId,
    role,
    createdAt,
    modifiedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EventParticipant &&
          other.id == this.id &&
          other.eventId == this.eventId &&
          other.personId == this.personId &&
          other.role == this.role &&
          other.createdAt == this.createdAt &&
          other.modifiedAt == this.modifiedAt &&
          other.deletedAt == this.deletedAt);
}

class EventParticipantsCompanion extends UpdateCompanion<EventParticipant> {
  final Value<String> id;
  final Value<String> eventId;
  final Value<String> personId;
  final Value<String> role;
  final Value<DateTime> createdAt;
  final Value<DateTime> modifiedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const EventParticipantsCompanion({
    this.id = const Value.absent(),
    this.eventId = const Value.absent(),
    this.personId = const Value.absent(),
    this.role = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.modifiedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EventParticipantsCompanion.insert({
    required String id,
    required String eventId,
    required String personId,
    required String role,
    required DateTime createdAt,
    required DateTime modifiedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       eventId = Value(eventId),
       personId = Value(personId),
       role = Value(role),
       createdAt = Value(createdAt),
       modifiedAt = Value(modifiedAt);
  static Insertable<EventParticipant> custom({
    Expression<String>? id,
    Expression<String>? eventId,
    Expression<String>? personId,
    Expression<String>? role,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? modifiedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (eventId != null) 'event_id': eventId,
      if (personId != null) 'person_id': personId,
      if (role != null) 'role': role,
      if (createdAt != null) 'created_at': createdAt,
      if (modifiedAt != null) 'modified_at': modifiedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EventParticipantsCompanion copyWith({
    Value<String>? id,
    Value<String>? eventId,
    Value<String>? personId,
    Value<String>? role,
    Value<DateTime>? createdAt,
    Value<DateTime>? modifiedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return EventParticipantsCompanion(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      personId: personId ?? this.personId,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (eventId.present) {
      map['event_id'] = Variable<String>(eventId.value);
    }
    if (personId.present) {
      map['person_id'] = Variable<String>(personId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (modifiedAt.present) {
      map['modified_at'] = Variable<DateTime>(modifiedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventParticipantsCompanion(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('personId: $personId, ')
          ..write('role: $role, ')
          ..write('createdAt: $createdAt, ')
          ..write('modifiedAt: $modifiedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SourcesTable extends Sources with TableInfo<$SourcesTable, Source> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SourcesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceDatePrecisionMeta =
      const VerificationMeta('sourceDatePrecision');
  @override
  late final GeneratedColumn<String> sourceDatePrecision =
      GeneratedColumn<String>(
        'source_date_precision',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _sourceDateStartDateMeta =
      const VerificationMeta('sourceDateStartDate');
  @override
  late final GeneratedColumn<DateTime> sourceDateStartDate =
      GeneratedColumn<DateTime>(
        'source_date_start_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _sourceDateEndDateMeta = const VerificationMeta(
    'sourceDateEndDate',
  );
  @override
  late final GeneratedColumn<DateTime> sourceDateEndDate =
      GeneratedColumn<DateTime>(
        'source_date_end_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _sourceDateDisplayTextMeta =
      const VerificationMeta('sourceDateDisplayText');
  @override
  late final GeneratedColumn<String> sourceDateDisplayText =
      GeneratedColumn<String>(
        'source_date_display_text',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _creatorMeta = const VerificationMeta(
    'creator',
  );
  @override
  late final GeneratedColumn<String> creator = GeneratedColumn<String>(
    'creator',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repositoryNameMeta = const VerificationMeta(
    'repositoryName',
  );
  @override
  late final GeneratedColumn<String> repositoryName = GeneratedColumn<String>(
    'repository_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _referenceCodeMeta = const VerificationMeta(
    'referenceCode',
  );
  @override
  late final GeneratedColumn<String> referenceCode = GeneratedColumn<String>(
    'reference_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _originalLocationMeta = const VerificationMeta(
    'originalLocation',
  );
  @override
  late final GeneratedColumn<String> originalLocation = GeneratedColumn<String>(
    'original_location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accessedAtMeta = const VerificationMeta(
    'accessedAt',
  );
  @override
  late final GeneratedColumn<DateTime> accessedAt = GeneratedColumn<DateTime>(
    'accessed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modifiedAtMeta = const VerificationMeta(
    'modifiedAt',
  );
  @override
  late final GeneratedColumn<DateTime> modifiedAt = GeneratedColumn<DateTime>(
    'modified_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    title,
    description,
    sourceDatePrecision,
    sourceDateStartDate,
    sourceDateEndDate,
    sourceDateDisplayText,
    creator,
    repositoryName,
    referenceCode,
    originalLocation,
    url,
    accessedAt,
    notes,
    createdAt,
    modifiedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sources';
  @override
  VerificationContext validateIntegrity(
    Insertable<Source> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('source_date_precision')) {
      context.handle(
        _sourceDatePrecisionMeta,
        sourceDatePrecision.isAcceptableOrUnknown(
          data['source_date_precision']!,
          _sourceDatePrecisionMeta,
        ),
      );
    }
    if (data.containsKey('source_date_start_date')) {
      context.handle(
        _sourceDateStartDateMeta,
        sourceDateStartDate.isAcceptableOrUnknown(
          data['source_date_start_date']!,
          _sourceDateStartDateMeta,
        ),
      );
    }
    if (data.containsKey('source_date_end_date')) {
      context.handle(
        _sourceDateEndDateMeta,
        sourceDateEndDate.isAcceptableOrUnknown(
          data['source_date_end_date']!,
          _sourceDateEndDateMeta,
        ),
      );
    }
    if (data.containsKey('source_date_display_text')) {
      context.handle(
        _sourceDateDisplayTextMeta,
        sourceDateDisplayText.isAcceptableOrUnknown(
          data['source_date_display_text']!,
          _sourceDateDisplayTextMeta,
        ),
      );
    }
    if (data.containsKey('creator')) {
      context.handle(
        _creatorMeta,
        creator.isAcceptableOrUnknown(data['creator']!, _creatorMeta),
      );
    }
    if (data.containsKey('repository_name')) {
      context.handle(
        _repositoryNameMeta,
        repositoryName.isAcceptableOrUnknown(
          data['repository_name']!,
          _repositoryNameMeta,
        ),
      );
    }
    if (data.containsKey('reference_code')) {
      context.handle(
        _referenceCodeMeta,
        referenceCode.isAcceptableOrUnknown(
          data['reference_code']!,
          _referenceCodeMeta,
        ),
      );
    }
    if (data.containsKey('original_location')) {
      context.handle(
        _originalLocationMeta,
        originalLocation.isAcceptableOrUnknown(
          data['original_location']!,
          _originalLocationMeta,
        ),
      );
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    }
    if (data.containsKey('accessed_at')) {
      context.handle(
        _accessedAtMeta,
        accessedAt.isAcceptableOrUnknown(data['accessed_at']!, _accessedAtMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('modified_at')) {
      context.handle(
        _modifiedAtMeta,
        modifiedAt.isAcceptableOrUnknown(data['modified_at']!, _modifiedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_modifiedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Source map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Source(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      sourceDatePrecision: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_date_precision'],
      ),
      sourceDateStartDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}source_date_start_date'],
      ),
      sourceDateEndDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}source_date_end_date'],
      ),
      sourceDateDisplayText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_date_display_text'],
      ),
      creator: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}creator'],
      ),
      repositoryName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}repository_name'],
      ),
      referenceCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference_code'],
      ),
      originalLocation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}original_location'],
      ),
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      ),
      accessedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}accessed_at'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      modifiedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}modified_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $SourcesTable createAlias(String alias) {
    return $SourcesTable(attachedDatabase, alias);
  }
}

class Source extends DataClass implements Insertable<Source> {
  final String id;
  final String type;
  final String title;
  final String? description;
  final String? sourceDatePrecision;
  final DateTime? sourceDateStartDate;
  final DateTime? sourceDateEndDate;
  final String? sourceDateDisplayText;
  final String? creator;
  final String? repositoryName;
  final String? referenceCode;
  final String? originalLocation;
  final String? url;
  final DateTime? accessedAt;
  final String? notes;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final DateTime? deletedAt;
  const Source({
    required this.id,
    required this.type,
    required this.title,
    this.description,
    this.sourceDatePrecision,
    this.sourceDateStartDate,
    this.sourceDateEndDate,
    this.sourceDateDisplayText,
    this.creator,
    this.repositoryName,
    this.referenceCode,
    this.originalLocation,
    this.url,
    this.accessedAt,
    this.notes,
    required this.createdAt,
    required this.modifiedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['type'] = Variable<String>(type);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || sourceDatePrecision != null) {
      map['source_date_precision'] = Variable<String>(sourceDatePrecision);
    }
    if (!nullToAbsent || sourceDateStartDate != null) {
      map['source_date_start_date'] = Variable<DateTime>(sourceDateStartDate);
    }
    if (!nullToAbsent || sourceDateEndDate != null) {
      map['source_date_end_date'] = Variable<DateTime>(sourceDateEndDate);
    }
    if (!nullToAbsent || sourceDateDisplayText != null) {
      map['source_date_display_text'] = Variable<String>(sourceDateDisplayText);
    }
    if (!nullToAbsent || creator != null) {
      map['creator'] = Variable<String>(creator);
    }
    if (!nullToAbsent || repositoryName != null) {
      map['repository_name'] = Variable<String>(repositoryName);
    }
    if (!nullToAbsent || referenceCode != null) {
      map['reference_code'] = Variable<String>(referenceCode);
    }
    if (!nullToAbsent || originalLocation != null) {
      map['original_location'] = Variable<String>(originalLocation);
    }
    if (!nullToAbsent || url != null) {
      map['url'] = Variable<String>(url);
    }
    if (!nullToAbsent || accessedAt != null) {
      map['accessed_at'] = Variable<DateTime>(accessedAt);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['modified_at'] = Variable<DateTime>(modifiedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  SourcesCompanion toCompanion(bool nullToAbsent) {
    return SourcesCompanion(
      id: Value(id),
      type: Value(type),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      sourceDatePrecision: sourceDatePrecision == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceDatePrecision),
      sourceDateStartDate: sourceDateStartDate == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceDateStartDate),
      sourceDateEndDate: sourceDateEndDate == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceDateEndDate),
      sourceDateDisplayText: sourceDateDisplayText == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceDateDisplayText),
      creator: creator == null && nullToAbsent
          ? const Value.absent()
          : Value(creator),
      repositoryName: repositoryName == null && nullToAbsent
          ? const Value.absent()
          : Value(repositoryName),
      referenceCode: referenceCode == null && nullToAbsent
          ? const Value.absent()
          : Value(referenceCode),
      originalLocation: originalLocation == null && nullToAbsent
          ? const Value.absent()
          : Value(originalLocation),
      url: url == null && nullToAbsent ? const Value.absent() : Value(url),
      accessedAt: accessedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(accessedAt),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      modifiedAt: Value(modifiedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory Source.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Source(
      id: serializer.fromJson<String>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      sourceDatePrecision: serializer.fromJson<String?>(
        json['sourceDatePrecision'],
      ),
      sourceDateStartDate: serializer.fromJson<DateTime?>(
        json['sourceDateStartDate'],
      ),
      sourceDateEndDate: serializer.fromJson<DateTime?>(
        json['sourceDateEndDate'],
      ),
      sourceDateDisplayText: serializer.fromJson<String?>(
        json['sourceDateDisplayText'],
      ),
      creator: serializer.fromJson<String?>(json['creator']),
      repositoryName: serializer.fromJson<String?>(json['repositoryName']),
      referenceCode: serializer.fromJson<String?>(json['referenceCode']),
      originalLocation: serializer.fromJson<String?>(json['originalLocation']),
      url: serializer.fromJson<String?>(json['url']),
      accessedAt: serializer.fromJson<DateTime?>(json['accessedAt']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      modifiedAt: serializer.fromJson<DateTime>(json['modifiedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<String>(type),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'sourceDatePrecision': serializer.toJson<String?>(sourceDatePrecision),
      'sourceDateStartDate': serializer.toJson<DateTime?>(sourceDateStartDate),
      'sourceDateEndDate': serializer.toJson<DateTime?>(sourceDateEndDate),
      'sourceDateDisplayText': serializer.toJson<String?>(
        sourceDateDisplayText,
      ),
      'creator': serializer.toJson<String?>(creator),
      'repositoryName': serializer.toJson<String?>(repositoryName),
      'referenceCode': serializer.toJson<String?>(referenceCode),
      'originalLocation': serializer.toJson<String?>(originalLocation),
      'url': serializer.toJson<String?>(url),
      'accessedAt': serializer.toJson<DateTime?>(accessedAt),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'modifiedAt': serializer.toJson<DateTime>(modifiedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  Source copyWith({
    String? id,
    String? type,
    String? title,
    Value<String?> description = const Value.absent(),
    Value<String?> sourceDatePrecision = const Value.absent(),
    Value<DateTime?> sourceDateStartDate = const Value.absent(),
    Value<DateTime?> sourceDateEndDate = const Value.absent(),
    Value<String?> sourceDateDisplayText = const Value.absent(),
    Value<String?> creator = const Value.absent(),
    Value<String?> repositoryName = const Value.absent(),
    Value<String?> referenceCode = const Value.absent(),
    Value<String?> originalLocation = const Value.absent(),
    Value<String?> url = const Value.absent(),
    Value<DateTime?> accessedAt = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? modifiedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => Source(
    id: id ?? this.id,
    type: type ?? this.type,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    sourceDatePrecision: sourceDatePrecision.present
        ? sourceDatePrecision.value
        : this.sourceDatePrecision,
    sourceDateStartDate: sourceDateStartDate.present
        ? sourceDateStartDate.value
        : this.sourceDateStartDate,
    sourceDateEndDate: sourceDateEndDate.present
        ? sourceDateEndDate.value
        : this.sourceDateEndDate,
    sourceDateDisplayText: sourceDateDisplayText.present
        ? sourceDateDisplayText.value
        : this.sourceDateDisplayText,
    creator: creator.present ? creator.value : this.creator,
    repositoryName: repositoryName.present
        ? repositoryName.value
        : this.repositoryName,
    referenceCode: referenceCode.present
        ? referenceCode.value
        : this.referenceCode,
    originalLocation: originalLocation.present
        ? originalLocation.value
        : this.originalLocation,
    url: url.present ? url.value : this.url,
    accessedAt: accessedAt.present ? accessedAt.value : this.accessedAt,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    modifiedAt: modifiedAt ?? this.modifiedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  Source copyWithCompanion(SourcesCompanion data) {
    return Source(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      sourceDatePrecision: data.sourceDatePrecision.present
          ? data.sourceDatePrecision.value
          : this.sourceDatePrecision,
      sourceDateStartDate: data.sourceDateStartDate.present
          ? data.sourceDateStartDate.value
          : this.sourceDateStartDate,
      sourceDateEndDate: data.sourceDateEndDate.present
          ? data.sourceDateEndDate.value
          : this.sourceDateEndDate,
      sourceDateDisplayText: data.sourceDateDisplayText.present
          ? data.sourceDateDisplayText.value
          : this.sourceDateDisplayText,
      creator: data.creator.present ? data.creator.value : this.creator,
      repositoryName: data.repositoryName.present
          ? data.repositoryName.value
          : this.repositoryName,
      referenceCode: data.referenceCode.present
          ? data.referenceCode.value
          : this.referenceCode,
      originalLocation: data.originalLocation.present
          ? data.originalLocation.value
          : this.originalLocation,
      url: data.url.present ? data.url.value : this.url,
      accessedAt: data.accessedAt.present
          ? data.accessedAt.value
          : this.accessedAt,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      modifiedAt: data.modifiedAt.present
          ? data.modifiedAt.value
          : this.modifiedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Source(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('sourceDatePrecision: $sourceDatePrecision, ')
          ..write('sourceDateStartDate: $sourceDateStartDate, ')
          ..write('sourceDateEndDate: $sourceDateEndDate, ')
          ..write('sourceDateDisplayText: $sourceDateDisplayText, ')
          ..write('creator: $creator, ')
          ..write('repositoryName: $repositoryName, ')
          ..write('referenceCode: $referenceCode, ')
          ..write('originalLocation: $originalLocation, ')
          ..write('url: $url, ')
          ..write('accessedAt: $accessedAt, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('modifiedAt: $modifiedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    type,
    title,
    description,
    sourceDatePrecision,
    sourceDateStartDate,
    sourceDateEndDate,
    sourceDateDisplayText,
    creator,
    repositoryName,
    referenceCode,
    originalLocation,
    url,
    accessedAt,
    notes,
    createdAt,
    modifiedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Source &&
          other.id == this.id &&
          other.type == this.type &&
          other.title == this.title &&
          other.description == this.description &&
          other.sourceDatePrecision == this.sourceDatePrecision &&
          other.sourceDateStartDate == this.sourceDateStartDate &&
          other.sourceDateEndDate == this.sourceDateEndDate &&
          other.sourceDateDisplayText == this.sourceDateDisplayText &&
          other.creator == this.creator &&
          other.repositoryName == this.repositoryName &&
          other.referenceCode == this.referenceCode &&
          other.originalLocation == this.originalLocation &&
          other.url == this.url &&
          other.accessedAt == this.accessedAt &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.modifiedAt == this.modifiedAt &&
          other.deletedAt == this.deletedAt);
}

class SourcesCompanion extends UpdateCompanion<Source> {
  final Value<String> id;
  final Value<String> type;
  final Value<String> title;
  final Value<String?> description;
  final Value<String?> sourceDatePrecision;
  final Value<DateTime?> sourceDateStartDate;
  final Value<DateTime?> sourceDateEndDate;
  final Value<String?> sourceDateDisplayText;
  final Value<String?> creator;
  final Value<String?> repositoryName;
  final Value<String?> referenceCode;
  final Value<String?> originalLocation;
  final Value<String?> url;
  final Value<DateTime?> accessedAt;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> modifiedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const SourcesCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.sourceDatePrecision = const Value.absent(),
    this.sourceDateStartDate = const Value.absent(),
    this.sourceDateEndDate = const Value.absent(),
    this.sourceDateDisplayText = const Value.absent(),
    this.creator = const Value.absent(),
    this.repositoryName = const Value.absent(),
    this.referenceCode = const Value.absent(),
    this.originalLocation = const Value.absent(),
    this.url = const Value.absent(),
    this.accessedAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.modifiedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SourcesCompanion.insert({
    required String id,
    required String type,
    required String title,
    this.description = const Value.absent(),
    this.sourceDatePrecision = const Value.absent(),
    this.sourceDateStartDate = const Value.absent(),
    this.sourceDateEndDate = const Value.absent(),
    this.sourceDateDisplayText = const Value.absent(),
    this.creator = const Value.absent(),
    this.repositoryName = const Value.absent(),
    this.referenceCode = const Value.absent(),
    this.originalLocation = const Value.absent(),
    this.url = const Value.absent(),
    this.accessedAt = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime modifiedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       type = Value(type),
       title = Value(title),
       createdAt = Value(createdAt),
       modifiedAt = Value(modifiedAt);
  static Insertable<Source> custom({
    Expression<String>? id,
    Expression<String>? type,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? sourceDatePrecision,
    Expression<DateTime>? sourceDateStartDate,
    Expression<DateTime>? sourceDateEndDate,
    Expression<String>? sourceDateDisplayText,
    Expression<String>? creator,
    Expression<String>? repositoryName,
    Expression<String>? referenceCode,
    Expression<String>? originalLocation,
    Expression<String>? url,
    Expression<DateTime>? accessedAt,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? modifiedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (sourceDatePrecision != null)
        'source_date_precision': sourceDatePrecision,
      if (sourceDateStartDate != null)
        'source_date_start_date': sourceDateStartDate,
      if (sourceDateEndDate != null) 'source_date_end_date': sourceDateEndDate,
      if (sourceDateDisplayText != null)
        'source_date_display_text': sourceDateDisplayText,
      if (creator != null) 'creator': creator,
      if (repositoryName != null) 'repository_name': repositoryName,
      if (referenceCode != null) 'reference_code': referenceCode,
      if (originalLocation != null) 'original_location': originalLocation,
      if (url != null) 'url': url,
      if (accessedAt != null) 'accessed_at': accessedAt,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (modifiedAt != null) 'modified_at': modifiedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SourcesCompanion copyWith({
    Value<String>? id,
    Value<String>? type,
    Value<String>? title,
    Value<String?>? description,
    Value<String?>? sourceDatePrecision,
    Value<DateTime?>? sourceDateStartDate,
    Value<DateTime?>? sourceDateEndDate,
    Value<String?>? sourceDateDisplayText,
    Value<String?>? creator,
    Value<String?>? repositoryName,
    Value<String?>? referenceCode,
    Value<String?>? originalLocation,
    Value<String?>? url,
    Value<DateTime?>? accessedAt,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? modifiedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return SourcesCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      sourceDatePrecision: sourceDatePrecision ?? this.sourceDatePrecision,
      sourceDateStartDate: sourceDateStartDate ?? this.sourceDateStartDate,
      sourceDateEndDate: sourceDateEndDate ?? this.sourceDateEndDate,
      sourceDateDisplayText:
          sourceDateDisplayText ?? this.sourceDateDisplayText,
      creator: creator ?? this.creator,
      repositoryName: repositoryName ?? this.repositoryName,
      referenceCode: referenceCode ?? this.referenceCode,
      originalLocation: originalLocation ?? this.originalLocation,
      url: url ?? this.url,
      accessedAt: accessedAt ?? this.accessedAt,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (sourceDatePrecision.present) {
      map['source_date_precision'] = Variable<String>(
        sourceDatePrecision.value,
      );
    }
    if (sourceDateStartDate.present) {
      map['source_date_start_date'] = Variable<DateTime>(
        sourceDateStartDate.value,
      );
    }
    if (sourceDateEndDate.present) {
      map['source_date_end_date'] = Variable<DateTime>(sourceDateEndDate.value);
    }
    if (sourceDateDisplayText.present) {
      map['source_date_display_text'] = Variable<String>(
        sourceDateDisplayText.value,
      );
    }
    if (creator.present) {
      map['creator'] = Variable<String>(creator.value);
    }
    if (repositoryName.present) {
      map['repository_name'] = Variable<String>(repositoryName.value);
    }
    if (referenceCode.present) {
      map['reference_code'] = Variable<String>(referenceCode.value);
    }
    if (originalLocation.present) {
      map['original_location'] = Variable<String>(originalLocation.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (accessedAt.present) {
      map['accessed_at'] = Variable<DateTime>(accessedAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (modifiedAt.present) {
      map['modified_at'] = Variable<DateTime>(modifiedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SourcesCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('sourceDatePrecision: $sourceDatePrecision, ')
          ..write('sourceDateStartDate: $sourceDateStartDate, ')
          ..write('sourceDateEndDate: $sourceDateEndDate, ')
          ..write('sourceDateDisplayText: $sourceDateDisplayText, ')
          ..write('creator: $creator, ')
          ..write('repositoryName: $repositoryName, ')
          ..write('referenceCode: $referenceCode, ')
          ..write('originalLocation: $originalLocation, ')
          ..write('url: $url, ')
          ..write('accessedAt: $accessedAt, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('modifiedAt: $modifiedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MediaAssetsTable extends MediaAssets
    with TableInfo<$MediaAssetsTable, MediaAsset> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MediaAssetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _relativePathMeta = const VerificationMeta(
    'relativePath',
  );
  @override
  late final GeneratedColumn<String> relativePath = GeneratedColumn<String>(
    'relative_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mimeTypeMeta = const VerificationMeta(
    'mimeType',
  );
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
    'mime_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _originalFilenameMeta = const VerificationMeta(
    'originalFilename',
  );
  @override
  late final GeneratedColumn<String> originalFilename = GeneratedColumn<String>(
    'original_filename',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _checksumSha256Meta = const VerificationMeta(
    'checksumSha256',
  );
  @override
  late final GeneratedColumn<String> checksumSha256 = GeneratedColumn<String>(
    'checksum_sha256',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 64,
      maxTextLength: 64,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileSizeMeta = const VerificationMeta(
    'fileSize',
  );
  @override
  late final GeneratedColumn<int> fileSize = GeneratedColumn<int>(
    'file_size',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modifiedAtMeta = const VerificationMeta(
    'modifiedAt',
  );
  @override
  late final GeneratedColumn<DateTime> modifiedAt = GeneratedColumn<DateTime>(
    'modified_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    relativePath,
    mimeType,
    originalFilename,
    checksumSha256,
    fileSize,
    createdAt,
    modifiedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'media';
  @override
  VerificationContext validateIntegrity(
    Insertable<MediaAsset> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('relative_path')) {
      context.handle(
        _relativePathMeta,
        relativePath.isAcceptableOrUnknown(
          data['relative_path']!,
          _relativePathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_relativePathMeta);
    }
    if (data.containsKey('mime_type')) {
      context.handle(
        _mimeTypeMeta,
        mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta),
      );
    }
    if (data.containsKey('original_filename')) {
      context.handle(
        _originalFilenameMeta,
        originalFilename.isAcceptableOrUnknown(
          data['original_filename']!,
          _originalFilenameMeta,
        ),
      );
    }
    if (data.containsKey('checksum_sha256')) {
      context.handle(
        _checksumSha256Meta,
        checksumSha256.isAcceptableOrUnknown(
          data['checksum_sha256']!,
          _checksumSha256Meta,
        ),
      );
    } else if (isInserting) {
      context.missing(_checksumSha256Meta);
    }
    if (data.containsKey('file_size')) {
      context.handle(
        _fileSizeMeta,
        fileSize.isAcceptableOrUnknown(data['file_size']!, _fileSizeMeta),
      );
    } else if (isInserting) {
      context.missing(_fileSizeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('modified_at')) {
      context.handle(
        _modifiedAtMeta,
        modifiedAt.isAcceptableOrUnknown(data['modified_at']!, _modifiedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_modifiedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MediaAsset map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MediaAsset(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      relativePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}relative_path'],
      )!,
      mimeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mime_type'],
      ),
      originalFilename: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}original_filename'],
      ),
      checksumSha256: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}checksum_sha256'],
      )!,
      fileSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}file_size'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      modifiedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}modified_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $MediaAssetsTable createAlias(String alias) {
    return $MediaAssetsTable(attachedDatabase, alias);
  }
}

class MediaAsset extends DataClass implements Insertable<MediaAsset> {
  final String id;
  final String type;
  final String relativePath;
  final String? mimeType;
  final String? originalFilename;
  final String checksumSha256;
  final int fileSize;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final DateTime? deletedAt;
  const MediaAsset({
    required this.id,
    required this.type,
    required this.relativePath,
    this.mimeType,
    this.originalFilename,
    required this.checksumSha256,
    required this.fileSize,
    required this.createdAt,
    required this.modifiedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['type'] = Variable<String>(type);
    map['relative_path'] = Variable<String>(relativePath);
    if (!nullToAbsent || mimeType != null) {
      map['mime_type'] = Variable<String>(mimeType);
    }
    if (!nullToAbsent || originalFilename != null) {
      map['original_filename'] = Variable<String>(originalFilename);
    }
    map['checksum_sha256'] = Variable<String>(checksumSha256);
    map['file_size'] = Variable<int>(fileSize);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['modified_at'] = Variable<DateTime>(modifiedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  MediaAssetsCompanion toCompanion(bool nullToAbsent) {
    return MediaAssetsCompanion(
      id: Value(id),
      type: Value(type),
      relativePath: Value(relativePath),
      mimeType: mimeType == null && nullToAbsent
          ? const Value.absent()
          : Value(mimeType),
      originalFilename: originalFilename == null && nullToAbsent
          ? const Value.absent()
          : Value(originalFilename),
      checksumSha256: Value(checksumSha256),
      fileSize: Value(fileSize),
      createdAt: Value(createdAt),
      modifiedAt: Value(modifiedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory MediaAsset.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MediaAsset(
      id: serializer.fromJson<String>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      relativePath: serializer.fromJson<String>(json['relativePath']),
      mimeType: serializer.fromJson<String?>(json['mimeType']),
      originalFilename: serializer.fromJson<String?>(json['originalFilename']),
      checksumSha256: serializer.fromJson<String>(json['checksumSha256']),
      fileSize: serializer.fromJson<int>(json['fileSize']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      modifiedAt: serializer.fromJson<DateTime>(json['modifiedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<String>(type),
      'relativePath': serializer.toJson<String>(relativePath),
      'mimeType': serializer.toJson<String?>(mimeType),
      'originalFilename': serializer.toJson<String?>(originalFilename),
      'checksumSha256': serializer.toJson<String>(checksumSha256),
      'fileSize': serializer.toJson<int>(fileSize),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'modifiedAt': serializer.toJson<DateTime>(modifiedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  MediaAsset copyWith({
    String? id,
    String? type,
    String? relativePath,
    Value<String?> mimeType = const Value.absent(),
    Value<String?> originalFilename = const Value.absent(),
    String? checksumSha256,
    int? fileSize,
    DateTime? createdAt,
    DateTime? modifiedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => MediaAsset(
    id: id ?? this.id,
    type: type ?? this.type,
    relativePath: relativePath ?? this.relativePath,
    mimeType: mimeType.present ? mimeType.value : this.mimeType,
    originalFilename: originalFilename.present
        ? originalFilename.value
        : this.originalFilename,
    checksumSha256: checksumSha256 ?? this.checksumSha256,
    fileSize: fileSize ?? this.fileSize,
    createdAt: createdAt ?? this.createdAt,
    modifiedAt: modifiedAt ?? this.modifiedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  MediaAsset copyWithCompanion(MediaAssetsCompanion data) {
    return MediaAsset(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      relativePath: data.relativePath.present
          ? data.relativePath.value
          : this.relativePath,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      originalFilename: data.originalFilename.present
          ? data.originalFilename.value
          : this.originalFilename,
      checksumSha256: data.checksumSha256.present
          ? data.checksumSha256.value
          : this.checksumSha256,
      fileSize: data.fileSize.present ? data.fileSize.value : this.fileSize,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      modifiedAt: data.modifiedAt.present
          ? data.modifiedAt.value
          : this.modifiedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MediaAsset(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('relativePath: $relativePath, ')
          ..write('mimeType: $mimeType, ')
          ..write('originalFilename: $originalFilename, ')
          ..write('checksumSha256: $checksumSha256, ')
          ..write('fileSize: $fileSize, ')
          ..write('createdAt: $createdAt, ')
          ..write('modifiedAt: $modifiedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    type,
    relativePath,
    mimeType,
    originalFilename,
    checksumSha256,
    fileSize,
    createdAt,
    modifiedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MediaAsset &&
          other.id == this.id &&
          other.type == this.type &&
          other.relativePath == this.relativePath &&
          other.mimeType == this.mimeType &&
          other.originalFilename == this.originalFilename &&
          other.checksumSha256 == this.checksumSha256 &&
          other.fileSize == this.fileSize &&
          other.createdAt == this.createdAt &&
          other.modifiedAt == this.modifiedAt &&
          other.deletedAt == this.deletedAt);
}

class MediaAssetsCompanion extends UpdateCompanion<MediaAsset> {
  final Value<String> id;
  final Value<String> type;
  final Value<String> relativePath;
  final Value<String?> mimeType;
  final Value<String?> originalFilename;
  final Value<String> checksumSha256;
  final Value<int> fileSize;
  final Value<DateTime> createdAt;
  final Value<DateTime> modifiedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const MediaAssetsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.relativePath = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.originalFilename = const Value.absent(),
    this.checksumSha256 = const Value.absent(),
    this.fileSize = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.modifiedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MediaAssetsCompanion.insert({
    required String id,
    required String type,
    required String relativePath,
    this.mimeType = const Value.absent(),
    this.originalFilename = const Value.absent(),
    required String checksumSha256,
    required int fileSize,
    required DateTime createdAt,
    required DateTime modifiedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       type = Value(type),
       relativePath = Value(relativePath),
       checksumSha256 = Value(checksumSha256),
       fileSize = Value(fileSize),
       createdAt = Value(createdAt),
       modifiedAt = Value(modifiedAt);
  static Insertable<MediaAsset> custom({
    Expression<String>? id,
    Expression<String>? type,
    Expression<String>? relativePath,
    Expression<String>? mimeType,
    Expression<String>? originalFilename,
    Expression<String>? checksumSha256,
    Expression<int>? fileSize,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? modifiedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (relativePath != null) 'relative_path': relativePath,
      if (mimeType != null) 'mime_type': mimeType,
      if (originalFilename != null) 'original_filename': originalFilename,
      if (checksumSha256 != null) 'checksum_sha256': checksumSha256,
      if (fileSize != null) 'file_size': fileSize,
      if (createdAt != null) 'created_at': createdAt,
      if (modifiedAt != null) 'modified_at': modifiedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MediaAssetsCompanion copyWith({
    Value<String>? id,
    Value<String>? type,
    Value<String>? relativePath,
    Value<String?>? mimeType,
    Value<String?>? originalFilename,
    Value<String>? checksumSha256,
    Value<int>? fileSize,
    Value<DateTime>? createdAt,
    Value<DateTime>? modifiedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return MediaAssetsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      relativePath: relativePath ?? this.relativePath,
      mimeType: mimeType ?? this.mimeType,
      originalFilename: originalFilename ?? this.originalFilename,
      checksumSha256: checksumSha256 ?? this.checksumSha256,
      fileSize: fileSize ?? this.fileSize,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (relativePath.present) {
      map['relative_path'] = Variable<String>(relativePath.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (originalFilename.present) {
      map['original_filename'] = Variable<String>(originalFilename.value);
    }
    if (checksumSha256.present) {
      map['checksum_sha256'] = Variable<String>(checksumSha256.value);
    }
    if (fileSize.present) {
      map['file_size'] = Variable<int>(fileSize.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (modifiedAt.present) {
      map['modified_at'] = Variable<DateTime>(modifiedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MediaAssetsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('relativePath: $relativePath, ')
          ..write('mimeType: $mimeType, ')
          ..write('originalFilename: $originalFilename, ')
          ..write('checksumSha256: $checksumSha256, ')
          ..write('fileSize: $fileSize, ')
          ..write('createdAt: $createdAt, ')
          ..write('modifiedAt: $modifiedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SourceMediaLinksTable extends SourceMediaLinks
    with TableInfo<$SourceMediaLinksTable, SourceMediaLink> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SourceMediaLinksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceIdMeta = const VerificationMeta(
    'sourceId',
  );
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
    'source_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sources (id)',
    ),
  );
  static const VerificationMeta _mediaIdMeta = const VerificationMeta(
    'mediaId',
  );
  @override
  late final GeneratedColumn<String> mediaId = GeneratedColumn<String>(
    'media_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES media (id)',
    ),
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _captionMeta = const VerificationMeta(
    'caption',
  );
  @override
  late final GeneratedColumn<String> caption = GeneratedColumn<String>(
    'caption',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modifiedAtMeta = const VerificationMeta(
    'modifiedAt',
  );
  @override
  late final GeneratedColumn<DateTime> modifiedAt = GeneratedColumn<DateTime>(
    'modified_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sourceId,
    mediaId,
    role,
    caption,
    sortOrder,
    createdAt,
    modifiedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'source_media';
  @override
  VerificationContext validateIntegrity(
    Insertable<SourceMediaLink> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('source_id')) {
      context.handle(
        _sourceIdMeta,
        sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    if (data.containsKey('media_id')) {
      context.handle(
        _mediaIdMeta,
        mediaId.isAcceptableOrUnknown(data['media_id']!, _mediaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_mediaIdMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('caption')) {
      context.handle(
        _captionMeta,
        caption.isAcceptableOrUnknown(data['caption']!, _captionMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('modified_at')) {
      context.handle(
        _modifiedAtMeta,
        modifiedAt.isAcceptableOrUnknown(data['modified_at']!, _modifiedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_modifiedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SourceMediaLink map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SourceMediaLink(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      )!,
      mediaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}media_id'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      caption: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}caption'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      modifiedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}modified_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $SourceMediaLinksTable createAlias(String alias) {
    return $SourceMediaLinksTable(attachedDatabase, alias);
  }
}

class SourceMediaLink extends DataClass implements Insertable<SourceMediaLink> {
  final String id;
  final String sourceId;
  final String mediaId;
  final String role;
  final String? caption;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final DateTime? deletedAt;
  const SourceMediaLink({
    required this.id,
    required this.sourceId,
    required this.mediaId,
    required this.role,
    this.caption,
    required this.sortOrder,
    required this.createdAt,
    required this.modifiedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['source_id'] = Variable<String>(sourceId);
    map['media_id'] = Variable<String>(mediaId);
    map['role'] = Variable<String>(role);
    if (!nullToAbsent || caption != null) {
      map['caption'] = Variable<String>(caption);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['modified_at'] = Variable<DateTime>(modifiedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  SourceMediaLinksCompanion toCompanion(bool nullToAbsent) {
    return SourceMediaLinksCompanion(
      id: Value(id),
      sourceId: Value(sourceId),
      mediaId: Value(mediaId),
      role: Value(role),
      caption: caption == null && nullToAbsent
          ? const Value.absent()
          : Value(caption),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      modifiedAt: Value(modifiedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory SourceMediaLink.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SourceMediaLink(
      id: serializer.fromJson<String>(json['id']),
      sourceId: serializer.fromJson<String>(json['sourceId']),
      mediaId: serializer.fromJson<String>(json['mediaId']),
      role: serializer.fromJson<String>(json['role']),
      caption: serializer.fromJson<String?>(json['caption']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      modifiedAt: serializer.fromJson<DateTime>(json['modifiedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sourceId': serializer.toJson<String>(sourceId),
      'mediaId': serializer.toJson<String>(mediaId),
      'role': serializer.toJson<String>(role),
      'caption': serializer.toJson<String?>(caption),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'modifiedAt': serializer.toJson<DateTime>(modifiedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  SourceMediaLink copyWith({
    String? id,
    String? sourceId,
    String? mediaId,
    String? role,
    Value<String?> caption = const Value.absent(),
    int? sortOrder,
    DateTime? createdAt,
    DateTime? modifiedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => SourceMediaLink(
    id: id ?? this.id,
    sourceId: sourceId ?? this.sourceId,
    mediaId: mediaId ?? this.mediaId,
    role: role ?? this.role,
    caption: caption.present ? caption.value : this.caption,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
    modifiedAt: modifiedAt ?? this.modifiedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  SourceMediaLink copyWithCompanion(SourceMediaLinksCompanion data) {
    return SourceMediaLink(
      id: data.id.present ? data.id.value : this.id,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      mediaId: data.mediaId.present ? data.mediaId.value : this.mediaId,
      role: data.role.present ? data.role.value : this.role,
      caption: data.caption.present ? data.caption.value : this.caption,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      modifiedAt: data.modifiedAt.present
          ? data.modifiedAt.value
          : this.modifiedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SourceMediaLink(')
          ..write('id: $id, ')
          ..write('sourceId: $sourceId, ')
          ..write('mediaId: $mediaId, ')
          ..write('role: $role, ')
          ..write('caption: $caption, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('modifiedAt: $modifiedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sourceId,
    mediaId,
    role,
    caption,
    sortOrder,
    createdAt,
    modifiedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SourceMediaLink &&
          other.id == this.id &&
          other.sourceId == this.sourceId &&
          other.mediaId == this.mediaId &&
          other.role == this.role &&
          other.caption == this.caption &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.modifiedAt == this.modifiedAt &&
          other.deletedAt == this.deletedAt);
}

class SourceMediaLinksCompanion extends UpdateCompanion<SourceMediaLink> {
  final Value<String> id;
  final Value<String> sourceId;
  final Value<String> mediaId;
  final Value<String> role;
  final Value<String?> caption;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<DateTime> modifiedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const SourceMediaLinksCompanion({
    this.id = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.mediaId = const Value.absent(),
    this.role = const Value.absent(),
    this.caption = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.modifiedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SourceMediaLinksCompanion.insert({
    required String id,
    required String sourceId,
    required String mediaId,
    required String role,
    this.caption = const Value.absent(),
    this.sortOrder = const Value.absent(),
    required DateTime createdAt,
    required DateTime modifiedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sourceId = Value(sourceId),
       mediaId = Value(mediaId),
       role = Value(role),
       createdAt = Value(createdAt),
       modifiedAt = Value(modifiedAt);
  static Insertable<SourceMediaLink> custom({
    Expression<String>? id,
    Expression<String>? sourceId,
    Expression<String>? mediaId,
    Expression<String>? role,
    Expression<String>? caption,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? modifiedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceId != null) 'source_id': sourceId,
      if (mediaId != null) 'media_id': mediaId,
      if (role != null) 'role': role,
      if (caption != null) 'caption': caption,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (modifiedAt != null) 'modified_at': modifiedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SourceMediaLinksCompanion copyWith({
    Value<String>? id,
    Value<String>? sourceId,
    Value<String>? mediaId,
    Value<String>? role,
    Value<String?>? caption,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
    Value<DateTime>? modifiedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return SourceMediaLinksCompanion(
      id: id ?? this.id,
      sourceId: sourceId ?? this.sourceId,
      mediaId: mediaId ?? this.mediaId,
      role: role ?? this.role,
      caption: caption ?? this.caption,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (mediaId.present) {
      map['media_id'] = Variable<String>(mediaId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (caption.present) {
      map['caption'] = Variable<String>(caption.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (modifiedAt.present) {
      map['modified_at'] = Variable<DateTime>(modifiedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SourceMediaLinksCompanion(')
          ..write('id: $id, ')
          ..write('sourceId: $sourceId, ')
          ..write('mediaId: $mediaId, ')
          ..write('role: $role, ')
          ..write('caption: $caption, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('modifiedAt: $modifiedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ClaimsTable extends Claims with TableInfo<$ClaimsTable, Claim> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClaimsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subjectTypeMeta = const VerificationMeta(
    'subjectType',
  );
  @override
  late final GeneratedColumn<String> subjectType = GeneratedColumn<String>(
    'subject_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subjectIdMeta = const VerificationMeta(
    'subjectId',
  );
  @override
  late final GeneratedColumn<String> subjectId = GeneratedColumn<String>(
    'subject_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _propertyMeta = const VerificationMeta(
    'property',
  );
  @override
  late final GeneratedColumn<String> property = GeneratedColumn<String>(
    'property',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueTypeMeta = const VerificationMeta(
    'valueType',
  );
  @override
  late final GeneratedColumn<String> valueType = GeneratedColumn<String>(
    'value_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueJsonMeta = const VerificationMeta(
    'valueJson',
  );
  @override
  late final GeneratedColumn<String> valueJson = GeneratedColumn<String>(
    'value_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadVersionMeta = const VerificationMeta(
    'payloadVersion',
  );
  @override
  late final GeneratedColumn<int> payloadVersion = GeneratedColumn<int>(
    'payload_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _sourceIdMeta = const VerificationMeta(
    'sourceId',
  );
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
    'source_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sources (id)',
    ),
  );
  static const VerificationMeta _sourceLocatorMeta = const VerificationMeta(
    'sourceLocator',
  );
  @override
  late final GeneratedColumn<String> sourceLocator = GeneratedColumn<String>(
    'source_locator',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _confidenceMeta = const VerificationMeta(
    'confidence',
  );
  @override
  late final GeneratedColumn<double> confidence = GeneratedColumn<double>(
    'confidence',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modifiedAtMeta = const VerificationMeta(
    'modifiedAt',
  );
  @override
  late final GeneratedColumn<DateTime> modifiedAt = GeneratedColumn<DateTime>(
    'modified_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    subjectType,
    subjectId,
    property,
    valueType,
    valueJson,
    payloadVersion,
    sourceId,
    sourceLocator,
    confidence,
    status,
    createdAt,
    modifiedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'claims';
  @override
  VerificationContext validateIntegrity(
    Insertable<Claim> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('subject_type')) {
      context.handle(
        _subjectTypeMeta,
        subjectType.isAcceptableOrUnknown(
          data['subject_type']!,
          _subjectTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_subjectTypeMeta);
    }
    if (data.containsKey('subject_id')) {
      context.handle(
        _subjectIdMeta,
        subjectId.isAcceptableOrUnknown(data['subject_id']!, _subjectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_subjectIdMeta);
    }
    if (data.containsKey('property')) {
      context.handle(
        _propertyMeta,
        property.isAcceptableOrUnknown(data['property']!, _propertyMeta),
      );
    } else if (isInserting) {
      context.missing(_propertyMeta);
    }
    if (data.containsKey('value_type')) {
      context.handle(
        _valueTypeMeta,
        valueType.isAcceptableOrUnknown(data['value_type']!, _valueTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_valueTypeMeta);
    }
    if (data.containsKey('value_json')) {
      context.handle(
        _valueJsonMeta,
        valueJson.isAcceptableOrUnknown(data['value_json']!, _valueJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_valueJsonMeta);
    }
    if (data.containsKey('payload_version')) {
      context.handle(
        _payloadVersionMeta,
        payloadVersion.isAcceptableOrUnknown(
          data['payload_version']!,
          _payloadVersionMeta,
        ),
      );
    }
    if (data.containsKey('source_id')) {
      context.handle(
        _sourceIdMeta,
        sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta),
      );
    }
    if (data.containsKey('source_locator')) {
      context.handle(
        _sourceLocatorMeta,
        sourceLocator.isAcceptableOrUnknown(
          data['source_locator']!,
          _sourceLocatorMeta,
        ),
      );
    }
    if (data.containsKey('confidence')) {
      context.handle(
        _confidenceMeta,
        confidence.isAcceptableOrUnknown(data['confidence']!, _confidenceMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('modified_at')) {
      context.handle(
        _modifiedAtMeta,
        modifiedAt.isAcceptableOrUnknown(data['modified_at']!, _modifiedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_modifiedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Claim map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Claim(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      subjectType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject_type'],
      )!,
      subjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject_id'],
      )!,
      property: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}property'],
      )!,
      valueType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value_type'],
      )!,
      valueJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value_json'],
      )!,
      payloadVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}payload_version'],
      )!,
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      ),
      sourceLocator: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_locator'],
      ),
      confidence: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}confidence'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      modifiedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}modified_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $ClaimsTable createAlias(String alias) {
    return $ClaimsTable(attachedDatabase, alias);
  }
}

class Claim extends DataClass implements Insertable<Claim> {
  final String id;
  final String subjectType;
  final String subjectId;
  final String property;
  final String valueType;
  final String valueJson;
  final int payloadVersion;
  final String? sourceId;
  final String? sourceLocator;
  final double? confidence;
  final String status;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final DateTime? deletedAt;
  const Claim({
    required this.id,
    required this.subjectType,
    required this.subjectId,
    required this.property,
    required this.valueType,
    required this.valueJson,
    required this.payloadVersion,
    this.sourceId,
    this.sourceLocator,
    this.confidence,
    required this.status,
    required this.createdAt,
    required this.modifiedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['subject_type'] = Variable<String>(subjectType);
    map['subject_id'] = Variable<String>(subjectId);
    map['property'] = Variable<String>(property);
    map['value_type'] = Variable<String>(valueType);
    map['value_json'] = Variable<String>(valueJson);
    map['payload_version'] = Variable<int>(payloadVersion);
    if (!nullToAbsent || sourceId != null) {
      map['source_id'] = Variable<String>(sourceId);
    }
    if (!nullToAbsent || sourceLocator != null) {
      map['source_locator'] = Variable<String>(sourceLocator);
    }
    if (!nullToAbsent || confidence != null) {
      map['confidence'] = Variable<double>(confidence);
    }
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['modified_at'] = Variable<DateTime>(modifiedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  ClaimsCompanion toCompanion(bool nullToAbsent) {
    return ClaimsCompanion(
      id: Value(id),
      subjectType: Value(subjectType),
      subjectId: Value(subjectId),
      property: Value(property),
      valueType: Value(valueType),
      valueJson: Value(valueJson),
      payloadVersion: Value(payloadVersion),
      sourceId: sourceId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceId),
      sourceLocator: sourceLocator == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceLocator),
      confidence: confidence == null && nullToAbsent
          ? const Value.absent()
          : Value(confidence),
      status: Value(status),
      createdAt: Value(createdAt),
      modifiedAt: Value(modifiedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory Claim.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Claim(
      id: serializer.fromJson<String>(json['id']),
      subjectType: serializer.fromJson<String>(json['subjectType']),
      subjectId: serializer.fromJson<String>(json['subjectId']),
      property: serializer.fromJson<String>(json['property']),
      valueType: serializer.fromJson<String>(json['valueType']),
      valueJson: serializer.fromJson<String>(json['valueJson']),
      payloadVersion: serializer.fromJson<int>(json['payloadVersion']),
      sourceId: serializer.fromJson<String?>(json['sourceId']),
      sourceLocator: serializer.fromJson<String?>(json['sourceLocator']),
      confidence: serializer.fromJson<double?>(json['confidence']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      modifiedAt: serializer.fromJson<DateTime>(json['modifiedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'subjectType': serializer.toJson<String>(subjectType),
      'subjectId': serializer.toJson<String>(subjectId),
      'property': serializer.toJson<String>(property),
      'valueType': serializer.toJson<String>(valueType),
      'valueJson': serializer.toJson<String>(valueJson),
      'payloadVersion': serializer.toJson<int>(payloadVersion),
      'sourceId': serializer.toJson<String?>(sourceId),
      'sourceLocator': serializer.toJson<String?>(sourceLocator),
      'confidence': serializer.toJson<double?>(confidence),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'modifiedAt': serializer.toJson<DateTime>(modifiedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  Claim copyWith({
    String? id,
    String? subjectType,
    String? subjectId,
    String? property,
    String? valueType,
    String? valueJson,
    int? payloadVersion,
    Value<String?> sourceId = const Value.absent(),
    Value<String?> sourceLocator = const Value.absent(),
    Value<double?> confidence = const Value.absent(),
    String? status,
    DateTime? createdAt,
    DateTime? modifiedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => Claim(
    id: id ?? this.id,
    subjectType: subjectType ?? this.subjectType,
    subjectId: subjectId ?? this.subjectId,
    property: property ?? this.property,
    valueType: valueType ?? this.valueType,
    valueJson: valueJson ?? this.valueJson,
    payloadVersion: payloadVersion ?? this.payloadVersion,
    sourceId: sourceId.present ? sourceId.value : this.sourceId,
    sourceLocator: sourceLocator.present
        ? sourceLocator.value
        : this.sourceLocator,
    confidence: confidence.present ? confidence.value : this.confidence,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    modifiedAt: modifiedAt ?? this.modifiedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  Claim copyWithCompanion(ClaimsCompanion data) {
    return Claim(
      id: data.id.present ? data.id.value : this.id,
      subjectType: data.subjectType.present
          ? data.subjectType.value
          : this.subjectType,
      subjectId: data.subjectId.present ? data.subjectId.value : this.subjectId,
      property: data.property.present ? data.property.value : this.property,
      valueType: data.valueType.present ? data.valueType.value : this.valueType,
      valueJson: data.valueJson.present ? data.valueJson.value : this.valueJson,
      payloadVersion: data.payloadVersion.present
          ? data.payloadVersion.value
          : this.payloadVersion,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      sourceLocator: data.sourceLocator.present
          ? data.sourceLocator.value
          : this.sourceLocator,
      confidence: data.confidence.present
          ? data.confidence.value
          : this.confidence,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      modifiedAt: data.modifiedAt.present
          ? data.modifiedAt.value
          : this.modifiedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Claim(')
          ..write('id: $id, ')
          ..write('subjectType: $subjectType, ')
          ..write('subjectId: $subjectId, ')
          ..write('property: $property, ')
          ..write('valueType: $valueType, ')
          ..write('valueJson: $valueJson, ')
          ..write('payloadVersion: $payloadVersion, ')
          ..write('sourceId: $sourceId, ')
          ..write('sourceLocator: $sourceLocator, ')
          ..write('confidence: $confidence, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('modifiedAt: $modifiedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    subjectType,
    subjectId,
    property,
    valueType,
    valueJson,
    payloadVersion,
    sourceId,
    sourceLocator,
    confidence,
    status,
    createdAt,
    modifiedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Claim &&
          other.id == this.id &&
          other.subjectType == this.subjectType &&
          other.subjectId == this.subjectId &&
          other.property == this.property &&
          other.valueType == this.valueType &&
          other.valueJson == this.valueJson &&
          other.payloadVersion == this.payloadVersion &&
          other.sourceId == this.sourceId &&
          other.sourceLocator == this.sourceLocator &&
          other.confidence == this.confidence &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.modifiedAt == this.modifiedAt &&
          other.deletedAt == this.deletedAt);
}

class ClaimsCompanion extends UpdateCompanion<Claim> {
  final Value<String> id;
  final Value<String> subjectType;
  final Value<String> subjectId;
  final Value<String> property;
  final Value<String> valueType;
  final Value<String> valueJson;
  final Value<int> payloadVersion;
  final Value<String?> sourceId;
  final Value<String?> sourceLocator;
  final Value<double?> confidence;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime> modifiedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const ClaimsCompanion({
    this.id = const Value.absent(),
    this.subjectType = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.property = const Value.absent(),
    this.valueType = const Value.absent(),
    this.valueJson = const Value.absent(),
    this.payloadVersion = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.sourceLocator = const Value.absent(),
    this.confidence = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.modifiedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ClaimsCompanion.insert({
    required String id,
    required String subjectType,
    required String subjectId,
    required String property,
    required String valueType,
    required String valueJson,
    this.payloadVersion = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.sourceLocator = const Value.absent(),
    this.confidence = const Value.absent(),
    required String status,
    required DateTime createdAt,
    required DateTime modifiedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       subjectType = Value(subjectType),
       subjectId = Value(subjectId),
       property = Value(property),
       valueType = Value(valueType),
       valueJson = Value(valueJson),
       status = Value(status),
       createdAt = Value(createdAt),
       modifiedAt = Value(modifiedAt);
  static Insertable<Claim> custom({
    Expression<String>? id,
    Expression<String>? subjectType,
    Expression<String>? subjectId,
    Expression<String>? property,
    Expression<String>? valueType,
    Expression<String>? valueJson,
    Expression<int>? payloadVersion,
    Expression<String>? sourceId,
    Expression<String>? sourceLocator,
    Expression<double>? confidence,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? modifiedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (subjectType != null) 'subject_type': subjectType,
      if (subjectId != null) 'subject_id': subjectId,
      if (property != null) 'property': property,
      if (valueType != null) 'value_type': valueType,
      if (valueJson != null) 'value_json': valueJson,
      if (payloadVersion != null) 'payload_version': payloadVersion,
      if (sourceId != null) 'source_id': sourceId,
      if (sourceLocator != null) 'source_locator': sourceLocator,
      if (confidence != null) 'confidence': confidence,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (modifiedAt != null) 'modified_at': modifiedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ClaimsCompanion copyWith({
    Value<String>? id,
    Value<String>? subjectType,
    Value<String>? subjectId,
    Value<String>? property,
    Value<String>? valueType,
    Value<String>? valueJson,
    Value<int>? payloadVersion,
    Value<String?>? sourceId,
    Value<String?>? sourceLocator,
    Value<double?>? confidence,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<DateTime>? modifiedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return ClaimsCompanion(
      id: id ?? this.id,
      subjectType: subjectType ?? this.subjectType,
      subjectId: subjectId ?? this.subjectId,
      property: property ?? this.property,
      valueType: valueType ?? this.valueType,
      valueJson: valueJson ?? this.valueJson,
      payloadVersion: payloadVersion ?? this.payloadVersion,
      sourceId: sourceId ?? this.sourceId,
      sourceLocator: sourceLocator ?? this.sourceLocator,
      confidence: confidence ?? this.confidence,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (subjectType.present) {
      map['subject_type'] = Variable<String>(subjectType.value);
    }
    if (subjectId.present) {
      map['subject_id'] = Variable<String>(subjectId.value);
    }
    if (property.present) {
      map['property'] = Variable<String>(property.value);
    }
    if (valueType.present) {
      map['value_type'] = Variable<String>(valueType.value);
    }
    if (valueJson.present) {
      map['value_json'] = Variable<String>(valueJson.value);
    }
    if (payloadVersion.present) {
      map['payload_version'] = Variable<int>(payloadVersion.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (sourceLocator.present) {
      map['source_locator'] = Variable<String>(sourceLocator.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<double>(confidence.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (modifiedAt.present) {
      map['modified_at'] = Variable<DateTime>(modifiedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClaimsCompanion(')
          ..write('id: $id, ')
          ..write('subjectType: $subjectType, ')
          ..write('subjectId: $subjectId, ')
          ..write('property: $property, ')
          ..write('valueType: $valueType, ')
          ..write('valueJson: $valueJson, ')
          ..write('payloadVersion: $payloadVersion, ')
          ..write('sourceId: $sourceId, ')
          ..write('sourceLocator: $sourceLocator, ')
          ..write('confidence: $confidence, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('modifiedAt: $modifiedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ClaimApplicationsTable extends ClaimApplications
    with TableInfo<$ClaimApplicationsTable, ClaimApplication> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClaimApplicationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _claimIdMeta = const VerificationMeta(
    'claimId',
  );
  @override
  late final GeneratedColumn<String> claimId = GeneratedColumn<String>(
    'claim_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES claims (id)',
    ),
  );
  static const VerificationMeta _operationTypeMeta = const VerificationMeta(
    'operationType',
  );
  @override
  late final GeneratedColumn<String> operationType = GeneratedColumn<String>(
    'operation_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _resultEntityTypeMeta = const VerificationMeta(
    'resultEntityType',
  );
  @override
  late final GeneratedColumn<String> resultEntityType = GeneratedColumn<String>(
    'result_entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _resultEntityIdMeta = const VerificationMeta(
    'resultEntityId',
  );
  @override
  late final GeneratedColumn<String> resultEntityId = GeneratedColumn<String>(
    'result_entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _appliedAtMeta = const VerificationMeta(
    'appliedAt',
  );
  @override
  late final GeneratedColumn<DateTime> appliedAt = GeneratedColumn<DateTime>(
    'applied_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    claimId,
    operationType,
    resultEntityType,
    resultEntityId,
    appliedAt,
    payloadJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'claim_applications';
  @override
  VerificationContext validateIntegrity(
    Insertable<ClaimApplication> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('claim_id')) {
      context.handle(
        _claimIdMeta,
        claimId.isAcceptableOrUnknown(data['claim_id']!, _claimIdMeta),
      );
    } else if (isInserting) {
      context.missing(_claimIdMeta);
    }
    if (data.containsKey('operation_type')) {
      context.handle(
        _operationTypeMeta,
        operationType.isAcceptableOrUnknown(
          data['operation_type']!,
          _operationTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_operationTypeMeta);
    }
    if (data.containsKey('result_entity_type')) {
      context.handle(
        _resultEntityTypeMeta,
        resultEntityType.isAcceptableOrUnknown(
          data['result_entity_type']!,
          _resultEntityTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_resultEntityTypeMeta);
    }
    if (data.containsKey('result_entity_id')) {
      context.handle(
        _resultEntityIdMeta,
        resultEntityId.isAcceptableOrUnknown(
          data['result_entity_id']!,
          _resultEntityIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_resultEntityIdMeta);
    }
    if (data.containsKey('applied_at')) {
      context.handle(
        _appliedAtMeta,
        appliedAt.isAcceptableOrUnknown(data['applied_at']!, _appliedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_appliedAtMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {claimId};
  @override
  ClaimApplication map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClaimApplication(
      claimId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}claim_id'],
      )!,
      operationType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation_type'],
      )!,
      resultEntityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}result_entity_type'],
      )!,
      resultEntityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}result_entity_id'],
      )!,
      appliedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}applied_at'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
    );
  }

  @override
  $ClaimApplicationsTable createAlias(String alias) {
    return $ClaimApplicationsTable(attachedDatabase, alias);
  }
}

class ClaimApplication extends DataClass
    implements Insertable<ClaimApplication> {
  final String claimId;
  final String operationType;
  final String resultEntityType;
  final String resultEntityId;
  final DateTime appliedAt;
  final String payloadJson;
  const ClaimApplication({
    required this.claimId,
    required this.operationType,
    required this.resultEntityType,
    required this.resultEntityId,
    required this.appliedAt,
    required this.payloadJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['claim_id'] = Variable<String>(claimId);
    map['operation_type'] = Variable<String>(operationType);
    map['result_entity_type'] = Variable<String>(resultEntityType);
    map['result_entity_id'] = Variable<String>(resultEntityId);
    map['applied_at'] = Variable<DateTime>(appliedAt);
    map['payload_json'] = Variable<String>(payloadJson);
    return map;
  }

  ClaimApplicationsCompanion toCompanion(bool nullToAbsent) {
    return ClaimApplicationsCompanion(
      claimId: Value(claimId),
      operationType: Value(operationType),
      resultEntityType: Value(resultEntityType),
      resultEntityId: Value(resultEntityId),
      appliedAt: Value(appliedAt),
      payloadJson: Value(payloadJson),
    );
  }

  factory ClaimApplication.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClaimApplication(
      claimId: serializer.fromJson<String>(json['claimId']),
      operationType: serializer.fromJson<String>(json['operationType']),
      resultEntityType: serializer.fromJson<String>(json['resultEntityType']),
      resultEntityId: serializer.fromJson<String>(json['resultEntityId']),
      appliedAt: serializer.fromJson<DateTime>(json['appliedAt']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'claimId': serializer.toJson<String>(claimId),
      'operationType': serializer.toJson<String>(operationType),
      'resultEntityType': serializer.toJson<String>(resultEntityType),
      'resultEntityId': serializer.toJson<String>(resultEntityId),
      'appliedAt': serializer.toJson<DateTime>(appliedAt),
      'payloadJson': serializer.toJson<String>(payloadJson),
    };
  }

  ClaimApplication copyWith({
    String? claimId,
    String? operationType,
    String? resultEntityType,
    String? resultEntityId,
    DateTime? appliedAt,
    String? payloadJson,
  }) => ClaimApplication(
    claimId: claimId ?? this.claimId,
    operationType: operationType ?? this.operationType,
    resultEntityType: resultEntityType ?? this.resultEntityType,
    resultEntityId: resultEntityId ?? this.resultEntityId,
    appliedAt: appliedAt ?? this.appliedAt,
    payloadJson: payloadJson ?? this.payloadJson,
  );
  ClaimApplication copyWithCompanion(ClaimApplicationsCompanion data) {
    return ClaimApplication(
      claimId: data.claimId.present ? data.claimId.value : this.claimId,
      operationType: data.operationType.present
          ? data.operationType.value
          : this.operationType,
      resultEntityType: data.resultEntityType.present
          ? data.resultEntityType.value
          : this.resultEntityType,
      resultEntityId: data.resultEntityId.present
          ? data.resultEntityId.value
          : this.resultEntityId,
      appliedAt: data.appliedAt.present ? data.appliedAt.value : this.appliedAt,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClaimApplication(')
          ..write('claimId: $claimId, ')
          ..write('operationType: $operationType, ')
          ..write('resultEntityType: $resultEntityType, ')
          ..write('resultEntityId: $resultEntityId, ')
          ..write('appliedAt: $appliedAt, ')
          ..write('payloadJson: $payloadJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    claimId,
    operationType,
    resultEntityType,
    resultEntityId,
    appliedAt,
    payloadJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClaimApplication &&
          other.claimId == this.claimId &&
          other.operationType == this.operationType &&
          other.resultEntityType == this.resultEntityType &&
          other.resultEntityId == this.resultEntityId &&
          other.appliedAt == this.appliedAt &&
          other.payloadJson == this.payloadJson);
}

class ClaimApplicationsCompanion extends UpdateCompanion<ClaimApplication> {
  final Value<String> claimId;
  final Value<String> operationType;
  final Value<String> resultEntityType;
  final Value<String> resultEntityId;
  final Value<DateTime> appliedAt;
  final Value<String> payloadJson;
  final Value<int> rowid;
  const ClaimApplicationsCompanion({
    this.claimId = const Value.absent(),
    this.operationType = const Value.absent(),
    this.resultEntityType = const Value.absent(),
    this.resultEntityId = const Value.absent(),
    this.appliedAt = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ClaimApplicationsCompanion.insert({
    required String claimId,
    required String operationType,
    required String resultEntityType,
    required String resultEntityId,
    required DateTime appliedAt,
    required String payloadJson,
    this.rowid = const Value.absent(),
  }) : claimId = Value(claimId),
       operationType = Value(operationType),
       resultEntityType = Value(resultEntityType),
       resultEntityId = Value(resultEntityId),
       appliedAt = Value(appliedAt),
       payloadJson = Value(payloadJson);
  static Insertable<ClaimApplication> custom({
    Expression<String>? claimId,
    Expression<String>? operationType,
    Expression<String>? resultEntityType,
    Expression<String>? resultEntityId,
    Expression<DateTime>? appliedAt,
    Expression<String>? payloadJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (claimId != null) 'claim_id': claimId,
      if (operationType != null) 'operation_type': operationType,
      if (resultEntityType != null) 'result_entity_type': resultEntityType,
      if (resultEntityId != null) 'result_entity_id': resultEntityId,
      if (appliedAt != null) 'applied_at': appliedAt,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ClaimApplicationsCompanion copyWith({
    Value<String>? claimId,
    Value<String>? operationType,
    Value<String>? resultEntityType,
    Value<String>? resultEntityId,
    Value<DateTime>? appliedAt,
    Value<String>? payloadJson,
    Value<int>? rowid,
  }) {
    return ClaimApplicationsCompanion(
      claimId: claimId ?? this.claimId,
      operationType: operationType ?? this.operationType,
      resultEntityType: resultEntityType ?? this.resultEntityType,
      resultEntityId: resultEntityId ?? this.resultEntityId,
      appliedAt: appliedAt ?? this.appliedAt,
      payloadJson: payloadJson ?? this.payloadJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (claimId.present) {
      map['claim_id'] = Variable<String>(claimId.value);
    }
    if (operationType.present) {
      map['operation_type'] = Variable<String>(operationType.value);
    }
    if (resultEntityType.present) {
      map['result_entity_type'] = Variable<String>(resultEntityType.value);
    }
    if (resultEntityId.present) {
      map['result_entity_id'] = Variable<String>(resultEntityId.value);
    }
    if (appliedAt.present) {
      map['applied_at'] = Variable<DateTime>(appliedAt.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClaimApplicationsCompanion(')
          ..write('claimId: $claimId, ')
          ..write('operationType: $operationType, ')
          ..write('resultEntityType: $resultEntityType, ')
          ..write('resultEntityId: $resultEntityId, ')
          ..write('appliedAt: $appliedAt, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DuplicateCandidatesTable extends DuplicateCandidates
    with TableInfo<$DuplicateCandidatesTable, DuplicateCandidate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DuplicateCandidatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _personAIdMeta = const VerificationMeta(
    'personAId',
  );
  @override
  late final GeneratedColumn<String> personAId = GeneratedColumn<String>(
    'person_a_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES persons (id)',
    ),
  );
  static const VerificationMeta _personBIdMeta = const VerificationMeta(
    'personBId',
  );
  @override
  late final GeneratedColumn<String> personBId = GeneratedColumn<String>(
    'person_b_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES persons (id)',
    ),
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
    'score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reasonCodesJsonMeta = const VerificationMeta(
    'reasonCodesJson',
  );
  @override
  late final GeneratedColumn<String> reasonCodesJson = GeneratedColumn<String>(
    'reason_codes_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _detectorVersionMeta = const VerificationMeta(
    'detectorVersion',
  );
  @override
  late final GeneratedColumn<int> detectorVersion = GeneratedColumn<int>(
    'detector_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastEvaluatedAtMeta = const VerificationMeta(
    'lastEvaluatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastEvaluatedAt =
      GeneratedColumn<DateTime>(
        'last_evaluated_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _resolvedAtMeta = const VerificationMeta(
    'resolvedAt',
  );
  @override
  late final GeneratedColumn<DateTime> resolvedAt = GeneratedColumn<DateTime>(
    'resolved_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mergedIntoPersonIdMeta =
      const VerificationMeta('mergedIntoPersonId');
  @override
  late final GeneratedColumn<String> mergedIntoPersonId =
      GeneratedColumn<String>(
        'merged_into_person_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES persons (id)',
        ),
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modifiedAtMeta = const VerificationMeta(
    'modifiedAt',
  );
  @override
  late final GeneratedColumn<DateTime> modifiedAt = GeneratedColumn<DateTime>(
    'modified_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    personAId,
    personBId,
    score,
    reasonCodesJson,
    detectorVersion,
    status,
    lastEvaluatedAt,
    resolvedAt,
    mergedIntoPersonId,
    createdAt,
    modifiedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'duplicate_candidates';
  @override
  VerificationContext validateIntegrity(
    Insertable<DuplicateCandidate> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('person_a_id')) {
      context.handle(
        _personAIdMeta,
        personAId.isAcceptableOrUnknown(data['person_a_id']!, _personAIdMeta),
      );
    } else if (isInserting) {
      context.missing(_personAIdMeta);
    }
    if (data.containsKey('person_b_id')) {
      context.handle(
        _personBIdMeta,
        personBId.isAcceptableOrUnknown(data['person_b_id']!, _personBIdMeta),
      );
    } else if (isInserting) {
      context.missing(_personBIdMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    } else if (isInserting) {
      context.missing(_scoreMeta);
    }
    if (data.containsKey('reason_codes_json')) {
      context.handle(
        _reasonCodesJsonMeta,
        reasonCodesJson.isAcceptableOrUnknown(
          data['reason_codes_json']!,
          _reasonCodesJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_reasonCodesJsonMeta);
    }
    if (data.containsKey('detector_version')) {
      context.handle(
        _detectorVersionMeta,
        detectorVersion.isAcceptableOrUnknown(
          data['detector_version']!,
          _detectorVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_detectorVersionMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('last_evaluated_at')) {
      context.handle(
        _lastEvaluatedAtMeta,
        lastEvaluatedAt.isAcceptableOrUnknown(
          data['last_evaluated_at']!,
          _lastEvaluatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastEvaluatedAtMeta);
    }
    if (data.containsKey('resolved_at')) {
      context.handle(
        _resolvedAtMeta,
        resolvedAt.isAcceptableOrUnknown(data['resolved_at']!, _resolvedAtMeta),
      );
    }
    if (data.containsKey('merged_into_person_id')) {
      context.handle(
        _mergedIntoPersonIdMeta,
        mergedIntoPersonId.isAcceptableOrUnknown(
          data['merged_into_person_id']!,
          _mergedIntoPersonIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('modified_at')) {
      context.handle(
        _modifiedAtMeta,
        modifiedAt.isAcceptableOrUnknown(data['modified_at']!, _modifiedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_modifiedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DuplicateCandidate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DuplicateCandidate(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      personAId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}person_a_id'],
      )!,
      personBId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}person_b_id'],
      )!,
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}score'],
      )!,
      reasonCodesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason_codes_json'],
      )!,
      detectorVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}detector_version'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      lastEvaluatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_evaluated_at'],
      )!,
      resolvedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}resolved_at'],
      ),
      mergedIntoPersonId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}merged_into_person_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      modifiedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}modified_at'],
      )!,
    );
  }

  @override
  $DuplicateCandidatesTable createAlias(String alias) {
    return $DuplicateCandidatesTable(attachedDatabase, alias);
  }
}

class DuplicateCandidate extends DataClass
    implements Insertable<DuplicateCandidate> {
  final String id;
  final String personAId;
  final String personBId;
  final int score;
  final String reasonCodesJson;
  final int detectorVersion;
  final String status;
  final DateTime lastEvaluatedAt;
  final DateTime? resolvedAt;
  final String? mergedIntoPersonId;
  final DateTime createdAt;
  final DateTime modifiedAt;
  const DuplicateCandidate({
    required this.id,
    required this.personAId,
    required this.personBId,
    required this.score,
    required this.reasonCodesJson,
    required this.detectorVersion,
    required this.status,
    required this.lastEvaluatedAt,
    this.resolvedAt,
    this.mergedIntoPersonId,
    required this.createdAt,
    required this.modifiedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['person_a_id'] = Variable<String>(personAId);
    map['person_b_id'] = Variable<String>(personBId);
    map['score'] = Variable<int>(score);
    map['reason_codes_json'] = Variable<String>(reasonCodesJson);
    map['detector_version'] = Variable<int>(detectorVersion);
    map['status'] = Variable<String>(status);
    map['last_evaluated_at'] = Variable<DateTime>(lastEvaluatedAt);
    if (!nullToAbsent || resolvedAt != null) {
      map['resolved_at'] = Variable<DateTime>(resolvedAt);
    }
    if (!nullToAbsent || mergedIntoPersonId != null) {
      map['merged_into_person_id'] = Variable<String>(mergedIntoPersonId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['modified_at'] = Variable<DateTime>(modifiedAt);
    return map;
  }

  DuplicateCandidatesCompanion toCompanion(bool nullToAbsent) {
    return DuplicateCandidatesCompanion(
      id: Value(id),
      personAId: Value(personAId),
      personBId: Value(personBId),
      score: Value(score),
      reasonCodesJson: Value(reasonCodesJson),
      detectorVersion: Value(detectorVersion),
      status: Value(status),
      lastEvaluatedAt: Value(lastEvaluatedAt),
      resolvedAt: resolvedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(resolvedAt),
      mergedIntoPersonId: mergedIntoPersonId == null && nullToAbsent
          ? const Value.absent()
          : Value(mergedIntoPersonId),
      createdAt: Value(createdAt),
      modifiedAt: Value(modifiedAt),
    );
  }

  factory DuplicateCandidate.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DuplicateCandidate(
      id: serializer.fromJson<String>(json['id']),
      personAId: serializer.fromJson<String>(json['personAId']),
      personBId: serializer.fromJson<String>(json['personBId']),
      score: serializer.fromJson<int>(json['score']),
      reasonCodesJson: serializer.fromJson<String>(json['reasonCodesJson']),
      detectorVersion: serializer.fromJson<int>(json['detectorVersion']),
      status: serializer.fromJson<String>(json['status']),
      lastEvaluatedAt: serializer.fromJson<DateTime>(json['lastEvaluatedAt']),
      resolvedAt: serializer.fromJson<DateTime?>(json['resolvedAt']),
      mergedIntoPersonId: serializer.fromJson<String?>(
        json['mergedIntoPersonId'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      modifiedAt: serializer.fromJson<DateTime>(json['modifiedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'personAId': serializer.toJson<String>(personAId),
      'personBId': serializer.toJson<String>(personBId),
      'score': serializer.toJson<int>(score),
      'reasonCodesJson': serializer.toJson<String>(reasonCodesJson),
      'detectorVersion': serializer.toJson<int>(detectorVersion),
      'status': serializer.toJson<String>(status),
      'lastEvaluatedAt': serializer.toJson<DateTime>(lastEvaluatedAt),
      'resolvedAt': serializer.toJson<DateTime?>(resolvedAt),
      'mergedIntoPersonId': serializer.toJson<String?>(mergedIntoPersonId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'modifiedAt': serializer.toJson<DateTime>(modifiedAt),
    };
  }

  DuplicateCandidate copyWith({
    String? id,
    String? personAId,
    String? personBId,
    int? score,
    String? reasonCodesJson,
    int? detectorVersion,
    String? status,
    DateTime? lastEvaluatedAt,
    Value<DateTime?> resolvedAt = const Value.absent(),
    Value<String?> mergedIntoPersonId = const Value.absent(),
    DateTime? createdAt,
    DateTime? modifiedAt,
  }) => DuplicateCandidate(
    id: id ?? this.id,
    personAId: personAId ?? this.personAId,
    personBId: personBId ?? this.personBId,
    score: score ?? this.score,
    reasonCodesJson: reasonCodesJson ?? this.reasonCodesJson,
    detectorVersion: detectorVersion ?? this.detectorVersion,
    status: status ?? this.status,
    lastEvaluatedAt: lastEvaluatedAt ?? this.lastEvaluatedAt,
    resolvedAt: resolvedAt.present ? resolvedAt.value : this.resolvedAt,
    mergedIntoPersonId: mergedIntoPersonId.present
        ? mergedIntoPersonId.value
        : this.mergedIntoPersonId,
    createdAt: createdAt ?? this.createdAt,
    modifiedAt: modifiedAt ?? this.modifiedAt,
  );
  DuplicateCandidate copyWithCompanion(DuplicateCandidatesCompanion data) {
    return DuplicateCandidate(
      id: data.id.present ? data.id.value : this.id,
      personAId: data.personAId.present ? data.personAId.value : this.personAId,
      personBId: data.personBId.present ? data.personBId.value : this.personBId,
      score: data.score.present ? data.score.value : this.score,
      reasonCodesJson: data.reasonCodesJson.present
          ? data.reasonCodesJson.value
          : this.reasonCodesJson,
      detectorVersion: data.detectorVersion.present
          ? data.detectorVersion.value
          : this.detectorVersion,
      status: data.status.present ? data.status.value : this.status,
      lastEvaluatedAt: data.lastEvaluatedAt.present
          ? data.lastEvaluatedAt.value
          : this.lastEvaluatedAt,
      resolvedAt: data.resolvedAt.present
          ? data.resolvedAt.value
          : this.resolvedAt,
      mergedIntoPersonId: data.mergedIntoPersonId.present
          ? data.mergedIntoPersonId.value
          : this.mergedIntoPersonId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      modifiedAt: data.modifiedAt.present
          ? data.modifiedAt.value
          : this.modifiedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DuplicateCandidate(')
          ..write('id: $id, ')
          ..write('personAId: $personAId, ')
          ..write('personBId: $personBId, ')
          ..write('score: $score, ')
          ..write('reasonCodesJson: $reasonCodesJson, ')
          ..write('detectorVersion: $detectorVersion, ')
          ..write('status: $status, ')
          ..write('lastEvaluatedAt: $lastEvaluatedAt, ')
          ..write('resolvedAt: $resolvedAt, ')
          ..write('mergedIntoPersonId: $mergedIntoPersonId, ')
          ..write('createdAt: $createdAt, ')
          ..write('modifiedAt: $modifiedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    personAId,
    personBId,
    score,
    reasonCodesJson,
    detectorVersion,
    status,
    lastEvaluatedAt,
    resolvedAt,
    mergedIntoPersonId,
    createdAt,
    modifiedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DuplicateCandidate &&
          other.id == this.id &&
          other.personAId == this.personAId &&
          other.personBId == this.personBId &&
          other.score == this.score &&
          other.reasonCodesJson == this.reasonCodesJson &&
          other.detectorVersion == this.detectorVersion &&
          other.status == this.status &&
          other.lastEvaluatedAt == this.lastEvaluatedAt &&
          other.resolvedAt == this.resolvedAt &&
          other.mergedIntoPersonId == this.mergedIntoPersonId &&
          other.createdAt == this.createdAt &&
          other.modifiedAt == this.modifiedAt);
}

class DuplicateCandidatesCompanion extends UpdateCompanion<DuplicateCandidate> {
  final Value<String> id;
  final Value<String> personAId;
  final Value<String> personBId;
  final Value<int> score;
  final Value<String> reasonCodesJson;
  final Value<int> detectorVersion;
  final Value<String> status;
  final Value<DateTime> lastEvaluatedAt;
  final Value<DateTime?> resolvedAt;
  final Value<String?> mergedIntoPersonId;
  final Value<DateTime> createdAt;
  final Value<DateTime> modifiedAt;
  final Value<int> rowid;
  const DuplicateCandidatesCompanion({
    this.id = const Value.absent(),
    this.personAId = const Value.absent(),
    this.personBId = const Value.absent(),
    this.score = const Value.absent(),
    this.reasonCodesJson = const Value.absent(),
    this.detectorVersion = const Value.absent(),
    this.status = const Value.absent(),
    this.lastEvaluatedAt = const Value.absent(),
    this.resolvedAt = const Value.absent(),
    this.mergedIntoPersonId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.modifiedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DuplicateCandidatesCompanion.insert({
    required String id,
    required String personAId,
    required String personBId,
    required int score,
    required String reasonCodesJson,
    required int detectorVersion,
    required String status,
    required DateTime lastEvaluatedAt,
    this.resolvedAt = const Value.absent(),
    this.mergedIntoPersonId = const Value.absent(),
    required DateTime createdAt,
    required DateTime modifiedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       personAId = Value(personAId),
       personBId = Value(personBId),
       score = Value(score),
       reasonCodesJson = Value(reasonCodesJson),
       detectorVersion = Value(detectorVersion),
       status = Value(status),
       lastEvaluatedAt = Value(lastEvaluatedAt),
       createdAt = Value(createdAt),
       modifiedAt = Value(modifiedAt);
  static Insertable<DuplicateCandidate> custom({
    Expression<String>? id,
    Expression<String>? personAId,
    Expression<String>? personBId,
    Expression<int>? score,
    Expression<String>? reasonCodesJson,
    Expression<int>? detectorVersion,
    Expression<String>? status,
    Expression<DateTime>? lastEvaluatedAt,
    Expression<DateTime>? resolvedAt,
    Expression<String>? mergedIntoPersonId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? modifiedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (personAId != null) 'person_a_id': personAId,
      if (personBId != null) 'person_b_id': personBId,
      if (score != null) 'score': score,
      if (reasonCodesJson != null) 'reason_codes_json': reasonCodesJson,
      if (detectorVersion != null) 'detector_version': detectorVersion,
      if (status != null) 'status': status,
      if (lastEvaluatedAt != null) 'last_evaluated_at': lastEvaluatedAt,
      if (resolvedAt != null) 'resolved_at': resolvedAt,
      if (mergedIntoPersonId != null)
        'merged_into_person_id': mergedIntoPersonId,
      if (createdAt != null) 'created_at': createdAt,
      if (modifiedAt != null) 'modified_at': modifiedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DuplicateCandidatesCompanion copyWith({
    Value<String>? id,
    Value<String>? personAId,
    Value<String>? personBId,
    Value<int>? score,
    Value<String>? reasonCodesJson,
    Value<int>? detectorVersion,
    Value<String>? status,
    Value<DateTime>? lastEvaluatedAt,
    Value<DateTime?>? resolvedAt,
    Value<String?>? mergedIntoPersonId,
    Value<DateTime>? createdAt,
    Value<DateTime>? modifiedAt,
    Value<int>? rowid,
  }) {
    return DuplicateCandidatesCompanion(
      id: id ?? this.id,
      personAId: personAId ?? this.personAId,
      personBId: personBId ?? this.personBId,
      score: score ?? this.score,
      reasonCodesJson: reasonCodesJson ?? this.reasonCodesJson,
      detectorVersion: detectorVersion ?? this.detectorVersion,
      status: status ?? this.status,
      lastEvaluatedAt: lastEvaluatedAt ?? this.lastEvaluatedAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      mergedIntoPersonId: mergedIntoPersonId ?? this.mergedIntoPersonId,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (personAId.present) {
      map['person_a_id'] = Variable<String>(personAId.value);
    }
    if (personBId.present) {
      map['person_b_id'] = Variable<String>(personBId.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (reasonCodesJson.present) {
      map['reason_codes_json'] = Variable<String>(reasonCodesJson.value);
    }
    if (detectorVersion.present) {
      map['detector_version'] = Variable<int>(detectorVersion.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (lastEvaluatedAt.present) {
      map['last_evaluated_at'] = Variable<DateTime>(lastEvaluatedAt.value);
    }
    if (resolvedAt.present) {
      map['resolved_at'] = Variable<DateTime>(resolvedAt.value);
    }
    if (mergedIntoPersonId.present) {
      map['merged_into_person_id'] = Variable<String>(mergedIntoPersonId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (modifiedAt.present) {
      map['modified_at'] = Variable<DateTime>(modifiedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DuplicateCandidatesCompanion(')
          ..write('id: $id, ')
          ..write('personAId: $personAId, ')
          ..write('personBId: $personBId, ')
          ..write('score: $score, ')
          ..write('reasonCodesJson: $reasonCodesJson, ')
          ..write('detectorVersion: $detectorVersion, ')
          ..write('status: $status, ')
          ..write('lastEvaluatedAt: $lastEvaluatedAt, ')
          ..write('resolvedAt: $resolvedAt, ')
          ..write('mergedIntoPersonId: $mergedIntoPersonId, ')
          ..write('createdAt: $createdAt, ')
          ..write('modifiedAt: $modifiedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AuditEntriesTable extends AuditEntries
    with TableInfo<$AuditEntriesTable, AuditEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuditEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originMeta = const VerificationMeta('origin');
  @override
  late final GeneratedColumn<String> origin = GeneratedColumn<String>(
    'origin',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadVersionMeta = const VerificationMeta(
    'payloadVersion',
  );
  @override
  late final GeneratedColumn<int> payloadVersion = GeneratedColumn<int>(
    'payload_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    origin,
    occurredAt,
    payloadVersion,
    payloadJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audit_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<AuditEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('origin')) {
      context.handle(
        _originMeta,
        origin.isAcceptableOrUnknown(data['origin']!, _originMeta),
      );
    } else if (isInserting) {
      context.missing(_originMeta);
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('payload_version')) {
      context.handle(
        _payloadVersionMeta,
        payloadVersion.isAcceptableOrUnknown(
          data['payload_version']!,
          _payloadVersionMeta,
        ),
      );
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AuditEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuditEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      origin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}origin'],
      )!,
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
      payloadVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}payload_version'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
    );
  }

  @override
  $AuditEntriesTable createAlias(String alias) {
    return $AuditEntriesTable(attachedDatabase, alias);
  }
}

class AuditEntry extends DataClass implements Insertable<AuditEntry> {
  final String id;
  final String type;
  final String origin;
  final DateTime occurredAt;
  final int payloadVersion;
  final String payloadJson;
  const AuditEntry({
    required this.id,
    required this.type,
    required this.origin,
    required this.occurredAt,
    required this.payloadVersion,
    required this.payloadJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['type'] = Variable<String>(type);
    map['origin'] = Variable<String>(origin);
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    map['payload_version'] = Variable<int>(payloadVersion);
    map['payload_json'] = Variable<String>(payloadJson);
    return map;
  }

  AuditEntriesCompanion toCompanion(bool nullToAbsent) {
    return AuditEntriesCompanion(
      id: Value(id),
      type: Value(type),
      origin: Value(origin),
      occurredAt: Value(occurredAt),
      payloadVersion: Value(payloadVersion),
      payloadJson: Value(payloadJson),
    );
  }

  factory AuditEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuditEntry(
      id: serializer.fromJson<String>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      origin: serializer.fromJson<String>(json['origin']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      payloadVersion: serializer.fromJson<int>(json['payloadVersion']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<String>(type),
      'origin': serializer.toJson<String>(origin),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'payloadVersion': serializer.toJson<int>(payloadVersion),
      'payloadJson': serializer.toJson<String>(payloadJson),
    };
  }

  AuditEntry copyWith({
    String? id,
    String? type,
    String? origin,
    DateTime? occurredAt,
    int? payloadVersion,
    String? payloadJson,
  }) => AuditEntry(
    id: id ?? this.id,
    type: type ?? this.type,
    origin: origin ?? this.origin,
    occurredAt: occurredAt ?? this.occurredAt,
    payloadVersion: payloadVersion ?? this.payloadVersion,
    payloadJson: payloadJson ?? this.payloadJson,
  );
  AuditEntry copyWithCompanion(AuditEntriesCompanion data) {
    return AuditEntry(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      origin: data.origin.present ? data.origin.value : this.origin,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      payloadVersion: data.payloadVersion.present
          ? data.payloadVersion.value
          : this.payloadVersion,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuditEntry(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('origin: $origin, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('payloadVersion: $payloadVersion, ')
          ..write('payloadJson: $payloadJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, type, origin, occurredAt, payloadVersion, payloadJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuditEntry &&
          other.id == this.id &&
          other.type == this.type &&
          other.origin == this.origin &&
          other.occurredAt == this.occurredAt &&
          other.payloadVersion == this.payloadVersion &&
          other.payloadJson == this.payloadJson);
}

class AuditEntriesCompanion extends UpdateCompanion<AuditEntry> {
  final Value<String> id;
  final Value<String> type;
  final Value<String> origin;
  final Value<DateTime> occurredAt;
  final Value<int> payloadVersion;
  final Value<String> payloadJson;
  final Value<int> rowid;
  const AuditEntriesCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.origin = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.payloadVersion = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AuditEntriesCompanion.insert({
    required String id,
    required String type,
    required String origin,
    required DateTime occurredAt,
    this.payloadVersion = const Value.absent(),
    required String payloadJson,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       type = Value(type),
       origin = Value(origin),
       occurredAt = Value(occurredAt),
       payloadJson = Value(payloadJson);
  static Insertable<AuditEntry> custom({
    Expression<String>? id,
    Expression<String>? type,
    Expression<String>? origin,
    Expression<DateTime>? occurredAt,
    Expression<int>? payloadVersion,
    Expression<String>? payloadJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (origin != null) 'origin': origin,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (payloadVersion != null) 'payload_version': payloadVersion,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AuditEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? type,
    Value<String>? origin,
    Value<DateTime>? occurredAt,
    Value<int>? payloadVersion,
    Value<String>? payloadJson,
    Value<int>? rowid,
  }) {
    return AuditEntriesCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      origin: origin ?? this.origin,
      occurredAt: occurredAt ?? this.occurredAt,
      payloadVersion: payloadVersion ?? this.payloadVersion,
      payloadJson: payloadJson ?? this.payloadJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (origin.present) {
      map['origin'] = Variable<String>(origin.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (payloadVersion.present) {
      map['payload_version'] = Variable<int>(payloadVersion.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuditEntriesCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('origin: $origin, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('payloadVersion: $payloadVersion, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AuditTargetsTable extends AuditTargets
    with TableInfo<$AuditTargetsTable, AuditTarget> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuditTargetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _auditEntryIdMeta = const VerificationMeta(
    'auditEntryId',
  );
  @override
  late final GeneratedColumn<String> auditEntryId = GeneratedColumn<String>(
    'audit_entry_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES audit_entries (id)',
    ),
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    auditEntryId,
    entityType,
    entityId,
    role,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audit_targets';
  @override
  VerificationContext validateIntegrity(
    Insertable<AuditTarget> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('audit_entry_id')) {
      context.handle(
        _auditEntryIdMeta,
        auditEntryId.isAcceptableOrUnknown(
          data['audit_entry_id']!,
          _auditEntryIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_auditEntryIdMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AuditTarget map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuditTarget(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      auditEntryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audit_entry_id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
    );
  }

  @override
  $AuditTargetsTable createAlias(String alias) {
    return $AuditTargetsTable(attachedDatabase, alias);
  }
}

class AuditTarget extends DataClass implements Insertable<AuditTarget> {
  final int id;
  final String auditEntryId;
  final String entityType;
  final String entityId;
  final String role;
  const AuditTarget({
    required this.id,
    required this.auditEntryId,
    required this.entityType,
    required this.entityId,
    required this.role,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['audit_entry_id'] = Variable<String>(auditEntryId);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['role'] = Variable<String>(role);
    return map;
  }

  AuditTargetsCompanion toCompanion(bool nullToAbsent) {
    return AuditTargetsCompanion(
      id: Value(id),
      auditEntryId: Value(auditEntryId),
      entityType: Value(entityType),
      entityId: Value(entityId),
      role: Value(role),
    );
  }

  factory AuditTarget.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuditTarget(
      id: serializer.fromJson<int>(json['id']),
      auditEntryId: serializer.fromJson<String>(json['auditEntryId']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      role: serializer.fromJson<String>(json['role']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'auditEntryId': serializer.toJson<String>(auditEntryId),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'role': serializer.toJson<String>(role),
    };
  }

  AuditTarget copyWith({
    int? id,
    String? auditEntryId,
    String? entityType,
    String? entityId,
    String? role,
  }) => AuditTarget(
    id: id ?? this.id,
    auditEntryId: auditEntryId ?? this.auditEntryId,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    role: role ?? this.role,
  );
  AuditTarget copyWithCompanion(AuditTargetsCompanion data) {
    return AuditTarget(
      id: data.id.present ? data.id.value : this.id,
      auditEntryId: data.auditEntryId.present
          ? data.auditEntryId.value
          : this.auditEntryId,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      role: data.role.present ? data.role.value : this.role,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuditTarget(')
          ..write('id: $id, ')
          ..write('auditEntryId: $auditEntryId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('role: $role')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, auditEntryId, entityType, entityId, role);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuditTarget &&
          other.id == this.id &&
          other.auditEntryId == this.auditEntryId &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.role == this.role);
}

class AuditTargetsCompanion extends UpdateCompanion<AuditTarget> {
  final Value<int> id;
  final Value<String> auditEntryId;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> role;
  const AuditTargetsCompanion({
    this.id = const Value.absent(),
    this.auditEntryId = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.role = const Value.absent(),
  });
  AuditTargetsCompanion.insert({
    this.id = const Value.absent(),
    required String auditEntryId,
    required String entityType,
    required String entityId,
    required String role,
  }) : auditEntryId = Value(auditEntryId),
       entityType = Value(entityType),
       entityId = Value(entityId),
       role = Value(role);
  static Insertable<AuditTarget> custom({
    Expression<int>? id,
    Expression<String>? auditEntryId,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? role,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (auditEntryId != null) 'audit_entry_id': auditEntryId,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (role != null) 'role': role,
    });
  }

  AuditTargetsCompanion copyWith({
    Value<int>? id,
    Value<String>? auditEntryId,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<String>? role,
  }) {
    return AuditTargetsCompanion(
      id: id ?? this.id,
      auditEntryId: auditEntryId ?? this.auditEntryId,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      role: role ?? this.role,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (auditEntryId.present) {
      map['audit_entry_id'] = Variable<String>(auditEntryId.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuditTargetsCompanion(')
          ..write('id: $id, ')
          ..write('auditEntryId: $auditEntryId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('role: $role')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProjectsTable projects = $ProjectsTable(this);
  late final $PersonsTable persons = $PersonsTable(this);
  late final $PersonNamesTable personNames = $PersonNamesTable(this);
  late final $ParentChildRelationshipsTable parentChildRelationships =
      $ParentChildRelationshipsTable(this);
  late final $PlacesTable places = $PlacesTable(this);
  late final $PartnershipsTable partnerships = $PartnershipsTable(this);
  late final $PlaceRelationshipsTable placeRelationships =
      $PlaceRelationshipsTable(this);
  late final $ResidencesTable residences = $ResidencesTable(this);
  late final $EventsTable events = $EventsTable(this);
  late final $EventParticipantsTable eventParticipants =
      $EventParticipantsTable(this);
  late final $SourcesTable sources = $SourcesTable(this);
  late final $MediaAssetsTable mediaAssets = $MediaAssetsTable(this);
  late final $SourceMediaLinksTable sourceMediaLinks = $SourceMediaLinksTable(
    this,
  );
  late final $ClaimsTable claims = $ClaimsTable(this);
  late final $ClaimApplicationsTable claimApplications =
      $ClaimApplicationsTable(this);
  late final $DuplicateCandidatesTable duplicateCandidates =
      $DuplicateCandidatesTable(this);
  late final $AuditEntriesTable auditEntries = $AuditEntriesTable(this);
  late final $AuditTargetsTable auditTargets = $AuditTargetsTable(this);
  late final Index personNamesPersonId = Index(
    'person_names_person_id',
    'CREATE INDEX person_names_person_id ON person_names (person_id)',
  );
  late final Index personNamesOnePreferredActive = Index(
    'person_names_one_preferred_active',
    'CREATE UNIQUE INDEX person_names_one_preferred_active ON person_names (person_id) WHERE is_preferred = 1 AND deleted_at IS NULL',
  );
  late final Index parentChildParentId = Index(
    'parent_child_parent_id',
    'CREATE INDEX parent_child_parent_id ON parent_child_relationships (parent_person_id)',
  );
  late final Index parentChildChildId = Index(
    'parent_child_child_id',
    'CREATE INDEX parent_child_child_id ON parent_child_relationships (child_person_id)',
  );
  late final Index parentChildUniqueActive = Index(
    'parent_child_unique_active',
    'CREATE UNIQUE INDEX parent_child_unique_active ON parent_child_relationships (parent_person_id, child_person_id, nature) WHERE deleted_at IS NULL',
  );
  late final Index partnershipsPersonAId = Index(
    'partnerships_person_a_id',
    'CREATE INDEX partnerships_person_a_id ON partnerships (person_a_id)',
  );
  late final Index partnershipsPersonBId = Index(
    'partnerships_person_b_id',
    'CREATE INDEX partnerships_person_b_id ON partnerships (person_b_id)',
  );
  late final Index placeRelationshipsSourceId = Index(
    'place_relationships_source_id',
    'CREATE INDEX place_relationships_source_id ON place_relationships (source_place_id)',
  );
  late final Index placeRelationshipsTargetId = Index(
    'place_relationships_target_id',
    'CREATE INDEX place_relationships_target_id ON place_relationships (target_place_id)',
  );
  late final Index residencesPersonId = Index(
    'residences_person_id',
    'CREATE INDEX residences_person_id ON residences (person_id)',
  );
  late final Index residencesPlaceId = Index(
    'residences_place_id',
    'CREATE INDEX residences_place_id ON residences (place_id)',
  );
  late final Index eventsPlaceId = Index(
    'events_place_id',
    'CREATE INDEX events_place_id ON events (place_id)',
  );
  late final Index eventParticipantsEventId = Index(
    'event_participants_event_id',
    'CREATE INDEX event_participants_event_id ON event_participants (event_id)',
  );
  late final Index eventParticipantsPersonId = Index(
    'event_participants_person_id',
    'CREATE INDEX event_participants_person_id ON event_participants (person_id)',
  );
  late final Index mediaRelativePathActive = Index(
    'media_relative_path_active',
    'CREATE UNIQUE INDEX media_relative_path_active ON media (relative_path) WHERE deleted_at IS NULL',
  );
  late final Index mediaChecksumSizeActive = Index(
    'media_checksum_size_active',
    'CREATE UNIQUE INDEX media_checksum_size_active ON media (checksum_sha256, file_size) WHERE deleted_at IS NULL',
  );
  late final Index sourceMediaSourceId = Index(
    'source_media_source_id',
    'CREATE INDEX source_media_source_id ON source_media (source_id)',
  );
  late final Index sourceMediaMediaId = Index(
    'source_media_media_id',
    'CREATE INDEX source_media_media_id ON source_media (media_id)',
  );
  late final Index sourceMediaPairActive = Index(
    'source_media_pair_active',
    'CREATE UNIQUE INDEX source_media_pair_active ON source_media (source_id, media_id) WHERE deleted_at IS NULL',
  );
  late final Index claimsSubject = Index(
    'claims_subject',
    'CREATE INDEX claims_subject ON claims (subject_type, subject_id)',
  );
  late final Index claimsSubjectProperty = Index(
    'claims_subject_property',
    'CREATE INDEX claims_subject_property ON claims (subject_type, subject_id, property)',
  );
  late final Index claimsSourceId = Index(
    'claims_source_id',
    'CREATE INDEX claims_source_id ON claims (source_id)',
  );
  late final Index claimsStatus = Index(
    'claims_status',
    'CREATE INDEX claims_status ON claims (status)',
  );
  late final Index claimApplicationsResult = Index(
    'claim_applications_result',
    'CREATE INDEX claim_applications_result ON claim_applications (result_entity_type, result_entity_id)',
  );
  late final Index duplicateCandidatesPair = Index(
    'duplicate_candidates_pair',
    'CREATE UNIQUE INDEX duplicate_candidates_pair ON duplicate_candidates (person_a_id, person_b_id)',
  );
  late final Index duplicateCandidatesStatus = Index(
    'duplicate_candidates_status',
    'CREATE INDEX duplicate_candidates_status ON duplicate_candidates (status)',
  );
  late final Index auditEntriesOccurredAt = Index(
    'audit_entries_occurred_at',
    'CREATE INDEX audit_entries_occurred_at ON audit_entries (occurred_at)',
  );
  late final Index auditTargetsEntity = Index(
    'audit_targets_entity',
    'CREATE INDEX audit_targets_entity ON audit_targets (entity_type, entity_id)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    projects,
    persons,
    personNames,
    parentChildRelationships,
    places,
    partnerships,
    placeRelationships,
    residences,
    events,
    eventParticipants,
    sources,
    mediaAssets,
    sourceMediaLinks,
    claims,
    claimApplications,
    duplicateCandidates,
    auditEntries,
    auditTargets,
    personNamesPersonId,
    personNamesOnePreferredActive,
    parentChildParentId,
    parentChildChildId,
    parentChildUniqueActive,
    partnershipsPersonAId,
    partnershipsPersonBId,
    placeRelationshipsSourceId,
    placeRelationshipsTargetId,
    residencesPersonId,
    residencesPlaceId,
    eventsPlaceId,
    eventParticipantsEventId,
    eventParticipantsPersonId,
    mediaRelativePathActive,
    mediaChecksumSizeActive,
    sourceMediaSourceId,
    sourceMediaMediaId,
    sourceMediaPairActive,
    claimsSubject,
    claimsSubjectProperty,
    claimsSourceId,
    claimsStatus,
    claimApplicationsResult,
    duplicateCandidatesPair,
    duplicateCandidatesStatus,
    auditEntriesOccurredAt,
    auditTargetsEntity,
  ];
}

typedef $$ProjectsTableCreateCompanionBuilder = ProjectsCompanion Function({
  required String id,
  required String name,
  required DateTime createdAt,
  required DateTime modifiedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});
typedef $$ProjectsTableUpdateCompanionBuilder = ProjectsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<DateTime> createdAt,
  Value<DateTime> modifiedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});

class $$ProjectsTableFilterComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProjectsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProjectsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$ProjectsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProjectsTable,
          Project,
          $$ProjectsTableFilterComposer,
          $$ProjectsTableOrderingComposer,
          $$ProjectsTableAnnotationComposer,
          $$ProjectsTableCreateCompanionBuilder,
          $$ProjectsTableUpdateCompanionBuilder,
          (Project, BaseReferences<_$AppDatabase, $ProjectsTable, Project>),
          Project,
          PrefetchHooks Function()
        > {
  $$ProjectsTableTableManager(_$AppDatabase db, $ProjectsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> modifiedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProjectsCompanion(
                id: id,
                name: name,
                createdAt: createdAt,
                modifiedAt: modifiedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required DateTime createdAt,
                required DateTime modifiedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProjectsCompanion.insert(
                id: id,
                name: name,
                createdAt: createdAt,
                modifiedAt: modifiedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProjectsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProjectsTable,
      Project,
      $$ProjectsTableFilterComposer,
      $$ProjectsTableOrderingComposer,
      $$ProjectsTableAnnotationComposer,
      $$ProjectsTableCreateCompanionBuilder,
      $$ProjectsTableUpdateCompanionBuilder,
      (Project, BaseReferences<_$AppDatabase, $ProjectsTable, Project>),
      Project,
      PrefetchHooks Function()
    >;
typedef $$PersonsTableCreateCompanionBuilder = PersonsCompanion Function({
  required String id,
  required String sex,
  Value<String?> birthPrecision,
  Value<DateTime?> birthStartDate,
  Value<DateTime?> birthEndDate,
  Value<String?> birthDisplayText,
  Value<String?> deathPrecision,
  Value<DateTime?> deathStartDate,
  Value<DateTime?> deathEndDate,
  Value<String?> deathDisplayText,
  Value<String?> biography,
  Value<String?> notes,
  required DateTime createdAt,
  required DateTime modifiedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});
typedef $$PersonsTableUpdateCompanionBuilder = PersonsCompanion Function({
  Value<String> id,
  Value<String> sex,
  Value<String?> birthPrecision,
  Value<DateTime?> birthStartDate,
  Value<DateTime?> birthEndDate,
  Value<String?> birthDisplayText,
  Value<String?> deathPrecision,
  Value<DateTime?> deathStartDate,
  Value<DateTime?> deathEndDate,
  Value<String?> deathDisplayText,
  Value<String?> biography,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> modifiedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});

final class $$PersonsTableReferences
    extends BaseReferences<_$AppDatabase, $PersonsTable, Person> {
  $$PersonsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PersonNamesTable, List<PersonName>>
  _personNamesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.personNames,
    aliasName: 'persons__id__person_names__person_id',
  );

  $$PersonNamesTableProcessedTableManager get personNamesRefs {
    final manager = $$PersonNamesTableTableManager(
      $_db,
      $_db.personNames,
    ).filter((f) => f.personId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_personNamesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ParentChildRelationshipsTable,
    List<ParentChildRelationship>
  >
  _childrenRelationshipsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.parentChildRelationships,
        aliasName: 'persons__id__parent_child_relationships__parent_person_id',
      );

  $$ParentChildRelationshipsTableProcessedTableManager
  get childrenRelationships {
    final manager = $$ParentChildRelationshipsTableTableManager(
      $_db,
      $_db.parentChildRelationships,
    ).filter((f) => f.parentPersonId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _childrenRelationshipsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ParentChildRelationshipsTable,
    List<ParentChildRelationship>
  >
  _parentRelationshipsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.parentChildRelationships,
    aliasName: 'persons__id__parent_child_relationships__child_person_id',
  );

  $$ParentChildRelationshipsTableProcessedTableManager get parentRelationships {
    final manager = $$ParentChildRelationshipsTableTableManager(
      $_db,
      $_db.parentChildRelationships,
    ).filter((f) => f.childPersonId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _parentRelationshipsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PartnershipsTable, List<Partnership>>
  _partnershipsAsPersonATable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.partnerships,
        aliasName: 'persons__id__partnerships__person_a_id',
      );

  $$PartnershipsTableProcessedTableManager get partnershipsAsPersonA {
    final manager = $$PartnershipsTableTableManager(
      $_db,
      $_db.partnerships,
    ).filter((f) => f.personAId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _partnershipsAsPersonATable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PartnershipsTable, List<Partnership>>
  _partnershipsAsPersonBTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.partnerships,
        aliasName: 'persons__id__partnerships__person_b_id',
      );

  $$PartnershipsTableProcessedTableManager get partnershipsAsPersonB {
    final manager = $$PartnershipsTableTableManager(
      $_db,
      $_db.partnerships,
    ).filter((f) => f.personBId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _partnershipsAsPersonBTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ResidencesTable, List<Residence>>
  _residencesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.residences,
    aliasName: 'persons__id__residences__person_id',
  );

  $$ResidencesTableProcessedTableManager get residencesRefs {
    final manager = $$ResidencesTableTableManager(
      $_db,
      $_db.residences,
    ).filter((f) => f.personId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_residencesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$EventParticipantsTable, List<EventParticipant>>
  _eventParticipantsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.eventParticipants,
        aliasName: 'persons__id__event_participants__person_id',
      );

  $$EventParticipantsTableProcessedTableManager get eventParticipantsRefs {
    final manager = $$EventParticipantsTableTableManager(
      $_db,
      $_db.eventParticipants,
    ).filter((f) => f.personId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _eventParticipantsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $DuplicateCandidatesTable,
    List<DuplicateCandidate>
  >
  _duplicateCandidatesAsATable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.duplicateCandidates,
        aliasName: 'persons__id__duplicate_candidates__person_a_id',
      );

  $$DuplicateCandidatesTableProcessedTableManager get duplicateCandidatesAsA {
    final manager = $$DuplicateCandidatesTableTableManager(
      $_db,
      $_db.duplicateCandidates,
    ).filter((f) => f.personAId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _duplicateCandidatesAsATable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $DuplicateCandidatesTable,
    List<DuplicateCandidate>
  >
  _duplicateCandidatesAsBTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.duplicateCandidates,
        aliasName: 'persons__id__duplicate_candidates__person_b_id',
      );

  $$DuplicateCandidatesTableProcessedTableManager get duplicateCandidatesAsB {
    final manager = $$DuplicateCandidatesTableTableManager(
      $_db,
      $_db.duplicateCandidates,
    ).filter((f) => f.personBId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _duplicateCandidatesAsBTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $DuplicateCandidatesTable,
    List<DuplicateCandidate>
  >
  _duplicateCandidatesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.duplicateCandidates,
        aliasName: 'persons__id__duplicate_candidates__merged_into_person_id',
      );

  $$DuplicateCandidatesTableProcessedTableManager get duplicateCandidatesRefs {
    final manager =
        $$DuplicateCandidatesTableTableManager(
          $_db,
          $_db.duplicateCandidates,
        ).filter(
          (f) => f.mergedIntoPersonId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _duplicateCandidatesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PersonsTableFilterComposer
    extends Composer<_$AppDatabase, $PersonsTable> {
  $$PersonsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sex => $composableBuilder(
    column: $table.sex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get birthPrecision => $composableBuilder(
    column: $table.birthPrecision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get birthStartDate => $composableBuilder(
    column: $table.birthStartDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get birthEndDate => $composableBuilder(
    column: $table.birthEndDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get birthDisplayText => $composableBuilder(
    column: $table.birthDisplayText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deathPrecision => $composableBuilder(
    column: $table.deathPrecision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deathStartDate => $composableBuilder(
    column: $table.deathStartDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deathEndDate => $composableBuilder(
    column: $table.deathEndDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deathDisplayText => $composableBuilder(
    column: $table.deathDisplayText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get biography => $composableBuilder(
    column: $table.biography,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> personNamesRefs(
    Expression<bool> Function($$PersonNamesTableFilterComposer f) f,
  ) {
    final $$PersonNamesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.personNames,
      getReferencedColumn: (t) => t.personId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonNamesTableFilterComposer(
            $db: $db,
            $table: $db.personNames,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> childrenRelationships(
    Expression<bool> Function($$ParentChildRelationshipsTableFilterComposer f)
    f,
  ) {
    final $$ParentChildRelationshipsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.parentChildRelationships,
          getReferencedColumn: (t) => t.parentPersonId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ParentChildRelationshipsTableFilterComposer(
                $db: $db,
                $table: $db.parentChildRelationships,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> parentRelationships(
    Expression<bool> Function($$ParentChildRelationshipsTableFilterComposer f)
    f,
  ) {
    final $$ParentChildRelationshipsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.parentChildRelationships,
          getReferencedColumn: (t) => t.childPersonId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ParentChildRelationshipsTableFilterComposer(
                $db: $db,
                $table: $db.parentChildRelationships,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> partnershipsAsPersonA(
    Expression<bool> Function($$PartnershipsTableFilterComposer f) f,
  ) {
    final $$PartnershipsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.partnerships,
      getReferencedColumn: (t) => t.personAId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartnershipsTableFilterComposer(
            $db: $db,
            $table: $db.partnerships,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> partnershipsAsPersonB(
    Expression<bool> Function($$PartnershipsTableFilterComposer f) f,
  ) {
    final $$PartnershipsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.partnerships,
      getReferencedColumn: (t) => t.personBId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartnershipsTableFilterComposer(
            $db: $db,
            $table: $db.partnerships,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> residencesRefs(
    Expression<bool> Function($$ResidencesTableFilterComposer f) f,
  ) {
    final $$ResidencesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.residences,
      getReferencedColumn: (t) => t.personId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ResidencesTableFilterComposer(
            $db: $db,
            $table: $db.residences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> eventParticipantsRefs(
    Expression<bool> Function($$EventParticipantsTableFilterComposer f) f,
  ) {
    final $$EventParticipantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.eventParticipants,
      getReferencedColumn: (t) => t.personId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventParticipantsTableFilterComposer(
            $db: $db,
            $table: $db.eventParticipants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> duplicateCandidatesAsA(
    Expression<bool> Function($$DuplicateCandidatesTableFilterComposer f) f,
  ) {
    final $$DuplicateCandidatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.duplicateCandidates,
      getReferencedColumn: (t) => t.personAId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DuplicateCandidatesTableFilterComposer(
            $db: $db,
            $table: $db.duplicateCandidates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> duplicateCandidatesAsB(
    Expression<bool> Function($$DuplicateCandidatesTableFilterComposer f) f,
  ) {
    final $$DuplicateCandidatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.duplicateCandidates,
      getReferencedColumn: (t) => t.personBId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DuplicateCandidatesTableFilterComposer(
            $db: $db,
            $table: $db.duplicateCandidates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> duplicateCandidatesRefs(
    Expression<bool> Function($$DuplicateCandidatesTableFilterComposer f) f,
  ) {
    final $$DuplicateCandidatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.duplicateCandidates,
      getReferencedColumn: (t) => t.mergedIntoPersonId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DuplicateCandidatesTableFilterComposer(
            $db: $db,
            $table: $db.duplicateCandidates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PersonsTableOrderingComposer
    extends Composer<_$AppDatabase, $PersonsTable> {
  $$PersonsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sex => $composableBuilder(
    column: $table.sex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get birthPrecision => $composableBuilder(
    column: $table.birthPrecision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get birthStartDate => $composableBuilder(
    column: $table.birthStartDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get birthEndDate => $composableBuilder(
    column: $table.birthEndDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get birthDisplayText => $composableBuilder(
    column: $table.birthDisplayText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deathPrecision => $composableBuilder(
    column: $table.deathPrecision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deathStartDate => $composableBuilder(
    column: $table.deathStartDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deathEndDate => $composableBuilder(
    column: $table.deathEndDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deathDisplayText => $composableBuilder(
    column: $table.deathDisplayText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get biography => $composableBuilder(
    column: $table.biography,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PersonsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PersonsTable> {
  $$PersonsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sex =>
      $composableBuilder(column: $table.sex, builder: (column) => column);

  GeneratedColumn<String> get birthPrecision => $composableBuilder(
    column: $table.birthPrecision,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get birthStartDate => $composableBuilder(
    column: $table.birthStartDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get birthEndDate => $composableBuilder(
    column: $table.birthEndDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get birthDisplayText => $composableBuilder(
    column: $table.birthDisplayText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deathPrecision => $composableBuilder(
    column: $table.deathPrecision,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deathStartDate => $composableBuilder(
    column: $table.deathStartDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deathEndDate => $composableBuilder(
    column: $table.deathEndDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deathDisplayText => $composableBuilder(
    column: $table.deathDisplayText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get biography =>
      $composableBuilder(column: $table.biography, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  Expression<T> personNamesRefs<T extends Object>(
    Expression<T> Function($$PersonNamesTableAnnotationComposer a) f,
  ) {
    final $$PersonNamesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.personNames,
      getReferencedColumn: (t) => t.personId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonNamesTableAnnotationComposer(
            $db: $db,
            $table: $db.personNames,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> childrenRelationships<T extends Object>(
    Expression<T> Function($$ParentChildRelationshipsTableAnnotationComposer a)
    f,
  ) {
    final $$ParentChildRelationshipsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.parentChildRelationships,
          getReferencedColumn: (t) => t.parentPersonId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ParentChildRelationshipsTableAnnotationComposer(
                $db: $db,
                $table: $db.parentChildRelationships,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> parentRelationships<T extends Object>(
    Expression<T> Function($$ParentChildRelationshipsTableAnnotationComposer a)
    f,
  ) {
    final $$ParentChildRelationshipsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.parentChildRelationships,
          getReferencedColumn: (t) => t.childPersonId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ParentChildRelationshipsTableAnnotationComposer(
                $db: $db,
                $table: $db.parentChildRelationships,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> partnershipsAsPersonA<T extends Object>(
    Expression<T> Function($$PartnershipsTableAnnotationComposer a) f,
  ) {
    final $$PartnershipsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.partnerships,
      getReferencedColumn: (t) => t.personAId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartnershipsTableAnnotationComposer(
            $db: $db,
            $table: $db.partnerships,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> partnershipsAsPersonB<T extends Object>(
    Expression<T> Function($$PartnershipsTableAnnotationComposer a) f,
  ) {
    final $$PartnershipsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.partnerships,
      getReferencedColumn: (t) => t.personBId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartnershipsTableAnnotationComposer(
            $db: $db,
            $table: $db.partnerships,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> residencesRefs<T extends Object>(
    Expression<T> Function($$ResidencesTableAnnotationComposer a) f,
  ) {
    final $$ResidencesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.residences,
      getReferencedColumn: (t) => t.personId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ResidencesTableAnnotationComposer(
            $db: $db,
            $table: $db.residences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> eventParticipantsRefs<T extends Object>(
    Expression<T> Function($$EventParticipantsTableAnnotationComposer a) f,
  ) {
    final $$EventParticipantsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.eventParticipants,
          getReferencedColumn: (t) => t.personId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EventParticipantsTableAnnotationComposer(
                $db: $db,
                $table: $db.eventParticipants,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> duplicateCandidatesAsA<T extends Object>(
    Expression<T> Function($$DuplicateCandidatesTableAnnotationComposer a) f,
  ) {
    final $$DuplicateCandidatesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.duplicateCandidates,
          getReferencedColumn: (t) => t.personAId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DuplicateCandidatesTableAnnotationComposer(
                $db: $db,
                $table: $db.duplicateCandidates,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> duplicateCandidatesAsB<T extends Object>(
    Expression<T> Function($$DuplicateCandidatesTableAnnotationComposer a) f,
  ) {
    final $$DuplicateCandidatesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.duplicateCandidates,
          getReferencedColumn: (t) => t.personBId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DuplicateCandidatesTableAnnotationComposer(
                $db: $db,
                $table: $db.duplicateCandidates,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> duplicateCandidatesRefs<T extends Object>(
    Expression<T> Function($$DuplicateCandidatesTableAnnotationComposer a) f,
  ) {
    final $$DuplicateCandidatesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.duplicateCandidates,
          getReferencedColumn: (t) => t.mergedIntoPersonId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DuplicateCandidatesTableAnnotationComposer(
                $db: $db,
                $table: $db.duplicateCandidates,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$PersonsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PersonsTable,
          Person,
          $$PersonsTableFilterComposer,
          $$PersonsTableOrderingComposer,
          $$PersonsTableAnnotationComposer,
          $$PersonsTableCreateCompanionBuilder,
          $$PersonsTableUpdateCompanionBuilder,
          (Person, $$PersonsTableReferences),
          Person,
          PrefetchHooks Function({
            bool personNamesRefs,
            bool childrenRelationships,
            bool parentRelationships,
            bool partnershipsAsPersonA,
            bool partnershipsAsPersonB,
            bool residencesRefs,
            bool eventParticipantsRefs,
            bool duplicateCandidatesAsA,
            bool duplicateCandidatesAsB,
            bool duplicateCandidatesRefs,
          })
        > {
  $$PersonsTableTableManager(_$AppDatabase db, $PersonsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PersonsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PersonsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PersonsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sex = const Value.absent(),
                Value<String?> birthPrecision = const Value.absent(),
                Value<DateTime?> birthStartDate = const Value.absent(),
                Value<DateTime?> birthEndDate = const Value.absent(),
                Value<String?> birthDisplayText = const Value.absent(),
                Value<String?> deathPrecision = const Value.absent(),
                Value<DateTime?> deathStartDate = const Value.absent(),
                Value<DateTime?> deathEndDate = const Value.absent(),
                Value<String?> deathDisplayText = const Value.absent(),
                Value<String?> biography = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> modifiedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PersonsCompanion(
                id: id,
                sex: sex,
                birthPrecision: birthPrecision,
                birthStartDate: birthStartDate,
                birthEndDate: birthEndDate,
                birthDisplayText: birthDisplayText,
                deathPrecision: deathPrecision,
                deathStartDate: deathStartDate,
                deathEndDate: deathEndDate,
                deathDisplayText: deathDisplayText,
                biography: biography,
                notes: notes,
                createdAt: createdAt,
                modifiedAt: modifiedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sex,
                Value<String?> birthPrecision = const Value.absent(),
                Value<DateTime?> birthStartDate = const Value.absent(),
                Value<DateTime?> birthEndDate = const Value.absent(),
                Value<String?> birthDisplayText = const Value.absent(),
                Value<String?> deathPrecision = const Value.absent(),
                Value<DateTime?> deathStartDate = const Value.absent(),
                Value<DateTime?> deathEndDate = const Value.absent(),
                Value<String?> deathDisplayText = const Value.absent(),
                Value<String?> biography = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                required DateTime modifiedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PersonsCompanion.insert(
                id: id,
                sex: sex,
                birthPrecision: birthPrecision,
                birthStartDate: birthStartDate,
                birthEndDate: birthEndDate,
                birthDisplayText: birthDisplayText,
                deathPrecision: deathPrecision,
                deathStartDate: deathStartDate,
                deathEndDate: deathEndDate,
                deathDisplayText: deathDisplayText,
                biography: biography,
                notes: notes,
                createdAt: createdAt,
                modifiedAt: modifiedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PersonsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                personNamesRefs = false,
                childrenRelationships = false,
                parentRelationships = false,
                partnershipsAsPersonA = false,
                partnershipsAsPersonB = false,
                residencesRefs = false,
                eventParticipantsRefs = false,
                duplicateCandidatesAsA = false,
                duplicateCandidatesAsB = false,
                duplicateCandidatesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (personNamesRefs) db.personNames,
                    if (childrenRelationships) db.parentChildRelationships,
                    if (parentRelationships) db.parentChildRelationships,
                    if (partnershipsAsPersonA) db.partnerships,
                    if (partnershipsAsPersonB) db.partnerships,
                    if (residencesRefs) db.residences,
                    if (eventParticipantsRefs) db.eventParticipants,
                    if (duplicateCandidatesAsA) db.duplicateCandidates,
                    if (duplicateCandidatesAsB) db.duplicateCandidates,
                    if (duplicateCandidatesRefs) db.duplicateCandidates,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (personNamesRefs)
                        await $_getPrefetchedData<
                          Person,
                          $PersonsTable,
                          PersonName
                        >(
                          currentTable: table,
                          referencedTable: $$PersonsTableReferences
                              ._personNamesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PersonsTableReferences(
                                db,
                                table,
                                p0,
                              ).personNamesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.personId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (childrenRelationships)
                        await $_getPrefetchedData<
                          Person,
                          $PersonsTable,
                          ParentChildRelationship
                        >(
                          currentTable: table,
                          referencedTable: $$PersonsTableReferences
                              ._childrenRelationshipsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PersonsTableReferences(
                                db,
                                table,
                                p0,
                              ).childrenRelationships,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.parentPersonId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (parentRelationships)
                        await $_getPrefetchedData<
                          Person,
                          $PersonsTable,
                          ParentChildRelationship
                        >(
                          currentTable: table,
                          referencedTable: $$PersonsTableReferences
                              ._parentRelationshipsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PersonsTableReferences(
                                db,
                                table,
                                p0,
                              ).parentRelationships,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.childPersonId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (partnershipsAsPersonA)
                        await $_getPrefetchedData<
                          Person,
                          $PersonsTable,
                          Partnership
                        >(
                          currentTable: table,
                          referencedTable: $$PersonsTableReferences
                              ._partnershipsAsPersonATable(db),
                          managerFromTypedResult: (p0) =>
                              $$PersonsTableReferences(
                                db,
                                table,
                                p0,
                              ).partnershipsAsPersonA,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.personAId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (partnershipsAsPersonB)
                        await $_getPrefetchedData<
                          Person,
                          $PersonsTable,
                          Partnership
                        >(
                          currentTable: table,
                          referencedTable: $$PersonsTableReferences
                              ._partnershipsAsPersonBTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PersonsTableReferences(
                                db,
                                table,
                                p0,
                              ).partnershipsAsPersonB,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.personBId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (residencesRefs)
                        await $_getPrefetchedData<
                          Person,
                          $PersonsTable,
                          Residence
                        >(
                          currentTable: table,
                          referencedTable: $$PersonsTableReferences
                              ._residencesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PersonsTableReferences(
                                db,
                                table,
                                p0,
                              ).residencesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.personId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (eventParticipantsRefs)
                        await $_getPrefetchedData<
                          Person,
                          $PersonsTable,
                          EventParticipant
                        >(
                          currentTable: table,
                          referencedTable: $$PersonsTableReferences
                              ._eventParticipantsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PersonsTableReferences(
                                db,
                                table,
                                p0,
                              ).eventParticipantsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.personId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (duplicateCandidatesAsA)
                        await $_getPrefetchedData<
                          Person,
                          $PersonsTable,
                          DuplicateCandidate
                        >(
                          currentTable: table,
                          referencedTable: $$PersonsTableReferences
                              ._duplicateCandidatesAsATable(db),
                          managerFromTypedResult: (p0) =>
                              $$PersonsTableReferences(
                                db,
                                table,
                                p0,
                              ).duplicateCandidatesAsA,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.personAId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (duplicateCandidatesAsB)
                        await $_getPrefetchedData<
                          Person,
                          $PersonsTable,
                          DuplicateCandidate
                        >(
                          currentTable: table,
                          referencedTable: $$PersonsTableReferences
                              ._duplicateCandidatesAsBTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PersonsTableReferences(
                                db,
                                table,
                                p0,
                              ).duplicateCandidatesAsB,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.personBId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (duplicateCandidatesRefs)
                        await $_getPrefetchedData<
                          Person,
                          $PersonsTable,
                          DuplicateCandidate
                        >(
                          currentTable: table,
                          referencedTable: $$PersonsTableReferences
                              ._duplicateCandidatesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PersonsTableReferences(
                                db,
                                table,
                                p0,
                              ).duplicateCandidatesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.mergedIntoPersonId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PersonsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PersonsTable,
      Person,
      $$PersonsTableFilterComposer,
      $$PersonsTableOrderingComposer,
      $$PersonsTableAnnotationComposer,
      $$PersonsTableCreateCompanionBuilder,
      $$PersonsTableUpdateCompanionBuilder,
      (Person, $$PersonsTableReferences),
      Person,
      PrefetchHooks Function({
        bool personNamesRefs,
        bool childrenRelationships,
        bool parentRelationships,
        bool partnershipsAsPersonA,
        bool partnershipsAsPersonB,
        bool residencesRefs,
        bool eventParticipantsRefs,
        bool duplicateCandidatesAsA,
        bool duplicateCandidatesAsB,
        bool duplicateCandidatesRefs,
      })
    >;
typedef $$PersonNamesTableCreateCompanionBuilder =
    PersonNamesCompanion Function({
      required String id,
      required String personId,
      Value<String?> givenNames,
      Value<String?> familyNames,
      required String displayName,
      required String type,
      Value<bool> isPreferred,
      required DateTime createdAt,
      required DateTime modifiedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$PersonNamesTableUpdateCompanionBuilder =
    PersonNamesCompanion Function({
      Value<String> id,
      Value<String> personId,
      Value<String?> givenNames,
      Value<String?> familyNames,
      Value<String> displayName,
      Value<String> type,
      Value<bool> isPreferred,
      Value<DateTime> createdAt,
      Value<DateTime> modifiedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

final class $$PersonNamesTableReferences
    extends BaseReferences<_$AppDatabase, $PersonNamesTable, PersonName> {
  $$PersonNamesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PersonsTable _personIdTable(_$AppDatabase db) =>
      db.persons.createAlias('person_names__person_id__persons__id');

  $$PersonsTableProcessedTableManager get personId {
    final $_column = $_itemColumn<String>('person_id')!;

    final manager = $$PersonsTableTableManager(
      $_db,
      $_db.persons,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_personIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PersonNamesTableFilterComposer
    extends Composer<_$AppDatabase, $PersonNamesTable> {
  $$PersonNamesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get givenNames => $composableBuilder(
    column: $table.givenNames,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get familyNames => $composableBuilder(
    column: $table.familyNames,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPreferred => $composableBuilder(
    column: $table.isPreferred,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PersonsTableFilterComposer get personId {
    final $$PersonsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personId,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableFilterComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PersonNamesTableOrderingComposer
    extends Composer<_$AppDatabase, $PersonNamesTable> {
  $$PersonNamesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get givenNames => $composableBuilder(
    column: $table.givenNames,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get familyNames => $composableBuilder(
    column: $table.familyNames,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPreferred => $composableBuilder(
    column: $table.isPreferred,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PersonsTableOrderingComposer get personId {
    final $$PersonsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personId,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableOrderingComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PersonNamesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PersonNamesTable> {
  $$PersonNamesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get givenNames => $composableBuilder(
    column: $table.givenNames,
    builder: (column) => column,
  );

  GeneratedColumn<String> get familyNames => $composableBuilder(
    column: $table.familyNames,
    builder: (column) => column,
  );

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<bool> get isPreferred => $composableBuilder(
    column: $table.isPreferred,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$PersonsTableAnnotationComposer get personId {
    final $$PersonsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personId,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableAnnotationComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PersonNamesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PersonNamesTable,
          PersonName,
          $$PersonNamesTableFilterComposer,
          $$PersonNamesTableOrderingComposer,
          $$PersonNamesTableAnnotationComposer,
          $$PersonNamesTableCreateCompanionBuilder,
          $$PersonNamesTableUpdateCompanionBuilder,
          (PersonName, $$PersonNamesTableReferences),
          PersonName,
          PrefetchHooks Function({bool personId})
        > {
  $$PersonNamesTableTableManager(_$AppDatabase db, $PersonNamesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PersonNamesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PersonNamesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PersonNamesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> personId = const Value.absent(),
                Value<String?> givenNames = const Value.absent(),
                Value<String?> familyNames = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<bool> isPreferred = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> modifiedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PersonNamesCompanion(
                id: id,
                personId: personId,
                givenNames: givenNames,
                familyNames: familyNames,
                displayName: displayName,
                type: type,
                isPreferred: isPreferred,
                createdAt: createdAt,
                modifiedAt: modifiedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String personId,
                Value<String?> givenNames = const Value.absent(),
                Value<String?> familyNames = const Value.absent(),
                required String displayName,
                required String type,
                Value<bool> isPreferred = const Value.absent(),
                required DateTime createdAt,
                required DateTime modifiedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PersonNamesCompanion.insert(
                id: id,
                personId: personId,
                givenNames: givenNames,
                familyNames: familyNames,
                displayName: displayName,
                type: type,
                isPreferred: isPreferred,
                createdAt: createdAt,
                modifiedAt: modifiedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PersonNamesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({personId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (personId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.personId,
                        referencedTable: $$PersonNamesTableReferences
                            ._personIdTable(db),
                        referencedColumn: $$PersonNamesTableReferences
                            ._personIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PersonNamesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PersonNamesTable,
      PersonName,
      $$PersonNamesTableFilterComposer,
      $$PersonNamesTableOrderingComposer,
      $$PersonNamesTableAnnotationComposer,
      $$PersonNamesTableCreateCompanionBuilder,
      $$PersonNamesTableUpdateCompanionBuilder,
      (PersonName, $$PersonNamesTableReferences),
      PersonName,
      PrefetchHooks Function({bool personId})
    >;
typedef $$ParentChildRelationshipsTableCreateCompanionBuilder =
    ParentChildRelationshipsCompanion Function({
      required String id,
      required String parentPersonId,
      required String childPersonId,
      required String nature,
      Value<String?> startPrecision,
      Value<DateTime?> startStartDate,
      Value<DateTime?> startEndDate,
      Value<String?> startDisplayText,
      Value<String?> endPrecision,
      Value<DateTime?> endStartDate,
      Value<DateTime?> endEndDate,
      Value<String?> endDisplayText,
      Value<String?> notes,
      required DateTime createdAt,
      required DateTime modifiedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$ParentChildRelationshipsTableUpdateCompanionBuilder =
    ParentChildRelationshipsCompanion Function({
      Value<String> id,
      Value<String> parentPersonId,
      Value<String> childPersonId,
      Value<String> nature,
      Value<String?> startPrecision,
      Value<DateTime?> startStartDate,
      Value<DateTime?> startEndDate,
      Value<String?> startDisplayText,
      Value<String?> endPrecision,
      Value<DateTime?> endStartDate,
      Value<DateTime?> endEndDate,
      Value<String?> endDisplayText,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> modifiedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

final class $$ParentChildRelationshipsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ParentChildRelationshipsTable,
          ParentChildRelationship
        > {
  $$ParentChildRelationshipsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PersonsTable _parentPersonIdTable(_$AppDatabase db) => db.persons
      .createAlias('parent_child_relationships__parent_person_id__persons__id');

  $$PersonsTableProcessedTableManager get parentPersonId {
    final $_column = $_itemColumn<String>('parent_person_id')!;

    final manager = $$PersonsTableTableManager(
      $_db,
      $_db.persons,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parentPersonIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PersonsTable _childPersonIdTable(_$AppDatabase db) => db.persons
      .createAlias('parent_child_relationships__child_person_id__persons__id');

  $$PersonsTableProcessedTableManager get childPersonId {
    final $_column = $_itemColumn<String>('child_person_id')!;

    final manager = $$PersonsTableTableManager(
      $_db,
      $_db.persons,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_childPersonIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ParentChildRelationshipsTableFilterComposer
    extends Composer<_$AppDatabase, $ParentChildRelationshipsTable> {
  $$ParentChildRelationshipsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nature => $composableBuilder(
    column: $table.nature,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startPrecision => $composableBuilder(
    column: $table.startPrecision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startStartDate => $composableBuilder(
    column: $table.startStartDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startEndDate => $composableBuilder(
    column: $table.startEndDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startDisplayText => $composableBuilder(
    column: $table.startDisplayText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endPrecision => $composableBuilder(
    column: $table.endPrecision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endStartDate => $composableBuilder(
    column: $table.endStartDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endEndDate => $composableBuilder(
    column: $table.endEndDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endDisplayText => $composableBuilder(
    column: $table.endDisplayText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PersonsTableFilterComposer get parentPersonId {
    final $$PersonsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentPersonId,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableFilterComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PersonsTableFilterComposer get childPersonId {
    final $$PersonsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.childPersonId,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableFilterComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ParentChildRelationshipsTableOrderingComposer
    extends Composer<_$AppDatabase, $ParentChildRelationshipsTable> {
  $$ParentChildRelationshipsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nature => $composableBuilder(
    column: $table.nature,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startPrecision => $composableBuilder(
    column: $table.startPrecision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startStartDate => $composableBuilder(
    column: $table.startStartDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startEndDate => $composableBuilder(
    column: $table.startEndDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startDisplayText => $composableBuilder(
    column: $table.startDisplayText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endPrecision => $composableBuilder(
    column: $table.endPrecision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endStartDate => $composableBuilder(
    column: $table.endStartDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endEndDate => $composableBuilder(
    column: $table.endEndDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endDisplayText => $composableBuilder(
    column: $table.endDisplayText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PersonsTableOrderingComposer get parentPersonId {
    final $$PersonsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentPersonId,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableOrderingComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PersonsTableOrderingComposer get childPersonId {
    final $$PersonsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.childPersonId,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableOrderingComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ParentChildRelationshipsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ParentChildRelationshipsTable> {
  $$ParentChildRelationshipsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nature =>
      $composableBuilder(column: $table.nature, builder: (column) => column);

  GeneratedColumn<String> get startPrecision => $composableBuilder(
    column: $table.startPrecision,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startStartDate => $composableBuilder(
    column: $table.startStartDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startEndDate => $composableBuilder(
    column: $table.startEndDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get startDisplayText => $composableBuilder(
    column: $table.startDisplayText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get endPrecision => $composableBuilder(
    column: $table.endPrecision,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get endStartDate => $composableBuilder(
    column: $table.endStartDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get endEndDate => $composableBuilder(
    column: $table.endEndDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get endDisplayText => $composableBuilder(
    column: $table.endDisplayText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$PersonsTableAnnotationComposer get parentPersonId {
    final $$PersonsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentPersonId,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableAnnotationComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PersonsTableAnnotationComposer get childPersonId {
    final $$PersonsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.childPersonId,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableAnnotationComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ParentChildRelationshipsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ParentChildRelationshipsTable,
          ParentChildRelationship,
          $$ParentChildRelationshipsTableFilterComposer,
          $$ParentChildRelationshipsTableOrderingComposer,
          $$ParentChildRelationshipsTableAnnotationComposer,
          $$ParentChildRelationshipsTableCreateCompanionBuilder,
          $$ParentChildRelationshipsTableUpdateCompanionBuilder,
          (ParentChildRelationship, $$ParentChildRelationshipsTableReferences),
          ParentChildRelationship,
          PrefetchHooks Function({bool parentPersonId, bool childPersonId})
        > {
  $$ParentChildRelationshipsTableTableManager(
    _$AppDatabase db,
    $ParentChildRelationshipsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ParentChildRelationshipsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ParentChildRelationshipsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ParentChildRelationshipsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> parentPersonId = const Value.absent(),
                Value<String> childPersonId = const Value.absent(),
                Value<String> nature = const Value.absent(),
                Value<String?> startPrecision = const Value.absent(),
                Value<DateTime?> startStartDate = const Value.absent(),
                Value<DateTime?> startEndDate = const Value.absent(),
                Value<String?> startDisplayText = const Value.absent(),
                Value<String?> endPrecision = const Value.absent(),
                Value<DateTime?> endStartDate = const Value.absent(),
                Value<DateTime?> endEndDate = const Value.absent(),
                Value<String?> endDisplayText = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> modifiedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ParentChildRelationshipsCompanion(
                id: id,
                parentPersonId: parentPersonId,
                childPersonId: childPersonId,
                nature: nature,
                startPrecision: startPrecision,
                startStartDate: startStartDate,
                startEndDate: startEndDate,
                startDisplayText: startDisplayText,
                endPrecision: endPrecision,
                endStartDate: endStartDate,
                endEndDate: endEndDate,
                endDisplayText: endDisplayText,
                notes: notes,
                createdAt: createdAt,
                modifiedAt: modifiedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String parentPersonId,
                required String childPersonId,
                required String nature,
                Value<String?> startPrecision = const Value.absent(),
                Value<DateTime?> startStartDate = const Value.absent(),
                Value<DateTime?> startEndDate = const Value.absent(),
                Value<String?> startDisplayText = const Value.absent(),
                Value<String?> endPrecision = const Value.absent(),
                Value<DateTime?> endStartDate = const Value.absent(),
                Value<DateTime?> endEndDate = const Value.absent(),
                Value<String?> endDisplayText = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                required DateTime modifiedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ParentChildRelationshipsCompanion.insert(
                id: id,
                parentPersonId: parentPersonId,
                childPersonId: childPersonId,
                nature: nature,
                startPrecision: startPrecision,
                startStartDate: startStartDate,
                startEndDate: startEndDate,
                startDisplayText: startDisplayText,
                endPrecision: endPrecision,
                endStartDate: endStartDate,
                endEndDate: endEndDate,
                endDisplayText: endDisplayText,
                notes: notes,
                createdAt: createdAt,
                modifiedAt: modifiedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ParentChildRelationshipsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({parentPersonId = false, childPersonId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (parentPersonId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.parentPersonId,
                            referencedTable:
                                $$ParentChildRelationshipsTableReferences
                                    ._parentPersonIdTable(db),
                            referencedColumn:
                                $$ParentChildRelationshipsTableReferences
                                    ._parentPersonIdTable(db)
                                    .id,
                          ) as T;
                        }
                        if (childPersonId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.childPersonId,
                            referencedTable:
                                $$ParentChildRelationshipsTableReferences
                                    ._childPersonIdTable(db),
                            referencedColumn:
                                $$ParentChildRelationshipsTableReferences
                                    ._childPersonIdTable(db)
                                    .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$ParentChildRelationshipsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ParentChildRelationshipsTable,
      ParentChildRelationship,
      $$ParentChildRelationshipsTableFilterComposer,
      $$ParentChildRelationshipsTableOrderingComposer,
      $$ParentChildRelationshipsTableAnnotationComposer,
      $$ParentChildRelationshipsTableCreateCompanionBuilder,
      $$ParentChildRelationshipsTableUpdateCompanionBuilder,
      (ParentChildRelationship, $$ParentChildRelationshipsTableReferences),
      ParentChildRelationship,
      PrefetchHooks Function({bool parentPersonId, bool childPersonId})
    >;
typedef $$PlacesTableCreateCompanionBuilder = PlacesCompanion Function({
  required String id,
  required String preferredName,
  required String type,
  Value<double?> latitude,
  Value<double?> longitude,
  Value<String?> description,
  Value<String?> notes,
  required DateTime createdAt,
  required DateTime modifiedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});
typedef $$PlacesTableUpdateCompanionBuilder = PlacesCompanion Function({
  Value<String> id,
  Value<String> preferredName,
  Value<String> type,
  Value<double?> latitude,
  Value<double?> longitude,
  Value<String?> description,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> modifiedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});

final class $$PlacesTableReferences
    extends BaseReferences<_$AppDatabase, $PlacesTable, Place> {
  $$PlacesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PartnershipsTable, List<Partnership>>
  _partnershipsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.partnerships,
    aliasName: 'places__id__partnerships__place_id',
  );

  $$PartnershipsTableProcessedTableManager get partnershipsRefs {
    final manager = $$PartnershipsTableTableManager(
      $_db,
      $_db.partnerships,
    ).filter((f) => f.placeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_partnershipsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PlaceRelationshipsTable, List<PlaceRelationship>>
  _outgoingPlaceRelationshipsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.placeRelationships,
        aliasName: 'places__id__place_relationships__source_place_id',
      );

  $$PlaceRelationshipsTableProcessedTableManager
  get outgoingPlaceRelationships {
    final manager = $$PlaceRelationshipsTableTableManager(
      $_db,
      $_db.placeRelationships,
    ).filter((f) => f.sourcePlaceId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _outgoingPlaceRelationshipsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PlaceRelationshipsTable, List<PlaceRelationship>>
  _incomingPlaceRelationshipsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.placeRelationships,
        aliasName: 'places__id__place_relationships__target_place_id',
      );

  $$PlaceRelationshipsTableProcessedTableManager
  get incomingPlaceRelationships {
    final manager = $$PlaceRelationshipsTableTableManager(
      $_db,
      $_db.placeRelationships,
    ).filter((f) => f.targetPlaceId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _incomingPlaceRelationshipsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ResidencesTable, List<Residence>>
  _residencesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.residences,
    aliasName: 'places__id__residences__place_id',
  );

  $$ResidencesTableProcessedTableManager get residencesRefs {
    final manager = $$ResidencesTableTableManager(
      $_db,
      $_db.residences,
    ).filter((f) => f.placeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_residencesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$EventsTable, List<Event>> _eventsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.events,
    aliasName: 'places__id__events__place_id',
  );

  $$EventsTableProcessedTableManager get eventsRefs {
    final manager = $$EventsTableTableManager(
      $_db,
      $_db.events,
    ).filter((f) => f.placeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_eventsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PlacesTableFilterComposer
    extends Composer<_$AppDatabase, $PlacesTable> {
  $$PlacesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preferredName => $composableBuilder(
    column: $table.preferredName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> partnershipsRefs(
    Expression<bool> Function($$PartnershipsTableFilterComposer f) f,
  ) {
    final $$PartnershipsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.partnerships,
      getReferencedColumn: (t) => t.placeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartnershipsTableFilterComposer(
            $db: $db,
            $table: $db.partnerships,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> outgoingPlaceRelationships(
    Expression<bool> Function($$PlaceRelationshipsTableFilterComposer f) f,
  ) {
    final $$PlaceRelationshipsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.placeRelationships,
      getReferencedColumn: (t) => t.sourcePlaceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlaceRelationshipsTableFilterComposer(
            $db: $db,
            $table: $db.placeRelationships,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> incomingPlaceRelationships(
    Expression<bool> Function($$PlaceRelationshipsTableFilterComposer f) f,
  ) {
    final $$PlaceRelationshipsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.placeRelationships,
      getReferencedColumn: (t) => t.targetPlaceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlaceRelationshipsTableFilterComposer(
            $db: $db,
            $table: $db.placeRelationships,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> residencesRefs(
    Expression<bool> Function($$ResidencesTableFilterComposer f) f,
  ) {
    final $$ResidencesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.residences,
      getReferencedColumn: (t) => t.placeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ResidencesTableFilterComposer(
            $db: $db,
            $table: $db.residences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> eventsRefs(
    Expression<bool> Function($$EventsTableFilterComposer f) f,
  ) {
    final $$EventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.placeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableFilterComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlacesTableOrderingComposer
    extends Composer<_$AppDatabase, $PlacesTable> {
  $$PlacesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preferredName => $composableBuilder(
    column: $table.preferredName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlacesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlacesTable> {
  $$PlacesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get preferredName => $composableBuilder(
    column: $table.preferredName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  Expression<T> partnershipsRefs<T extends Object>(
    Expression<T> Function($$PartnershipsTableAnnotationComposer a) f,
  ) {
    final $$PartnershipsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.partnerships,
      getReferencedColumn: (t) => t.placeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartnershipsTableAnnotationComposer(
            $db: $db,
            $table: $db.partnerships,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> outgoingPlaceRelationships<T extends Object>(
    Expression<T> Function($$PlaceRelationshipsTableAnnotationComposer a) f,
  ) {
    final $$PlaceRelationshipsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.placeRelationships,
          getReferencedColumn: (t) => t.sourcePlaceId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PlaceRelationshipsTableAnnotationComposer(
                $db: $db,
                $table: $db.placeRelationships,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> incomingPlaceRelationships<T extends Object>(
    Expression<T> Function($$PlaceRelationshipsTableAnnotationComposer a) f,
  ) {
    final $$PlaceRelationshipsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.placeRelationships,
          getReferencedColumn: (t) => t.targetPlaceId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PlaceRelationshipsTableAnnotationComposer(
                $db: $db,
                $table: $db.placeRelationships,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> residencesRefs<T extends Object>(
    Expression<T> Function($$ResidencesTableAnnotationComposer a) f,
  ) {
    final $$ResidencesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.residences,
      getReferencedColumn: (t) => t.placeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ResidencesTableAnnotationComposer(
            $db: $db,
            $table: $db.residences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> eventsRefs<T extends Object>(
    Expression<T> Function($$EventsTableAnnotationComposer a) f,
  ) {
    final $$EventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.placeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableAnnotationComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlacesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlacesTable,
          Place,
          $$PlacesTableFilterComposer,
          $$PlacesTableOrderingComposer,
          $$PlacesTableAnnotationComposer,
          $$PlacesTableCreateCompanionBuilder,
          $$PlacesTableUpdateCompanionBuilder,
          (Place, $$PlacesTableReferences),
          Place,
          PrefetchHooks Function({
            bool partnershipsRefs,
            bool outgoingPlaceRelationships,
            bool incomingPlaceRelationships,
            bool residencesRefs,
            bool eventsRefs,
          })
        > {
  $$PlacesTableTableManager(_$AppDatabase db, $PlacesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlacesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlacesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlacesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> preferredName = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> modifiedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlacesCompanion(
                id: id,
                preferredName: preferredName,
                type: type,
                latitude: latitude,
                longitude: longitude,
                description: description,
                notes: notes,
                createdAt: createdAt,
                modifiedAt: modifiedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String preferredName,
                required String type,
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                required DateTime modifiedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlacesCompanion.insert(
                id: id,
                preferredName: preferredName,
                type: type,
                latitude: latitude,
                longitude: longitude,
                description: description,
                notes: notes,
                createdAt: createdAt,
                modifiedAt: modifiedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$PlacesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                partnershipsRefs = false,
                outgoingPlaceRelationships = false,
                incomingPlaceRelationships = false,
                residencesRefs = false,
                eventsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (partnershipsRefs) db.partnerships,
                    if (outgoingPlaceRelationships) db.placeRelationships,
                    if (incomingPlaceRelationships) db.placeRelationships,
                    if (residencesRefs) db.residences,
                    if (eventsRefs) db.events,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (partnershipsRefs)
                        await $_getPrefetchedData<
                          Place,
                          $PlacesTable,
                          Partnership
                        >(
                          currentTable: table,
                          referencedTable: $$PlacesTableReferences
                              ._partnershipsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlacesTableReferences(
                                db,
                                table,
                                p0,
                              ).partnershipsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.placeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (outgoingPlaceRelationships)
                        await $_getPrefetchedData<
                          Place,
                          $PlacesTable,
                          PlaceRelationship
                        >(
                          currentTable: table,
                          referencedTable: $$PlacesTableReferences
                              ._outgoingPlaceRelationshipsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlacesTableReferences(
                                db,
                                table,
                                p0,
                              ).outgoingPlaceRelationships,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sourcePlaceId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (incomingPlaceRelationships)
                        await $_getPrefetchedData<
                          Place,
                          $PlacesTable,
                          PlaceRelationship
                        >(
                          currentTable: table,
                          referencedTable: $$PlacesTableReferences
                              ._incomingPlaceRelationshipsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlacesTableReferences(
                                db,
                                table,
                                p0,
                              ).incomingPlaceRelationships,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.targetPlaceId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (residencesRefs)
                        await $_getPrefetchedData<
                          Place,
                          $PlacesTable,
                          Residence
                        >(
                          currentTable: table,
                          referencedTable: $$PlacesTableReferences
                              ._residencesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlacesTableReferences(
                                db,
                                table,
                                p0,
                              ).residencesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.placeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (eventsRefs)
                        await $_getPrefetchedData<Place, $PlacesTable, Event>(
                          currentTable: table,
                          referencedTable: $$PlacesTableReferences
                              ._eventsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlacesTableReferences(db, table, p0).eventsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.placeId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PlacesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlacesTable,
      Place,
      $$PlacesTableFilterComposer,
      $$PlacesTableOrderingComposer,
      $$PlacesTableAnnotationComposer,
      $$PlacesTableCreateCompanionBuilder,
      $$PlacesTableUpdateCompanionBuilder,
      (Place, $$PlacesTableReferences),
      Place,
      PrefetchHooks Function({
        bool partnershipsRefs,
        bool outgoingPlaceRelationships,
        bool incomingPlaceRelationships,
        bool residencesRefs,
        bool eventsRefs,
      })
    >;
typedef $$PartnershipsTableCreateCompanionBuilder =
    PartnershipsCompanion Function({
      required String id,
      required String personAId,
      required String personBId,
      required String type,
      Value<String?> startPrecision,
      Value<DateTime?> startStartDate,
      Value<DateTime?> startEndDate,
      Value<String?> startDisplayText,
      Value<String?> endPrecision,
      Value<DateTime?> endStartDate,
      Value<DateTime?> endEndDate,
      Value<String?> endDisplayText,
      Value<String?> placeId,
      Value<String?> notes,
      required DateTime createdAt,
      required DateTime modifiedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$PartnershipsTableUpdateCompanionBuilder =
    PartnershipsCompanion Function({
      Value<String> id,
      Value<String> personAId,
      Value<String> personBId,
      Value<String> type,
      Value<String?> startPrecision,
      Value<DateTime?> startStartDate,
      Value<DateTime?> startEndDate,
      Value<String?> startDisplayText,
      Value<String?> endPrecision,
      Value<DateTime?> endStartDate,
      Value<DateTime?> endEndDate,
      Value<String?> endDisplayText,
      Value<String?> placeId,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> modifiedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

final class $$PartnershipsTableReferences
    extends BaseReferences<_$AppDatabase, $PartnershipsTable, Partnership> {
  $$PartnershipsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PersonsTable _personAIdTable(_$AppDatabase db) =>
      db.persons.createAlias('partnerships__person_a_id__persons__id');

  $$PersonsTableProcessedTableManager get personAId {
    final $_column = $_itemColumn<String>('person_a_id')!;

    final manager = $$PersonsTableTableManager(
      $_db,
      $_db.persons,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_personAIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PersonsTable _personBIdTable(_$AppDatabase db) =>
      db.persons.createAlias('partnerships__person_b_id__persons__id');

  $$PersonsTableProcessedTableManager get personBId {
    final $_column = $_itemColumn<String>('person_b_id')!;

    final manager = $$PersonsTableTableManager(
      $_db,
      $_db.persons,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_personBIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PlacesTable _placeIdTable(_$AppDatabase db) =>
      db.places.createAlias('partnerships__place_id__places__id');

  $$PlacesTableProcessedTableManager? get placeId {
    final $_column = $_itemColumn<String>('place_id');
    if ($_column == null) return null;
    final manager = $$PlacesTableTableManager(
      $_db,
      $_db.places,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_placeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PartnershipsTableFilterComposer
    extends Composer<_$AppDatabase, $PartnershipsTable> {
  $$PartnershipsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startPrecision => $composableBuilder(
    column: $table.startPrecision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startStartDate => $composableBuilder(
    column: $table.startStartDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startEndDate => $composableBuilder(
    column: $table.startEndDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startDisplayText => $composableBuilder(
    column: $table.startDisplayText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endPrecision => $composableBuilder(
    column: $table.endPrecision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endStartDate => $composableBuilder(
    column: $table.endStartDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endEndDate => $composableBuilder(
    column: $table.endEndDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endDisplayText => $composableBuilder(
    column: $table.endDisplayText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PersonsTableFilterComposer get personAId {
    final $$PersonsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personAId,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableFilterComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PersonsTableFilterComposer get personBId {
    final $$PersonsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personBId,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableFilterComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlacesTableFilterComposer get placeId {
    final $$PlacesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.placeId,
      referencedTable: $db.places,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlacesTableFilterComposer(
            $db: $db,
            $table: $db.places,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PartnershipsTableOrderingComposer
    extends Composer<_$AppDatabase, $PartnershipsTable> {
  $$PartnershipsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startPrecision => $composableBuilder(
    column: $table.startPrecision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startStartDate => $composableBuilder(
    column: $table.startStartDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startEndDate => $composableBuilder(
    column: $table.startEndDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startDisplayText => $composableBuilder(
    column: $table.startDisplayText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endPrecision => $composableBuilder(
    column: $table.endPrecision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endStartDate => $composableBuilder(
    column: $table.endStartDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endEndDate => $composableBuilder(
    column: $table.endEndDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endDisplayText => $composableBuilder(
    column: $table.endDisplayText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PersonsTableOrderingComposer get personAId {
    final $$PersonsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personAId,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableOrderingComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PersonsTableOrderingComposer get personBId {
    final $$PersonsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personBId,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableOrderingComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlacesTableOrderingComposer get placeId {
    final $$PlacesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.placeId,
      referencedTable: $db.places,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlacesTableOrderingComposer(
            $db: $db,
            $table: $db.places,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PartnershipsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PartnershipsTable> {
  $$PartnershipsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get startPrecision => $composableBuilder(
    column: $table.startPrecision,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startStartDate => $composableBuilder(
    column: $table.startStartDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startEndDate => $composableBuilder(
    column: $table.startEndDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get startDisplayText => $composableBuilder(
    column: $table.startDisplayText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get endPrecision => $composableBuilder(
    column: $table.endPrecision,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get endStartDate => $composableBuilder(
    column: $table.endStartDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get endEndDate => $composableBuilder(
    column: $table.endEndDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get endDisplayText => $composableBuilder(
    column: $table.endDisplayText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$PersonsTableAnnotationComposer get personAId {
    final $$PersonsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personAId,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableAnnotationComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PersonsTableAnnotationComposer get personBId {
    final $$PersonsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personBId,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableAnnotationComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlacesTableAnnotationComposer get placeId {
    final $$PlacesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.placeId,
      referencedTable: $db.places,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlacesTableAnnotationComposer(
            $db: $db,
            $table: $db.places,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PartnershipsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PartnershipsTable,
          Partnership,
          $$PartnershipsTableFilterComposer,
          $$PartnershipsTableOrderingComposer,
          $$PartnershipsTableAnnotationComposer,
          $$PartnershipsTableCreateCompanionBuilder,
          $$PartnershipsTableUpdateCompanionBuilder,
          (Partnership, $$PartnershipsTableReferences),
          Partnership,
          PrefetchHooks Function({bool personAId, bool personBId, bool placeId})
        > {
  $$PartnershipsTableTableManager(_$AppDatabase db, $PartnershipsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PartnershipsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PartnershipsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PartnershipsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> personAId = const Value.absent(),
                Value<String> personBId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> startPrecision = const Value.absent(),
                Value<DateTime?> startStartDate = const Value.absent(),
                Value<DateTime?> startEndDate = const Value.absent(),
                Value<String?> startDisplayText = const Value.absent(),
                Value<String?> endPrecision = const Value.absent(),
                Value<DateTime?> endStartDate = const Value.absent(),
                Value<DateTime?> endEndDate = const Value.absent(),
                Value<String?> endDisplayText = const Value.absent(),
                Value<String?> placeId = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> modifiedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PartnershipsCompanion(
                id: id,
                personAId: personAId,
                personBId: personBId,
                type: type,
                startPrecision: startPrecision,
                startStartDate: startStartDate,
                startEndDate: startEndDate,
                startDisplayText: startDisplayText,
                endPrecision: endPrecision,
                endStartDate: endStartDate,
                endEndDate: endEndDate,
                endDisplayText: endDisplayText,
                placeId: placeId,
                notes: notes,
                createdAt: createdAt,
                modifiedAt: modifiedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String personAId,
                required String personBId,
                required String type,
                Value<String?> startPrecision = const Value.absent(),
                Value<DateTime?> startStartDate = const Value.absent(),
                Value<DateTime?> startEndDate = const Value.absent(),
                Value<String?> startDisplayText = const Value.absent(),
                Value<String?> endPrecision = const Value.absent(),
                Value<DateTime?> endStartDate = const Value.absent(),
                Value<DateTime?> endEndDate = const Value.absent(),
                Value<String?> endDisplayText = const Value.absent(),
                Value<String?> placeId = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                required DateTime modifiedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PartnershipsCompanion.insert(
                id: id,
                personAId: personAId,
                personBId: personBId,
                type: type,
                startPrecision: startPrecision,
                startStartDate: startStartDate,
                startEndDate: startEndDate,
                startDisplayText: startDisplayText,
                endPrecision: endPrecision,
                endStartDate: endStartDate,
                endEndDate: endEndDate,
                endDisplayText: endDisplayText,
                placeId: placeId,
                notes: notes,
                createdAt: createdAt,
                modifiedAt: modifiedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PartnershipsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({personAId = false, personBId = false, placeId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (personAId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.personAId,
                            referencedTable: $$PartnershipsTableReferences
                                ._personAIdTable(db),
                            referencedColumn: $$PartnershipsTableReferences
                                ._personAIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (personBId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.personBId,
                            referencedTable: $$PartnershipsTableReferences
                                ._personBIdTable(db),
                            referencedColumn: $$PartnershipsTableReferences
                                ._personBIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (placeId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.placeId,
                            referencedTable: $$PartnershipsTableReferences
                                ._placeIdTable(db),
                            referencedColumn: $$PartnershipsTableReferences
                                ._placeIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$PartnershipsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PartnershipsTable,
      Partnership,
      $$PartnershipsTableFilterComposer,
      $$PartnershipsTableOrderingComposer,
      $$PartnershipsTableAnnotationComposer,
      $$PartnershipsTableCreateCompanionBuilder,
      $$PartnershipsTableUpdateCompanionBuilder,
      (Partnership, $$PartnershipsTableReferences),
      Partnership,
      PrefetchHooks Function({bool personAId, bool personBId, bool placeId})
    >;
typedef $$PlaceRelationshipsTableCreateCompanionBuilder =
    PlaceRelationshipsCompanion Function({
      required String id,
      required String sourcePlaceId,
      required String targetPlaceId,
      required String type,
      required DateTime createdAt,
      required DateTime modifiedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$PlaceRelationshipsTableUpdateCompanionBuilder =
    PlaceRelationshipsCompanion Function({
      Value<String> id,
      Value<String> sourcePlaceId,
      Value<String> targetPlaceId,
      Value<String> type,
      Value<DateTime> createdAt,
      Value<DateTime> modifiedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

final class $$PlaceRelationshipsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PlaceRelationshipsTable,
          PlaceRelationship
        > {
  $$PlaceRelationshipsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PlacesTable _sourcePlaceIdTable(_$AppDatabase db) =>
      db.places.createAlias('place_relationships__source_place_id__places__id');

  $$PlacesTableProcessedTableManager get sourcePlaceId {
    final $_column = $_itemColumn<String>('source_place_id')!;

    final manager = $$PlacesTableTableManager(
      $_db,
      $_db.places,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourcePlaceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PlacesTable _targetPlaceIdTable(_$AppDatabase db) =>
      db.places.createAlias('place_relationships__target_place_id__places__id');

  $$PlacesTableProcessedTableManager get targetPlaceId {
    final $_column = $_itemColumn<String>('target_place_id')!;

    final manager = $$PlacesTableTableManager(
      $_db,
      $_db.places,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_targetPlaceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PlaceRelationshipsTableFilterComposer
    extends Composer<_$AppDatabase, $PlaceRelationshipsTable> {
  $$PlaceRelationshipsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PlacesTableFilterComposer get sourcePlaceId {
    final $$PlacesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourcePlaceId,
      referencedTable: $db.places,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlacesTableFilterComposer(
            $db: $db,
            $table: $db.places,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlacesTableFilterComposer get targetPlaceId {
    final $$PlacesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.targetPlaceId,
      referencedTable: $db.places,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlacesTableFilterComposer(
            $db: $db,
            $table: $db.places,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlaceRelationshipsTableOrderingComposer
    extends Composer<_$AppDatabase, $PlaceRelationshipsTable> {
  $$PlaceRelationshipsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PlacesTableOrderingComposer get sourcePlaceId {
    final $$PlacesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourcePlaceId,
      referencedTable: $db.places,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlacesTableOrderingComposer(
            $db: $db,
            $table: $db.places,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlacesTableOrderingComposer get targetPlaceId {
    final $$PlacesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.targetPlaceId,
      referencedTable: $db.places,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlacesTableOrderingComposer(
            $db: $db,
            $table: $db.places,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlaceRelationshipsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlaceRelationshipsTable> {
  $$PlaceRelationshipsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$PlacesTableAnnotationComposer get sourcePlaceId {
    final $$PlacesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourcePlaceId,
      referencedTable: $db.places,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlacesTableAnnotationComposer(
            $db: $db,
            $table: $db.places,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlacesTableAnnotationComposer get targetPlaceId {
    final $$PlacesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.targetPlaceId,
      referencedTable: $db.places,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlacesTableAnnotationComposer(
            $db: $db,
            $table: $db.places,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlaceRelationshipsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlaceRelationshipsTable,
          PlaceRelationship,
          $$PlaceRelationshipsTableFilterComposer,
          $$PlaceRelationshipsTableOrderingComposer,
          $$PlaceRelationshipsTableAnnotationComposer,
          $$PlaceRelationshipsTableCreateCompanionBuilder,
          $$PlaceRelationshipsTableUpdateCompanionBuilder,
          (PlaceRelationship, $$PlaceRelationshipsTableReferences),
          PlaceRelationship,
          PrefetchHooks Function({bool sourcePlaceId, bool targetPlaceId})
        > {
  $$PlaceRelationshipsTableTableManager(
    _$AppDatabase db,
    $PlaceRelationshipsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlaceRelationshipsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlaceRelationshipsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlaceRelationshipsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sourcePlaceId = const Value.absent(),
                Value<String> targetPlaceId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> modifiedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlaceRelationshipsCompanion(
                id: id,
                sourcePlaceId: sourcePlaceId,
                targetPlaceId: targetPlaceId,
                type: type,
                createdAt: createdAt,
                modifiedAt: modifiedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sourcePlaceId,
                required String targetPlaceId,
                required String type,
                required DateTime createdAt,
                required DateTime modifiedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlaceRelationshipsCompanion.insert(
                id: id,
                sourcePlaceId: sourcePlaceId,
                targetPlaceId: targetPlaceId,
                type: type,
                createdAt: createdAt,
                modifiedAt: modifiedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PlaceRelationshipsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({sourcePlaceId = false, targetPlaceId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (sourcePlaceId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.sourcePlaceId,
                            referencedTable: $$PlaceRelationshipsTableReferences
                                ._sourcePlaceIdTable(db),
                            referencedColumn:
                                $$PlaceRelationshipsTableReferences
                                    ._sourcePlaceIdTable(db)
                                    .id,
                          ) as T;
                        }
                        if (targetPlaceId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.targetPlaceId,
                            referencedTable: $$PlaceRelationshipsTableReferences
                                ._targetPlaceIdTable(db),
                            referencedColumn:
                                $$PlaceRelationshipsTableReferences
                                    ._targetPlaceIdTable(db)
                                    .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$PlaceRelationshipsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlaceRelationshipsTable,
      PlaceRelationship,
      $$PlaceRelationshipsTableFilterComposer,
      $$PlaceRelationshipsTableOrderingComposer,
      $$PlaceRelationshipsTableAnnotationComposer,
      $$PlaceRelationshipsTableCreateCompanionBuilder,
      $$PlaceRelationshipsTableUpdateCompanionBuilder,
      (PlaceRelationship, $$PlaceRelationshipsTableReferences),
      PlaceRelationship,
      PrefetchHooks Function({bool sourcePlaceId, bool targetPlaceId})
    >;
typedef $$ResidencesTableCreateCompanionBuilder = ResidencesCompanion Function({
  required String id,
  required String personId,
  required String placeId,
  Value<String?> startPrecision,
  Value<DateTime?> startStartDate,
  Value<DateTime?> startEndDate,
  Value<String?> startDisplayText,
  Value<String?> endPrecision,
  Value<DateTime?> endStartDate,
  Value<DateTime?> endEndDate,
  Value<String?> endDisplayText,
  Value<String?> reason,
  Value<String?> notes,
  required DateTime createdAt,
  required DateTime modifiedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});
typedef $$ResidencesTableUpdateCompanionBuilder = ResidencesCompanion Function({
  Value<String> id,
  Value<String> personId,
  Value<String> placeId,
  Value<String?> startPrecision,
  Value<DateTime?> startStartDate,
  Value<DateTime?> startEndDate,
  Value<String?> startDisplayText,
  Value<String?> endPrecision,
  Value<DateTime?> endStartDate,
  Value<DateTime?> endEndDate,
  Value<String?> endDisplayText,
  Value<String?> reason,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> modifiedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});

final class $$ResidencesTableReferences
    extends BaseReferences<_$AppDatabase, $ResidencesTable, Residence> {
  $$ResidencesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PersonsTable _personIdTable(_$AppDatabase db) =>
      db.persons.createAlias('residences__person_id__persons__id');

  $$PersonsTableProcessedTableManager get personId {
    final $_column = $_itemColumn<String>('person_id')!;

    final manager = $$PersonsTableTableManager(
      $_db,
      $_db.persons,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_personIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PlacesTable _placeIdTable(_$AppDatabase db) =>
      db.places.createAlias('residences__place_id__places__id');

  $$PlacesTableProcessedTableManager get placeId {
    final $_column = $_itemColumn<String>('place_id')!;

    final manager = $$PlacesTableTableManager(
      $_db,
      $_db.places,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_placeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ResidencesTableFilterComposer
    extends Composer<_$AppDatabase, $ResidencesTable> {
  $$ResidencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startPrecision => $composableBuilder(
    column: $table.startPrecision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startStartDate => $composableBuilder(
    column: $table.startStartDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startEndDate => $composableBuilder(
    column: $table.startEndDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startDisplayText => $composableBuilder(
    column: $table.startDisplayText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endPrecision => $composableBuilder(
    column: $table.endPrecision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endStartDate => $composableBuilder(
    column: $table.endStartDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endEndDate => $composableBuilder(
    column: $table.endEndDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endDisplayText => $composableBuilder(
    column: $table.endDisplayText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PersonsTableFilterComposer get personId {
    final $$PersonsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personId,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableFilterComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlacesTableFilterComposer get placeId {
    final $$PlacesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.placeId,
      referencedTable: $db.places,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlacesTableFilterComposer(
            $db: $db,
            $table: $db.places,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ResidencesTableOrderingComposer
    extends Composer<_$AppDatabase, $ResidencesTable> {
  $$ResidencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startPrecision => $composableBuilder(
    column: $table.startPrecision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startStartDate => $composableBuilder(
    column: $table.startStartDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startEndDate => $composableBuilder(
    column: $table.startEndDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startDisplayText => $composableBuilder(
    column: $table.startDisplayText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endPrecision => $composableBuilder(
    column: $table.endPrecision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endStartDate => $composableBuilder(
    column: $table.endStartDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endEndDate => $composableBuilder(
    column: $table.endEndDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endDisplayText => $composableBuilder(
    column: $table.endDisplayText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PersonsTableOrderingComposer get personId {
    final $$PersonsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personId,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableOrderingComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlacesTableOrderingComposer get placeId {
    final $$PlacesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.placeId,
      referencedTable: $db.places,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlacesTableOrderingComposer(
            $db: $db,
            $table: $db.places,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ResidencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ResidencesTable> {
  $$ResidencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get startPrecision => $composableBuilder(
    column: $table.startPrecision,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startStartDate => $composableBuilder(
    column: $table.startStartDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startEndDate => $composableBuilder(
    column: $table.startEndDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get startDisplayText => $composableBuilder(
    column: $table.startDisplayText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get endPrecision => $composableBuilder(
    column: $table.endPrecision,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get endStartDate => $composableBuilder(
    column: $table.endStartDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get endEndDate => $composableBuilder(
    column: $table.endEndDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get endDisplayText => $composableBuilder(
    column: $table.endDisplayText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$PersonsTableAnnotationComposer get personId {
    final $$PersonsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personId,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableAnnotationComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlacesTableAnnotationComposer get placeId {
    final $$PlacesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.placeId,
      referencedTable: $db.places,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlacesTableAnnotationComposer(
            $db: $db,
            $table: $db.places,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ResidencesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ResidencesTable,
          Residence,
          $$ResidencesTableFilterComposer,
          $$ResidencesTableOrderingComposer,
          $$ResidencesTableAnnotationComposer,
          $$ResidencesTableCreateCompanionBuilder,
          $$ResidencesTableUpdateCompanionBuilder,
          (Residence, $$ResidencesTableReferences),
          Residence,
          PrefetchHooks Function({bool personId, bool placeId})
        > {
  $$ResidencesTableTableManager(_$AppDatabase db, $ResidencesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ResidencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ResidencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ResidencesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> personId = const Value.absent(),
                Value<String> placeId = const Value.absent(),
                Value<String?> startPrecision = const Value.absent(),
                Value<DateTime?> startStartDate = const Value.absent(),
                Value<DateTime?> startEndDate = const Value.absent(),
                Value<String?> startDisplayText = const Value.absent(),
                Value<String?> endPrecision = const Value.absent(),
                Value<DateTime?> endStartDate = const Value.absent(),
                Value<DateTime?> endEndDate = const Value.absent(),
                Value<String?> endDisplayText = const Value.absent(),
                Value<String?> reason = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> modifiedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ResidencesCompanion(
                id: id,
                personId: personId,
                placeId: placeId,
                startPrecision: startPrecision,
                startStartDate: startStartDate,
                startEndDate: startEndDate,
                startDisplayText: startDisplayText,
                endPrecision: endPrecision,
                endStartDate: endStartDate,
                endEndDate: endEndDate,
                endDisplayText: endDisplayText,
                reason: reason,
                notes: notes,
                createdAt: createdAt,
                modifiedAt: modifiedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String personId,
                required String placeId,
                Value<String?> startPrecision = const Value.absent(),
                Value<DateTime?> startStartDate = const Value.absent(),
                Value<DateTime?> startEndDate = const Value.absent(),
                Value<String?> startDisplayText = const Value.absent(),
                Value<String?> endPrecision = const Value.absent(),
                Value<DateTime?> endStartDate = const Value.absent(),
                Value<DateTime?> endEndDate = const Value.absent(),
                Value<String?> endDisplayText = const Value.absent(),
                Value<String?> reason = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                required DateTime modifiedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ResidencesCompanion.insert(
                id: id,
                personId: personId,
                placeId: placeId,
                startPrecision: startPrecision,
                startStartDate: startStartDate,
                startEndDate: startEndDate,
                startDisplayText: startDisplayText,
                endPrecision: endPrecision,
                endStartDate: endStartDate,
                endEndDate: endEndDate,
                endDisplayText: endDisplayText,
                reason: reason,
                notes: notes,
                createdAt: createdAt,
                modifiedAt: modifiedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ResidencesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({personId = false, placeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (personId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.personId,
                        referencedTable: $$ResidencesTableReferences
                            ._personIdTable(db),
                        referencedColumn: $$ResidencesTableReferences
                            ._personIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (placeId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.placeId,
                        referencedTable: $$ResidencesTableReferences
                            ._placeIdTable(db),
                        referencedColumn: $$ResidencesTableReferences
                            ._placeIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ResidencesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ResidencesTable,
      Residence,
      $$ResidencesTableFilterComposer,
      $$ResidencesTableOrderingComposer,
      $$ResidencesTableAnnotationComposer,
      $$ResidencesTableCreateCompanionBuilder,
      $$ResidencesTableUpdateCompanionBuilder,
      (Residence, $$ResidencesTableReferences),
      Residence,
      PrefetchHooks Function({bool personId, bool placeId})
    >;
typedef $$EventsTableCreateCompanionBuilder = EventsCompanion Function({
  required String id,
  required String type,
  Value<String?> datePrecision,
  Value<DateTime?> dateStartDate,
  Value<DateTime?> dateEndDate,
  Value<String?> dateDisplayText,
  Value<String?> placeId,
  Value<String?> title,
  Value<String?> description,
  required DateTime createdAt,
  required DateTime modifiedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});
typedef $$EventsTableUpdateCompanionBuilder = EventsCompanion Function({
  Value<String> id,
  Value<String> type,
  Value<String?> datePrecision,
  Value<DateTime?> dateStartDate,
  Value<DateTime?> dateEndDate,
  Value<String?> dateDisplayText,
  Value<String?> placeId,
  Value<String?> title,
  Value<String?> description,
  Value<DateTime> createdAt,
  Value<DateTime> modifiedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});

final class $$EventsTableReferences
    extends BaseReferences<_$AppDatabase, $EventsTable, Event> {
  $$EventsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PlacesTable _placeIdTable(_$AppDatabase db) =>
      db.places.createAlias('events__place_id__places__id');

  $$PlacesTableProcessedTableManager? get placeId {
    final $_column = $_itemColumn<String>('place_id');
    if ($_column == null) return null;
    final manager = $$PlacesTableTableManager(
      $_db,
      $_db.places,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_placeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$EventParticipantsTable, List<EventParticipant>>
  _eventParticipantsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.eventParticipants,
        aliasName: 'events__id__event_participants__event_id',
      );

  $$EventParticipantsTableProcessedTableManager get eventParticipantsRefs {
    final manager = $$EventParticipantsTableTableManager(
      $_db,
      $_db.eventParticipants,
    ).filter((f) => f.eventId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _eventParticipantsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EventsTableFilterComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get datePrecision => $composableBuilder(
    column: $table.datePrecision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateStartDate => $composableBuilder(
    column: $table.dateStartDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateEndDate => $composableBuilder(
    column: $table.dateEndDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dateDisplayText => $composableBuilder(
    column: $table.dateDisplayText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PlacesTableFilterComposer get placeId {
    final $$PlacesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.placeId,
      referencedTable: $db.places,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlacesTableFilterComposer(
            $db: $db,
            $table: $db.places,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> eventParticipantsRefs(
    Expression<bool> Function($$EventParticipantsTableFilterComposer f) f,
  ) {
    final $$EventParticipantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.eventParticipants,
      getReferencedColumn: (t) => t.eventId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventParticipantsTableFilterComposer(
            $db: $db,
            $table: $db.eventParticipants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EventsTableOrderingComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get datePrecision => $composableBuilder(
    column: $table.datePrecision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateStartDate => $composableBuilder(
    column: $table.dateStartDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateEndDate => $composableBuilder(
    column: $table.dateEndDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dateDisplayText => $composableBuilder(
    column: $table.dateDisplayText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PlacesTableOrderingComposer get placeId {
    final $$PlacesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.placeId,
      referencedTable: $db.places,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlacesTableOrderingComposer(
            $db: $db,
            $table: $db.places,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get datePrecision => $composableBuilder(
    column: $table.datePrecision,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dateStartDate => $composableBuilder(
    column: $table.dateStartDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dateEndDate => $composableBuilder(
    column: $table.dateEndDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dateDisplayText => $composableBuilder(
    column: $table.dateDisplayText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$PlacesTableAnnotationComposer get placeId {
    final $$PlacesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.placeId,
      referencedTable: $db.places,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlacesTableAnnotationComposer(
            $db: $db,
            $table: $db.places,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> eventParticipantsRefs<T extends Object>(
    Expression<T> Function($$EventParticipantsTableAnnotationComposer a) f,
  ) {
    final $$EventParticipantsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.eventParticipants,
          getReferencedColumn: (t) => t.eventId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EventParticipantsTableAnnotationComposer(
                $db: $db,
                $table: $db.eventParticipants,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$EventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EventsTable,
          Event,
          $$EventsTableFilterComposer,
          $$EventsTableOrderingComposer,
          $$EventsTableAnnotationComposer,
          $$EventsTableCreateCompanionBuilder,
          $$EventsTableUpdateCompanionBuilder,
          (Event, $$EventsTableReferences),
          Event,
          PrefetchHooks Function({bool placeId, bool eventParticipantsRefs})
        > {
  $$EventsTableTableManager(_$AppDatabase db, $EventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> datePrecision = const Value.absent(),
                Value<DateTime?> dateStartDate = const Value.absent(),
                Value<DateTime?> dateEndDate = const Value.absent(),
                Value<String?> dateDisplayText = const Value.absent(),
                Value<String?> placeId = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> modifiedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EventsCompanion(
                id: id,
                type: type,
                datePrecision: datePrecision,
                dateStartDate: dateStartDate,
                dateEndDate: dateEndDate,
                dateDisplayText: dateDisplayText,
                placeId: placeId,
                title: title,
                description: description,
                createdAt: createdAt,
                modifiedAt: modifiedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String type,
                Value<String?> datePrecision = const Value.absent(),
                Value<DateTime?> dateStartDate = const Value.absent(),
                Value<DateTime?> dateEndDate = const Value.absent(),
                Value<String?> dateDisplayText = const Value.absent(),
                Value<String?> placeId = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                required DateTime createdAt,
                required DateTime modifiedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EventsCompanion.insert(
                id: id,
                type: type,
                datePrecision: datePrecision,
                dateStartDate: dateStartDate,
                dateEndDate: dateEndDate,
                dateDisplayText: dateDisplayText,
                placeId: placeId,
                title: title,
                description: description,
                createdAt: createdAt,
                modifiedAt: modifiedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$EventsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({placeId = false, eventParticipantsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (eventParticipantsRefs) db.eventParticipants,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (placeId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.placeId,
                            referencedTable: $$EventsTableReferences
                                ._placeIdTable(db),
                            referencedColumn: $$EventsTableReferences
                                ._placeIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (eventParticipantsRefs)
                        await $_getPrefetchedData<
                          Event,
                          $EventsTable,
                          EventParticipant
                        >(
                          currentTable: table,
                          referencedTable: $$EventsTableReferences
                              ._eventParticipantsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EventsTableReferences(
                                db,
                                table,
                                p0,
                              ).eventParticipantsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.eventId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$EventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EventsTable,
      Event,
      $$EventsTableFilterComposer,
      $$EventsTableOrderingComposer,
      $$EventsTableAnnotationComposer,
      $$EventsTableCreateCompanionBuilder,
      $$EventsTableUpdateCompanionBuilder,
      (Event, $$EventsTableReferences),
      Event,
      PrefetchHooks Function({bool placeId, bool eventParticipantsRefs})
    >;
typedef $$EventParticipantsTableCreateCompanionBuilder =
    EventParticipantsCompanion Function({
      required String id,
      required String eventId,
      required String personId,
      required String role,
      required DateTime createdAt,
      required DateTime modifiedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$EventParticipantsTableUpdateCompanionBuilder =
    EventParticipantsCompanion Function({
      Value<String> id,
      Value<String> eventId,
      Value<String> personId,
      Value<String> role,
      Value<DateTime> createdAt,
      Value<DateTime> modifiedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

final class $$EventParticipantsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $EventParticipantsTable,
          EventParticipant
        > {
  $$EventParticipantsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $EventsTable _eventIdTable(_$AppDatabase db) =>
      db.events.createAlias('event_participants__event_id__events__id');

  $$EventsTableProcessedTableManager get eventId {
    final $_column = $_itemColumn<String>('event_id')!;

    final manager = $$EventsTableTableManager(
      $_db,
      $_db.events,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_eventIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PersonsTable _personIdTable(_$AppDatabase db) =>
      db.persons.createAlias('event_participants__person_id__persons__id');

  $$PersonsTableProcessedTableManager get personId {
    final $_column = $_itemColumn<String>('person_id')!;

    final manager = $$PersonsTableTableManager(
      $_db,
      $_db.persons,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_personIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EventParticipantsTableFilterComposer
    extends Composer<_$AppDatabase, $EventParticipantsTable> {
  $$EventParticipantsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$EventsTableFilterComposer get eventId {
    final $$EventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableFilterComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PersonsTableFilterComposer get personId {
    final $$PersonsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personId,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableFilterComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EventParticipantsTableOrderingComposer
    extends Composer<_$AppDatabase, $EventParticipantsTable> {
  $$EventParticipantsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$EventsTableOrderingComposer get eventId {
    final $$EventsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableOrderingComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PersonsTableOrderingComposer get personId {
    final $$PersonsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personId,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableOrderingComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EventParticipantsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EventParticipantsTable> {
  $$EventParticipantsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$EventsTableAnnotationComposer get eventId {
    final $$EventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableAnnotationComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PersonsTableAnnotationComposer get personId {
    final $$PersonsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personId,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableAnnotationComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EventParticipantsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EventParticipantsTable,
          EventParticipant,
          $$EventParticipantsTableFilterComposer,
          $$EventParticipantsTableOrderingComposer,
          $$EventParticipantsTableAnnotationComposer,
          $$EventParticipantsTableCreateCompanionBuilder,
          $$EventParticipantsTableUpdateCompanionBuilder,
          (EventParticipant, $$EventParticipantsTableReferences),
          EventParticipant,
          PrefetchHooks Function({bool eventId, bool personId})
        > {
  $$EventParticipantsTableTableManager(
    _$AppDatabase db,
    $EventParticipantsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EventParticipantsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EventParticipantsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EventParticipantsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> eventId = const Value.absent(),
                Value<String> personId = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> modifiedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EventParticipantsCompanion(
                id: id,
                eventId: eventId,
                personId: personId,
                role: role,
                createdAt: createdAt,
                modifiedAt: modifiedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String eventId,
                required String personId,
                required String role,
                required DateTime createdAt,
                required DateTime modifiedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EventParticipantsCompanion.insert(
                id: id,
                eventId: eventId,
                personId: personId,
                role: role,
                createdAt: createdAt,
                modifiedAt: modifiedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EventParticipantsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({eventId = false, personId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (eventId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.eventId,
                        referencedTable: $$EventParticipantsTableReferences
                            ._eventIdTable(db),
                        referencedColumn: $$EventParticipantsTableReferences
                            ._eventIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (personId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.personId,
                        referencedTable: $$EventParticipantsTableReferences
                            ._personIdTable(db),
                        referencedColumn: $$EventParticipantsTableReferences
                            ._personIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$EventParticipantsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EventParticipantsTable,
      EventParticipant,
      $$EventParticipantsTableFilterComposer,
      $$EventParticipantsTableOrderingComposer,
      $$EventParticipantsTableAnnotationComposer,
      $$EventParticipantsTableCreateCompanionBuilder,
      $$EventParticipantsTableUpdateCompanionBuilder,
      (EventParticipant, $$EventParticipantsTableReferences),
      EventParticipant,
      PrefetchHooks Function({bool eventId, bool personId})
    >;
typedef $$SourcesTableCreateCompanionBuilder = SourcesCompanion Function({
  required String id,
  required String type,
  required String title,
  Value<String?> description,
  Value<String?> sourceDatePrecision,
  Value<DateTime?> sourceDateStartDate,
  Value<DateTime?> sourceDateEndDate,
  Value<String?> sourceDateDisplayText,
  Value<String?> creator,
  Value<String?> repositoryName,
  Value<String?> referenceCode,
  Value<String?> originalLocation,
  Value<String?> url,
  Value<DateTime?> accessedAt,
  Value<String?> notes,
  required DateTime createdAt,
  required DateTime modifiedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});
typedef $$SourcesTableUpdateCompanionBuilder = SourcesCompanion Function({
  Value<String> id,
  Value<String> type,
  Value<String> title,
  Value<String?> description,
  Value<String?> sourceDatePrecision,
  Value<DateTime?> sourceDateStartDate,
  Value<DateTime?> sourceDateEndDate,
  Value<String?> sourceDateDisplayText,
  Value<String?> creator,
  Value<String?> repositoryName,
  Value<String?> referenceCode,
  Value<String?> originalLocation,
  Value<String?> url,
  Value<DateTime?> accessedAt,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> modifiedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});

final class $$SourcesTableReferences
    extends BaseReferences<_$AppDatabase, $SourcesTable, Source> {
  $$SourcesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SourceMediaLinksTable, List<SourceMediaLink>>
  _sourceMediaLinksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.sourceMediaLinks,
    aliasName: 'sources__id__source_media__source_id',
  );

  $$SourceMediaLinksTableProcessedTableManager get sourceMediaLinksRefs {
    final manager = $$SourceMediaLinksTableTableManager(
      $_db,
      $_db.sourceMediaLinks,
    ).filter((f) => f.sourceId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _sourceMediaLinksRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ClaimsTable, List<Claim>> _claimsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.claims,
    aliasName: 'sources__id__claims__source_id',
  );

  $$ClaimsTableProcessedTableManager get claimsRefs {
    final manager = $$ClaimsTableTableManager(
      $_db,
      $_db.claims,
    ).filter((f) => f.sourceId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_claimsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SourcesTableFilterComposer
    extends Composer<_$AppDatabase, $SourcesTable> {
  $$SourcesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceDatePrecision => $composableBuilder(
    column: $table.sourceDatePrecision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get sourceDateStartDate => $composableBuilder(
    column: $table.sourceDateStartDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get sourceDateEndDate => $composableBuilder(
    column: $table.sourceDateEndDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceDateDisplayText => $composableBuilder(
    column: $table.sourceDateDisplayText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get creator => $composableBuilder(
    column: $table.creator,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get repositoryName => $composableBuilder(
    column: $table.repositoryName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get referenceCode => $composableBuilder(
    column: $table.referenceCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originalLocation => $composableBuilder(
    column: $table.originalLocation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get accessedAt => $composableBuilder(
    column: $table.accessedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> sourceMediaLinksRefs(
    Expression<bool> Function($$SourceMediaLinksTableFilterComposer f) f,
  ) {
    final $$SourceMediaLinksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sourceMediaLinks,
      getReferencedColumn: (t) => t.sourceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourceMediaLinksTableFilterComposer(
            $db: $db,
            $table: $db.sourceMediaLinks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> claimsRefs(
    Expression<bool> Function($$ClaimsTableFilterComposer f) f,
  ) {
    final $$ClaimsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.claims,
      getReferencedColumn: (t) => t.sourceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClaimsTableFilterComposer(
            $db: $db,
            $table: $db.claims,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SourcesTableOrderingComposer
    extends Composer<_$AppDatabase, $SourcesTable> {
  $$SourcesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceDatePrecision => $composableBuilder(
    column: $table.sourceDatePrecision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get sourceDateStartDate => $composableBuilder(
    column: $table.sourceDateStartDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get sourceDateEndDate => $composableBuilder(
    column: $table.sourceDateEndDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceDateDisplayText => $composableBuilder(
    column: $table.sourceDateDisplayText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get creator => $composableBuilder(
    column: $table.creator,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get repositoryName => $composableBuilder(
    column: $table.repositoryName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get referenceCode => $composableBuilder(
    column: $table.referenceCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originalLocation => $composableBuilder(
    column: $table.originalLocation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get accessedAt => $composableBuilder(
    column: $table.accessedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SourcesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SourcesTable> {
  $$SourcesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceDatePrecision => $composableBuilder(
    column: $table.sourceDatePrecision,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get sourceDateStartDate => $composableBuilder(
    column: $table.sourceDateStartDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get sourceDateEndDate => $composableBuilder(
    column: $table.sourceDateEndDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceDateDisplayText => $composableBuilder(
    column: $table.sourceDateDisplayText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get creator =>
      $composableBuilder(column: $table.creator, builder: (column) => column);

  GeneratedColumn<String> get repositoryName => $composableBuilder(
    column: $table.repositoryName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get referenceCode => $composableBuilder(
    column: $table.referenceCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get originalLocation => $composableBuilder(
    column: $table.originalLocation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<DateTime> get accessedAt => $composableBuilder(
    column: $table.accessedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  Expression<T> sourceMediaLinksRefs<T extends Object>(
    Expression<T> Function($$SourceMediaLinksTableAnnotationComposer a) f,
  ) {
    final $$SourceMediaLinksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sourceMediaLinks,
      getReferencedColumn: (t) => t.sourceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourceMediaLinksTableAnnotationComposer(
            $db: $db,
            $table: $db.sourceMediaLinks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> claimsRefs<T extends Object>(
    Expression<T> Function($$ClaimsTableAnnotationComposer a) f,
  ) {
    final $$ClaimsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.claims,
      getReferencedColumn: (t) => t.sourceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClaimsTableAnnotationComposer(
            $db: $db,
            $table: $db.claims,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SourcesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SourcesTable,
          Source,
          $$SourcesTableFilterComposer,
          $$SourcesTableOrderingComposer,
          $$SourcesTableAnnotationComposer,
          $$SourcesTableCreateCompanionBuilder,
          $$SourcesTableUpdateCompanionBuilder,
          (Source, $$SourcesTableReferences),
          Source,
          PrefetchHooks Function({bool sourceMediaLinksRefs, bool claimsRefs})
        > {
  $$SourcesTableTableManager(_$AppDatabase db, $SourcesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SourcesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SourcesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SourcesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> sourceDatePrecision = const Value.absent(),
                Value<DateTime?> sourceDateStartDate = const Value.absent(),
                Value<DateTime?> sourceDateEndDate = const Value.absent(),
                Value<String?> sourceDateDisplayText = const Value.absent(),
                Value<String?> creator = const Value.absent(),
                Value<String?> repositoryName = const Value.absent(),
                Value<String?> referenceCode = const Value.absent(),
                Value<String?> originalLocation = const Value.absent(),
                Value<String?> url = const Value.absent(),
                Value<DateTime?> accessedAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> modifiedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SourcesCompanion(
                id: id,
                type: type,
                title: title,
                description: description,
                sourceDatePrecision: sourceDatePrecision,
                sourceDateStartDate: sourceDateStartDate,
                sourceDateEndDate: sourceDateEndDate,
                sourceDateDisplayText: sourceDateDisplayText,
                creator: creator,
                repositoryName: repositoryName,
                referenceCode: referenceCode,
                originalLocation: originalLocation,
                url: url,
                accessedAt: accessedAt,
                notes: notes,
                createdAt: createdAt,
                modifiedAt: modifiedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String type,
                required String title,
                Value<String?> description = const Value.absent(),
                Value<String?> sourceDatePrecision = const Value.absent(),
                Value<DateTime?> sourceDateStartDate = const Value.absent(),
                Value<DateTime?> sourceDateEndDate = const Value.absent(),
                Value<String?> sourceDateDisplayText = const Value.absent(),
                Value<String?> creator = const Value.absent(),
                Value<String?> repositoryName = const Value.absent(),
                Value<String?> referenceCode = const Value.absent(),
                Value<String?> originalLocation = const Value.absent(),
                Value<String?> url = const Value.absent(),
                Value<DateTime?> accessedAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                required DateTime modifiedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SourcesCompanion.insert(
                id: id,
                type: type,
                title: title,
                description: description,
                sourceDatePrecision: sourceDatePrecision,
                sourceDateStartDate: sourceDateStartDate,
                sourceDateEndDate: sourceDateEndDate,
                sourceDateDisplayText: sourceDateDisplayText,
                creator: creator,
                repositoryName: repositoryName,
                referenceCode: referenceCode,
                originalLocation: originalLocation,
                url: url,
                accessedAt: accessedAt,
                notes: notes,
                createdAt: createdAt,
                modifiedAt: modifiedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SourcesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({sourceMediaLinksRefs = false, claimsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (sourceMediaLinksRefs) db.sourceMediaLinks,
                    if (claimsRefs) db.claims,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (sourceMediaLinksRefs)
                        await $_getPrefetchedData<
                          Source,
                          $SourcesTable,
                          SourceMediaLink
                        >(
                          currentTable: table,
                          referencedTable: $$SourcesTableReferences
                              ._sourceMediaLinksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SourcesTableReferences(
                                db,
                                table,
                                p0,
                              ).sourceMediaLinksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sourceId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (claimsRefs)
                        await $_getPrefetchedData<Source, $SourcesTable, Claim>(
                          currentTable: table,
                          referencedTable: $$SourcesTableReferences
                              ._claimsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SourcesTableReferences(
                                db,
                                table,
                                p0,
                              ).claimsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sourceId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SourcesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SourcesTable,
      Source,
      $$SourcesTableFilterComposer,
      $$SourcesTableOrderingComposer,
      $$SourcesTableAnnotationComposer,
      $$SourcesTableCreateCompanionBuilder,
      $$SourcesTableUpdateCompanionBuilder,
      (Source, $$SourcesTableReferences),
      Source,
      PrefetchHooks Function({bool sourceMediaLinksRefs, bool claimsRefs})
    >;
typedef $$MediaAssetsTableCreateCompanionBuilder =
    MediaAssetsCompanion Function({
      required String id,
      required String type,
      required String relativePath,
      Value<String?> mimeType,
      Value<String?> originalFilename,
      required String checksumSha256,
      required int fileSize,
      required DateTime createdAt,
      required DateTime modifiedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$MediaAssetsTableUpdateCompanionBuilder =
    MediaAssetsCompanion Function({
      Value<String> id,
      Value<String> type,
      Value<String> relativePath,
      Value<String?> mimeType,
      Value<String?> originalFilename,
      Value<String> checksumSha256,
      Value<int> fileSize,
      Value<DateTime> createdAt,
      Value<DateTime> modifiedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

final class $$MediaAssetsTableReferences
    extends BaseReferences<_$AppDatabase, $MediaAssetsTable, MediaAsset> {
  $$MediaAssetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SourceMediaLinksTable, List<SourceMediaLink>>
  _sourceMediaLinksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.sourceMediaLinks,
    aliasName: 'media__id__source_media__media_id',
  );

  $$SourceMediaLinksTableProcessedTableManager get sourceMediaLinksRefs {
    final manager = $$SourceMediaLinksTableTableManager(
      $_db,
      $_db.sourceMediaLinks,
    ).filter((f) => f.mediaId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _sourceMediaLinksRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MediaAssetsTableFilterComposer
    extends Composer<_$AppDatabase, $MediaAssetsTable> {
  $$MediaAssetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get relativePath => $composableBuilder(
    column: $table.relativePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originalFilename => $composableBuilder(
    column: $table.originalFilename,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get checksumSha256 => $composableBuilder(
    column: $table.checksumSha256,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fileSize => $composableBuilder(
    column: $table.fileSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> sourceMediaLinksRefs(
    Expression<bool> Function($$SourceMediaLinksTableFilterComposer f) f,
  ) {
    final $$SourceMediaLinksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sourceMediaLinks,
      getReferencedColumn: (t) => t.mediaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourceMediaLinksTableFilterComposer(
            $db: $db,
            $table: $db.sourceMediaLinks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MediaAssetsTableOrderingComposer
    extends Composer<_$AppDatabase, $MediaAssetsTable> {
  $$MediaAssetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relativePath => $composableBuilder(
    column: $table.relativePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originalFilename => $composableBuilder(
    column: $table.originalFilename,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get checksumSha256 => $composableBuilder(
    column: $table.checksumSha256,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fileSize => $composableBuilder(
    column: $table.fileSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MediaAssetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MediaAssetsTable> {
  $$MediaAssetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get relativePath => $composableBuilder(
    column: $table.relativePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  GeneratedColumn<String> get originalFilename => $composableBuilder(
    column: $table.originalFilename,
    builder: (column) => column,
  );

  GeneratedColumn<String> get checksumSha256 => $composableBuilder(
    column: $table.checksumSha256,
    builder: (column) => column,
  );

  GeneratedColumn<int> get fileSize =>
      $composableBuilder(column: $table.fileSize, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  Expression<T> sourceMediaLinksRefs<T extends Object>(
    Expression<T> Function($$SourceMediaLinksTableAnnotationComposer a) f,
  ) {
    final $$SourceMediaLinksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sourceMediaLinks,
      getReferencedColumn: (t) => t.mediaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourceMediaLinksTableAnnotationComposer(
            $db: $db,
            $table: $db.sourceMediaLinks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MediaAssetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MediaAssetsTable,
          MediaAsset,
          $$MediaAssetsTableFilterComposer,
          $$MediaAssetsTableOrderingComposer,
          $$MediaAssetsTableAnnotationComposer,
          $$MediaAssetsTableCreateCompanionBuilder,
          $$MediaAssetsTableUpdateCompanionBuilder,
          (MediaAsset, $$MediaAssetsTableReferences),
          MediaAsset,
          PrefetchHooks Function({bool sourceMediaLinksRefs})
        > {
  $$MediaAssetsTableTableManager(_$AppDatabase db, $MediaAssetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MediaAssetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MediaAssetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MediaAssetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> relativePath = const Value.absent(),
                Value<String?> mimeType = const Value.absent(),
                Value<String?> originalFilename = const Value.absent(),
                Value<String> checksumSha256 = const Value.absent(),
                Value<int> fileSize = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> modifiedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MediaAssetsCompanion(
                id: id,
                type: type,
                relativePath: relativePath,
                mimeType: mimeType,
                originalFilename: originalFilename,
                checksumSha256: checksumSha256,
                fileSize: fileSize,
                createdAt: createdAt,
                modifiedAt: modifiedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String type,
                required String relativePath,
                Value<String?> mimeType = const Value.absent(),
                Value<String?> originalFilename = const Value.absent(),
                required String checksumSha256,
                required int fileSize,
                required DateTime createdAt,
                required DateTime modifiedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MediaAssetsCompanion.insert(
                id: id,
                type: type,
                relativePath: relativePath,
                mimeType: mimeType,
                originalFilename: originalFilename,
                checksumSha256: checksumSha256,
                fileSize: fileSize,
                createdAt: createdAt,
                modifiedAt: modifiedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MediaAssetsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sourceMediaLinksRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (sourceMediaLinksRefs) db.sourceMediaLinks,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (sourceMediaLinksRefs)
                    await $_getPrefetchedData<
                      MediaAsset,
                      $MediaAssetsTable,
                      SourceMediaLink
                    >(
                      currentTable: table,
                      referencedTable: $$MediaAssetsTableReferences
                          ._sourceMediaLinksRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$MediaAssetsTableReferences(
                            db,
                            table,
                            p0,
                          ).sourceMediaLinksRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.mediaId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$MediaAssetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MediaAssetsTable,
      MediaAsset,
      $$MediaAssetsTableFilterComposer,
      $$MediaAssetsTableOrderingComposer,
      $$MediaAssetsTableAnnotationComposer,
      $$MediaAssetsTableCreateCompanionBuilder,
      $$MediaAssetsTableUpdateCompanionBuilder,
      (MediaAsset, $$MediaAssetsTableReferences),
      MediaAsset,
      PrefetchHooks Function({bool sourceMediaLinksRefs})
    >;
typedef $$SourceMediaLinksTableCreateCompanionBuilder =
    SourceMediaLinksCompanion Function({
      required String id,
      required String sourceId,
      required String mediaId,
      required String role,
      Value<String?> caption,
      Value<int> sortOrder,
      required DateTime createdAt,
      required DateTime modifiedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$SourceMediaLinksTableUpdateCompanionBuilder =
    SourceMediaLinksCompanion Function({
      Value<String> id,
      Value<String> sourceId,
      Value<String> mediaId,
      Value<String> role,
      Value<String?> caption,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
      Value<DateTime> modifiedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

final class $$SourceMediaLinksTableReferences
    extends
        BaseReferences<_$AppDatabase, $SourceMediaLinksTable, SourceMediaLink> {
  $$SourceMediaLinksTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SourcesTable _sourceIdTable(_$AppDatabase db) =>
      db.sources.createAlias('source_media__source_id__sources__id');

  $$SourcesTableProcessedTableManager get sourceId {
    final $_column = $_itemColumn<String>('source_id')!;

    final manager = $$SourcesTableTableManager(
      $_db,
      $_db.sources,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $MediaAssetsTable _mediaIdTable(_$AppDatabase db) =>
      db.mediaAssets.createAlias('source_media__media_id__media__id');

  $$MediaAssetsTableProcessedTableManager get mediaId {
    final $_column = $_itemColumn<String>('media_id')!;

    final manager = $$MediaAssetsTableTableManager(
      $_db,
      $_db.mediaAssets,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mediaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SourceMediaLinksTableFilterComposer
    extends Composer<_$AppDatabase, $SourceMediaLinksTable> {
  $$SourceMediaLinksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SourcesTableFilterComposer get sourceId {
    final $$SourcesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceId,
      referencedTable: $db.sources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourcesTableFilterComposer(
            $db: $db,
            $table: $db.sources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MediaAssetsTableFilterComposer get mediaId {
    final $$MediaAssetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mediaId,
      referencedTable: $db.mediaAssets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaAssetsTableFilterComposer(
            $db: $db,
            $table: $db.mediaAssets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SourceMediaLinksTableOrderingComposer
    extends Composer<_$AppDatabase, $SourceMediaLinksTable> {
  $$SourceMediaLinksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SourcesTableOrderingComposer get sourceId {
    final $$SourcesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceId,
      referencedTable: $db.sources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourcesTableOrderingComposer(
            $db: $db,
            $table: $db.sources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MediaAssetsTableOrderingComposer get mediaId {
    final $$MediaAssetsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mediaId,
      referencedTable: $db.mediaAssets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaAssetsTableOrderingComposer(
            $db: $db,
            $table: $db.mediaAssets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SourceMediaLinksTableAnnotationComposer
    extends Composer<_$AppDatabase, $SourceMediaLinksTable> {
  $$SourceMediaLinksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get caption =>
      $composableBuilder(column: $table.caption, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$SourcesTableAnnotationComposer get sourceId {
    final $$SourcesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceId,
      referencedTable: $db.sources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourcesTableAnnotationComposer(
            $db: $db,
            $table: $db.sources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MediaAssetsTableAnnotationComposer get mediaId {
    final $$MediaAssetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mediaId,
      referencedTable: $db.mediaAssets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaAssetsTableAnnotationComposer(
            $db: $db,
            $table: $db.mediaAssets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SourceMediaLinksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SourceMediaLinksTable,
          SourceMediaLink,
          $$SourceMediaLinksTableFilterComposer,
          $$SourceMediaLinksTableOrderingComposer,
          $$SourceMediaLinksTableAnnotationComposer,
          $$SourceMediaLinksTableCreateCompanionBuilder,
          $$SourceMediaLinksTableUpdateCompanionBuilder,
          (SourceMediaLink, $$SourceMediaLinksTableReferences),
          SourceMediaLink,
          PrefetchHooks Function({bool sourceId, bool mediaId})
        > {
  $$SourceMediaLinksTableTableManager(
    _$AppDatabase db,
    $SourceMediaLinksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SourceMediaLinksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SourceMediaLinksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SourceMediaLinksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sourceId = const Value.absent(),
                Value<String> mediaId = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String?> caption = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> modifiedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SourceMediaLinksCompanion(
                id: id,
                sourceId: sourceId,
                mediaId: mediaId,
                role: role,
                caption: caption,
                sortOrder: sortOrder,
                createdAt: createdAt,
                modifiedAt: modifiedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sourceId,
                required String mediaId,
                required String role,
                Value<String?> caption = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                required DateTime createdAt,
                required DateTime modifiedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SourceMediaLinksCompanion.insert(
                id: id,
                sourceId: sourceId,
                mediaId: mediaId,
                role: role,
                caption: caption,
                sortOrder: sortOrder,
                createdAt: createdAt,
                modifiedAt: modifiedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SourceMediaLinksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sourceId = false, mediaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sourceId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.sourceId,
                        referencedTable: $$SourceMediaLinksTableReferences
                            ._sourceIdTable(db),
                        referencedColumn: $$SourceMediaLinksTableReferences
                            ._sourceIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (mediaId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.mediaId,
                        referencedTable: $$SourceMediaLinksTableReferences
                            ._mediaIdTable(db),
                        referencedColumn: $$SourceMediaLinksTableReferences
                            ._mediaIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SourceMediaLinksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SourceMediaLinksTable,
      SourceMediaLink,
      $$SourceMediaLinksTableFilterComposer,
      $$SourceMediaLinksTableOrderingComposer,
      $$SourceMediaLinksTableAnnotationComposer,
      $$SourceMediaLinksTableCreateCompanionBuilder,
      $$SourceMediaLinksTableUpdateCompanionBuilder,
      (SourceMediaLink, $$SourceMediaLinksTableReferences),
      SourceMediaLink,
      PrefetchHooks Function({bool sourceId, bool mediaId})
    >;
typedef $$ClaimsTableCreateCompanionBuilder = ClaimsCompanion Function({
  required String id,
  required String subjectType,
  required String subjectId,
  required String property,
  required String valueType,
  required String valueJson,
  Value<int> payloadVersion,
  Value<String?> sourceId,
  Value<String?> sourceLocator,
  Value<double?> confidence,
  required String status,
  required DateTime createdAt,
  required DateTime modifiedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});
typedef $$ClaimsTableUpdateCompanionBuilder = ClaimsCompanion Function({
  Value<String> id,
  Value<String> subjectType,
  Value<String> subjectId,
  Value<String> property,
  Value<String> valueType,
  Value<String> valueJson,
  Value<int> payloadVersion,
  Value<String?> sourceId,
  Value<String?> sourceLocator,
  Value<double?> confidence,
  Value<String> status,
  Value<DateTime> createdAt,
  Value<DateTime> modifiedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});

final class $$ClaimsTableReferences
    extends BaseReferences<_$AppDatabase, $ClaimsTable, Claim> {
  $$ClaimsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SourcesTable _sourceIdTable(_$AppDatabase db) =>
      db.sources.createAlias('claims__source_id__sources__id');

  $$SourcesTableProcessedTableManager? get sourceId {
    final $_column = $_itemColumn<String>('source_id');
    if ($_column == null) return null;
    final manager = $$SourcesTableTableManager(
      $_db,
      $_db.sources,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ClaimApplicationsTable, List<ClaimApplication>>
  _claimApplicationsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.claimApplications,
        aliasName: 'claims__id__claim_applications__claim_id',
      );

  $$ClaimApplicationsTableProcessedTableManager get claimApplicationsRefs {
    final manager = $$ClaimApplicationsTableTableManager(
      $_db,
      $_db.claimApplications,
    ).filter((f) => f.claimId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _claimApplicationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ClaimsTableFilterComposer
    extends Composer<_$AppDatabase, $ClaimsTable> {
  $$ClaimsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subjectType => $composableBuilder(
    column: $table.subjectType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subjectId => $composableBuilder(
    column: $table.subjectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get property => $composableBuilder(
    column: $table.property,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valueType => $composableBuilder(
    column: $table.valueType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valueJson => $composableBuilder(
    column: $table.valueJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get payloadVersion => $composableBuilder(
    column: $table.payloadVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceLocator => $composableBuilder(
    column: $table.sourceLocator,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SourcesTableFilterComposer get sourceId {
    final $$SourcesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceId,
      referencedTable: $db.sources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourcesTableFilterComposer(
            $db: $db,
            $table: $db.sources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> claimApplicationsRefs(
    Expression<bool> Function($$ClaimApplicationsTableFilterComposer f) f,
  ) {
    final $$ClaimApplicationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.claimApplications,
      getReferencedColumn: (t) => t.claimId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClaimApplicationsTableFilterComposer(
            $db: $db,
            $table: $db.claimApplications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ClaimsTableOrderingComposer
    extends Composer<_$AppDatabase, $ClaimsTable> {
  $$ClaimsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subjectType => $composableBuilder(
    column: $table.subjectType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subjectId => $composableBuilder(
    column: $table.subjectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get property => $composableBuilder(
    column: $table.property,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valueType => $composableBuilder(
    column: $table.valueType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valueJson => $composableBuilder(
    column: $table.valueJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get payloadVersion => $composableBuilder(
    column: $table.payloadVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceLocator => $composableBuilder(
    column: $table.sourceLocator,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SourcesTableOrderingComposer get sourceId {
    final $$SourcesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceId,
      referencedTable: $db.sources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourcesTableOrderingComposer(
            $db: $db,
            $table: $db.sources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ClaimsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClaimsTable> {
  $$ClaimsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get subjectType => $composableBuilder(
    column: $table.subjectType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get subjectId =>
      $composableBuilder(column: $table.subjectId, builder: (column) => column);

  GeneratedColumn<String> get property =>
      $composableBuilder(column: $table.property, builder: (column) => column);

  GeneratedColumn<String> get valueType =>
      $composableBuilder(column: $table.valueType, builder: (column) => column);

  GeneratedColumn<String> get valueJson =>
      $composableBuilder(column: $table.valueJson, builder: (column) => column);

  GeneratedColumn<int> get payloadVersion => $composableBuilder(
    column: $table.payloadVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceLocator => $composableBuilder(
    column: $table.sourceLocator,
    builder: (column) => column,
  );

  GeneratedColumn<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$SourcesTableAnnotationComposer get sourceId {
    final $$SourcesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceId,
      referencedTable: $db.sources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourcesTableAnnotationComposer(
            $db: $db,
            $table: $db.sources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> claimApplicationsRefs<T extends Object>(
    Expression<T> Function($$ClaimApplicationsTableAnnotationComposer a) f,
  ) {
    final $$ClaimApplicationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.claimApplications,
          getReferencedColumn: (t) => t.claimId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ClaimApplicationsTableAnnotationComposer(
                $db: $db,
                $table: $db.claimApplications,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ClaimsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ClaimsTable,
          Claim,
          $$ClaimsTableFilterComposer,
          $$ClaimsTableOrderingComposer,
          $$ClaimsTableAnnotationComposer,
          $$ClaimsTableCreateCompanionBuilder,
          $$ClaimsTableUpdateCompanionBuilder,
          (Claim, $$ClaimsTableReferences),
          Claim,
          PrefetchHooks Function({bool sourceId, bool claimApplicationsRefs})
        > {
  $$ClaimsTableTableManager(_$AppDatabase db, $ClaimsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClaimsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClaimsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClaimsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> subjectType = const Value.absent(),
                Value<String> subjectId = const Value.absent(),
                Value<String> property = const Value.absent(),
                Value<String> valueType = const Value.absent(),
                Value<String> valueJson = const Value.absent(),
                Value<int> payloadVersion = const Value.absent(),
                Value<String?> sourceId = const Value.absent(),
                Value<String?> sourceLocator = const Value.absent(),
                Value<double?> confidence = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> modifiedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ClaimsCompanion(
                id: id,
                subjectType: subjectType,
                subjectId: subjectId,
                property: property,
                valueType: valueType,
                valueJson: valueJson,
                payloadVersion: payloadVersion,
                sourceId: sourceId,
                sourceLocator: sourceLocator,
                confidence: confidence,
                status: status,
                createdAt: createdAt,
                modifiedAt: modifiedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String subjectType,
                required String subjectId,
                required String property,
                required String valueType,
                required String valueJson,
                Value<int> payloadVersion = const Value.absent(),
                Value<String?> sourceId = const Value.absent(),
                Value<String?> sourceLocator = const Value.absent(),
                Value<double?> confidence = const Value.absent(),
                required String status,
                required DateTime createdAt,
                required DateTime modifiedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ClaimsCompanion.insert(
                id: id,
                subjectType: subjectType,
                subjectId: subjectId,
                property: property,
                valueType: valueType,
                valueJson: valueJson,
                payloadVersion: payloadVersion,
                sourceId: sourceId,
                sourceLocator: sourceLocator,
                confidence: confidence,
                status: status,
                createdAt: createdAt,
                modifiedAt: modifiedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$ClaimsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({sourceId = false, claimApplicationsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (claimApplicationsRefs) db.claimApplications,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (sourceId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.sourceId,
                            referencedTable: $$ClaimsTableReferences
                                ._sourceIdTable(db),
                            referencedColumn: $$ClaimsTableReferences
                                ._sourceIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (claimApplicationsRefs)
                        await $_getPrefetchedData<
                          Claim,
                          $ClaimsTable,
                          ClaimApplication
                        >(
                          currentTable: table,
                          referencedTable: $$ClaimsTableReferences
                              ._claimApplicationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ClaimsTableReferences(
                                db,
                                table,
                                p0,
                              ).claimApplicationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.claimId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ClaimsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ClaimsTable,
      Claim,
      $$ClaimsTableFilterComposer,
      $$ClaimsTableOrderingComposer,
      $$ClaimsTableAnnotationComposer,
      $$ClaimsTableCreateCompanionBuilder,
      $$ClaimsTableUpdateCompanionBuilder,
      (Claim, $$ClaimsTableReferences),
      Claim,
      PrefetchHooks Function({bool sourceId, bool claimApplicationsRefs})
    >;
typedef $$ClaimApplicationsTableCreateCompanionBuilder =
    ClaimApplicationsCompanion Function({
      required String claimId,
      required String operationType,
      required String resultEntityType,
      required String resultEntityId,
      required DateTime appliedAt,
      required String payloadJson,
      Value<int> rowid,
    });
typedef $$ClaimApplicationsTableUpdateCompanionBuilder =
    ClaimApplicationsCompanion Function({
      Value<String> claimId,
      Value<String> operationType,
      Value<String> resultEntityType,
      Value<String> resultEntityId,
      Value<DateTime> appliedAt,
      Value<String> payloadJson,
      Value<int> rowid,
    });

final class $$ClaimApplicationsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ClaimApplicationsTable,
          ClaimApplication
        > {
  $$ClaimApplicationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ClaimsTable _claimIdTable(_$AppDatabase db) =>
      db.claims.createAlias('claim_applications__claim_id__claims__id');

  $$ClaimsTableProcessedTableManager get claimId {
    final $_column = $_itemColumn<String>('claim_id')!;

    final manager = $$ClaimsTableTableManager(
      $_db,
      $_db.claims,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_claimIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ClaimApplicationsTableFilterComposer
    extends Composer<_$AppDatabase, $ClaimApplicationsTable> {
  $$ClaimApplicationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get operationType => $composableBuilder(
    column: $table.operationType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get resultEntityType => $composableBuilder(
    column: $table.resultEntityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get resultEntityId => $composableBuilder(
    column: $table.resultEntityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get appliedAt => $composableBuilder(
    column: $table.appliedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  $$ClaimsTableFilterComposer get claimId {
    final $$ClaimsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.claimId,
      referencedTable: $db.claims,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClaimsTableFilterComposer(
            $db: $db,
            $table: $db.claims,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ClaimApplicationsTableOrderingComposer
    extends Composer<_$AppDatabase, $ClaimApplicationsTable> {
  $$ClaimApplicationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get operationType => $composableBuilder(
    column: $table.operationType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get resultEntityType => $composableBuilder(
    column: $table.resultEntityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get resultEntityId => $composableBuilder(
    column: $table.resultEntityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get appliedAt => $composableBuilder(
    column: $table.appliedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  $$ClaimsTableOrderingComposer get claimId {
    final $$ClaimsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.claimId,
      referencedTable: $db.claims,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClaimsTableOrderingComposer(
            $db: $db,
            $table: $db.claims,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ClaimApplicationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClaimApplicationsTable> {
  $$ClaimApplicationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get operationType => $composableBuilder(
    column: $table.operationType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get resultEntityType => $composableBuilder(
    column: $table.resultEntityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get resultEntityId => $composableBuilder(
    column: $table.resultEntityId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get appliedAt =>
      $composableBuilder(column: $table.appliedAt, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  $$ClaimsTableAnnotationComposer get claimId {
    final $$ClaimsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.claimId,
      referencedTable: $db.claims,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClaimsTableAnnotationComposer(
            $db: $db,
            $table: $db.claims,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ClaimApplicationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ClaimApplicationsTable,
          ClaimApplication,
          $$ClaimApplicationsTableFilterComposer,
          $$ClaimApplicationsTableOrderingComposer,
          $$ClaimApplicationsTableAnnotationComposer,
          $$ClaimApplicationsTableCreateCompanionBuilder,
          $$ClaimApplicationsTableUpdateCompanionBuilder,
          (ClaimApplication, $$ClaimApplicationsTableReferences),
          ClaimApplication,
          PrefetchHooks Function({bool claimId})
        > {
  $$ClaimApplicationsTableTableManager(
    _$AppDatabase db,
    $ClaimApplicationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClaimApplicationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClaimApplicationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClaimApplicationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> claimId = const Value.absent(),
                Value<String> operationType = const Value.absent(),
                Value<String> resultEntityType = const Value.absent(),
                Value<String> resultEntityId = const Value.absent(),
                Value<DateTime> appliedAt = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ClaimApplicationsCompanion(
                claimId: claimId,
                operationType: operationType,
                resultEntityType: resultEntityType,
                resultEntityId: resultEntityId,
                appliedAt: appliedAt,
                payloadJson: payloadJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String claimId,
                required String operationType,
                required String resultEntityType,
                required String resultEntityId,
                required DateTime appliedAt,
                required String payloadJson,
                Value<int> rowid = const Value.absent(),
              }) => ClaimApplicationsCompanion.insert(
                claimId: claimId,
                operationType: operationType,
                resultEntityType: resultEntityType,
                resultEntityId: resultEntityId,
                appliedAt: appliedAt,
                payloadJson: payloadJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ClaimApplicationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({claimId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (claimId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.claimId,
                        referencedTable: $$ClaimApplicationsTableReferences
                            ._claimIdTable(db),
                        referencedColumn: $$ClaimApplicationsTableReferences
                            ._claimIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ClaimApplicationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ClaimApplicationsTable,
      ClaimApplication,
      $$ClaimApplicationsTableFilterComposer,
      $$ClaimApplicationsTableOrderingComposer,
      $$ClaimApplicationsTableAnnotationComposer,
      $$ClaimApplicationsTableCreateCompanionBuilder,
      $$ClaimApplicationsTableUpdateCompanionBuilder,
      (ClaimApplication, $$ClaimApplicationsTableReferences),
      ClaimApplication,
      PrefetchHooks Function({bool claimId})
    >;
typedef $$DuplicateCandidatesTableCreateCompanionBuilder =
    DuplicateCandidatesCompanion Function({
      required String id,
      required String personAId,
      required String personBId,
      required int score,
      required String reasonCodesJson,
      required int detectorVersion,
      required String status,
      required DateTime lastEvaluatedAt,
      Value<DateTime?> resolvedAt,
      Value<String?> mergedIntoPersonId,
      required DateTime createdAt,
      required DateTime modifiedAt,
      Value<int> rowid,
    });
typedef $$DuplicateCandidatesTableUpdateCompanionBuilder =
    DuplicateCandidatesCompanion Function({
      Value<String> id,
      Value<String> personAId,
      Value<String> personBId,
      Value<int> score,
      Value<String> reasonCodesJson,
      Value<int> detectorVersion,
      Value<String> status,
      Value<DateTime> lastEvaluatedAt,
      Value<DateTime?> resolvedAt,
      Value<String?> mergedIntoPersonId,
      Value<DateTime> createdAt,
      Value<DateTime> modifiedAt,
      Value<int> rowid,
    });

final class $$DuplicateCandidatesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $DuplicateCandidatesTable,
          DuplicateCandidate
        > {
  $$DuplicateCandidatesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PersonsTable _personAIdTable(_$AppDatabase db) =>
      db.persons.createAlias('duplicate_candidates__person_a_id__persons__id');

  $$PersonsTableProcessedTableManager get personAId {
    final $_column = $_itemColumn<String>('person_a_id')!;

    final manager = $$PersonsTableTableManager(
      $_db,
      $_db.persons,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_personAIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PersonsTable _personBIdTable(_$AppDatabase db) =>
      db.persons.createAlias('duplicate_candidates__person_b_id__persons__id');

  $$PersonsTableProcessedTableManager get personBId {
    final $_column = $_itemColumn<String>('person_b_id')!;

    final manager = $$PersonsTableTableManager(
      $_db,
      $_db.persons,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_personBIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PersonsTable _mergedIntoPersonIdTable(_$AppDatabase db) => db.persons
      .createAlias('duplicate_candidates__merged_into_person_id__persons__id');

  $$PersonsTableProcessedTableManager? get mergedIntoPersonId {
    final $_column = $_itemColumn<String>('merged_into_person_id');
    if ($_column == null) return null;
    final manager = $$PersonsTableTableManager(
      $_db,
      $_db.persons,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mergedIntoPersonIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DuplicateCandidatesTableFilterComposer
    extends Composer<_$AppDatabase, $DuplicateCandidatesTable> {
  $$DuplicateCandidatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reasonCodesJson => $composableBuilder(
    column: $table.reasonCodesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get detectorVersion => $composableBuilder(
    column: $table.detectorVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastEvaluatedAt => $composableBuilder(
    column: $table.lastEvaluatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PersonsTableFilterComposer get personAId {
    final $$PersonsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personAId,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableFilterComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PersonsTableFilterComposer get personBId {
    final $$PersonsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personBId,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableFilterComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PersonsTableFilterComposer get mergedIntoPersonId {
    final $$PersonsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mergedIntoPersonId,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableFilterComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DuplicateCandidatesTableOrderingComposer
    extends Composer<_$AppDatabase, $DuplicateCandidatesTable> {
  $$DuplicateCandidatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reasonCodesJson => $composableBuilder(
    column: $table.reasonCodesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get detectorVersion => $composableBuilder(
    column: $table.detectorVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastEvaluatedAt => $composableBuilder(
    column: $table.lastEvaluatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PersonsTableOrderingComposer get personAId {
    final $$PersonsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personAId,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableOrderingComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PersonsTableOrderingComposer get personBId {
    final $$PersonsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personBId,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableOrderingComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PersonsTableOrderingComposer get mergedIntoPersonId {
    final $$PersonsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mergedIntoPersonId,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableOrderingComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DuplicateCandidatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DuplicateCandidatesTable> {
  $$DuplicateCandidatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<String> get reasonCodesJson => $composableBuilder(
    column: $table.reasonCodesJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get detectorVersion => $composableBuilder(
    column: $table.detectorVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get lastEvaluatedAt => $composableBuilder(
    column: $table.lastEvaluatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => column,
  );

  $$PersonsTableAnnotationComposer get personAId {
    final $$PersonsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personAId,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableAnnotationComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PersonsTableAnnotationComposer get personBId {
    final $$PersonsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personBId,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableAnnotationComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PersonsTableAnnotationComposer get mergedIntoPersonId {
    final $$PersonsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mergedIntoPersonId,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableAnnotationComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DuplicateCandidatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DuplicateCandidatesTable,
          DuplicateCandidate,
          $$DuplicateCandidatesTableFilterComposer,
          $$DuplicateCandidatesTableOrderingComposer,
          $$DuplicateCandidatesTableAnnotationComposer,
          $$DuplicateCandidatesTableCreateCompanionBuilder,
          $$DuplicateCandidatesTableUpdateCompanionBuilder,
          (DuplicateCandidate, $$DuplicateCandidatesTableReferences),
          DuplicateCandidate,
          PrefetchHooks Function({
            bool personAId,
            bool personBId,
            bool mergedIntoPersonId,
          })
        > {
  $$DuplicateCandidatesTableTableManager(
    _$AppDatabase db,
    $DuplicateCandidatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DuplicateCandidatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DuplicateCandidatesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DuplicateCandidatesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> personAId = const Value.absent(),
                Value<String> personBId = const Value.absent(),
                Value<int> score = const Value.absent(),
                Value<String> reasonCodesJson = const Value.absent(),
                Value<int> detectorVersion = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> lastEvaluatedAt = const Value.absent(),
                Value<DateTime?> resolvedAt = const Value.absent(),
                Value<String?> mergedIntoPersonId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> modifiedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DuplicateCandidatesCompanion(
                id: id,
                personAId: personAId,
                personBId: personBId,
                score: score,
                reasonCodesJson: reasonCodesJson,
                detectorVersion: detectorVersion,
                status: status,
                lastEvaluatedAt: lastEvaluatedAt,
                resolvedAt: resolvedAt,
                mergedIntoPersonId: mergedIntoPersonId,
                createdAt: createdAt,
                modifiedAt: modifiedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String personAId,
                required String personBId,
                required int score,
                required String reasonCodesJson,
                required int detectorVersion,
                required String status,
                required DateTime lastEvaluatedAt,
                Value<DateTime?> resolvedAt = const Value.absent(),
                Value<String?> mergedIntoPersonId = const Value.absent(),
                required DateTime createdAt,
                required DateTime modifiedAt,
                Value<int> rowid = const Value.absent(),
              }) => DuplicateCandidatesCompanion.insert(
                id: id,
                personAId: personAId,
                personBId: personBId,
                score: score,
                reasonCodesJson: reasonCodesJson,
                detectorVersion: detectorVersion,
                status: status,
                lastEvaluatedAt: lastEvaluatedAt,
                resolvedAt: resolvedAt,
                mergedIntoPersonId: mergedIntoPersonId,
                createdAt: createdAt,
                modifiedAt: modifiedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DuplicateCandidatesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                personAId = false,
                personBId = false,
                mergedIntoPersonId = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (personAId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.personAId,
                            referencedTable:
                                $$DuplicateCandidatesTableReferences
                                    ._personAIdTable(db),
                            referencedColumn:
                                $$DuplicateCandidatesTableReferences
                                    ._personAIdTable(db)
                                    .id,
                          ) as T;
                        }
                        if (personBId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.personBId,
                            referencedTable:
                                $$DuplicateCandidatesTableReferences
                                    ._personBIdTable(db),
                            referencedColumn:
                                $$DuplicateCandidatesTableReferences
                                    ._personBIdTable(db)
                                    .id,
                          ) as T;
                        }
                        if (mergedIntoPersonId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.mergedIntoPersonId,
                            referencedTable:
                                $$DuplicateCandidatesTableReferences
                                    ._mergedIntoPersonIdTable(db),
                            referencedColumn:
                                $$DuplicateCandidatesTableReferences
                                    ._mergedIntoPersonIdTable(db)
                                    .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$DuplicateCandidatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DuplicateCandidatesTable,
      DuplicateCandidate,
      $$DuplicateCandidatesTableFilterComposer,
      $$DuplicateCandidatesTableOrderingComposer,
      $$DuplicateCandidatesTableAnnotationComposer,
      $$DuplicateCandidatesTableCreateCompanionBuilder,
      $$DuplicateCandidatesTableUpdateCompanionBuilder,
      (DuplicateCandidate, $$DuplicateCandidatesTableReferences),
      DuplicateCandidate,
      PrefetchHooks Function({
        bool personAId,
        bool personBId,
        bool mergedIntoPersonId,
      })
    >;
typedef $$AuditEntriesTableCreateCompanionBuilder =
    AuditEntriesCompanion Function({
      required String id,
      required String type,
      required String origin,
      required DateTime occurredAt,
      Value<int> payloadVersion,
      required String payloadJson,
      Value<int> rowid,
    });
typedef $$AuditEntriesTableUpdateCompanionBuilder =
    AuditEntriesCompanion Function({
      Value<String> id,
      Value<String> type,
      Value<String> origin,
      Value<DateTime> occurredAt,
      Value<int> payloadVersion,
      Value<String> payloadJson,
      Value<int> rowid,
    });

final class $$AuditEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $AuditEntriesTable, AuditEntry> {
  $$AuditEntriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AuditTargetsTable, List<AuditTarget>>
  _auditTargetsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.auditTargets,
    aliasName: 'audit_entries__id__audit_targets__audit_entry_id',
  );

  $$AuditTargetsTableProcessedTableManager get auditTargetsRefs {
    final manager = $$AuditTargetsTableTableManager(
      $_db,
      $_db.auditTargets,
    ).filter((f) => f.auditEntryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_auditTargetsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AuditEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $AuditEntriesTable> {
  $$AuditEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get origin => $composableBuilder(
    column: $table.origin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get payloadVersion => $composableBuilder(
    column: $table.payloadVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> auditTargetsRefs(
    Expression<bool> Function($$AuditTargetsTableFilterComposer f) f,
  ) {
    final $$AuditTargetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.auditTargets,
      getReferencedColumn: (t) => t.auditEntryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AuditTargetsTableFilterComposer(
            $db: $db,
            $table: $db.auditTargets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AuditEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $AuditEntriesTable> {
  $$AuditEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get origin => $composableBuilder(
    column: $table.origin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get payloadVersion => $composableBuilder(
    column: $table.payloadVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AuditEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuditEntriesTable> {
  $$AuditEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get origin =>
      $composableBuilder(column: $table.origin, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get payloadVersion => $composableBuilder(
    column: $table.payloadVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  Expression<T> auditTargetsRefs<T extends Object>(
    Expression<T> Function($$AuditTargetsTableAnnotationComposer a) f,
  ) {
    final $$AuditTargetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.auditTargets,
      getReferencedColumn: (t) => t.auditEntryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AuditTargetsTableAnnotationComposer(
            $db: $db,
            $table: $db.auditTargets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AuditEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AuditEntriesTable,
          AuditEntry,
          $$AuditEntriesTableFilterComposer,
          $$AuditEntriesTableOrderingComposer,
          $$AuditEntriesTableAnnotationComposer,
          $$AuditEntriesTableCreateCompanionBuilder,
          $$AuditEntriesTableUpdateCompanionBuilder,
          (AuditEntry, $$AuditEntriesTableReferences),
          AuditEntry,
          PrefetchHooks Function({bool auditTargetsRefs})
        > {
  $$AuditEntriesTableTableManager(_$AppDatabase db, $AuditEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuditEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuditEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuditEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> origin = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<int> payloadVersion = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AuditEntriesCompanion(
                id: id,
                type: type,
                origin: origin,
                occurredAt: occurredAt,
                payloadVersion: payloadVersion,
                payloadJson: payloadJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String type,
                required String origin,
                required DateTime occurredAt,
                Value<int> payloadVersion = const Value.absent(),
                required String payloadJson,
                Value<int> rowid = const Value.absent(),
              }) => AuditEntriesCompanion.insert(
                id: id,
                type: type,
                origin: origin,
                occurredAt: occurredAt,
                payloadVersion: payloadVersion,
                payloadJson: payloadJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AuditEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({auditTargetsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (auditTargetsRefs) db.auditTargets],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (auditTargetsRefs)
                    await $_getPrefetchedData<
                      AuditEntry,
                      $AuditEntriesTable,
                      AuditTarget
                    >(
                      currentTable: table,
                      referencedTable: $$AuditEntriesTableReferences
                          ._auditTargetsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$AuditEntriesTableReferences(
                            db,
                            table,
                            p0,
                          ).auditTargetsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.auditEntryId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$AuditEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AuditEntriesTable,
      AuditEntry,
      $$AuditEntriesTableFilterComposer,
      $$AuditEntriesTableOrderingComposer,
      $$AuditEntriesTableAnnotationComposer,
      $$AuditEntriesTableCreateCompanionBuilder,
      $$AuditEntriesTableUpdateCompanionBuilder,
      (AuditEntry, $$AuditEntriesTableReferences),
      AuditEntry,
      PrefetchHooks Function({bool auditTargetsRefs})
    >;
typedef $$AuditTargetsTableCreateCompanionBuilder =
    AuditTargetsCompanion Function({
      Value<int> id,
      required String auditEntryId,
      required String entityType,
      required String entityId,
      required String role,
    });
typedef $$AuditTargetsTableUpdateCompanionBuilder =
    AuditTargetsCompanion Function({
      Value<int> id,
      Value<String> auditEntryId,
      Value<String> entityType,
      Value<String> entityId,
      Value<String> role,
    });

final class $$AuditTargetsTableReferences
    extends BaseReferences<_$AppDatabase, $AuditTargetsTable, AuditTarget> {
  $$AuditTargetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AuditEntriesTable _auditEntryIdTable(_$AppDatabase db) => db
      .auditEntries
      .createAlias('audit_targets__audit_entry_id__audit_entries__id');

  $$AuditEntriesTableProcessedTableManager get auditEntryId {
    final $_column = $_itemColumn<String>('audit_entry_id')!;

    final manager = $$AuditEntriesTableTableManager(
      $_db,
      $_db.auditEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_auditEntryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AuditTargetsTableFilterComposer
    extends Composer<_$AppDatabase, $AuditTargetsTable> {
  $$AuditTargetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  $$AuditEntriesTableFilterComposer get auditEntryId {
    final $$AuditEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.auditEntryId,
      referencedTable: $db.auditEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AuditEntriesTableFilterComposer(
            $db: $db,
            $table: $db.auditEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AuditTargetsTableOrderingComposer
    extends Composer<_$AppDatabase, $AuditTargetsTable> {
  $$AuditTargetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  $$AuditEntriesTableOrderingComposer get auditEntryId {
    final $$AuditEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.auditEntryId,
      referencedTable: $db.auditEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AuditEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.auditEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AuditTargetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuditTargetsTable> {
  $$AuditTargetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  $$AuditEntriesTableAnnotationComposer get auditEntryId {
    final $$AuditEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.auditEntryId,
      referencedTable: $db.auditEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AuditEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.auditEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AuditTargetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AuditTargetsTable,
          AuditTarget,
          $$AuditTargetsTableFilterComposer,
          $$AuditTargetsTableOrderingComposer,
          $$AuditTargetsTableAnnotationComposer,
          $$AuditTargetsTableCreateCompanionBuilder,
          $$AuditTargetsTableUpdateCompanionBuilder,
          (AuditTarget, $$AuditTargetsTableReferences),
          AuditTarget,
          PrefetchHooks Function({bool auditEntryId})
        > {
  $$AuditTargetsTableTableManager(_$AppDatabase db, $AuditTargetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuditTargetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuditTargetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuditTargetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> auditEntryId = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> role = const Value.absent(),
              }) => AuditTargetsCompanion(
                id: id,
                auditEntryId: auditEntryId,
                entityType: entityType,
                entityId: entityId,
                role: role,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String auditEntryId,
                required String entityType,
                required String entityId,
                required String role,
              }) => AuditTargetsCompanion.insert(
                id: id,
                auditEntryId: auditEntryId,
                entityType: entityType,
                entityId: entityId,
                role: role,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AuditTargetsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({auditEntryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (auditEntryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.auditEntryId,
                        referencedTable: $$AuditTargetsTableReferences
                            ._auditEntryIdTable(db),
                        referencedColumn: $$AuditTargetsTableReferences
                            ._auditEntryIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AuditTargetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AuditTargetsTable,
      AuditTarget,
      $$AuditTargetsTableFilterComposer,
      $$AuditTargetsTableOrderingComposer,
      $$AuditTargetsTableAnnotationComposer,
      $$AuditTargetsTableCreateCompanionBuilder,
      $$AuditTargetsTableUpdateCompanionBuilder,
      (AuditTarget, $$AuditTargetsTableReferences),
      AuditTarget,
      PrefetchHooks Function({bool auditEntryId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProjectsTableTableManager get projects =>
      $$ProjectsTableTableManager(_db, _db.projects);
  $$PersonsTableTableManager get persons =>
      $$PersonsTableTableManager(_db, _db.persons);
  $$PersonNamesTableTableManager get personNames =>
      $$PersonNamesTableTableManager(_db, _db.personNames);
  $$ParentChildRelationshipsTableTableManager get parentChildRelationships =>
      $$ParentChildRelationshipsTableTableManager(
        _db,
        _db.parentChildRelationships,
      );
  $$PlacesTableTableManager get places =>
      $$PlacesTableTableManager(_db, _db.places);
  $$PartnershipsTableTableManager get partnerships =>
      $$PartnershipsTableTableManager(_db, _db.partnerships);
  $$PlaceRelationshipsTableTableManager get placeRelationships =>
      $$PlaceRelationshipsTableTableManager(_db, _db.placeRelationships);
  $$ResidencesTableTableManager get residences =>
      $$ResidencesTableTableManager(_db, _db.residences);
  $$EventsTableTableManager get events =>
      $$EventsTableTableManager(_db, _db.events);
  $$EventParticipantsTableTableManager get eventParticipants =>
      $$EventParticipantsTableTableManager(_db, _db.eventParticipants);
  $$SourcesTableTableManager get sources =>
      $$SourcesTableTableManager(_db, _db.sources);
  $$MediaAssetsTableTableManager get mediaAssets =>
      $$MediaAssetsTableTableManager(_db, _db.mediaAssets);
  $$SourceMediaLinksTableTableManager get sourceMediaLinks =>
      $$SourceMediaLinksTableTableManager(_db, _db.sourceMediaLinks);
  $$ClaimsTableTableManager get claims =>
      $$ClaimsTableTableManager(_db, _db.claims);
  $$ClaimApplicationsTableTableManager get claimApplications =>
      $$ClaimApplicationsTableTableManager(_db, _db.claimApplications);
  $$DuplicateCandidatesTableTableManager get duplicateCandidates =>
      $$DuplicateCandidatesTableTableManager(_db, _db.duplicateCandidates);
  $$AuditEntriesTableTableManager get auditEntries =>
      $$AuditEntriesTableTableManager(_db, _db.auditEntries);
  $$AuditTargetsTableTableManager get auditTargets =>
      $$AuditTargetsTableTableManager(_db, _db.auditTargets);
}
