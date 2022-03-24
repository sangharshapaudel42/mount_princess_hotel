import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mount_princess_hotel/utils/colors.dart';

class RoomDetailWidget extends StatefulWidget {
  final String name;
  final String image;
  final String price;
  final String description;
  const RoomDetailWidget(
      {Key? key,
      required this.name,
      required this.price,
      required this.image,
      required this.description})
      : super(key: key);

  @override
  State<RoomDetailWidget> createState() => _RoomDetailWidgetState();
}

class _RoomDetailWidgetState extends State<RoomDetailWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Container(
            //   foregroundDecoration: const BoxDecoration(
            //     color: Colors.black26,
            //     borderRadius: BorderRadius.only(
            //       bottomLeft: Radius.circular(30.0),
            //       bottomRight: Radius.circular(30.0),
            //     ),
            //   ),
            //   // width: MediaQuery.of(context).size.width,
            //   // color: backgroundColor,
            //   child: Stack(
            //     children: <Widget>[
            //       ClipRRect(
            //         borderRadius: const BorderRadius.only(
            //           bottomLeft: Radius.circular(30.0),
            //           bottomRight: Radius.circular(30.0),
            //         ),
            //         child: Image.asset(image, fit: BoxFit.cover),
            //       ),
            //       Container(
            //         alignment: Alignment.bottomCenter,
            //         child: Container(
            //           height: 80,
            //           color: Colors.red,
            //           child: Row(
            //             children: const <Widget>[
            //               Padding(
            //                 padding: EdgeInsets.symmetric(horizontal: 16.0),
            //                 child: Text(
            //                   "Single Bedroom",
            //                   style: TextStyle(
            //                       color: Colors.white,
            //                       fontSize: 28.0,
            //                       fontWeight: FontWeight.bold),
            //                 ),
            //               ),
            //               Spacer(),
            //               Padding(
            //                 padding: EdgeInsets.only(right: 20.0),
            //                 child: Text(
            //                   "\$ 200",
            //                   style: TextStyle(
            //                     color: Colors.white,
            //                     fontWeight: FontWeight.bold,
            //                     fontSize: 20.0,
            //                   ),
            //                 ),
            //               )
            //             ],
            //           ),
            //         ),
            //       )
            //     ],
            //   ),
            // ),
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
    // Stack(
    //   children: <Widget>[
    //     Container(
    //       foregroundDecoration: const BoxDecoration(color: Colors.black26),
    //       // height: 400,
    //       width: MediaQuery.of(context).size.width,
    //       // maxheight
    //       color: backgroundColor,
    //       child: Stack(
    //         children: <Widget>[
    //           Image.asset(image, fit: BoxFit.cover),
    //           Align(
    //             alignment: Alignment.bottomLeft,
    //           )
    //         ],
    //       ),
    //     ),
    //     SingleChildScrollView(
    //       padding: const EdgeInsets.only(top: 16.0, bottom: 20.0),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: <Widget>[
    //           const SizedBox(height: 300),
    //           Row(
    //             children: const <Widget>[
    //               Padding(
    //                 padding: EdgeInsets.symmetric(horizontal: 16.0),
    //                 child: Text(
    //                   "Single Bedroom",
    //                   style: TextStyle(
    //                       color: Colors.white,
    //                       fontSize: 28.0,
    //                       fontWeight: FontWeight.bold),
    //                 ),
    //               ),
    //               Spacer(),
    //               Padding(
    //                 padding: EdgeInsets.only(right: 20.0),
    //                 child: Text(
    //                   "\$ 200",
    //                   style: TextStyle(
    //                     color: Colors.white,
    //                     fontWeight: FontWeight.bold,
    //                     fontSize: 20.0,
    //                   ),
    //                 ),
    //               )
    //             ],
    //           ),
    //           const SizedBox(height: 20),
    //           Container(
    //             padding: const EdgeInsets.all(32.0),
    //             color: Colors.white,
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               mainAxisSize: MainAxisSize.min,
    //               children: <Widget>[
    //                 Text(
    //                   "Description".toUpperCase(),
    //                   style: const TextStyle(
    //                       fontWeight: FontWeight.w600, fontSize: 14.0),
    //                 ),
    //                 const SizedBox(height: 10.0),
    //                 const Text(
    //                   "Lorem ipsum dolor sit, amet consectetur adipisicing elit. Ratione architecto autem quasi nisi iusto eius ex dolorum velit! Atque, veniam! Atque incidunt laudantium eveniet sint quod harum facere numquam molestias?",
    //                   textAlign: TextAlign.justify,
    //                   style: TextStyle(
    //                       fontWeight: FontWeight.w300, fontSize: 14.0),
    //                 ),
    //                 const SizedBox(height: 10.0),
    //                 const Text(
    //                   'hello',
    //                   // "Lorem ipsum dolor sit, amet consectetur adipisicing elit. Ratione architecto autem quasi nisi iusto eius ex dolorum velit! Atque, veniam! Atque incidunt laudantium eveniet sint quod harum facere numquam molestias?",
    //                   textAlign: TextAlign.justify,
    //                   style: TextStyle(
    //                       fontWeight: FontWeight.w300, fontSize: 14.0),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ],
    // ),
  }
}
