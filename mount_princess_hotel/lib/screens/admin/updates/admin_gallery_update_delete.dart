import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mount_princess_hotel/screens/admin/updates/add_gallery_image_screen.dart';
import 'package:mount_princess_hotel/screens/admin/updates/deleteImagePopUp.dart';

import '../../../utils/colors.dart';

class AdminGalleryUpdateDelete extends StatefulWidget {
  final String categoryId;
  const AdminGalleryUpdateDelete({Key? key, required this.categoryId})
      : super(key: key);

  @override
  State<AdminGalleryUpdateDelete> createState() =>
      _AdminGalleryUpdateDeleteState();
}

class _AdminGalleryUpdateDeleteState extends State<AdminGalleryUpdateDelete> {
  StreamBuilder categoryImages() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Gallery')
            .doc(widget.categoryId)
            .collection('Images')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          List<DocumentSnapshot> docs = (snapshot.data! as QuerySnapshot).docs;

          List<String> imageUrls = [];
          List<String> imageIds = [];

          docs.forEach((item) {
            imageUrls.add(item['image']);
            imageIds.add(item.id);
          });

          return Container(
            child: ListView.builder(
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: CachedNetworkImage(
                              imageUrl: imageUrls[index],
                              fit: BoxFit.fill,
                              maxHeightDiskCache:
                                  (MediaQuery.of(context).size.height / 2)
                                      .round()),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(Icons.delete),
                          color: Colors.black,
                          iconSize: 35,
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  DeletePopUpDialog(
                                categoryId: widget.categoryId,
                                imageId: imageIds[index],
                                deleteType: "gallery",
                              ),
                            );
                            print(imageUrls[index]);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: backgroundColor,
          title: Text('Add Delete Image ' + widget.categoryId),
          centerTitle: true,
        ),
        body: categoryImages(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    AddGalleryImageScreen(categoryId: widget.categoryId),
              ),
            );
          },
          backgroundColor: backgroundColor,
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 32,
          ),
        ),
      );
}
