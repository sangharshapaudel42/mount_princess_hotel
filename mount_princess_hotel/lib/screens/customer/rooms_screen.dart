import 'package:cloud_firestore/cloud_firestore.dart';
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
  StreamBuilder createCard() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Rooms')
          .orderBy("Price", descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        List<QueryDocumentSnapshot> docs =
            (snapshot.data! as QuerySnapshot).docs;

        List<String> names = [];
        List<String> images = [];
        List prices = [];
        List<String> roomReference = [];

        docs.forEach((item) {
          names.add(item['Name']);
          images.add(item['imgName']);
          prices.add(item['Price']);
          roomReference.add(item.id);
        });

        return SizedBox(
          height: MediaQuery.of(context).size.height,

          // new design
          child: ListView.builder(
            itemCount: names.length,
            itemBuilder: (context, index) {
              return RoomsScreenResources(
                name: names[index],
                imgName: images[index],
                price: prices[index].toString(),
                roomReferenceId: roomReference[index],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: NavigationDrawerWidget(),
        appBar: AppBar(
          title: const Text('Rooms'),
          centerTitle: true,
          backgroundColor: backgroundColor,
        ),
        body: Container(
          margin: const EdgeInsets.only(top: 30),
          height: MediaQuery.of(context).size.height,
          child: createCard(),
        ),
      );
}
