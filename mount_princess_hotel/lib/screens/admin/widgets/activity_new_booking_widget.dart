import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

// Activity New Booking widget
Widget buildNewBookingWidget(BuildContext context, QueryDocumentSnapshot data) {
  // get the checkIn date
  Timestamp timestampCheckIn = data['checkIn'];
  DateTime dateTimeCheckIn = timestampCheckIn.toDate();
  String checkInDate = DateFormat.yMMMEd().format(dateTimeCheckIn);

  // get the checkOut date
  Timestamp timestampCheckOut = data['checkOut'];
  DateTime dateTimeCheckOut = timestampCheckOut.toDate();

  // get the bookingDate date
  Timestamp timestampBookingDate = data['bookingDate'];
  DateTime dateTimeBookingDate = timestampBookingDate.toDate();
  String newBookingDate = DateFormat.yMMMEd().format(dateTimeBookingDate);

  // number of nights
  int nights = dateTimeCheckOut.difference(dateTimeCheckIn).inDays;

  // numbers of rooms
  int numberOfRooms = data["numberOfRooms"];

  // total price
  double price = data["totalPrice"];

  return Container(
    margin: const EdgeInsets.only(top: 5, bottom: 5),
    padding: const EdgeInsets.only(right: 15, left: 15, top: 20, bottom: 20),
    decoration: const BoxDecoration(
      color: Colors.white,
      border: Border(left: BorderSide(width: 3, color: Color(0xff0f8204))),
    ),
    // inner content of the container
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // new booking and the ago
        Row(
          children: [
            const Text(
              "New booking",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Text(
              timeago.format(dateTimeBookingDate),
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        // last-minute booking and new note from guest
        Row(
          children: [
            checkInDate == newBookingDate
                ?
                // Last-minute booking: if check-in date and booking date is same.
                Container(
                    margin: EdgeInsets.only(
                        top: 10, right: MediaQuery.of(context).size.width / 10),
                    color: const Color.fromARGB(255, 255, 115, 0),
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(
                      "Last-minute booking",
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  )
                : const SizedBox(height: 0),
            data["note"] != ""
                ?
                // Last-minute booking: if check-in date and booking date is same.
                Container(
                    margin: const EdgeInsets.only(top: 10),
                    color: const Color.fromARGB(255, 12, 12, 231),
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(
                      "Note from guest",
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  )
                : const SizedBox(height: 0),
          ],
        ),
        const SizedBox(height: 10),
        // Room type
        Text(
          data["roomType"],
          style: const TextStyle(
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 15),
        // arrival, nights
        Row(
          children: [
            // arrival - date
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Arrival",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  checkInDate,
                  style: const TextStyle(
                    fontSize: 20,
                    // color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            const Spacer(),
            // Nights - no_of_nights
            Padding(
              padding: const EdgeInsets.only(right: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Nights",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "$nights",
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
        const SizedBox(height: 15),
        // guest name, Price
        Row(
          children: [
            // guest name - name
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Guest name",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  data["name"],
                  style: const TextStyle(
                    fontSize: 20,
                    // color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            const Spacer(),
            // Price - price
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Price",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "US \$$price",
                  style: const TextStyle(
                    fontSize: 20,
                    // color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 15),
        // phone number
        Row(
          children: [
            Column(
              children: [
                Text(
                  "Phone number",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  data["phoneNumber"],
                  style: const TextStyle(
                    fontSize: 20,
                    // color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            const Spacer(),
            // Rooms
            Padding(
              padding: const EdgeInsets.only(right: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Rooms",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "$numberOfRooms",
                    style: const TextStyle(
                      fontSize: 20,
                      // color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    ),
  );
}
