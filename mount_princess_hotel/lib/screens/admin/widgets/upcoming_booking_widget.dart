import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mount_princess_hotel/screens/admin/widgets/booking_indiviusal_card.dart';

Widget buildUpcomingBookingsWidget(BuildContext context, List _weekDates,
    List _allResults, List _weekDatesEasy) {
  var size = MediaQuery.of(context).size;

  String todayDate = DateFormat.yMMMMEEEEd().format(DateTime.now());
  String tomorrowDate = DateFormat.yMMMMEEEEd()
      .format(DateTime.now().add(const Duration(days: 1)));

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
    color: Colors.grey[100],

    // if there is upcoming booking.
    child: _allResults.isNotEmpty
        ? ListView.builder(
            itemCount: _weekDates.length,
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            itemBuilder: (context, index) {
              // removing redundant results with same checkInString
              List _noRedentResults = [];

              // check if the new result has same checInString date as that in list
              // if yes then do nothing else add that to the list.
              for (int i = 0; i < _allResults.length; i++) {
                if (_allResults[i]["checkInString"] == _weekDatesEasy[index] &&
                    _allResults[i]["bookingCancel"] == false &&
                    _noRedentResults
                            .contains(_allResults[i]["checkInString"]) ==
                        false) {
                  _noRedentResults.add(_allResults[i]["checkInString"]);
                }
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // show this if there is booking on that perticular day.
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _noRedentResults.length,
                    itemBuilder: (context, i) {
                      if (_noRedentResults[i] == _weekDatesEasy[index]) {
                        // date
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 8, bottom: 5.0, top: 10),
                          child: Text(
                            _weekDates[index] == todayDate
                                ? "Today"
                                : _weekDates[index] == tomorrowDate
                                    ? "Tomorrow"
                                    : _weekDates[index],
                            style: const TextStyle(
                              color: Color(0xff0b29d6),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox(height: 0);
                      }
                    },
                  ),
                  // booking card
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _allResults.length,
                    itemBuilder: (context, i) {
                      List _resultsList = [];

                      if (_allResults[i]["checkInString"] ==
                              _weekDatesEasy[index] &&
                          _allResults[i]["bookingCancel"] == false) {
                        _resultsList.add(_allResults[i]);
                        return _resultsList.isNotEmpty
                            // if any booking on that day
                            ? ListView.builder(
                                shrinkWrap: true,
                                itemCount: _resultsList.length,
                                itemBuilder:
                                    (BuildContext context, int index) =>
                                        buildBookingInfoCard(
                                            context, _resultsList[index]))
                            : const SizedBox(height: 0);
                      } else {
                        return const SizedBox(height: 0);
                      }
                    },
                  )
                ],
              );
            },
          )
        // if there is no upcoming bookings
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cancel_outlined,
                  size: MediaQuery.of(context).size.height / 6,
                  color: Colors.grey[600],
                ),
                SizedBox(height: MediaQuery.of(context).size.width / 23),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 25,
                      ),
                      children: const <TextSpan>[
                        TextSpan(
                          text: "No upcoming bookings.",
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                      ]),
                ),
              ],
            ),
          ),
  );
}
