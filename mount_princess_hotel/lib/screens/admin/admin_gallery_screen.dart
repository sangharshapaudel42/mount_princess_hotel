import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../widgets/admin_navigation_drawer_widget.dart';

class AdminGallery extends StatefulWidget {
  const AdminGallery({Key? key}) : super(key: key);

  @override
  State<AdminGallery> createState() => _AdminGalleryState();
}

class _AdminGalleryState extends State<AdminGallery> {
  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: AdminNavigationDrawerWidget(),
        appBar: AppBar(
          backgroundColor: backgroundColor,
          title: const Text('Manage Gallery'),
          centerTitle: true,
        ),
        body: Container(
          child: Center(
            child: Text("Admin Gallery Screen"),
          ),
        ),
      );
}
