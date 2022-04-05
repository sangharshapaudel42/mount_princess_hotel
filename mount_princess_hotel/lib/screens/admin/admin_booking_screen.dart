import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mount_princess_hotel/screens/admin/widgets/arrival_departure_button_widget.dart';
import 'package:mount_princess_hotel/screens/admin/widgets/booking_indiviusal_card.dart';
import 'package:mount_princess_hotel/widgets/text_field_input.dart';

import '../../utils/colors.dart';
import '../../widgets/admin_navigation_drawer_widget.dart';

class AdminBookingPage extends StatefulWidget {
  const AdminBookingPage({Key? key}) : super(key: key);

  @override
  State<AdminBookingPage> createState() => _AdminBookingPageState();
}

class _AdminBookingPageState extends State<AdminBookingPage> {
  late Future resultsLoaded;
  List _allResults = [];
  List _resultsList = [];
  List _departureList = [];
  String _chooseDate = "";
  bool _departureInfo = false;

  // this list is used to see all the arrivals on that day
  List numberOfArrivals = [];

  // this list is used to see all the Departures on that day
  List numberOfDepartures = [];

  int totalNumberOfArrivals = 0;
  int totalNumberOfDepartures = 0;

  @override
  void initState() {
    super.initState();
    resultsLoaded = getUsersPastTripsStreamSnapshots();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   resultsLoaded = getUsersPastTripsStreamSnapshots();
  // }

  // number of arivals and departures on current or choosen dates
  numberOfArivalsDepartures() {
    for (var bookingInfoSnapshot in _allResults) {
      // get the checkIn date
      Timestamp timestampCheckIn = bookingInfoSnapshot['checkIn'];
      DateTime dateTimeCheckIn = timestampCheckIn.toDate();
      String checkInDate =
          DateFormat('MM-dd-yyyy').format(dateTimeCheckIn).toString();

      // get the checkOut date
      Timestamp timestampCheckOut = bookingInfoSnapshot['checkOut'];
      DateTime dateTimeCheckOut = timestampCheckOut.toDate();
      String checkOutDate =
          DateFormat('MM-dd-yyyy').format(dateTimeCheckOut).toString();

      // for a today's day
      if (_chooseDate == "") {
        String _todayDate = DateFormat('MM-dd-yyyy').format(DateTime.now());

        // if either arrivals or departuers are present on today's day.
        if (checkInDate.contains(_todayDate) ||
            checkOutDate.contains(_todayDate)) {
          // for today's arrivals
          if (checkInDate.contains(_todayDate)) {
            // add arrivals to numberOfArrivals list
            numberOfArrivals.add(bookingInfoSnapshot);
            setState(() {
              // change the count to the list size
              totalNumberOfArrivals = numberOfArrivals.length;
            });

            // for today's departures
          } else if (checkOutDate.contains(_todayDate)) {
            // add departures to numberOfDepartures list
            numberOfDepartures.add(bookingInfoSnapshot);
            setState(() {
              // change the count to the list size
              totalNumberOfDepartures = numberOfDepartures.length;
            });
          }
        }

        // for choosen day
      } else {
        // if choosen day has either arrivals or departues
        if (checkInDate.contains(_chooseDate) ||
            checkOutDate.contains(_chooseDate)) {
          // if choosen day has any arrivals
          if (checkInDate.contains(_chooseDate)) {
            numberOfArrivals.add(bookingInfoSnapshot);
            setState(() {
              totalNumberOfArrivals = numberOfArrivals.toSet().length;
            });
          } else if (checkOutDate.contains(_chooseDate)) {
            numberOfDepartures.add(bookingInfoSnapshot);
            setState(() {
              totalNumberOfDepartures = numberOfDepartures.toSet().length;
            });
          }
        }
      }
    }
  }

  // this function is responsible for changing booking info results
  searchResultsList() {
    // date-picker results will be stored here
    var showResults = [];

    for (var bookingInfoSnapshot in _allResults) {
      // check in date
      Timestamp timestampCheckIn = bookingInfoSnapshot['checkIn'];
      DateTime dateTimeCheckIn = timestampCheckIn.toDate();
      String checkInDate =
          DateFormat('MM-dd-yyyy').format(dateTimeCheckIn).toString();

      // check-out date
      Timestamp timestampCheckOut = bookingInfoSnapshot['checkOut'];
      DateTime dateTimeCheckOut = timestampCheckOut.toDate();
      String checkOutDate =
          DateFormat('MM-dd-yyyy').format(dateTimeCheckOut).toString();

      // today's date
      String _todayDate = DateFormat('MM-dd-yyyy').format(DateTime.now());

      // if date is choose
      // display the today's arrival info
      if (_chooseDate == "" && _departureInfo == false) {
        if (checkInDate.contains(_todayDate)) {
          showResults.add(bookingInfoSnapshot);
        }
        // arrival's info according to user's choice date.
      } else if (_chooseDate != "" && _departureInfo == false) {
        if (checkInDate.contains(_chooseDate)) {
          showResults.add(bookingInfoSnapshot);
        }
        // display the today's departure's info
      } else if (_departureInfo == true && _chooseDate == "") {
        if (checkOutDate.contains(_todayDate)) {
          showResults.add(bookingInfoSnapshot);
        }
        // departure's info according to user's choice date.
      } else if (_departureInfo == true && _chooseDate != "") {
        if (checkOutDate.contains(_chooseDate)) {
          showResults.add(bookingInfoSnapshot);
        }
        // if nothing is choose then all the results will be displayed.
      } else {
        showResults = List.from(_allResults);
      }
    }
    setState(() {
      // arrivals info
      if (_departureInfo == false) {
        _resultsList = showResults;
        // departures info
      } else {
        _departureList = showResults;
      }
    });
  }

  // get all the Booking info of all users.
  getUsersPastTripsStreamSnapshots() async {
    var data = await FirebaseFirestore.instance.collection('Booking').get();
    setState(() {
      _allResults = data.docs;
    });
    numberOfArivalsDepartures();
    searchResultsList();
    return "complete";
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: const AdminNavigationDrawerWidget(),
        appBar: AppBar(
          backgroundColor: backgroundColor,
          title: const Text('Bookings'),
          centerTitle: true,
          // search all the guests
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: MySearchDelegate(allresults: _allResults),
                );
              },
            )
          ],
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.grey[100],
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // date picker
                SizedBox(
                  height: MediaQuery.of(context).size.height / 3,
                  child: CupertinoDatePicker(
                    dateOrder: DatePickerDateOrder.ymd,
                    initialDateTime: DateTime.now(),
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (DateTime value) {
                      setState(() {
                        // converting the choose date to string
                        _chooseDate = DateFormat('MM-dd-yyyy').format(value);

                        // change to false because once we change the date first we
                        // want to see arrival date.
                        _departureInfo = false;

                        // reseting all the values to null.
                        // So the previous day's result would not affect the current
                        // choosen day.
                        numberOfArrivals = [];
                        numberOfDepartures = [];
                        totalNumberOfArrivals = 0;
                        totalNumberOfDepartures = 0;

                        // calling numberOfArivalsDepartures() so that we could
                        // display number of arrivals and departues on that day.
                        numberOfArivalsDepartures();

                        // calling seachResultsList() so that we could display
                        // bookingInfo of disered date.
                        searchResultsList();
                      });
                    },
                  ),
                ),
                // when there is no arrivals and no departures
                numberOfArrivals.isEmpty && numberOfDepartures.isEmpty
                    // if there is no booking in that day
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: MediaQuery.of(context).size.height / 8),
                          Text(
                            "No guests arriving or departing this day",
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey[800]),
                          ),
                          const SizedBox(height: 20),
                          const InkWell(
                            onTap: null,
                            child: Text(
                              "VIEW UPCOMING BOOKINGS",
                              style: TextStyle(
                                  fontSize: 22,
                                  color: Color.fromARGB(189, 15, 138, 239)),
                            ),
                          ),
                        ],
                      )
                    // if there is arrival and departure on that day
                    : Container(
                        height: MediaQuery.of(context).size.height / 2.2229,
                        margin: const EdgeInsets.only(right: 10, left: 10),
                        color: Colors.white,
                        child: Column(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height / 9,
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 0.5,
                                          color: Color.fromARGB(
                                              255, 214, 212, 212)))),
                              margin: const EdgeInsets.only(
                                  top: 5, right: 5, left: 5),
                              child: Row(
                                children: [
                                  // arrival
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        _departureInfo = false;
                                        searchResultsList();
                                      });
                                    },
                                    // widget
                                    child: arrivalsDepartures(context,
                                        "Arrivals", totalNumberOfArrivals),
                                  ),

                                  const Spacer(),
                                  // departure
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        _departureInfo = true;
                                        searchResultsList();
                                      });
                                    },
                                    child: arrivalsDepartures(context,
                                        "Departures", totalNumberOfDepartures),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: _departureInfo == false
                                  // arrivals records
                                  ? numberOfArrivals.isNotEmpty
                                      // if presence of arrivals
                                      ? ListView.builder(
                                          itemCount: _resultsList.length,
                                          itemBuilder: (BuildContext context,
                                                  int index) =>
                                              buildBookingInfoCard(
                                                  context, _resultsList[index]))
                                      // if no arrivals
                                      : const Padding(
                                          padding: EdgeInsets.only(top: 40.0),
                                          child: Text(
                                            "No guests arriving this day",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        )
                                  // departure records
                                  : numberOfDepartures.isNotEmpty
                                      // if presence of depatures
                                      ? ListView.builder(
                                          itemCount: _departureList.length,
                                          itemBuilder: (BuildContext context,
                                                  int index) =>
                                              buildBookingInfoCard(context,
                                                  _departureList[index]))
                                      // if no depatures
                                      : const Padding(
                                          padding: EdgeInsets.only(top: 40.0),
                                          child: Text(
                                            "No guests departing this day",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                            )
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ),
      );
}

class MySearchDelegate extends SearchDelegate {
  List allresults;

  MySearchDelegate({required this.allresults});

  // arrow_back
  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        // close searchbar
        onPressed: () => close(context, null),
      );

  // icon.clear
  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (query.isEmpty) {
              close(context, null);
            } else {
              query = "";
            }
          },
        )
      ];

  // the results of the search
  @override
  Widget buildResults(BuildContext context) {
    var showResults = [];

    for (var bookingInfoSnapshot in allresults) {
      // access the name of current snapshot and convert it to lower case
      String title = bookingInfoSnapshot["name"];
      title = title.toLowerCase();

      if (title.contains(query.toLowerCase())) {
        showResults.add(bookingInfoSnapshot);
      }
    }

    return query != ""
        ? Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: ListView.builder(
                itemCount: showResults.length,
                itemBuilder: (BuildContext context, int index) =>
                    buildBookingInfoCard(context, showResults[index])),
          )
        : Container();
  }

  // no suggestions
  @override
  Widget buildSuggestions(BuildContext context) => Container();
}
