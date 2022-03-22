import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../widgets/admin_navigation_drawer_widget.dart';

class AdminAboutUs extends StatefulWidget {
  const AdminAboutUs({Key? key}) : super(key: key);

  @override
  State<AdminAboutUs> createState() => _AdminAboutUsState();
}

class _AdminAboutUsState extends State<AdminAboutUs> {
  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: AdminNavigationDrawerWidget(),
        appBar: AppBar(
          backgroundColor: backgroundColor,
          title: const Text('Manage About Us'),
          centerTitle: true,
        ),
        body: Container(
          child: Center(
            child: Text("Admin About Us Screen"),
          ),
        ),
      );
}
