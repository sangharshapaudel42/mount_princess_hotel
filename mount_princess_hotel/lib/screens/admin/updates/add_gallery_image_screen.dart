import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mount_princess_hotel/resources/storage_method.dart';
import 'package:mount_princess_hotel/utils/utils.dart';

import '../../../utils/colors.dart';

class AddGalleryImageScreen extends StatefulWidget {
  final String categoryId;
  const AddGalleryImageScreen({Key? key, required this.categoryId})
      : super(key: key);

  @override
  State<AddGalleryImageScreen> createState() => _AddGalleryImageScreenState();
}

class _AddGalleryImageScreenState extends State<AddGalleryImageScreen> {
  File? _image;
  final _galleryCategories = FirebaseFirestore.instance.collection('Gallery');
  bool _isLoading = false;

  // selecting Image from the gallery
  Future selectImageFromGallery() async {
    try {
      File img = await pickImage(ImageSource.gallery);

      setState(() {
        _image = img;
      });
    } catch (err) {
      print(err.toString());
    }
  }

  // image taken from the camera
  Future selectImageTakePhoto() async {
    try {
      File img = await pickImage(ImageSource.camera);
      setState(() {
        _image = img;
      });
    } catch (err) {
      print(err.toString());
    }
  }

  // upload photo to firebase storage and then to the database "Gallery"
  Future<String> uploadGalleryImageFirebaseStorageDatabase() async {
    String res = "error";

    // during the process of uploading the loading is true.
    setState(() {
      _isLoading = true;
    });

    try {
      // uploading image to the firebase storage

      String photoUrl = await StorageMethods().uploadGalleryMenusImageToStorage(
          "Gallery", widget.categoryId, "", _image!);

      // uploading to the "Gallery" database
      await _galleryCategories
          .doc(widget.categoryId)
          .collection('Images')
          .doc()
          .set(
        {"image": photoUrl},
      );
      res = "success";

      // loadin is "false" after uploading has been successfull.
      if (res == "success") {
        setState(() {
          _isLoading = false;
        });
      }

      return res;
    } catch (err) {
      setState(() {
        _isLoading = false;
      });
      return err.toString();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: backgroundColor,
          title: Text('Add Image To ' + widget.categoryId),
          centerTitle: true,
        ),
        // body: addGalleryImage(),
        body: _image == null
            ? imageNotChoose()
            : _isLoading
                ? Stack(
                    children: [
                      imageChoose(),
                      const Center(
                        child: CircularProgressIndicator(
                            // backgroundColor: Colors.blue.opacity(0.9),
                            ),
                      )
                    ],
                  )
                : imageChoose(),
      );

  // if the image hasnot been choosen yet
  Widget imageNotChoose() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // select image from camera
          SizedBox(
              width: MediaQuery.of(context).size.width / 1.5,
              child: ElevatedButton(
                  onPressed: () async {
                    selectImageTakePhoto();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: backgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      Icon(Icons.camera_alt),
                      Text('Take From Camera'),
                      Opacity(
                        opacity: 0,
                        child: Icon(Icons.camera_alt),
                      )
                    ],
                  ))),

          // select image from gallery
          SizedBox(
              width: MediaQuery.of(context).size.width / 1.5,
              child: ElevatedButton(
                  onPressed: () async {
                    selectImageFromGallery();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: backgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Icon(Icons.photo),
                      Text('Choose From Gallery'),
                      Opacity(opacity: 0, child: Icon(Icons.camera_alt))
                    ],
                  )))
        ],
      ),
    );
  }

  Widget imageChoose() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(
              left: 30.0, right: 30.0, top: 20.0, bottom: 20.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30.0),
            child: Image.file(_image!),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            MaterialButton(
              height: MediaQuery.of(context).size.height / 20,
              minWidth: MediaQuery.of(context).size.width / 2.5,
              color: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
              onPressed: () {
                setState(() {
                  _image = null;
                });
              },
            ),
            MaterialButton(
              height: MediaQuery.of(context).size.height / 20,
              minWidth: MediaQuery.of(context).size.width / 2.5,
              color: const Color(0xff024DB8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Text(
                "Upload Image",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
              onPressed: () async {
                if (_image != null) {
                  String res =
                      await uploadGalleryImageFirebaseStorageDatabase();

                  if (res == "success") {
                    Navigator.pop(context);

                    showSnackBar(context,
                        "Image Uploaded succesfully in " + widget.categoryId);
                  }
                } else {
                  showSnackBar(context, "Choose Image.");
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
