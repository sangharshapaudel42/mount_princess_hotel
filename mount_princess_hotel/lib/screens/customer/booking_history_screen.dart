import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mount_princess_hotel/widgets/booking_cancel_widget.dart';

import 'package:mount_princess_hotel/widgets/navigation_drawer_widget.dart';
import 'package:mount_princess_hotel/utils/colors.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

class BookingHistory extends StatefulWidget {
  const BookingHistory({Key? key}) : super(key: key);

  @override
  _BookingHistoryState createState() => _BookingHistoryState();
}

class _BookingHistoryState extends State<BookingHistory> {
  @override
  Widget build(BuildContext context) {
    // current user uid
    final user = FirebaseAuth.instance.currentUser!;
    final userID = user.uid;

    return Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        title: const Text('Booking History'),
        centerTitle: true,
        backgroundColor: backgroundColor,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Booking')
              .where("bookingCancel", isEqualTo: false)
              .where("uid", isEqualTo: userID)
              .orderBy("bookingDate", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            List<QueryDocumentSnapshot> docs =
                (snapshot.data! as QuerySnapshot).docs;

            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.grey[100],
              child: ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  return buildBookingCancelWidget(context, docs[index]);
                },
              ),
            );
          }),
    );
  }
}
