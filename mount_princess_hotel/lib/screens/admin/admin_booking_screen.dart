import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mount_princess_hotel/models/booking.dart';
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
  final TextEditingController _searchController = TextEditingController();

  late Future resultsLoaded;
  List _allResults = [];
  List _resultsList = [];
  String _chooseDate = "";

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getUsersPastTripsStreamSnapshots();
  }

  // will be called after typing in search text field
  _onSearchChanged() {
    searchResultsList();
  }

  // this function is responsible for changing search results and date picker
  searchResultsList() {
    // searched-results and date-picker results will be stored here
    var showResults = [];

    // if there is anything in the text fields
    if (_searchController.text != "") {
      for (var bookingInfoSnapshot in _allResults) {
        var title =
            Booking.fromSnapshot(bookingInfoSnapshot).name.toLowerCase();

        if (title.contains(_searchController.text.toLowerCase())) {
          showResults.add(bookingInfoSnapshot);
        }
      }

      // if date is choose

      // display the current day booking info
    } else if (_chooseDate == "") {
      for (var bookingInfoSnapshot in _allResults) {
        var title = Booking.fromSnapshot(bookingInfoSnapshot).checkIn;
        print(title);

        String _todayDate = DateFormat('MM-dd-yyyy').format(DateTime.now());

        if (title.contains(_todayDate)) {
          showResults.add(bookingInfoSnapshot);
        }
      }
      // booking info according to user's choice
    } else if (_chooseDate != "") {
      for (var bookingInfoSnapshot in _allResults) {
        var title = Booking.fromSnapshot(bookingInfoSnapshot).checkIn;

        if (title.contains(_chooseDate)) {
          showResults.add(bookingInfoSnapshot);
        }
      }

      // if nothing is choose then all the results will be displayed.
    } else {
      showResults = List.from(_allResults);
    }
    setState(() {
      _resultsList = showResults;
    });
  }

  // get all the Booking info of all users.
  getUsersPastTripsStreamSnapshots() async {
    var data = await FirebaseFirestore.instance.collection('Booking').get();
    setState(() {
      _allResults = data.docs;
      print(_allResults);
    });
    searchResultsList();
    return "complete";
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: const AdminNavigationDrawerWidget(),
        appBar: AppBar(
          backgroundColor: backgroundColor,
          title: const Text('Manage Booking'),
          centerTitle: true,
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.grey[100],
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    top: 20, left: 10.0, right: 10.0, bottom: 0.0),
                // search bar
                child: TextFieldInput(
                  hintText: "Search...",
                  textInputType: TextInputType.text,
                  textEditingController: _searchController,
                  icon: Icons.search,
                  color: Colors.white,
                ),
              ),
              // date picker
              SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                child: CupertinoDatePicker(
                  initialDateTime: DateTime.now(),
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (DateTime value) {
                    setState(() {
                      // converting the choose date to string
                      _chooseDate = DateFormat('MM-dd-yyyy').format(value);

                      // calling seachResultsList() so that we could display
                      // bookingInfo of disered date.
                      searchResultsList();
                    });
                  },
                ),
              ),
              _resultsList.isEmpty
                  // if there is no booking in that day
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height / 5),
                        Text(
                          "Sorry, No Booking...",
                          style:
                              TextStyle(fontSize: 30, color: Colors.grey[800]),
                        ),
                      ],
                    )
                  // if there is booking on that day
                  : Expanded(
                      child: ListView.builder(
                        itemCount: _resultsList.length,
                        itemBuilder: (BuildContext context, int index) =>
                            buildBookingInfoCard(context, _resultsList[index]),
                      ),
                    ),
            ],
          ),
        ),
      );
}
