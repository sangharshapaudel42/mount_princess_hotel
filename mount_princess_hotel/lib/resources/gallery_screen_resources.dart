import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:mount_princess_hotel/screens/customer/gallery_detail.dart';
import 'package:mount_princess_hotel/widgets/individual_gallery_category.dart';

class GalleryResources extends StatefulWidget {
  final String galleryImageCategory;
  final List<String> galleryImageCategoryList;
  final int galleryImageCategoryLength;
  GalleryResources({
    Key? key,
    required this.galleryImageCategory,
    required this.galleryImageCategoryList,
    required this.galleryImageCategoryLength,
  }) : super(key: key);

  @override
  State<GalleryResources> createState() => _GalleryResourcesState();
}

class _GalleryResourcesState extends State<GalleryResources> {
  StreamBuilder createCard() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Gallery')
          .doc(widget.galleryImageCategory)
          .collection('Images')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        print(widget.galleryImageCategory);
        // print(widget.galleryImageCategory.length);

        List<DocumentSnapshot> docs = (snapshot.data! as QuerySnapshot).docs;

        List<String> images = [];

        // print(widget.galleryImageCategoryList);

        docs.forEach((item) {
          images.add(item['image']);
        });
        // print(widget.galleryImageCategory.length);
        // print(widget.galleryImageCategoryList);
        print(images);
        print(images.length);
        // print(widget.galleryImageCategoryLength);

        return Container(
          height: MediaQuery.of(context).size.height,
          child: ListView.builder(
            itemCount: images.length,
            itemBuilder: (context, index) {
              return IndividualGalleryCategory(
                images: images,
                // galleryImageCategory: widget.galleryImageCategory,
                galleryImageCategory: widget.galleryImageCategoryList[index],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return createCard();
  }
}
