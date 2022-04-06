import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mount_princess_hotel/widgets/booking_cancel_pop_up.dart';
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
  String checkOutDate = DateFormat.yMMMEd().format(dateTimeCheckOut);

  // get the bookingDate date
  Timestamp timestampBookingDate = data['bookingDate'];
  DateTime dateTimeBookingDate = timestampBookingDate.toDate();
  String bookingDate = DateFormat.yMMMMEEEEd().format(dateTimeBookingDate);

  // number of nights
  int nights = dateTimeCheckOut.difference(dateTimeCheckIn).inDays;

  // numbers of rooms
  int numberOfRooms = data["numberOfRooms"];

  // total price
  double price = data["totalPrice"];

  return SingleChildScrollView(
    child: Container(
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.only(right: 10, left: 10, top: 15, bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            bookingDate,
            style: const TextStyle(
              color: Color(0xff0b29d6),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.only(left: 15, bottom: 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              border:
                  Border(left: BorderSide(width: 3, color: Color(0xff0f8204))),
            ),
            // inner content of the container
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40.0, right: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // room type and the time ago
                      Row(
                        children: [
                          Text(
                            data["roomType"],
                            style: const TextStyle(
                              fontSize: 22,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            // time ago booking date.
                            timeago.format(dateTimeBookingDate),
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[700],
                            ),
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
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          // departure - date
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Departure",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                checkOutDate,
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
                      ),
                      const SizedBox(height: 20),
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
                      const SizedBox(height: 20),
                      // email / phone number
                      Row(
                        children: [
                          // email
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Email",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                data["email"].length > 20
                                    ? data["email"].substring(0, 20) + '...'
                                    : data["email"],
                                style: const TextStyle(
                                  fontSize: 20,
                                  // color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          // phone number
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
                        ],
                      )
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.delete),
                    color: Colors.black,
                    iconSize: 35,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            CancelBookingPopUpDialog(
                          bookingId: data.id,
                          roomType: data["roomType"],
                          noOfRooms: data["numberOfRooms"],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
