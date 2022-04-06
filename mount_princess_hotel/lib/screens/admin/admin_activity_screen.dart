import 'package:flutter/material.dart';
import 'package:mount_princess_hotel/screens/admin/widgets/activity_booking_cancel_widget.dart';
import 'package:mount_princess_hotel/screens/admin/widgets/activity_daily_report_widget.dart';
import 'package:mount_princess_hotel/screens/admin/widgets/activity_new_booking_widget.dart';
import 'package:mount_princess_hotel/widgets/admin_navigation_drawer_widget.dart';

import '../../utils/colors.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({Key? key}) : super(key: key);

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: const AdminNavigationDrawerWidget(),
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text('Activity'),
        centerTitle: true,
      ),
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.grey[100],
        child: SingleChildScrollView(
          child: Container(
            padding:
                const EdgeInsets.only(right: 10, left: 10, top: 15, bottom: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Today",
                  style: TextStyle(
                    color: Color(0xff0b29d6),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                buildNewBookingWidget(context),
                const SizedBox(height: 10),
                buildBookingCancelWidget(context),
                const SizedBox(height: 10),
                buildDailyReportWidget(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
