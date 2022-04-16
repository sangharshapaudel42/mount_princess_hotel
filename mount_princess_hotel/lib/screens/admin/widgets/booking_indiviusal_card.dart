import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mount_princess_hotel/screens/admin/admin_booking_detail.dart';

Widget buildBookingInfoCard(BuildContext context, DocumentSnapshot document) {
  // final bookingInfo = Booking.fromSnapshot(document);
  // check-in date
  Timestamp timestampCheckIn = document['checkIn'];
  DateTime dateTimeCheckIn = timestampCheckIn.toDate();

  Timestamp timestampCheckOut = document['checkOut'];
  DateTime dateTimeCheckOut = timestampCheckOut.toDate();

  // difference between check-in date and check-out date
  int nightStay =
      int.parse(dateTimeCheckOut.difference(dateTimeCheckIn).inDays.toString());

  int numberOfguest = document["person"];
  int numberOfRooms = document["numberOfRooms"];

  return Card(
    // shape: RoundedRectangleBorder(
    //   borderRadius: BorderRadius.circular(20.0),
    // ),
    child: InkWell(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              document["name"],
              style: GoogleFonts.roboto(fontSize: 23.0),
            ),
            const SizedBox(height: 10),
            Text(
              "$nightStay night - $numberOfguest guests - $numberOfRooms room",
              // + bookingInfo.phoneNumber,
              style:
                  GoogleFonts.roboto(fontSize: 18.0, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailBookingPage(
                    documentId: document.id,
                  )),
        );
      },
    ),
  );
}
