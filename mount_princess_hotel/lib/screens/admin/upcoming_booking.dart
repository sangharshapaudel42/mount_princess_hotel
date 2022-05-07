import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mount_princess_hotel/screens/admin/widgets/upcoming_booking_widget.dart';
import 'package:mount_princess_hotel/widgets/refresh_widget.dart';

import '../../utils/colors.dart';

class UpcomingBooking extends StatefulWidget {
  const UpcomingBooking({Key? key}) : super(key: key);

  @override
  State<UpcomingBooking> createState() => _UpcomingBookingState();
}

class _UpcomingBookingState extends State<UpcomingBooking> {
  late Future resultsLoaded;
  // all booking datas after today
  List? _allResultsAfterToday;
  List _weekDates = [];
  // this list items are in form "mm-dd-yyyy"
  // which is then compared with "bookingDateString" from database
  List _weekDatesEasy = [];

  @override
  void initState() {
    super.initState();
    _weekDates = getWeekDate();
    resultsLoaded = getBookingStreamSnapshots();
  }

  // get next week dates from today and store that in string list.
  // And, store in "_weekDates".
  List<String> getWeekDate() {
    List<String> weeksDates = [];

    for (int i = 0; i < 7; i++) {
      DateTime weekDates = DateTime.now().add(Duration(days: i));
      String weekStringDates = DateFormat.yMMMMEEEEd().format(weekDates);
      String weekDatesStringEasy = DateFormat('MM-dd-yyyy').format(weekDates);
      setState(() {
        _weekDatesEasy.add(weekDatesStringEasy);
      });
      weeksDates.add(weekStringDates);
    }
    return weeksDates;
  }

  // get all the Booking info of all users. (TODAY onwards)
  Future getBookingStreamSnapshots() async {
    var data = await FirebaseFirestore.instance
        .collection('Booking')
        .where("checkIn",
            isGreaterThanOrEqualTo:
                DateTime.now().subtract(const Duration(days: 1)))
        .get();
    setState(() {
      _allResultsAfterToday = data.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upcoming Bookings"),
        centerTitle: true,
        backgroundColor: backgroundColor,
      ),
      body: RefreshWidget(
          onRefresh: getBookingStreamSnapshots,
          child: _allResultsAfterToday != null
              ? buildUpcomingBookingsWidget(
                  context, _weekDates, _allResultsAfterToday!, _weekDatesEasy)
              : const SizedBox(height: 0)),
    );
  }
}
