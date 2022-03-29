import 'package:flutter/material.dart';
import 'package:mount_princess_hotel/widgets/menus_screen_widget.dart';

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
        drawer: const AdminNavigationDrawerWidget(),
        appBar: AppBar(
          backgroundColor: backgroundColor,
          title: const Text('Manage Menus'),
          centerTitle: true,
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    'Food Categories',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 30),
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    // using same widget for both admin and customer
                    children: const [MenusScreenWidget()],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
