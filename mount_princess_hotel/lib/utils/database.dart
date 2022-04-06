import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _roomsCollection = _firestore.collection('rooms');

class Database {
  static String? userUid;

  static Stream<QuerySnapshot> readRoomsTypes() {
    CollectionReference roomsInfoItemCollection =
        _roomsCollection.doc(userUid).collection('items');

    return roomsInfoItemCollection.snapshots();
  }
}
