import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mount_princess_hotel/models/user.dart' as model;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:mount_princess_hotel/screens/admin/admin_booking_screen.dart';
import 'package:mount_princess_hotel/screens/admin/admin_home_page.dart';
import 'package:mount_princess_hotel/screens/customer/booking_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

import '../screens/customer/phoneVerificationScreen.dart';

class AuthMethods {
  // creating the firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // creating the auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  ///////////////// Sign Up user /////////////////
  Future<String> signUpUser({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          name.isNotEmpty ||
          phoneNumber.isNotEmpty ||
          phoneNumber.length >= 10 ||
          phoneNumber[0] == "9" ||
          phoneNumber[1] == "8") {
        // registering user in auth with email and password
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        model.User _user = model.User(
          email: email,
          name: name,
          phoneNumber: phoneNumber,
          role: "customer",
          uid: cred.user!.uid,
        );

        // adding user in our database
        await _firestore
            .collection("Users")
            .doc(cred.user!.uid)
            .set(_user.toJson());

        res = "success";
      } else if (phoneNumber.length < 10) {
        res = "Phone number should be greater then ten.";
      } else {
        res = "Please enter all the fields";
      }
    }
    // if wants to costumize the error given by the firebase
    on FirebaseAuthException catch (e) {
      if (e.code == "email-already-exists") {
        res = "This email already exists.";
      } else if (e.code == "weak-password") {
        res = "Password should be at least 6 characters.";
      } else if (e.code == "phone-number-already-exists") {
        res = "This Phone Number already exists.";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  ///////////////// Logging in user /////////////////
  Future<String> loginUser(
      {required String email,
      required String password,
      required BuildContext context}) async {
    String res = "Some Error Occured";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        final finalUser = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "Success";
        if (finalUser != null) {
          final User user = _auth.currentUser!;
          final userID = user.uid;
          print(userID);

          DocumentSnapshot doc = await FirebaseFirestore.instance
              .collection('Users')
              .doc(userID)
              .get();
          print(doc['role']);

          // //get the token and store it by creating the collection
          // String? tokenRef = await _fcm.getToken();

          // final refToken = FirebaseFirestore.instance
          //     .collection('Users')
          //     .doc(userID)
          //     .collection('tokens')
          //     .doc(tokenRef);

          // await refToken.set({"token": tokenRef});

          if (doc['role'] == "admin") {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const AdminBookingPage(),
            ));
          } else {
            // Navigator.of(context).pushReplacement(MaterialPageRoute(
            //   builder: (context) => const BookingPage(),
            // ));
          }
        }
      } else {
        res = "Please enter all the fields";
      }
    }
    // if wants to costumize the error given by the firebase
    on FirebaseAuthException catch (e) {
      if (e.code == "wrong-password") {
        res = "Wrong password.";
      } else if (e.code == "user-not-found") {
        res = "User not found.";
      } else if (e.code == "invalid-email") {
        res = "Invalid Email.";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  /////////////////// Sign Out /////////////////
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
