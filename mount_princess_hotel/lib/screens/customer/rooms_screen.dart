import 'package:flutter/material.dart';

import 'package:mount_princess_hotel/widgets/navigation_drawer_widget.dart';
import 'package:mount_princess_hotel/utils/colors.dart';

import 'package:mount_princess_hotel/resources/rooms_screen_resources.dart';

class Rooms extends StatefulWidget {
  const Rooms({Key? key}) : super(key: key);

  @override
  _RoomsState createState() => _RoomsState();
}

class _RoomsState extends State<Rooms> {
  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: NavigationDrawerWidget(),
        appBar: AppBar(
          title: const Text('Rooms'),
          centerTitle: true,
          backgroundColor: backgroundColor,
        ),
        body: Container(
          margin: const EdgeInsets.only(top: 50),
          height: MediaQuery.of(context).size.height,
          child: GridView.count(
            shrinkWrap: false,
            primary: false,
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 0.8,
            children: const [
              RoomsScreenResources(
                name: "Single Room",
                imgName: 'assets/images/single_room.jfif',
              ),
              RoomsScreenResources(
                name: "Standard Room",
                imgName: 'assets/images/single_room.jfif',
              ),
              RoomsScreenResources(
                name: "Delux Room",
                imgName: 'assets/images/single_room.jfif',
              ),
            ],
          ),
        ),
      );
}
