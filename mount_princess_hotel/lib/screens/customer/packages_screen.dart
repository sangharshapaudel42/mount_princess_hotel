import 'package:flutter/material.dart';

import 'package:mount_princess_hotel/widgets/navigation_drawer_widget.dart';
import 'package:mount_princess_hotel/utils/colors.dart';
import 'package:mount_princess_hotel/resources/packages_screen_resources.dart';

class Packages extends StatefulWidget {
  const Packages({Key? key}) : super(key: key);

  @override
  _PackagesState createState() => _PackagesState();
}

class _PackagesState extends State<Packages> {
  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: NavigationDrawerWidget(),
        appBar: AppBar(
          title: const Text('Packages'),
          centerTitle: true,
          backgroundColor: backgroundColor,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: const <Widget>[
              SizedBox(height: 40),
              PackagesResource(
                packageName: 'Bed and Breakfast double - BB',
                price: '25',
              ),
              PackagesResource(
                packageName: 'Diner, breakfast and bed double - MAP',
                price: '35',
              ),
              PackagesResource(
                packageName: 'Dinner, lunch, breakfast and bed double - AP',
                price: '45',
              ),
              PackagesResource(
                packageName: 'Seminar package purposnal',
                price: '25',
              ),
            ],
          ),
        ),
      );
}

// - Bed and Breakfast double (BB)
// (Price $25)
// - Diner, breakfast and bed double (MAP)
// (Price $35)
// - Dinner, lunch, breakfast and bed double(AP)
// (Price: $45)
// - Seminar package purposnal
// (price $25)