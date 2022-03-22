import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../widgets/admin_navigation_drawer_widget.dart';

class AdminBookingPage extends StatefulWidget {
  const AdminBookingPage({Key? key}) : super(key: key);

  @override
  State<AdminBookingPage> createState() => _AdminBookingPageState();
}

class _AdminBookingPageState extends State<AdminBookingPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: AdminNavigationDrawerWidget(),
        appBar: AppBar(
          backgroundColor: backgroundColor,
          title: const Text('Manage Booking'),
          centerTitle: true,
        ),
        body: Container(
          child: Center(
            child: Text("Admin Booking Screen"),
          ),
        ),
      );
}
