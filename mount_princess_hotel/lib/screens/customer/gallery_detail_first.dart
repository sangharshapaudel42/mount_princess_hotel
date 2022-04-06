import 'package:flutter/material.dart';

import 'package:mount_princess_hotel/utils/colors.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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
      // body: Container(
      //   // color: Colors.grey,
      //   margin: const EdgeInsets.only(top: 20, right: 10, left: 10, bottom: 5),
      //   height: MediaQuery.of(context).size.height,
      //   child: GridView.count(
      //     shrinkWrap: false,
      //     primary: false,
      //     crossAxisCount: 2,
      //     crossAxisSpacing: 15,
      //     // mainAxisSpacing: 15,
      //     childAspectRatio: 1.0,
      //     children: <Widget>[
      //       // ListView.builder(
      //       //   scrollDirection: Axis.horizontal,
      //       //   itemCount: imageUrls.length,
      //       //   itemBuilder: (context, index) {
      //       //     final urlImage = imageUrls[index];
      //       //     return Image.network(
      //       //       urlImage,
      //       //       fit: BoxFit.cover,
      //       //     );
      //       //   },
      //       // ),
      //       for (var image in imageUrls)
      //         Image.network(
      //           image,
      //           // fit: BoxFit.cover,
      //         )
      //     ],
      //   ),
      // ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 12.0),
          child: Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18.0),
              child: StaggeredGridView.countBuilder(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                itemCount: imageUrls.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        imageUrls[index],
                        fit: BoxFit.fill,
                      ),
                    ),
                  );
                },
                staggeredTileBuilder: (index) {
                  return new StaggeredTile.count(1, index.isEven ? 1.0 : 1.2);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
