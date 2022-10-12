import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mount_princess_hotel/utils/colors.dart';
import 'package:mount_princess_hotel/widgets/rooms_gallery_widget.dart';

class RoomDetailWidget extends StatefulWidget {
  final String name;
  final String image;
  final String price;
  final String description;
  final String roomReferenceId;
  const RoomDetailWidget({
    Key? key,
    required this.name,
    required this.price,
    required this.image,
    required this.description,
    required this.roomReferenceId,
  }) : super(key: key);

  @override
  State<RoomDetailWidget> createState() => _RoomDetailWidgetState();
}

class _RoomDetailWidgetState extends State<RoomDetailWidget> {
  late Future roomGalleryInfos;
  List roomGalleryImages = [];

  String mainImage = "";

  @override
  void initState() {
    super.initState();
    roomGalleryInfos = getRoomsGalleryDocs();
  }

  // getting gallery images of that room.
  Future getRoomsGalleryDocs() async {
    var data = await FirebaseFirestore.instance
        .collection("Rooms")
        .doc(widget.roomReferenceId)
        .collection("images")
        .get();
    setState(() {
      roomGalleryImages = data.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            SizedBox(
              width: size.width,
              height: size.height / 2.3,
              child: CachedNetworkImage(
                // changing the mainImage to galleryImage after click.
                imageUrl: mainImage == "" ? widget.image : mainImage,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              // this is responsiable for the curve effect
              margin: EdgeInsets.only(top: size.height * 0.36),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(50)),
              // inside curve part
              child: Padding(
                padding: EdgeInsets.all(size.width / 17),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // name, description part
                  children: <Widget>[
                    // red line
                    Align(
                      child: Container(
                        width: size.width / 2.8,
                        height: size.width / 60,
                        decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Room name and price
                        Row(
                          children: <Widget>[
                            Text(
                              widget.name,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'Price: \$' + widget.price,
                              style: const TextStyle(
                                color: backgroundColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 19.0,
                              ),
                            ),
                          ],
                        ),
                        //  END OF Room name and price //////

                        const SizedBox(height: 20.0),
                        Text(
                          "Gallery".toUpperCase(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        const SizedBox(height: 20.0),
                        // Room Gallery Images
                        // RoomsGalleryImage(
                        //     roomReferenceId: widget.roomReferenceId),
                        SizedBox(
                          height: MediaQuery.of(context).size.width / 3.5,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: roomGalleryImages.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () => setState(() {
                                  mainImage = roomGalleryImages[index]["image"];
                                }),
                                child: Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  width: size.width / 3.5,
                                  height: size.width / 3.5,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: CachedNetworkImage(
                                      imageUrl: roomGalleryImages[index]
                                          ["image"],
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        // Description
                        const SizedBox(height: 20.0),
                        Text(
                          "Description".toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 18.0,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          widget.description,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(height: size.height / 38),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

/* class _RoomDetailWidgetState extends State<RoomDetailWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ),
              child: CachedNetworkImage(
                imageUrl: widget.image.toString(),
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(25.0),
              // color: Colors.grey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // Room name and price
                  Row(
                    children: <Widget>[
                      Text(
                        widget.name,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Text(
                        'Price: ' + widget.price,
                        style: const TextStyle(
                          color: backgroundColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ],
                  ),
                  //  END OF Room name and price //////
                  const SizedBox(height: 10.0),
                  Text(
                    "Description".toUpperCase(),
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14.0),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    widget.description,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                        fontWeight: FontWeight.w300, fontSize: 20.0),
                  ),
                  const SizedBox(height: 10.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/
