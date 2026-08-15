String enumToSql(Enum value) {
  final name = value.name;
  final buffer = StringBuffer();
  for (var index = 0; index < name.length; index++) {
    final character = name[index];
    final isUppercase =
        character.toUpperCase() == character &&
        character.toLowerCase() != character;
    if (isUppercase && index > 0) buffer.write('_');
    buffer.write(character.toUpperCase());
  }
  return buffer.toString();
}

T enumFromSql<T extends Enum>(Iterable<T> values, String stored) {
  return values.firstWhere(
    (value) => enumToSql(value) == stored,
    orElse: () => throw FormatException('Unknown $T database value: $stored'),
  );
}
