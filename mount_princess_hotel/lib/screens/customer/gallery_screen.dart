import 'package:flutter/material.dart';

import 'package:mount_princess_hotel/widgets/navigation_drawer_widget.dart';
import 'package:mount_princess_hotel/utils/colors.dart';

import 'package:mount_princess_hotel/resources/gallery_screen_resources.dart';

class Gallery extends StatefulWidget {
  const Gallery({Key? key}) : super(key: key);

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: NavigationDrawerWidget(),
        appBar: AppBar(
          title: const Text('Gallery'),
          centerTitle: true,
          backgroundColor: backgroundColor,
        ),
        // whole page
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    'Gallery',
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                const Divider(color: Colors.black, thickness: 1),
                GalleryResources(galleryImageCategory: "Dining"),
                GalleryResources(galleryImageCategory: "Rooms"),
                GalleryResources(galleryImageCategory: "Garden"),
                GalleryResources(galleryImageCategory: "Paking"),
              ],
            ),
          ),
        ),
      );
}
