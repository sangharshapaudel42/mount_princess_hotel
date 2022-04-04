import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final DateTime checkIn;
  final DateTime checkOut;
  final DateTime bookingDate;
  final String roomType;
  final int person;
  final String name;
  final String email;
  final String phoneNumber;
  final int numberOfRooms;
  final double totalPrice;

  const Booking({
    required this.checkIn,
    required this.checkOut,
    required this.bookingDate,
    required this.roomType,
    required this.person,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.numberOfRooms,
    required this.totalPrice,
  });

  static Booking fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Booking(
      checkIn: snapshot["checkIn"],
      checkOut: snapshot["checkOut"],
      bookingDate: snapshot["bookingDate"],
      roomType: snapshot["roomType"],
      person: snapshot["person"],
      name: snapshot["name"],
      email: snapshot["email"],
      phoneNumber: snapshot["phoneNumber"],
      numberOfRooms: snapshot["numberOfRooms"],
      totalPrice: snapshot["totalPrice"],
    );
  }

  Booking.fromSnapshot(DocumentSnapshot snapshot)
      : checkIn = snapshot["checkIn"],
        checkOut = snapshot["checkOut"],
        bookingDate = snapshot["bookingDate"],
        roomType = snapshot["roomType"],
        person = snapshot["person"],
        name = snapshot["name"],
        email = snapshot["email"],
        phoneNumber = snapshot["phoneNumber"],
        numberOfRooms = snapshot["numberOfRooms"],
        totalPrice = snapshot["totalPrice"];

  Map<String, dynamic> toJson() => {
        "checkIn": checkIn,
        "checkOut": checkOut,
        "bookingDate": bookingDate,
        "roomType": roomType,
        "person": person,
        "name": name,
        "email": email,
        "phoneNumber": phoneNumber,
        "numberOfRooms": numberOfRooms,
        "totalPrice": totalPrice,
      };
}
