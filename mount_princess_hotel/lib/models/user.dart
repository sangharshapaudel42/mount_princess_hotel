import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String name;
  final String phoneNumber;
  final String role;
  final String uid;

  const User({
    required this.email,
    required this.name,
    required this.phoneNumber,
    required this.role,
    required this.uid,
  });

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      email: snapshot["email"],
      name: snapshot["name"],
      phoneNumber: snapshot["phoneNumber"],
      role: snapshot["role"],
      uid: snapshot["uid"],
    );
  }

  Map<String, dynamic> toJson() => {
        "email": email,
        "name": name,
        "phoneNumber": phoneNumber,
        "role": role,
        "uid": uid,
      };
}
