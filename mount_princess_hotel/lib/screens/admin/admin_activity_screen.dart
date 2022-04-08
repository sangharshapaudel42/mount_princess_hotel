import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mount_princess_hotel/screens/admin/widgets/activity_booking_cancel_widget.dart';
import 'package:mount_princess_hotel/screens/admin/widgets/activity_daily_report_widget.dart';
import 'package:mount_princess_hotel/screens/admin/widgets/activity_new_booking_widget.dart';
import 'package:mount_princess_hotel/widgets/admin_navigation_drawer_widget.dart';

import '../../utils/colors.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({Key? key}) : super(key: key);

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  List _weekDates = [];
  // this list items are in form "mm-dd-yyyy"
  // which is then compared with "bookingDateString" from database
  List _weekDatesEasy = [];

  @override
  void initState() {
    super.initState();
    _weekDates = getWeekDate();
  }

  // get past week dates and store that in string list.
  // And, store in "_weekDates".
  List<String> getWeekDate() {
    List<String> weeksDates = [];

    for (int i = 0; i < 7; i++) {
      DateTime weekDates = DateTime.now().subtract(Duration(days: i));
      String weekStringDates = DateFormat.yMMMMEEEEd().format(weekDates);
      String weekDatesStringEasy = DateFormat('MM-dd-yyyy').format(weekDates);
      setState(() {
        _weekDatesEasy.add(weekDatesStringEasy);
      });
      weeksDates.add(weekStringDates);
    }
    return weeksDates;
  }

  @override
  Widget build(BuildContext context) {
    String todayDate = DateFormat.yMMMMEEEEd().format(DateTime.now());
    String yesterdayDate = DateFormat.yMMMMEEEEd()
        .format(DateTime.now().subtract(const Duration(days: 1)));

    return Scaffold(
        drawer: const AdminNavigationDrawerWidget(),
        appBar: AppBar(
          backgroundColor: backgroundColor,
          title: const Text('Activity'),
          centerTitle: true,
        ),
        body: _weekDatesEasy.isNotEmpty
            ? ListView.builder(
                itemCount: _weekDatesEasy.length,
                itemBuilder: ((context, index) {
                  return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Booking')
                        .where("bookingDateString",
                            isEqualTo: _weekDatesEasy[index])
                        .where("bookingCancel", isEqualTo: false)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      List<QueryDocumentSnapshot> docs =
                          (snapshot.data! as QuerySnapshot).docs;

                      return Container(
                        color: Colors.grey[100],
                        child: Container(
                            margin: const EdgeInsets.only(bottom: 5),
                            padding: const EdgeInsets.only(
                                right: 10, left: 10, top: 10, bottom: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5.0),
                                  child: Text(
                                    _weekDates[index] == todayDate
                                        ? "Today"
                                        : _weekDates[index] == yesterdayDate
                                            ? "Yesterday"
                                            : _weekDates[index],
                                    style: const TextStyle(
                                      color: Color(0xff0b29d6),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                // new booking
                                docs.isNotEmpty
                                    ? ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: docs.length,
                                        itemBuilder: (context, index) {
                                          return buildNewBookingWidget(
                                            context,
                                            docs[index],
                                          );
                                        })
                                    : const SizedBox(height: 0),
                                // booking cancel
                                bookingCancelWidget(_weekDatesEasy[index]),
                                // daily report
                                dailyReportWidget(_weekDatesEasy[index]),
                              ],
                            )),
                      );
                    },
                  );
                }),
              )
            : const Text("error"));
  }

  // if there is any booking cancel on that day.
  Widget bookingCancelWidget(String weekdate) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Booking')
          .where("bookingDateString", isEqualTo: weekdate)
          .where("bookingCancel", isEqualTo: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        List<QueryDocumentSnapshot> datas =
            (snapshot.data! as QuerySnapshot).docs;

        return datas.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: datas.length,
                itemBuilder: (context, index) {
                  return buildBookingCancelWidget(context, datas[index]);
                })
            : const SizedBox(height: 0);
      },
    );
  }

  // daily report widget
  Widget dailyReportWidget(String weekDate) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Booking')
          .where("bookingCancel", isEqualTo: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        List<QueryDocumentSnapshot> datas =
            (snapshot.data! as QuerySnapshot).docs;

        // ids of those items which has either checkIn or checkOut on "weekdate"
        List checkInIds = [];
        List checkOutIds = [];

        datas.forEach((item) {
          // comparing checkInString from database with "weekDate".
          if (item["checkInString"] == weekDate) {
            checkInIds.add(item.id);
          }

          if (item["checkOutString"] == weekDate) {
            checkOutIds.add(item.id);
          }
        });

        return datas.isNotEmpty
            ? buildDailyReportWidget(
                context, checkInIds.length, checkOutIds.length)
            : const SizedBox(height: 0);
      },
    );
  }
}
