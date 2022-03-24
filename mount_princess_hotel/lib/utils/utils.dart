import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as Im;

// for picking image from the gallery if source is 'ImageSource.gallery'
// for picking image from the camera if source is 'ImageSource.camera'
Future pickImage(ImageSource source) async {
  final _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source);

  if (_file != null) {
    return File(_file.path);
  }
  print('No Image Selected');
}

// compressing the image
Future<File> compressImage(File file) async {
  String postId = Uuid().v4();
  final tempDir = await getTemporaryDirectory();
  final path = tempDir.path;
  Im.Image? imageFile = Im.decodeImage(file.readAsBytesSync());
  final compressedImagefile = File('$path/img_$postId.jpg')
    ..writeAsBytesSync(Im.encodeJpg(imageFile!, quality: 70));
  return compressedImagefile;
}

// for displaying snackbars
showSnackBar(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      // backgroundColor: Colors.black,
    ),
  );
}
