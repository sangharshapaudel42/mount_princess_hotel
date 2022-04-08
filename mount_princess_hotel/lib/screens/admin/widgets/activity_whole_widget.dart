import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mount_princess_hotel/screens/admin/widgets/activity_booking_cancel_widget.dart';
import 'package:mount_princess_hotel/screens/admin/widgets/activity_daily_report_widget.dart';
import 'package:mount_princess_hotel/screens/admin/widgets/activity_new_booking_widget.dart';

Widget buildBookingActivityWidget(BuildContext context, List _weekDates,
    List _allResults, List _weekDatesEasy) {
  String todayDate = DateFormat.yMMMMEEEEd().format(DateTime.now());
  String yesterdayDate = DateFormat.yMMMMEEEEd()
      .format(DateTime.now().subtract(const Duration(days: 1)));

  return ListView.builder(
    itemCount: _weekDates.length,
    physics:
        const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
    itemBuilder: (context, index) {
      return Container(
        color: Colors.grey[100],
        child: Container(
            margin: const EdgeInsets.only(bottom: 5),
            padding:
                const EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 5),
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
                _allResults.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _allResults.length,
                        itemBuilder: (context, i) {
                          List newBookingDatas = [];
                          List bookingCancelDatas = [];

                          // new booking
                          // for new booking date must be equal and "bookingCancel" must be false.
                          if (_allResults[i]["bookingDateString"] ==
                                  _weekDatesEasy[index] &&
                              _allResults[i]["bookingCancel"] == false) {
                            newBookingDatas.add(_allResults[i]);
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: newBookingDatas.length,
                              itemBuilder: (context, newBookingIndex) {
                                return buildNewBookingWidget(
                                    context, newBookingDatas[newBookingIndex]);
                              },
                            );

                            // booking cancel
                          } else if (_allResults[i]["bookingDateString"] ==
                                  _weekDatesEasy[index] &&
                              _allResults[i]["bookingCancel"] == true) {
                            bookingCancelDatas.add(_allResults[i]);
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: bookingCancelDatas.length,
                              itemBuilder: (context, bookingCancelIndex) {
                                return buildBookingCancelWidget(context,
                                    bookingCancelDatas[bookingCancelIndex]);
                              },
                            );
                            // in case on that day there was neither new booking nor booking cancel
                          } else {
                            return const SizedBox();
                          }
                        })
                    : const SizedBox(height: 0),
                // daily report
                _allResults.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 1,
                        itemBuilder: (context, cancelBookingIndex) {
                          List checkInNumbers = [];
                          List checkOutNumbers = [];

                          for (int i = 0; i < _allResults.length; i++) {
                            if (_allResults[i]["checkInString"] ==
                                    _weekDatesEasy[index] &&
                                _allResults[i]["bookingCancel"] == false) {
                              checkInNumbers.add(_allResults[i]);
                            } else if (_allResults[i]["checkOutString"] ==
                                    _weekDatesEasy[index] &&
                                _allResults[i]["bookingCancel"] == false) {
                              checkOutNumbers.add(_allResults[i]);
                            }
                          }
                          return buildDailyReportWidget(context,
                              checkInNumbers.length, checkOutNumbers.length);
                        })
                    : buildDailyReportWidget(context, 0, 0),
              ],
            )),
      );
    },
  );
}
