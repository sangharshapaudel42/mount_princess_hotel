import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mount_princess_hotel/models/booking.dart';
import 'package:mount_princess_hotel/utils/colors.dart';

class DetailBookingPage extends StatefulWidget {
  final DocumentSnapshot document;
  const DetailBookingPage({Key? key, required this.document}) : super(key: key);

  @override
  State<DetailBookingPage> createState() => _DetailBookingPageState();
}

class _DetailBookingPageState extends State<DetailBookingPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: backgroundColor,
          title: const Text('Booking Detail'),
          centerTitle: true,
        ),
        body: Container(
          child: Center(
            child: Text(widget.document["name"]),
          ),
        ),
      );
}
