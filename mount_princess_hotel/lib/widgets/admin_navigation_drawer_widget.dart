import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mount_princess_hotel/screens/admin/admin_activity_screen.dart';
import 'package:mount_princess_hotel/screens/admin/admin_availability_screen.dart';
import 'package:mount_princess_hotel/screens/welcome_screen.dart';

import 'package:mount_princess_hotel/utils/colors.dart';

import 'package:mount_princess_hotel/screens/admin/admin_rooms_screen.dart';
import 'package:mount_princess_hotel/screens/admin/admin_gallery_screen.dart';
import 'package:mount_princess_hotel/screens/admin/admin_packages_screen.dart';
import 'package:mount_princess_hotel/screens/admin/admin_menus_screen.dart';
import 'package:mount_princess_hotel/screens/admin/admin_booking_screen.dart';

class AdminNavigationDrawerWidget extends StatelessWidget {
  final padding = const EdgeInsets.symmetric(horizontal: 20);
  const AdminNavigationDrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: backgroundColor,
        child: ListView(
          padding: padding,
          children: <Widget>[
            const SizedBox(
              height: 55,
            ),
            buildMenuItem(
              text: 'Bookings',
              icon: Icons.list,
              onClicked: () => selectedItem(context, 0),
            ),
            buildMenuItem(
              text: 'Activity',
              icon: Icons.monitor_heart_outlined,
              onClicked: () => selectedItem(context, 1),
            ),
            buildMenuItem(
              text: 'Availability',
              icon: Icons.calendar_month,
              onClicked: () => selectedItem(context, 2),
            ),
            const SizedBox(height: 10),
            buildMenuItem(
              text: 'Manage Gallery',
              icon: Icons.photo_album,
              onClicked: () => selectedItem(context, 3),
            ),
            const SizedBox(height: 10),
            buildMenuItem(
              text: 'Manage Rooms',
              icon: Icons.room_service,
              onClicked: () => selectedItem(context, 4),
            ),
            const SizedBox(height: 10),
            buildMenuItem(
              text: 'Manage Menus',
              icon: Icons.menu,
              onClicked: () => selectedItem(context, 5),
            ),
            const SizedBox(height: 10),
            buildMenuItem(
              text: 'Manage Packages',
              icon: Icons.account_tree_outlined,
              onClicked: () => selectedItem(context, 6),
            ),
            const SizedBox(height: 10),
            buildMenuItem(
              text: 'Sign Out',
              icon: Icons.login_outlined,
              onClicked: () => selectedItem(context, 7),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.white;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color, fontSize: 18)),
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();

    switch (index) {
      case 0:
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const AdminBookingPage(),
        ));
        break;
      case 1:
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ActivityPage(),
        ));
        break;
      case 2:
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const AvailabilityPage(),
        ));
        break;
      case 3:
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const AdminGallery(),
        ));
        break;
      case 4:
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const AdminRooms(),
        ));
        break;
      case 5:
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const AdminMenus(),
        ));
        break;
      case 6:
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const AdminPackages(),
        ));
        break;
      case 7:
        FirebaseAuth.instance.signOut();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const WelcomePage(),
        ));
        break;
    }
  }
}
