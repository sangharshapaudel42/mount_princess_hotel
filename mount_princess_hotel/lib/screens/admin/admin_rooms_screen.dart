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
          stream:
              _roomsCollection.orderBy("Price", descending: false).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            List<QueryDocumentSnapshot> docs =
                (snapshot.data! as QuerySnapshot).docs;

            List<String> names = [];
            List<String> images = [];
            List prices = [];
            List<String> roomReference = [];

            docs.forEach((item) {
              names.add(item['Name']);
              images.add(item['imgName']);
              prices.add(item['Price']);
              roomReference.add(item.id);
            });

            return ListView.builder(
                itemCount: names.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin:
                        const EdgeInsets.only(right: 15, left: 15, bottom: 20),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                            blurRadius: 15,
                            spreadRadius: 5,
                            color: Color.fromRGBO(0, 0, 0, .05))
                      ],
                    ),
                    child: Stack(
                      children: <Widget>[
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Opacity(
                              opacity: 0.85,
                              child: CachedNetworkImage(
                                imageUrl: images[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8, right: 8),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: ClipOval(
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => UpdateRooms(
                                        roomId: roomReference[index]),
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
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: MediaQuery.of(context).size.height / 13,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(20.0),
                                bottomRight: Radius.circular(20.0),
                              ),
                              gradient: LinearGradient(
                                end: const Alignment(0.0, 0.5),
                                begin: const Alignment(0.0, 0.10),
                                colors: <Color>[
                                  const Color(0x8A000000),
                                  Colors.black12.withOpacity(0.3),
                                ],
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Text(
                                      names[index],
                                      style: const TextStyle(
                                        fontSize: 25,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      'Price: \$' + prices[index].toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 25.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                });
            // return GridView.builder(
            //   itemCount: streamSnapshot.data!.docs.length,
            //   gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            //       maxCrossAxisExtent: 300,
            //       childAspectRatio: 0.8,
            //       crossAxisSpacing: 20,
            //       mainAxisSpacing: 20),
            //   itemBuilder: (context, index) {
            //     final DocumentSnapshot documentSnapshot =
            //         streamSnapshot.data!.docs[index];
            //     return Stack(
            //       children: <Widget>[
            //         Positioned.fill(
            //           child: ClipRRect(
            //             borderRadius: BorderRadius.circular(20.0),
            //             child: Opacity(
            //               opacity: 0.8,
            //               child: CachedNetworkImage(
            //                 imageUrl: documentSnapshot["imgName"],
            //                 fit: BoxFit.cover,
            //               ),
            //             ),
            //           ),
            //         ),
            //         Align(
            //           alignment: Alignment.topRight,
            //           // child: IconButton(
            //           //   icon: const Icon(Icons.edit),
            //           //   color: Colors.white,
            //           //   iconSize: 30,
            //           //   onPressed: () {},
            //           // ),
            //           child: ClipOval(
            //             child: InkWell(
            //               onTap: () {
            //                 Navigator.of(context).push(MaterialPageRoute(
            //                   builder: (context) =>
            //                       UpdateRooms(roomId: documentSnapshot.id),
            //                 ));
            //                 // _updateRoomInfo(documentSnapshot);
            //               },
            //               child: Container(
            //                 color: backgroundColor,
            //                 padding: const EdgeInsets.all(10),
            //                 child: const Icon(
            //                   Icons.edit,
            //                   size: 25,
            //                   color: Colors.white,
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ),
            //         Align(
            //           alignment: Alignment.bottomCenter,
            //           child: Container(
            //             height: 60,
            //             width: double.infinity,
            //             decoration: BoxDecoration(
            //               borderRadius: const BorderRadius.only(
            //                 bottomLeft: Radius.circular(20.0),
            //                 bottomRight: Radius.circular(20.0),
            //               ),
            //               gradient: LinearGradient(
            //                 end: const Alignment(0.0, 0.1),
            //                 begin: const Alignment(0.0, 0.15),
            //                 colors: <Color>[
            //                   const Color(0x8A000000),
            //                   Colors.black12.withOpacity(0.15),
            //                 ],
            //               ),
            //             ),
            //             child: Align(
            //               alignment: Alignment.centerLeft,
            //               child: Text(
            //                 documentSnapshot["Name"],
            //                 style: const TextStyle(
            //                   fontSize: 25,
            //                   color: Colors.white,
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ),
            //       ],
            //     );
            //   },
            // );
          },
        ),
      );
}
