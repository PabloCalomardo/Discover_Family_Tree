import 'package:family_history/core/dates/historical_date.dart';
import 'package:flutter/material.dart';

class HistoricalDateField extends StatefulWidget {
  const HistoricalDateField({
    required this.label,
    this.initialValue,
    super.key,
  });

  final String label;
  final HistoricalDate? initialValue;

  @override
  State<HistoricalDateField> createState() => HistoricalDateFieldState();
}

class HistoricalDateFieldState extends State<HistoricalDateField> {
  HistoricalDatePrecision? _precision;
  late final TextEditingController _year;
  late final TextEditingController _month;
  late final TextEditingController _day;
  late final TextEditingController _endYear;
  late final TextEditingController _displayText;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialValue;
    _precision = initial?.precision;
    _year = TextEditingController(
      text:
          initial?.startDate?.year.toString() ??
          initial?.endDate?.year.toString() ??
          '',
    );
    _month = TextEditingController(
      text: initial?.startDate?.month.toString() ?? '',
    );
    _day = TextEditingController(
      text: initial?.startDate?.day.toString() ?? '',
    );
    _endYear = TextEditingController(
      text: initial?.precision == HistoricalDatePrecision.range
          ? initial?.endDate?.year.toString() ?? ''
          : '',
    );
    _displayText = TextEditingController(text: initial?.displayText ?? '');
  }

  @override
  void dispose() {
    _year.dispose();
    _month.dispose();
    _day.dispose();
    _endYear.dispose();
    _displayText.dispose();
    super.dispose();
  }

  HistoricalDate? buildValue() {
    final precision = _precision;
    if (precision == null) return null;
    final display = _displayText.text.trim();
    final displayText = display.isEmpty ? null : display;
    final year = int.tryParse(_year.text);

    return switch (precision) {
      HistoricalDatePrecision.exactDay => HistoricalDate.exactDay(
        year!,
        int.parse(_month.text),
        int.parse(_day.text),
        displayText: displayText,
      ),
      HistoricalDatePrecision.month => HistoricalDate.month(
        year!,
        int.parse(_month.text),
        displayText: displayText,
      ),
      HistoricalDatePrecision.year => HistoricalDate.year(
        year!,
        displayText: displayText,
      ),
      HistoricalDatePrecision.range => HistoricalDate.range(
        DateTime.utc(year!),
        DateTime.utc(int.parse(_endYear.text), 12, 31),
        displayText: displayText,
      ),
      HistoricalDatePrecision.approximate => HistoricalDate.approximate(
        DateTime.utc(year!),
        displayText: displayText,
      ),
      HistoricalDatePrecision.before => HistoricalDate.before(
        DateTime.utc(year!),
        displayText: displayText,
      ),
      HistoricalDatePrecision.after => HistoricalDate.after(
        DateTime.utc(year!),
        displayText: displayText,
      ),
      HistoricalDatePrecision.unknown => HistoricalDate.unknown(
        displayText: displayText,
      ),
    };
  }

  String? _requiredNumber(String? value) =>
      int.tryParse(value ?? '') == null ? 'Introdueix un número vàlid.' : null;

  @override
  Widget build(BuildContext context) {
    final needsYear =
        _precision != null && _precision != HistoricalDatePrecision.unknown;
    final needsMonth =
        _precision == HistoricalDatePrecision.exactDay ||
        _precision == HistoricalDatePrecision.month;
    final needsDay = _precision == HistoricalDatePrecision.exactDay;
    final needsEndYear = _precision == HistoricalDatePrecision.range;

    return InputDecorator(
      decoration: InputDecoration(labelText: widget.label),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<HistoricalDatePrecision?>(
            initialValue: _precision,
            decoration: const InputDecoration(labelText: 'Precisió'),
            items: [
              const DropdownMenuItem(value: null, child: Text('No indicada')),
              ...HistoricalDatePrecision.values.map(
                (precision) => DropdownMenuItem(
                  value: precision,
                  child: Text(historicalDatePrecisionLabel(precision)),
                ),
              ),
            ],
            onChanged: (value) => setState(() => _precision = value),
          ),
          if (needsYear || needsMonth || needsDay || needsEndYear) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                if (needsYear)
                  SizedBox(
                    width: 130,
                    child: TextFormField(
                      controller: _year,
                      decoration: const InputDecoration(labelText: 'Any'),
                      validator: _requiredNumber,
                    ),
                  ),
                if (needsMonth)
                  SizedBox(
                    width: 130,
                    child: TextFormField(
                      controller: _month,
                      decoration: const InputDecoration(labelText: 'Mes'),
                      validator: _requiredNumber,
                    ),
                  ),
                if (needsDay)
                  SizedBox(
                    width: 130,
                    child: TextFormField(
                      controller: _day,
                      decoration: const InputDecoration(labelText: 'Dia'),
                      validator: _requiredNumber,
                    ),
                  ),
                if (needsEndYear)
                  SizedBox(
                    width: 160,
                    child: TextFormField(
                      controller: _endYear,
                      decoration: const InputDecoration(labelText: 'Any final'),
                      validator: _requiredNumber,
                    ),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 12),
          TextFormField(
            controller: _displayText,
            decoration: const InputDecoration(
              labelText: 'Text de presentació opcional',
            ),
          ),
        ],
      ),
    );
  }
}

String historicalDatePrecisionLabel(HistoricalDatePrecision precision) =>
    switch (precision) {
      HistoricalDatePrecision.exactDay => 'Dia exacte',
      HistoricalDatePrecision.month => 'Mes',
      HistoricalDatePrecision.year => 'Any',
      HistoricalDatePrecision.range => 'Rang',
      HistoricalDatePrecision.approximate => 'Aproximada',
      HistoricalDatePrecision.before => 'Abans de',
      HistoricalDatePrecision.after => 'Després de',
      HistoricalDatePrecision.unknown => 'Desconeguda',
    };

String historicalDateLabel(HistoricalDate? date) {
  if (date == null) return 'No indicada';
  if (date.displayText case final text?) return text;
  final start = date.startDate;
  final end = date.endDate;
  return switch (date.precision) {
    HistoricalDatePrecision.exactDay =>
      '${start!.day.toString().padLeft(2, '0')}/'
          '${start.month.toString().padLeft(2, '0')}/${start.year}',
    HistoricalDatePrecision.month => '${start!.month}/${start.year}',
    HistoricalDatePrecision.year => '${start!.year}',
    HistoricalDatePrecision.range => '${start!.year}–${end!.year}',
    HistoricalDatePrecision.approximate => 'cap al ${start!.year}',
    HistoricalDatePrecision.before => 'abans de ${end!.year}',
    HistoricalDatePrecision.after => 'després de ${start!.year}',
    HistoricalDatePrecision.unknown => 'Desconeguda',
  };
}
