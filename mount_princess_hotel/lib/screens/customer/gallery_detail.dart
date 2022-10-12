import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:mount_princess_hotel/utils/colors.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:pinch_zoom_image_updated/pinch_zoom_image_updated.dart';

class GalleryDetail extends StatelessWidget {
  final String galleryCategoryName;
  final List<String> imageUrls;
  const GalleryDetail({
    Key? key,
    required this.galleryCategoryName,
    required this.imageUrls,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(galleryCategoryName),
        centerTitle: true,
        backgroundColor: backgroundColor,
      ),
      body: ListView.builder(
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CachedNetworkImage(
                    imageUrl: imageUrls[index],
                    fit: BoxFit.fill,
                    maxHeightDiskCache:
                        (MediaQuery.of(context).size.height / 2.5).round()),
              ),
              /*child: PinchZoomImage(
                image: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                      imageUrl: imageUrls[index],
                      fit: BoxFit.fill,
                      maxHeightDiskCache:
                          (MediaQuery.of(context).size.height / 2).round()),
                ),
                hideStatusBarWhileZooming: true,
                zoomedBackgroundColor: const Color.fromRGBO(240, 240, 240, 1.0),
                onZoomStart: () {
                  print("zoom started");
                },
                onZoomEnd: () {
                  print("zoom ended.");
                },
              ),*/
            ),
          );
        },
      ),
    );
  }
}
