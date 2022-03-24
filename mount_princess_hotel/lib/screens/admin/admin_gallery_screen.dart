import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mount_princess_hotel/screens/admin/updates/admin_gallery_update_delete.dart';
import '../../utils/colors.dart';
import '../../widgets/admin_navigation_drawer_widget.dart';

class AdminGallery extends StatefulWidget {
  const AdminGallery({Key? key}) : super(key: key);

  @override
  State<AdminGallery> createState() => _AdminGalleryState();
}

class _AdminGalleryState extends State<AdminGallery> {
  StreamBuilder galleryCategories() {
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

        List<String> galleryImageCategories = [];

        docs.forEach((item) {
          galleryImageCategories.add(item.id);
        });

        return SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
              itemCount: galleryImageCategories.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AdminGalleryUpdateDelete(
                                categoryId: galleryImageCategories[index],
                              )),
                    );
                  },
                  child: Card(
                    color: Colors.grey[300],
                    margin: const EdgeInsets.only(top: 20, right: 10, left: 10),
                    child: ListTile(
                      title: Text(galleryImageCategories[index],
                          style: const TextStyle(
                            fontSize: 25,
                          )),
                      trailing: const SizedBox(
                        width: 35,
                        child: IconButton(
                            iconSize: 30,
                            icon: Icon(Icons.edit),
                            onPressed: null),
                      ),
                    ),
                  ),
                );
              }),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: const AdminNavigationDrawerWidget(),
        appBar: AppBar(
          backgroundColor: backgroundColor,
          title: const Text('Manage Gallery'),
          centerTitle: true,
        ),
        body: galleryCategories(),
      );
}
