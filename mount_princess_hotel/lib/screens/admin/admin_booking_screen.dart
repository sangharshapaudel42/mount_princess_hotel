import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mount_princess_hotel/screens/admin/upcoming_booking.dart';
import 'package:mount_princess_hotel/screens/admin/widgets/arrival_departure_button_widget.dart';
import 'package:mount_princess_hotel/screens/admin/widgets/booking_indiviusal_card.dart';
import 'package:mount_princess_hotel/widgets/refresh_widget.dart';
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
  List _stayOverList = [];
  String _chooseDate = "";
  bool _departureInfo = false;
  bool _stayOverInfo = false;

  // this list is used to see all the arrivals on that day
  List numberOfArrivals = [];

  // this list is used to see all the Departures on that day
  List numberOfDepartures = [];

  // this list is used to see all the Stay Over on that day
  List numberOfStayOver = [];

  int totalNumberOfArrivals = 0;
  int totalNumberOfDepartures = 0;
  int totalNumberOfStayOver = 0;

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
      var stayOverDateList = [];
      String? date;

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

      // get the dates between check-in and check-ou
      for (int i = 1;
          i < dateTimeCheckOut.difference(dateTimeCheckIn).inDays;
          i++) {
        // first convert it to string('mm-dd-yyyy') then store in list.
        stayOverDateList.add(DateFormat('MM-dd-yyyy')
            .format(dateTimeCheckIn.add(Duration(days: i))));
      }

      // change the value of 'date' according to the conditions.
      // for a today's day
      if (_chooseDate == "") {
        String _todayDate = DateFormat('MM-dd-yyyy').format(DateTime.now());

        // if date is not choosen then 'date' is today's date.
        date = _todayDate;

        // for choosen day
      } else {
        date = _chooseDate;
      }

      // null check for date
      if (date != null) {
        // for today's arrivals
        if (checkInDate.contains(date)) {
          // add arrivals to numberOfArrivals list
          numberOfArrivals.add(bookingInfoSnapshot);
          setState(() {
            // change the count to the list size
            totalNumberOfArrivals = numberOfArrivals.length;
          });
        }
        // for today's departures
        if (checkOutDate.contains(date)) {
          // add departures to numberOfDepartures list
          numberOfDepartures.add(bookingInfoSnapshot);
          setState(() {
            // change the count to the list size
            totalNumberOfDepartures = numberOfDepartures.length;
          });
        }
        // for today's stay overs
        if (stayOverDateList.contains(date)) {
          // add stay over to numberOfStayOver list
          numberOfStayOver.add(bookingInfoSnapshot);
          setState(() {
            // change the count to the list size
            totalNumberOfStayOver = numberOfStayOver.length;
          });
        }
      }
    }
  }

  // this function is responsible for changing booking info results
  searchResultsList() {
    // date-picker results will be stored here
    var showResults = [];

    for (var bookingInfoSnapshot in _allResults) {
      var stayOverDateList = [];

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

      // get the dates between check-in and check-ou
      for (int i = 1;
          i < dateTimeCheckOut.difference(dateTimeCheckIn).inDays;
          i++) {
        // first convert it to string('mm-dd-yyyy') then store in list.
        stayOverDateList.add(DateFormat('MM-dd-yyyy')
            .format(dateTimeCheckIn.add(Duration(days: i))));
      }

      // in initial state. i.e. no date has been choosen.
      if (_chooseDate == "") {
        // for check-in
        if (_departureInfo == false && _stayOverInfo == false) {
          // checking if checkIn date for that booking info is eqaul to today's date
          if (checkInDate.contains(_todayDate)) {
            showResults.add(bookingInfoSnapshot);
          }

          // for check-out
        } else if (_departureInfo == true && _stayOverInfo == false) {
          if (checkOutDate.contains(_todayDate)) {
            showResults.add(bookingInfoSnapshot);
          }

          // for stay-over
        } else if (_departureInfo == false && _stayOverInfo == true) {
          if (stayOverDateList.contains(_todayDate)) {
            showResults.add(bookingInfoSnapshot);
          }
        }
        // if date is choosen.
      } else if (_chooseDate != "") {
        // for check-in
        if (_departureInfo == false && _stayOverInfo == false) {
          // checking if checkIn date for that booking info is eqaul to today's date
          if (checkInDate.contains(_chooseDate)) {
            showResults.add(bookingInfoSnapshot);
          }

          // for check-out
        } else if (_departureInfo == true && _stayOverInfo == false) {
          if (checkOutDate.contains(_chooseDate)) {
            showResults.add(bookingInfoSnapshot);
          }
          // for stay-over
        } else if (_departureInfo == false && _stayOverInfo == true) {
          if (stayOverDateList.contains(_chooseDate)) {
            showResults.add(bookingInfoSnapshot);
          }
        }
      }
    }
    setState(() {
      // arrivals info
      if (_departureInfo == false && _stayOverInfo == false) {
        _resultsList = showResults;
        // departures info
      } else if (_departureInfo == true && _stayOverInfo == false) {
        _departureList = showResults;
        // for stay-over
      } else if (_departureInfo == false && _stayOverInfo == true) {
        _stayOverList = showResults;
      }
    });
  }

  // get all the Booking info of all users.
  Future getUsersPastTripsStreamSnapshots() async {
    var data = await FirebaseFirestore.instance
        .collection('Booking')
        .where("bookingCancel", isEqualTo: false)
        .get();
    setState(() {
      _allResults = data.docs;
    });
    numberOfArivalsDepartures();
    searchResultsList();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: const AdminNavigationDrawerWidget(),
        appBar: AppBar(
          backgroundColor: backgroundColor,
          title: const Text('Bookings'),
          centerTitle: true,
          // search the guests
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
                        _stayOverInfo = false;

                        // reseting all the values to null.
                        // So the previous day's result would not affect the current
                        // choosen day.
                        numberOfArrivals = [];
                        numberOfDepartures = [];
                        numberOfStayOver = [];
                        totalNumberOfArrivals = 0;
                        totalNumberOfDepartures = 0;
                        totalNumberOfStayOver = 0;

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
                // when there is no arrivals and no departures and stay overs
                numberOfArrivals.isEmpty &&
                        numberOfDepartures.isEmpty &&
                        numberOfStayOver.isEmpty
                    // if there is no booking in that day
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: MediaQuery.of(context).size.height / 8),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8),
                            child: Text(
                              "No guests arriving or departing or staying over this day.",
                              style: TextStyle(
                                  fontSize: 18, color: Colors.grey[800]),
                            ),
                          ),
                          const SizedBox(height: 20),
                          InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const UpcomingBooking(),
                              ),
                            ),
                            child: const Text(
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
                        height: MediaQuery.of(context).size.height / 1.821,
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
                                  // arrival header
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        _departureInfo = false;
                                        _stayOverInfo = false;
                                        searchResultsList();
                                      });
                                    },
                                    // widget
                                    child: arrivalsDepartures(context,
                                        "Arrivals", numberOfArrivals.length),
                                  ),

                                  const Spacer(),
                                  // departure header
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        _departureInfo = true;
                                        _stayOverInfo = false;
                                        searchResultsList();
                                      });
                                    },
                                    child: arrivalsDepartures(
                                        context,
                                        "Departures",
                                        numberOfDepartures.length),
                                  ),
                                  const Spacer(),
                                  // stay-over header
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        _departureInfo = false;
                                        _stayOverInfo = true;
                                        searchResultsList();
                                      });
                                    },
                                    child: arrivalsDepartures(context,
                                        "Stay over", numberOfStayOver.length),
                                  ),
                                ],
                              ),
                            ),
                            // arrivals, departures & stay over records
                            Expanded(
                              // stay over records
                              child: (_departureInfo == false &&
                                      _stayOverInfo == true)
                                  ? numberOfStayOver.isNotEmpty
                                      // if presence of stay-over
                                      ? ListView.builder(
                                          itemCount: _stayOverList.length,
                                          itemBuilder:
                                              (BuildContext context, int index) =>
                                                  buildBookingInfoCard(context,
                                                      _stayOverList[index]))
                                      // if no stay overs
                                      : const Padding(
                                          padding: EdgeInsets.only(top: 40.0),
                                          child: Text(
                                            "No guest staying over this day",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        )

                                  // departure records
                                  : (_departureInfo == true &&
                                          _stayOverInfo == false)
                                      ? numberOfDepartures.isNotEmpty
                                          // if presence of depatures
                                          ? ListView.builder(
                                              itemCount: _departureList.length,
                                              itemBuilder: (BuildContext context,
                                                      int index) =>
                                                  buildBookingInfoCard(context,
                                                      _departureList[index]))
                                          // if no depatures
                                          : const Padding(
                                              padding:
                                                  EdgeInsets.only(top: 40.0),
                                              child: Text(
                                                "No guests departing this day",
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            )

                                      // arrivals records
                                      : numberOfArrivals.isNotEmpty
                                          // if presence of arrivals
                                          ? ListView.builder(
                                              itemCount: _resultsList.length,
                                              itemBuilder: (BuildContext context,
                                                      int index) =>
                                                  buildBookingInfoCard(context, _resultsList[index]))
                                          // if no arrivals
                                          : const Padding(
                                              padding:
                                                  EdgeInsets.only(top: 40.0),
                                              child: Text(
                                                "No guests arriving this day",
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

  @override
  String get searchFieldLabel => 'Search Guest Name...';

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

    if (query != "") {
      // upload the new search query to the database.
      FirebaseFirestore.instance
          .collection("BookingSearchHistory")
          .doc(query)
          .set({"search": query});
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
  Widget buildSuggestions(BuildContext context) {
    var _bookingSearchHistoryDocs =
        FirebaseFirestore.instance.collection("BookingSearchHistory");

    return StreamBuilder(
      stream: _bookingSearchHistoryDocs.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        List<QueryDocumentSnapshot> docs =
            (snapshot.data! as QuerySnapshot).docs;

        List searchList = [];

        docs.forEach((item) {
          searchList.add(item["search"]);
        });

        return ListView.builder(
            itemCount: searchList.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  query = searchList[index];

                  buildResults(context);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 12,
                  padding: const EdgeInsets.only(right: 20, left: 10),
                  margin: const EdgeInsets.only(top: 5),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(bottom: BorderSide(color: Colors.grey)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.history,
                        color: Colors.grey,
                        size: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          searchList[index],
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                      const Spacer(),
                      // delete the seach history
                      InkWell(
                        onTap: () async {
                          await FirebaseFirestore.instance
                              .collection("BookingSearchHistory")
                              .doc(searchList[index])
                              .delete();
                        },
                        child: const Icon(
                          Icons.close,
                          size: 30,
                        ),
                      )
                    ],
                  ),
                ),
              );
            });
      },
    );
  }
}
