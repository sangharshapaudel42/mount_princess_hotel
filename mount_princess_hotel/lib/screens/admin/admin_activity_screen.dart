import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mount_princess_hotel/screens/admin/widgets/activity_whole_widget.dart';
import 'package:mount_princess_hotel/widgets/admin_navigation_drawer_widget.dart';
import 'package:mount_princess_hotel/widgets/refresh_widget.dart';

import '../../utils/colors.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({Key? key}) : super(key: key);

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  late Future resultsLoaded;
  // all booking datas
  List _allResults = [];
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

  // get all the Booking info of all users.
  Future getBookingStreamSnapshots() async {
    var data = await FirebaseFirestore.instance.collection('Booking').get();
    setState(() {
      _allResults = data.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AdminNavigationDrawerWidget(),
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text('Activity'),
        centerTitle: true,
        // search the date
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
      body: RefreshWidget(
        onRefresh: getBookingStreamSnapshots,
        child: buildBookingActivityWidget(
            context, _weekDates, _allResults, _weekDatesEasy),
      ),
    );
  }
}

class MySearchDelegate extends SearchDelegate {
  List allresults;

  @override
  String get searchFieldLabel => 'Search Date (yyyy-MM-dd)...';

  MySearchDelegate({
    required this.allresults,
  });

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
    try {
      DateTime dateInYMD = DateTime.parse(query);
      String weekStringDates = DateFormat.yMMMMEEEEd().format(dateInYMD);
      String weekDatesStringEasy = DateFormat('MM-dd-yyyy').format(dateInYMD);

      return Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: buildBookingActivityWidget(
            context, [weekStringDates], allresults, [weekDatesStringEasy]),
      );
    } catch (err) {
      return Center(
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
                      text: "Invalid Date Format!!!.\n\n",
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                    TextSpan(text: 'Date Format: year-month-day\n\n'),
                    TextSpan(text: 'i.e. 2022-04-06\n\n')
                  ]),
            ),
          ],
        ),
      );
    }
  }

  // suggestions
  @override
  Widget buildSuggestions(BuildContext context) => Container();
}
