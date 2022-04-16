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

  // document snapshot of booking status table.
  DocumentSnapshot? bookingStatusDoc;

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
    // booking docs
    var data = await FirebaseFirestore.instance
        .collection('Booking')
        .orderBy("bookingDate", descending: true)
        .get();

    // booking status docs
    var bookingStatusData = await FirebaseFirestore.instance
        .collection("BookingStatus")
        .doc("booking_status")
        .get();
    setState(() {
      _allResults = data.docs;
      bookingStatusDoc = bookingStatusData;
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
                delegate: MySearchDelegate(
                    allresults: _allResults,
                    bookingStatusDoc: bookingStatusDoc!),
              );
            },
          )
        ],
      ),
      body: RefreshWidget(
          onRefresh: getBookingStreamSnapshots,
          child: bookingStatusDoc != null
              ? buildBookingActivityWidget(context, _weekDates, _allResults,
                  _weekDatesEasy, bookingStatusDoc!)
              : const SizedBox()),
    );
  }
}

// search bar
class MySearchDelegate extends SearchDelegate {
  List allresults;
  DocumentSnapshot bookingStatusDoc;

  @override
  String get searchFieldLabel => 'Search Date (yyyy-MM-dd)...';

  MySearchDelegate({
    required this.allresults,
    required this.bookingStatusDoc,
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

      if (query != "") {
        // upload the new search query to the database.
        FirebaseFirestore.instance
            .collection("ActivitySearchHistory")
            .doc(query)
            .set({"search": query});
      }

      return Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: buildBookingActivityWidget(context, [weekStringDates],
            allresults, [weekDatesStringEasy], bookingStatusDoc),
      );
    } catch (err) {
      return query != ""
          ? Center(
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
            )
          : const SizedBox(height: 0);
    }
  }

  // suggestions
  // suggestions from the firebase
  @override
  Widget buildSuggestions(BuildContext context) {
    var _activitySearchHistoryDocs =
        FirebaseFirestore.instance.collection("ActivitySearchHistory");

    return StreamBuilder(
      stream: _activitySearchHistoryDocs.snapshots(),
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
                      InkWell(
                        onTap: () async {
                          await FirebaseFirestore.instance
                              .collection("ActivitySearchHistory")
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
