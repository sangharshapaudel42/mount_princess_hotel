import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

// Activity New Booking widget
Widget buildBookingCancelWidget(
    BuildContext context, QueryDocumentSnapshot data) {
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
      border: Border(left: BorderSide(width: 3, color: Color(0xffd60b0b))),
    ),
    // inner content of the container
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // new booking and the ago
        Row(
          children: [
            const Text(
              "Cancellation",
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
        const SizedBox(height: 15),
        // Room type
        Text(
          data["roomType"],
          style: const TextStyle(
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 20),
        // guest name
        Row(
          children: [
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
        const SizedBox(height: 20),
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
      ],
    ),
  );
}
