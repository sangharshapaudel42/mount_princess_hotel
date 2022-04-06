import 'package:cloud_firestore/cloud_firestore.dart';
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
  StreamBuilder createCard() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("Packages").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        List<QueryDocumentSnapshot> docs =
            (snapshot.data! as QuerySnapshot).docs;

        List names = [];
        List descriptions = [];
        List prices = [];

        docs.forEach((item) {
          names.add(item['name']);
          descriptions.add(item['description']);
          prices.add(item['price']);
        });

        return Container(
          height: MediaQuery.of(context).size.height - 80,
          child: ListView.builder(
            itemCount: names.length,
            itemBuilder: (context, index) {
              return PackagesResource(
                packageName: names[index],
                packageDescription: descriptions[index],
                price: prices[index],
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
          title: const Text('Packages'),
          centerTitle: true,
          backgroundColor: backgroundColor,
        ),
        body: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                createCard(),
              ],
            ),
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