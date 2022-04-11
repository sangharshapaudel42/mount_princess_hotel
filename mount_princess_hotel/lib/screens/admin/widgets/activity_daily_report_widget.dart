import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Activity Daily Report widget
Widget buildDailyReportWidget(BuildContext context, int checkIns, int checkOuts,
    DocumentSnapshot bookingStatusDoc, String currentDate) {
  var size = MediaQuery.of(context).size;

  int numberOfSoldOutRoomsType = 0;
  String soldOutRoom = "0";

  String todayDate = DateFormat("MM-dd-yyyy").format(DateTime.now());

  // if both of the rooms are sold old
  if (bookingStatusDoc["deluxeRoomTotalRooms"] == 0 &&
      bookingStatusDoc["standardRoomTotalRooms"] == 0) {
    // if both rooms are sold out then the number is 2 and both names are added to the list
    numberOfSoldOutRoomsType = 2;

    // if either of the rooms are sold old
  } else if (bookingStatusDoc["deluxeRoomTotalRooms"] == 0 ||
      bookingStatusDoc["standardRoomTotalRooms"] == 0) {
    if (bookingStatusDoc["deluxeRoomTotalRooms"] == 0) {
      numberOfSoldOutRoomsType = 1;
      soldOutRoom = "Deluxe Room";
    } else if (bookingStatusDoc["standardRoomTotalRooms"] == 0) {
      numberOfSoldOutRoomsType = 1;
      soldOutRoom = "Standard Room";
    }
  }

  return Container(
    margin: const EdgeInsets.only(top: 5),
    padding: const EdgeInsets.only(right: 15, left: 15, top: 20, bottom: 20),
    decoration: const BoxDecoration(
      color: Colors.white,
      border: Border(
          left: BorderSide(width: 3, color: Color.fromARGB(255, 3, 11, 166))),
    ),
    // inner content of the container
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // new booking and the ago
        const Text(
          "Daily Report",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: size.height / 40),
        // arrival, departure
        Row(
          children: [
            // number of arrival
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Arrivals",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "$checkIns",
                  style: const TextStyle(
                    fontSize: 20,
                    // color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            const Spacer(),
            // number of departure
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Departures",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "$checkOuts",
                    style: const TextStyle(
                      fontSize: 20,
                      // color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        // show this only for today's date
        todayDate == currentDate
            ? Column(
                children: [
                  SizedBox(height: size.height / 40),
                  // number of sold out rooms type
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Sold out room types",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        // if no room is sold old
                        (numberOfSoldOutRoomsType == 0)
                            ? "$numberOfSoldOutRoomsType"
                            // if any of the room is sold out
                            : (numberOfSoldOutRoomsType == 1)
                                ? "$soldOutRoom"
                                // if both room is sold out
                                : (numberOfSoldOutRoomsType == 2)
                                    ? "Deluxe & Standard room"
                                    : "0",
                        style: const TextStyle(
                          fontSize: 20,
                          // color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : const SizedBox()
      ],
    ),
  );
}
