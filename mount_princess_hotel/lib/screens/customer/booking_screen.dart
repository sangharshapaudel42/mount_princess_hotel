import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:mount_princess_hotel/widgets/navigation_drawer_widget.dart';
import 'package:mount_princess_hotel/utils/colors.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({Key? key}) : super(key: key);

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        // if we want the navbar to be in the right side 'endDrawer'
        drawer: NavigationDrawerWidget(),
        appBar: AppBar(
          backgroundColor: backgroundColor,
          title: SvgPicture.asset(
            "assets/images/logo.svg",
            width: MediaQuery.of(context).size.width * 0.75,
          ),
          // toolbarHeight: MediaQuery.of(context).size.height * 0.20,
        ),
      );
}
