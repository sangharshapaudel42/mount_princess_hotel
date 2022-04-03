import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mount_princess_hotel/models/booking.dart';
import 'package:mount_princess_hotel/screens/admin/admin_booking_detail.dart';

Widget buildBookingInfoCard(BuildContext context, DocumentSnapshot document) {
  final bookingInfo = Booking.fromSnapshot(document);

  return Container(
    margin: const EdgeInsets.only(left: 10, right: 10),
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                bookingInfo.name,
                style: GoogleFonts.roboto(
                    fontSize: 23.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                "Phone number: " + bookingInfo.phoneNumber,
                style: GoogleFonts.roboto(fontSize: 20.0),
              ),
              const SizedBox(height: 10),
              Text(
                "Check-In date: " + bookingInfo.checkIn,
                style: GoogleFonts.roboto(fontSize: 20.0),
              ),
              const SizedBox(height: 10),
              Text(
                "Check-Out date: " + bookingInfo.checkOut,
                style: GoogleFonts.roboto(fontSize: 20.0),
              )
            ],
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailBookingPage(booking: bookingInfo)),
          );
        },
      ),
    ),
  );
}
