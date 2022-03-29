import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mount_princess_hotel/screens/admin/updates/update_rooms.dart';

import '../../utils/colors.dart';
import '../../widgets/admin_navigation_drawer_widget.dart';

class AdminRooms extends StatefulWidget {
  const AdminRooms({Key? key}) : super(key: key);

  @override
  State<AdminRooms> createState() => _AdminRoomsState();
}

class _AdminRoomsState extends State<AdminRooms> {
  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: AdminNavigationDrawerWidget(),
        appBar: AppBar(
          backgroundColor: backgroundColor,
          title: const Text('Manage Rooms'),
          centerTitle: true,
        ),
        body: Container(
          margin: const EdgeInsets.only(top: 50),
          padding: const EdgeInsets.only(right: 10, left: 10),
          child: const AdminRoomPage(),
        ),
      );
}

class AdminRoomPage extends StatefulWidget {
  const AdminRoomPage({Key? key}) : super(key: key);

  @override
  _AdminRoomPageState createState() => _AdminRoomPageState();
}

class _AdminRoomPageState extends State<AdminRoomPage> {
  final _roomsCollection = FirebaseFirestore.instance.collection('Rooms');

  // Future<void> _updateRoomInfo([DocumentSnapshot? documentSnapshot]) async {
  //   final _roomInfos = FirebaseFirestore.instance
  //       .collection('Rooms')
  //       .doc(documentSnapshot!.id)
  //       .snapshots();

  //   await Navigator.of(context).push(MaterialPageRoute(
  //     builder: (context) => UpdateRooms(
  //       roomId: documentSnapshot.id,
  //     ),
  //   ));
  // }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder(
          stream: _roomsCollection.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (!streamSnapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return GridView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 300,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20),
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Opacity(
                          opacity: 0.8,
                          child: CachedNetworkImage(
                            imageUrl: documentSnapshot["imgName"],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      // child: IconButton(
                      //   icon: const Icon(Icons.edit),
                      //   color: Colors.white,
                      //   iconSize: 30,
                      //   onPressed: () {},
                      // ),
                      child: ClipOval(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  UpdateRooms(roomId: documentSnapshot.id),
                            ));
                            // _updateRoomInfo(documentSnapshot);
                          },
                          child: Container(
                            color: backgroundColor,
                            padding: const EdgeInsets.all(10),
                            child: const Icon(
                              Icons.edit,
                              size: 25,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0),
                          ),
                          gradient: LinearGradient(
                            end: const Alignment(0.0, 0.1),
                            begin: const Alignment(0.0, 0.15),
                            colors: <Color>[
                              const Color(0x8A000000),
                              Colors.black12.withOpacity(0.15),
                            ],
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            documentSnapshot["Name"],
                            style: const TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      );
}
