// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:kuple/Database/FirestoreServices.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:uuid/uuid.dart';
// import 'package:image/image.dart' as Im;

// class UploadService {
//   // Important Variable for different date
//   final _service = DatabaseService.instance;
//   String postId = Uuid().v4();

//   // Handle Function When User wants to take photo from camera.
//   Future<File> handleTakePhoto() async {
//     try {
//       File finalCroppedImageFile;
//       final picker = ImagePicker();
//       PickedFile pickedfile = await picker.getImage(
//         source: ImageSource.camera,
//       );
//       File file = File(pickedfile.path);
//       if (file != null) {
//         finalCroppedImageFile = await cropImage(file);
//       }
//       return finalCroppedImageFile;
//     } catch (e) {
//       print(e.toString());
//     }
//     return null;
//   }

//   // Handle Function When User wants to take photo from gallery.
//   Future<File> handleChooseFromGallery() async {
//     try {
//       File finalCroppedImageFile;
//       final picker = ImagePicker();
//       PickedFile pickedFile =
//           await picker.getImage(source: ImageSource.gallery);
//       File file = File(pickedFile.path);

//       if (file != null) {
//         finalCroppedImageFile = await cropImage(file);
//       }
//       return finalCroppedImageFile;
//     } catch (e) {
//       print(e.toString());
//     }
//     return null;
//   }

//   // Clears the Image Preview when user decides to cancel the selected Image.
//   bool clearImage() {
//     return true;
//   }

//   // Handle Function When User wants Crop the Image.
//   Future<File> cropImage(File picked) async {
//     try {
//       File croppedImage = await ImageCropper.cropImage(
//         aspectRatioPresets: [
//           CropAspectRatioPreset.square,
//         ],
//         sourcePath: picked.path,
//         androidUiSettings: AndroidUiSettings(
//             statusBarColor: Color(0xff202020),
//             toolbarWidgetColor: Colors.white,
//             activeControlsWidgetColor: Colors.pink,
//             cropFrameColor: Colors.pink,
//             toolbarColor: Color(0xff202020),
//             toolbarTitle: "Crop Image",
//             backgroundColor: Color(0xff202020)),
//       );
//       if (croppedImage != null) {
//         return croppedImage;
//       }
//       return null;
//     } catch (e) {
//       print(e.toString());
//     }
//     return null;
//   }

//   //Stores Image in Firbase Storage and returns back photoUrl
//   Future<String> uploadImage(File imageFile) async {
//     postId = postId + DateTime.now().toIso8601String();
//     try {
//       var imageUrl =
//           await _service.uploadImage(imageFile: imageFile, postId: postId);
//       return imageUrl;
//     } catch (e) {
//       print(e.toString());
//     }
//     return null;
//   }

//   //Creates post in Firebase cloudstore.
//   Future<void> createPostInFireStore({
//     String mediaUrl,
//     String locationL,
//     String descriptionD,
//   }) async {
//     try {
//       _service.createPostInFireStore(
//           mediaUrl: mediaUrl,
//           locationL: locationL,
//           descriptionD: descriptionD,
//           postId: postId);
//     } catch (e) {
//       print(e.toString());
//     }
//   }

//   Future<File> compressImage(File file) async {
//     final tempDir = await getTemporaryDirectory();
//     final path = tempDir.path;
//     Im.Image imageFile = Im.decodeImage(file.readAsBytesSync());
//     final compressedImagefile = File('$path/img_$postId.jpg')
//       ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 70));
//     return compressedImagefile;
//   }
// }
