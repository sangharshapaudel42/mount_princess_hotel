import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String checkIn;
  final String checkOut;
  final String roomType;
  final int adults;
  final int childrens;
  final String name;
  final String email;
  final String phoneNumber;
  final int numberOfRooms;
  final int totalPrice;

  const Booking({
    required this.checkIn,
    required this.checkOut,
    required this.roomType,
    required this.adults,
    required this.childrens,
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
      roomType: snapshot["roomType"],
      adults: snapshot["adults"],
      childrens: snapshot["childrens"],
      name: snapshot["name"],
      email: snapshot["email"],
      phoneNumber: snapshot["phoneNumber"],
      numberOfRooms: snapshot["numberOfRooms"],
      totalPrice: snapshot["totalPrice"],
    );
  }

  Map<String, dynamic> toJson() => {
        "checkIn": checkIn,
        "checkOut": checkOut,
        "roomType": roomType,
        "adults": adults,
        "childrens": childrens,
        "name": name,
        "email": email,
        "phoneNumber": phoneNumber,
        "numberOfRooms": numberOfRooms,
        "totalPrice": totalPrice,
      };
}
