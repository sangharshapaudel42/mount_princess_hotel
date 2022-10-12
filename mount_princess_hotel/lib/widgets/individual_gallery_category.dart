import 'package:cached_network_image/cached_network_image.dart';
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
    var size = MediaQuery.of(context).size;

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
                    padding: EdgeInsets.symmetric(
                      horizontal: size.height / 75,
                    ),
                    child: Text(
                      widget.galleryImageCategory,
                      // widget.galleryImageCategory,
                      style: const TextStyle(
                        // color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: EdgeInsets.only(right: size.height / 65),
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
                          fontSize: 20.0,
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
                      height: MediaQuery.of(context).size.height / 3,
                      viewportFraction: 1,
                      enableInfiniteScroll: false,
                    ),
                    itemBuilder: (context, index, realIndex) {
                      final urlImage = images[index];
                      final newIndex = index + 1;

                      return buildImage(urlImage, newIndex, images.length);
                    }),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 160),
              const Divider(color: Colors.black, thickness: 1),
              SizedBox(height: MediaQuery.of(context).size.height / 160),
            ],
          );
        });
  }

  Widget buildImage(String urlImage, int newIndex, int totalImage) {
    var size = MediaQuery.of(context).size;

    return Container(
      // margin: const EdgeInsets.symmetric(horizontal: 5),
      color: Colors.transparent,
      child: Stack(
        children: <Widget>[
          Center(
            child: CachedNetworkImage(
              imageUrl: urlImage,
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(
                  top: size.height / 40, right: size.height / 45),
              child: Container(
                height: size.height / 30,
                width: size.height / 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[900],
                ),
                child: Center(
                  child: Text(
                    '$newIndex/$totalImage',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
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
}
