import 'dart:io';

import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  String galleryImageId = const Uuid().v4();

  Future<String> uploadImageToStorage(
    String childName,
    String imageName,
    File file,
  ) async {
    // creating location to our firebase storage
    Reference ref =
        _storage.ref().child("Images").child(childName).child(imageName);

    // uploading file in the storage
    UploadTask uploadTask = ref.putFile(file);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  // adding gallery image to firebase storage
  Future<String> uploadGalleryMenusImageToStorage(
      String childName, String categoryId, String imageName, File file) async {
    if (imageName == "") {
      imageName = galleryImageId;
    }
    // creating location to our firebase storage
    Reference ref = _storage
        .ref("Images")
        .child(childName)
        .child(categoryId)
        .child(imageName);

    // uploading file in the storage
    UploadTask uploadTask = ref.putFile(file);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
