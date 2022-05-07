import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final DateTime checkIn;
  final DateTime checkOut;
  final DateTime bookingDate;
  final String bookingDateString;
  final String roomType;
  final int person;
  final String name;
  final String email;
  final String phoneNumber;
  final int numberOfRooms;
  final double totalPrice;
  final bool bookingCancel;
  final String uid;
  final String checkInString;
  final String checkOutString;
  final String bookingCancelDate;
  final String note;

  const Booking({
    required this.checkIn,
    required this.checkOut,
    required this.bookingDate,
    required this.bookingDateString,
    required this.roomType,
    required this.person,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.numberOfRooms,
    required this.totalPrice,
    required this.bookingCancel,
    required this.uid,
    required this.checkInString,
    required this.checkOutString,
    required this.bookingCancelDate,
    required this.note,
  });

  static Booking fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Booking(
      checkIn: snapshot["checkIn"],
      checkOut: snapshot["checkOut"],
      bookingDate: snapshot["bookingDate"],
      bookingDateString: snapshot["bookingDateString"],
      roomType: snapshot["roomType"],
      person: snapshot["person"],
      name: snapshot["name"],
      email: snapshot["email"],
      phoneNumber: snapshot["phoneNumber"],
      numberOfRooms: snapshot["numberOfRooms"],
      totalPrice: snapshot["totalPrice"],
      bookingCancel: snapshot["bookingCancel"],
      uid: snapshot["uid"],
      checkInString: snapshot["checkInString"],
      checkOutString: snapshot["checkOutString"],
      bookingCancelDate: snapshot["bookingCancelDate"],
      note: snapshot["note"],
    );
  }

  Booking.fromSnapshot(DocumentSnapshot snapshot)
      : checkIn = snapshot["checkIn"],
        checkOut = snapshot["checkOut"],
        bookingDate = snapshot["bookingDate"],
        bookingDateString = snapshot["bookingDateString"],
        roomType = snapshot["roomType"],
        person = snapshot["person"],
        name = snapshot["name"],
        email = snapshot["email"],
        phoneNumber = snapshot["phoneNumber"],
        numberOfRooms = snapshot["numberOfRooms"],
        totalPrice = snapshot["totalPrice"],
        bookingCancel = snapshot["bookingCancel"],
        uid = snapshot["uid"],
        checkInString = snapshot["checkInString"],
        checkOutString = snapshot["checkOutString"],
        bookingCancelDate = snapshot["bookingCancelDate"],
        note = snapshot["note"];

  Map<String, dynamic> toJson() => {
        "checkIn": checkIn,
        "checkOut": checkOut,
        "bookingDate": bookingDate,
        "bookingDateString": bookingDateString,
        "roomType": roomType,
        "person": person,
        "name": name,
        "email": email,
        "phoneNumber": phoneNumber,
        "numberOfRooms": numberOfRooms,
        "totalPrice": totalPrice,
        "bookingCancel": bookingCancel,
        "uid": uid,
        "checkInString": checkInString,
        "checkOutString": checkOutString,
        "bookingCancelDate": bookingCancelDate,
        "note": note,
      };
}
