import 'package:cached_network_image/cached_network_image.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.3,
              child: CachedNetworkImage(
                imageUrl: widget.image.toString(),
                fit: BoxFit.cover,
              ),
            ),
            Container(
              // this is responsiable for the curve effect
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.36),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(50)),
              // inside curve part
              child: Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width / 17),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // name, description part
                  children: <Widget>[
                    // red line
                    Align(
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2.8,
                        height: MediaQuery.of(context).size.width / 60,
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
                        RoomsGalleryImage(
                            roomReferenceId: widget.roomReferenceId),

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
                        const SizedBox(height: 10.0),
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
