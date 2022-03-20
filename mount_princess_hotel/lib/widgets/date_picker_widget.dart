import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerWidget extends StatefulWidget {
  final String status;
  const DatePickerWidget({Key? key, required this.status}) : super(key: key);

  @override
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  DateTime? _date;

  String getText() {
    if (_date == null) {
      return widget.status;
    } else {
      print(_date);
      return DateFormat('MM/dd/yyyy').format(_date!);
      // return '${_date.month}/${_date.day}/${_date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
        primary: Colors.white,
      ),
      child: FittedBox(
        child: Text(
          getText(),
          style: TextStyle(fontSize: 25, color: Colors.grey[600]),
        ),
      ),
      onPressed: () => pickDate(context),
    );
  }

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: _date ?? initialDate,
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (newDate == null) return;

    setState(() => _date = newDate);
  }
}
