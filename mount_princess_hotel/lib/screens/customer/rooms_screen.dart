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
      stream: FirebaseFirestore.instance.collection('Rooms').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        List<QueryDocumentSnapshot> docs =
            (snapshot.data! as QuerySnapshot).docs;

        List names = [];
        List images = [];
        List roomReference = [];

        docs.forEach((item) {
          names.add(item['Name']);
          images.add(item['imgName']);
          roomReference.add(item.id);
        });

        return Container(
          height: MediaQuery.of(context).size.height,
          child: GridView.builder(
            itemCount: names.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300,
                childAspectRatio: 0.8,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10),
            itemBuilder: (context, index) {
              return RoomsScreenResources(
                name: names[index],
                imgName: images[index],
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
          margin: const EdgeInsets.only(top: 50),
          height: MediaQuery.of(context).size.height,
          child: createCard(),
        ),
      );
}
