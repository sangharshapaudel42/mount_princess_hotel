import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:mount_princess_hotel/models/booking.dart' as model;

class BookingMethods {
  // creating the firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // creating the auth instance
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> addBookingInfo({
    required String checkIn,
    required String checkOut,
    required String roomType,
    required int adults,
    required int childrens,
    required String name,
    required String email,
    required String phoneNumber,
    required int numberOfRooms,
    required int totalPrice,
  }) async {
    String res = "Some error Occurred";
    try {
      if (checkIn.isNotEmpty ||
          checkOut.isNotEmpty ||
          roomType.isNotEmpty ||
          name.isNotEmpty ||
          email.isNotEmpty ||
          phoneNumber.isNotEmpty ||
          phoneNumber.length >= 10 ||
          numberOfRooms > 0) {
        // booking model
        model.Booking _booking = model.Booking(
          checkIn: checkIn,
          checkOut: checkOut,
          roomType: roomType,
          adults: adults,
          childrens: childrens,
          name: name,
          email: email,
          phoneNumber: phoneNumber,
          numberOfRooms: numberOfRooms,
          totalPrice: totalPrice,
        );

        // adding booking in our database
        await _firestore.collection("Booking").doc().set(_booking.toJson());

        res = "success";
      } else if (phoneNumber.length < 10) {
        res = "Phone number should be greater than ten.";
      } else if (numberOfRooms <= 0) {
        res = "Number of Rooms booked should be atleast one.";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }
}
