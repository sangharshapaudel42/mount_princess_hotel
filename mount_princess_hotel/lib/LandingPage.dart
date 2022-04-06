import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mount_princess_hotel/screens/admin/admin_booking_screen.dart';
import 'package:mount_princess_hotel/screens/admin/admin_home_page.dart';
import 'package:mount_princess_hotel/screens/customer/booking_screen.dart';

class LandingPage extends StatefulWidget {
  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool isLoading = false;
  bool isAdmin = false;
  String? userId = "";
  Future<void> checkUserRole() async {
    setState(() {
      isLoading = true;
    });
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get();
      isAdmin = doc['role'] == "admin";
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void generateUid() async {
    setState(() {
      isLoading = true;
    });
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        userId = FirebaseAuth.instance.currentUser?.uid;
      }
    } catch (e) {
      setState(() {
        isLoading = true;
      });
    }
  }

  @override
  void initState() {
    generateUid();
    checkUserRole();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : isAdmin
            ? const AdminBookingPage()
            : const BookingPage();
  }
}
