import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RoomsGalleryImage extends StatefulWidget {
  final String roomReferenceId;
  const RoomsGalleryImage({Key? key, required this.roomReferenceId})
      : super(key: key);

  @override
  State<RoomsGalleryImage> createState() => _RoomsGalleryImageState();
}

class _RoomsGalleryImageState extends State<RoomsGalleryImage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Rooms')
          .doc(widget.roomReferenceId)
          .collection("images")
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        List<QueryDocumentSnapshot> docs =
            (snapshot.data! as QuerySnapshot).docs;

        List<String> images = [];

        docs.forEach((item) {
          images.add(item['image']);
        });

        return SizedBox(
          height: MediaQuery.of(context).size.width / 3.5,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: images.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {},
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  width: MediaQuery.of(context).size.width / 3.5,
                  height: MediaQuery.of(context).size.width / 3.5,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(5)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: CachedNetworkImage(
                      imageUrl: images[index],
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
