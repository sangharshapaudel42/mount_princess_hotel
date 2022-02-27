import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:mount_princess_hotel/utils/utils.dart';

class AuthMethods {
  // creating the auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign Up user

  // Logging in user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some Error Occured";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "Success";
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

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
