import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../widgets/admin_navigation_drawer_widget.dart';

class AdminPackages extends StatefulWidget {
  const AdminPackages({Key? key}) : super(key: key);

  @override
  State<AdminPackages> createState() => _AdminPackagesState();
}

class _AdminPackagesState extends State<AdminPackages> {
  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: AdminNavigationDrawerWidget(),
        appBar: AppBar(
          backgroundColor: backgroundColor,
          title: const Text('Manage Packages'),
          centerTitle: true,
        ),
        body: Container(
          child: Center(
            child: Text("Admin Packages Screen"),
          ),
        ),
      );
}
