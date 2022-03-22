import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../widgets/admin_navigation_drawer_widget.dart';

class AdminMenus extends StatefulWidget {
  const AdminMenus({Key? key}) : super(key: key);

  @override
  State<AdminMenus> createState() => _AdminMenusState();
}

class _AdminMenusState extends State<AdminMenus> {
  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: AdminNavigationDrawerWidget(),
        appBar: AppBar(
          backgroundColor: backgroundColor,
          title: const Text('Manage Menus'),
          centerTitle: true,
        ),
        body: Container(
          child: Center(
            child: Text("Admin Menus Screen"),
          ),
        ),
      );
}
