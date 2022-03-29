import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mount_princess_hotel/screens/customer/gallery_detail.dart';

class IndividualGalleryCategory extends StatefulWidget {
  final String galleryImageCategory;

  const IndividualGalleryCategory(
      {Key? key, required this.galleryImageCategory})
      : super(key: key);

  @override
  State<IndividualGalleryCategory> createState() =>
      _IndividualGalleryCategoryState();
}

class _IndividualGalleryCategoryState extends State<IndividualGalleryCategory> {
  @override
  Widget build(BuildContext context) {
    // One category container
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

          List<DocumentSnapshot> docs = (snapshot.data! as QuerySnapshot).docs;

          List<String> images = [];

          docs.forEach((item) {
            images.add(item['image']);
          });

          return Column(
            children: <Widget>[
              // Category name and view all
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 5.0),
                    child: Text(
                      widget.galleryImageCategory,
                      // widget.galleryImageCategory,
                      style: const TextStyle(
                        // color: Colors.white,
                        fontSize: 25.0,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GalleryDetail(
                              galleryCategoryName: widget.galleryImageCategory,
                              imageUrls: images,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        "View all",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 25.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Center(
                child: CarouselSlider.builder(
                    itemCount: images.length,
                    options: CarouselOptions(
                      height: MediaQuery.of(context).size.height / 2.5,
                      viewportFraction: 1,
                      enableInfiniteScroll: false,
                    ),
                    itemBuilder: (context, index, realIndex) {
                      final urlImage = images[index];
                      final newIndex = index + 1;

                      return buildImage(urlImage, newIndex, images.length);
                    }),
              ),
              const SizedBox(height: 5),
              const Divider(color: Colors.black, thickness: 1),
              const SizedBox(height: 5),
            ],
          );
        });
  }

  Widget buildImage(String urlImage, int newIndex, int totalImage) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        color: Colors.transparent,
        child: Stack(
          children: <Widget>[
            Center(
              child: Image.network(
                urlImage,
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 10, right: 15),
                child: Container(
                  height: 40,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[900],
                  ),
                  child: Center(
                    child: Text(
                      '$newIndex/$totalImage',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
