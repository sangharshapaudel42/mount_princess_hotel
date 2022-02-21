import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:mount_princess_hotel/screens/customer/gallery_detail.dart';

class GalleryResources extends StatelessWidget {
  final urlImages = [
    'https://images.unsplash.com/photo-1558981403-c5f9899a28bc?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
    'https://images.unsplash.com/photo-1532298229144-0ec0c57515c7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1122&q=80',
    'https://images.unsplash.com/photo-1571068316344-75bc76f77890?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
    'https://images.unsplash.com/photo-1602148740250-0a4750e232e9?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
    'https://images.unsplash.com/photo-1505705694340-019e1e335916?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1332&q=80',
  ];
  final String galleryImageCategory;
  GalleryResources({Key? key, required this.galleryImageCategory})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return // One category container
        Column(
      children: <Widget>[
        // Category name and view all
        Row(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
              child: Text(
                galleryImageCategory,
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
                        galleryCategoryName: galleryImageCategory,
                        imageUrls: urlImages,
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
              itemCount: urlImages.length,
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height / 2.5,
                viewportFraction: 1,
                enableInfiniteScroll: false,
              ),
              itemBuilder: (context, index, realIndex) {
                final urlImage = urlImages[index];
                final newIndex = index + 1;

                return buildImage(urlImage, newIndex, urlImages.length);
              }),
        ),
        const SizedBox(height: 5),
        const Divider(color: Colors.black, thickness: 1),
        const SizedBox(height: 5),
      ],
    );
  }

  Widget buildImage(String urlImage, int newIndex, int totalImage) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        color: Colors.transparent,
        child: Stack(
          children: <Widget>[
            Image.network(
              urlImage,
              fit: BoxFit.cover,
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
