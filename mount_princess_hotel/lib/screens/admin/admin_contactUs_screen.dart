import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../widgets/admin_navigation_drawer_widget.dart';

class AdminContactUs extends StatefulWidget {
  const AdminContactUs({Key? key}) : super(key: key);

  @override
  State<AdminContactUs> createState() => _AdminContactUsState();
}

class _AdminContactUsState extends State<AdminContactUs> {
  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: AdminNavigationDrawerWidget(),
        appBar: AppBar(
          backgroundColor: backgroundColor,
          title: const Text('Manage Contact Us'),
          centerTitle: true,
        ),
        body: Container(
          child: Center(
            child: Text("Admin Contact Us Screen"),
          ),
        ),
      );
}
