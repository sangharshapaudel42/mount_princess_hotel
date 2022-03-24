import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:mount_princess_hotel/models/booking_data_from_widget.dart'
    as model;

import '../models/booking_data_from_widget.dart';

class DatePickerWidget extends StatefulWidget {
  final String status;
  final String dateType;
  const DatePickerWidget(
      {Key? key, required this.status, required this.dateType})
      : super(key: key);

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
      if (widget.dateType == "check-in") {
        // } else if (widget.dateType == "check-out") {
        //   model.DataBookingWidget _data =
        //       model.DataBookingWidget(checkOut: _date.toString());
      }
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
      // firstDate: DateTime(DateTime.now().year),
      firstDate: initialDate,
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (newDate == null) return;

    setState(() => _date = newDate);
  }
}
