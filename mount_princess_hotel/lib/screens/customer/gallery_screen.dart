import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mount_princess_hotel/widgets/individual_gallery_category.dart';

import 'package:mount_princess_hotel/widgets/navigation_drawer_widget.dart';
import 'package:mount_princess_hotel/utils/colors.dart';

class Gallery extends StatefulWidget {
  const Gallery({Key? key}) : super(key: key);

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  StreamBuilder createCard() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('Gallery').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        List<QueryDocumentSnapshot> docs =
            (snapshot.data! as QuerySnapshot).docs;

        List<String> galleryImageCategory = [];

        docs.forEach((item) {
          galleryImageCategory.add(item.id);
        });

        return SizedBox(
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).size.height / 9,
          child: ListView.builder(
            itemCount: galleryImageCategory.length,
            itemBuilder: (context, index) {
              // sending the id of gallery category
              return IndividualGalleryCategory(
                galleryImageCategory: galleryImageCategory[index],
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
          title: const Text('Gallery'),
          centerTitle: true,
          backgroundColor: backgroundColor,
        ),
        // whole page
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height / 90),
                createCard(),
              ],
            ),
          ),
        ),
      );
}
