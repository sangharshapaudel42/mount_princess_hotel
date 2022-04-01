import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mount_princess_hotel/utils/utils.dart';
import 'package:mount_princess_hotel/widgets/admin_text_field_input.dart';

import '../../../resources/storage_method.dart';

import '../../../utils/colors.dart';

class UpdateFoodItem extends StatefulWidget {
  final String image;
  final String foodItemName;
  final String foodId;
  final String categoryId;
  final String categoryName;
  const UpdateFoodItem({
    Key? key,
    required this.image,
    required this.foodItemName,
    required this.foodId,
    required this.categoryId,
    required this.categoryName,
  }) : super(key: key);

  @override
  State<UpdateFoodItem> createState() => _UpdateFoodItemState();
}

class _UpdateFoodItemState extends State<UpdateFoodItem> {
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

  Future<String> updateImage() async {
    final _foodItemInfo = _menusCollection
        .doc(widget.categoryId)
        .collection('Food Item')
        .doc(widget.foodId);
    String res = "error";

    final String? name = _nameController.text;
    final double? price = double.tryParse(_priceController.text);

    // Update the food item if image is not changed
    if (name != null && price != null && _image == null) {
      try {
        await _foodItemInfo.update({"name": name, "price": price});

        res = "success";
        return res;
      } catch (err) {
        return err.toString();
      }

      // Update the food item if image is changed
    } else if (name != null && price != null && _image != null) {
      // showing the circularProgressIndicator
      // setState(() {
      //   _isLoading = true;
      // });
      try {
        // compressing the image
        File compressedImage = await compressImage(_image!);

        // uploading the photo to the firebase storage
        // sending the compressed image to storage
        String photoUrl =
            await StorageMethods().uploadGalleryMenusImageToStorage(
          'Menus',
          widget.categoryName,
          widget.foodItemName, // category ko name
          compressedImage, // file
        );

        // Update the product
        await _foodItemInfo
            .update({"image": photoUrl, "name": name, "price": price});

        res = "success";

        // if (res == "success") {
        //   setState(() {
        //     _isLoading = false;
        //   });
        // }
        return res;
      } catch (err) {
        setState(() {
          _isLoading = false;
        });
        return err.toString();
      }
    }
    return res;
  }

  StreamBuilder updateRoom() {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("Menus")
          .doc(widget.categoryId)
          .collection("Food Item")
          .doc(widget.foodId)
          .snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        Map<String, dynamic> data =
            snapshot.data!.data() as Map<String, dynamic>;

        var foodName = data['name'];
        var originalImage = data['image'];
        var price = data['price'];

        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {
          _nameController.text = foodName;
          _priceController.text = price.toString();
        }

        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding:
              const EdgeInsets.only(top: 30, right: 10, left: 10, bottom: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    _image != null
                        // if it selects images from the gallery
                        ? CircleAvatar(
                            radius: 64,
                            backgroundImage: FileImage(_image!),
                            backgroundColor: Colors.grey[450],
                          )
                        : CircleAvatar(
                            radius: 64,
                            backgroundImage: NetworkImage(originalImage),
                            backgroundColor: Colors.grey[450],
                          ),
                    // same as update_rooms.dart
                    Positioned(
                      bottom: -3,
                      left: 87,
                      child: ClipOval(
                        child: InkWell(
                          onTap: selectImageTakePhoto,
                          child: Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(3),
                            child: ClipOval(
                              child: Container(
                                color: backgroundColor,
                                padding: const EdgeInsets.all(5),
                                child: const Icon(
                                  Icons.add_a_photo,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -3,
                      right: 87,
                      child: ClipOval(
                        child: InkWell(
                          onTap: selectImageFromGallery,
                          child: Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(3),
                            child: ClipOval(
                              child: Container(
                                color: backgroundColor,
                                padding: const EdgeInsets.all(5),
                                child: const Icon(
                                  Icons.add_photo_alternate,
                                  // size: 25,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    _image != null
                        // if image is choose display cancel button to cancel image
                        ? Positioned(
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
                              ),
                            ),
                          )

                        // if no image is shown then show nothing
                        : const Positioned(
                            top: -10,
                            left: 80,
                            child: IconButton(
                              onPressed: null,
                              icon: Icon(
                                Icons.abc,
                                color: Colors.transparent,
                                size: 0,
                              ),
                            ),
                          ),
                  ],
                ),
                const SizedBox(height: 30),
                AdminTextFieldInput(
                  textEditingController: _nameController,
                  textInputType: TextInputType.text,
                  labelTextInput: 'Name',
                  maxlines: 1,
                ),
                const SizedBox(height: 20),
                AdminTextFieldInput(
                  textEditingController: _priceController,
                  textInputType: TextInputType.number,
                  labelTextInput: 'Price',
                  maxlines: 1,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  child: const Text('Update'),
                  onPressed: () async {
                    if (_nameController.text != null &&
                        _priceController.text != null) {
                      String res = await updateImage();

                      if (res == "success") {
                        // Hide the bottom sheet
                        Navigator.of(context).pop();
                      }
                    }
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: backgroundColor,
          title: Text('Edit ' + widget.foodItemName),
          centerTitle: true,
        ),
        body: _isLoading
            ? Stack(
                children: [
                  updateRoom(),
                  const Center(
                    child: CircularProgressIndicator(
                        // backgroundColor: Colors.blue.opacity(0.9),
                        ),
                  )
                ],
              )
            : updateRoom(),
      );
}
