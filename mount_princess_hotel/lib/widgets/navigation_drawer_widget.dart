import 'package:flutter/material.dart';

import 'package:mount_princess_hotel/screens/admin/admin_login_screen.dart';
import 'package:mount_princess_hotel/utils/colors.dart';

import 'package:mount_princess_hotel/screens/customer/aboutUs.dart';
import 'package:mount_princess_hotel/screens/customer/contactUs.dart';
import 'package:mount_princess_hotel/screens/customer/rooms_screen.dart';
import 'package:mount_princess_hotel/screens/customer/gallery_screen.dart';
import 'package:mount_princess_hotel/screens/customer/packages_screen.dart';
import 'package:mount_princess_hotel/screens/customer/menus_screen.dart';
import 'package:mount_princess_hotel/screens/customer/booking_status_screen.dart';
import 'package:mount_princess_hotel/screens/customer/booking_screen.dart';

class NavigationDrawerWidget extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 20);
  NavigationDrawerWidget({Key? key}) : super(key: key);

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
              text: 'Booking',
              icon: Icons.library_books_outlined,
              onClicked: () => selectedItem(context, 0),
            ),
            const SizedBox(height: 10),
            buildMenuItem(
              text: 'Gallery',
              icon: Icons.photo_album,
              onClicked: () => selectedItem(context, 1),
            ),
            const SizedBox(height: 10),
            buildMenuItem(
              text: 'Rooms',
              icon: Icons.room_service,
              onClicked: () => selectedItem(context, 2),
            ),
            const SizedBox(height: 10),
            buildMenuItem(
              text: 'Menus',
              icon: Icons.menu,
              onClicked: () => selectedItem(context, 3),
            ),
            const SizedBox(height: 10),
            buildMenuItem(
              text: 'Packages',
              icon: Icons.account_tree_outlined,
              onClicked: () => selectedItem(context, 4),
            ),
            const SizedBox(height: 10),
            buildMenuItem(
              text: 'Booking Status',
              icon: Icons.notifications_outlined,
              onClicked: () => selectedItem(context, 5),
            ),
            const SizedBox(height: 10),
            buildMenuItem(
              text: 'Admin Login',
              icon: Icons.login_outlined,
              onClicked: () => selectedItem(context, 6),
            ),
            const SizedBox(height: 10),
            buildMenuItem(
              text: 'About Us',
              icon: Icons.info,
              onClicked: () => selectedItem(context, 7),
            ),
            const SizedBox(height: 10),
            buildMenuItem(
              text: 'Contact Us',
              icon: Icons.contact_phone_outlined,
              onClicked: () => selectedItem(context, 8),
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
          builder: (context) => const BookingPage(),
        ));
        break;
      case 1:
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const Gallery(),
        ));
        break;
      case 2:
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const Rooms(),
        ));
        break;
      case 3:
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const Menus(),
        ));
        break;
      case 4:
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const Packages(),
        ));
        break;
      case 5:
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const BookingStatus(),
        ));
        break;
      case 6:
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const Login(),
        ));
        break;
      case 7:
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const AboutUs(),
        ));
        break;
      case 8:
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ContactUs(),
        ));
        break;
    }
  }
}
