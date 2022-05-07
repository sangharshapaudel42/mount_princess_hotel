import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:mount_princess_hotel/models/booking.dart' as model;

class BookingMethods {
  // creating the firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // creating the auth instance
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> addBookingInfo({
    required DateTime checkIn,
    required DateTime checkOut,
    required DateTime bookingDate,
    required String bookingDateString,
    required String roomType,
    required int person,
    required String name,
    required String email,
    required String phoneNumber,
    required int numberOfRooms,
    required double totalPrice,
    required bool bookingCancel,
    required String uid,
    required String checkInString,
    required String checkOutString,
    required String bookingCancelDate,
    required String note,
  }) async {
    String res = "Some error Occurred";
    try {
      if (checkIn != null ||
          checkOut != null ||
          roomType.isNotEmpty ||
          name.isNotEmpty ||
          email.isNotEmpty ||
          phoneNumber.isNotEmpty ||
          phoneNumber.length >= 10 ||
          numberOfRooms > 0) {
        // booking model
        model.Booking _booking = model.Booking(
          checkIn: checkIn,
          bookingDate: bookingDate,
          bookingDateString: bookingDateString,
          checkOut: checkOut,
          roomType: roomType,
          person: person,
          name: name,
          email: email,
          phoneNumber: phoneNumber,
          numberOfRooms: numberOfRooms,
          totalPrice: totalPrice,
          bookingCancel: bookingCancel,
          uid: uid,
          checkInString: checkInString,
          checkOutString: checkOutString,
          bookingCancelDate: bookingCancelDate,
          note: note,
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
