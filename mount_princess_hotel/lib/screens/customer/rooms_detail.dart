import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:mount_princess_hotel/utils/colors.dart';
import 'package:mount_princess_hotel/widgets/room_detail_widget.dart';

class RoomDetailPage extends StatefulWidget {
  final String roomReferenceId;
  final String name;
  const RoomDetailPage(
      {Key? key, required this.roomReferenceId, required this.name})
      : super(key: key);

  @override
  State<RoomDetailPage> createState() => _RoomDetailPageState();
}

class _RoomDetailPageState extends State<RoomDetailPage> {
  StreamBuilder createCard() {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Rooms')
          .doc(widget.roomReferenceId)
          .snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        Map<String, dynamic> data =
            snapshot.data!.data() as Map<String, dynamic>;

        var roomName = data['Name'];
        var image = data['imgName'];
        var price = data['Price'];
        var description = data['Description'];

        return SizedBox(
          height: MediaQuery.of(context).size.height,
          child: RoomDetailWidget(
            name: roomName,
            price: price.toString(),
            image: image,
            description: description,
            roomReferenceId: widget.roomReferenceId,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.name),
          centerTitle: true,
          backgroundColor: backgroundColor,
        ),
        body: createCard());
  }
}
