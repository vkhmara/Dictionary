import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class DatePicker extends StatelessWidget {
  const DatePicker(
      {Key key,
        this.labelText,
        this.selectedDate,
        this.selectDate,
      })
      : super(key: key);

  final String labelText;
  final DateTime selectedDate;
  final ValueChanged<DateTime> selectDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2021),
        lastDate: DateTime(2101));
    if (picked != null) selectDate(picked);
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.bodyText2;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _InputDropdown(
              labelText: labelText,
              valueText: DateFormat.yMMMd().format(selectedDate),
              valueStyle: valueStyle,
              onPressed: () {
                _selectDate(context);
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _InputDropdown extends StatelessWidget {
  const _InputDropdown(
      {Key key,
        this.child,
        this.labelText,
        this.valueText,
        this.valueStyle,
        this.onPressed})
      : super(key: key);

  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: InputDecorator(
        decoration: InputDecoration(
            labelText: labelText,
            labelStyle: TextStyle(
                fontSize: 24,
                color: Colors.blueAccent
            )
        ),
        baseStyle: valueStyle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              valueText,
              style: valueStyle,
            ),
            Icon(Icons.arrow_drop_down,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade700
                    : Colors.white70),
          ],
        ),
      ),
    );
  }
}
