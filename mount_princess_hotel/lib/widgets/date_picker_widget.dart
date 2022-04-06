import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerWidget extends StatefulWidget {
  final String status;
  final String dateType;
  DatePickerWidget({Key? key, required this.status, required this.dateType})
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

class SendDatePickerDataProvider extends ChangeNotifier {
  final String? checkInDate;
  final String? checkOutDate;
  late bool _checkInHasData = false;
  late bool _checkOutHasData = false;

  SendDatePickerDataProvider({this.checkInDate, this.checkOutDate});

  void checkDateAndSend() {
    // if (_date != null && _date != "") {
    //   _hasData = true;
    // }
    if (checkInDate != null &&
        checkInDate != "" &&
        checkOutDate == null &&
        checkOutDate == "") {
      _checkInHasData = true;
    } else if (checkOutDate != null &&
        checkOutDate != "" &&
        checkInDate == null &&
        checkInDate == "") {
      _checkOutHasData = true;
    }

    //Call this whenever there is some change in any field of change notifier.
    notifyListeners();
  }

  // Getter for check-in date
  String? get providerCheckInDate => checkInDate;

  // Getter for check-out date
  String? get providerCheckOutDate => checkOutDate;

  // Getter for check-in flag
  bool get checkInHasData => _checkInHasData;

  // Getter for check-in flag
  bool get checkOutHasData => _checkOutHasData;
}
