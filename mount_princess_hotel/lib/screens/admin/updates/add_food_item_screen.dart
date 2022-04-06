import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mount_princess_hotel/resources/storage_method.dart';
import 'package:mount_princess_hotel/utils/colors.dart';
import 'package:mount_princess_hotel/utils/utils.dart';
import 'package:mount_princess_hotel/widgets/admin_text_field_input.dart';

class AddFoodItem extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  const AddFoodItem({
    Key? key,
    required this.categoryId,
    required this.categoryName,
  }) : super(key: key);

  @override
  State<AddFoodItem> createState() => _AddFoodItemState();
}

class _AddFoodItemState extends State<AddFoodItem> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  File? _image;
  bool _isLoading = false;

  final _menusCollection = FirebaseFirestore.instance.collection('Menus');

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _priceController.dispose();
  }

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

  // two button for choosing image
  chooseImage() {
    return SizedBox(
      width: double.infinity,
      child: Column(
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

  Future<String> uploadFoodItemFirebaseStorageDatabase(
      String name, double price) async {
    String res = "error";

    // during the process of uploading the loading is true.
    setState(() {
      _isLoading = true;
    });

    try {
      // uploading image to the firebase storage
      String photoUrl = await StorageMethods().uploadGalleryMenusImageToStorage(
        'Menus',
        widget.categoryName, // category name
        name, // image name
        _image!, // file
      );

      // uploading to the "Gallery" database
      await _menusCollection
          .doc(widget.categoryId)
          .collection('Food Item')
          .doc()
          .set(
        {
          "image": photoUrl,
          "name": name,
          "price": price,
        },
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

  // whole page
  addFoodItem() {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(top: 30, right: 30, left: 30, bottom: 20),
        child: Column(
          children: [
            // if image is choosen then circularAvatar will be displayed
            _image == null
                // if image hasnot been choosed
                ? chooseImage()
                // after image is choosed
                : Stack(
                    children: [
                      CircleAvatar(
                        radius: 64,
                        backgroundImage: FileImage(_image!),
                        backgroundColor: Colors.grey[450],
                      ),
                      Positioned(
                        top: -10,
                        left: 80,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              _image = null;
                            });
                          },
                          icon: const Icon(
                            Icons.cancel_outlined,
                            color: Colors.red,
                            size: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
            // displaying text fields and button
            const SizedBox(height: 30),
            AdminTextFieldInput(
              textEditingController: _nameController,
              textInputType: TextInputType.text,
              labelTextInput: 'Name',
              maxlines: 1,
            ),
            const SizedBox(height: 30),
            AdminTextFieldInput(
              textEditingController: _priceController,
              textInputType: TextInputType.number,
              labelTextInput: 'Price',
              maxlines: 1,
            ),
            const SizedBox(height: 30),
            MaterialButton(
              height: MediaQuery.of(context).size.height / 20,
              minWidth: MediaQuery.of(context).size.width / 2.5,
              color: const Color(0xff024DB8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Text(
                "Upload Food Item",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
              onPressed: () async {
                try {
                  if (_nameController.text != null &&
                      _priceController.text != null &&
                      _image != null) {
                    String res = await uploadFoodItemFirebaseStorageDatabase(
                        _nameController.text,
                        double.tryParse(_priceController.text)!);

                    if (res == "success") {
                      Navigator.pop(context);

                      showSnackBar(context, "Food Item Uploaded succesfully.");
                    }
                  } else if (_image == null &&
                      _nameController.text != null &&
                      _priceController.text != null) {
                    showSnackBar(context, "Choose Image.");
                  } else {
                    showSnackBar(context, "Fill all the fields.");
                  }
                } catch (err) {
                  print(err.toString());
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Food Item'),
        centerTitle: true,
        backgroundColor: backgroundColor,
      ),
      body: _isLoading
          ? Stack(
              children: [
                addFoodItem(),
                const Center(
                  child: CircularProgressIndicator(
                      // backgroundColor: Colors.blue.opacity(0.9),
                      ),
                )
              ],
            )
          : addFoodItem(),
    );
  }
}
