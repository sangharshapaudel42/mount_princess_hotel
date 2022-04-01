import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mount_princess_hotel/utils/utils.dart';
import 'package:mount_princess_hotel/widgets/admin_text_field_input.dart';

import '../../../resources/storage_method.dart';

import '../../../utils/colors.dart';

class UpdateRooms extends StatefulWidget {
  final String roomId;
  const UpdateRooms({Key? key, required this.roomId}) : super(key: key);

  @override
  State<UpdateRooms> createState() => _UpdateRoomsState();
}

class _UpdateRoomsState extends State<UpdateRooms> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  File? _image;
  bool _isLoading = false;

  final _roomCollection = FirebaseFirestore.instance.collection('Rooms');

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
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
    final _roomInfo = _roomCollection.doc(widget.roomId);
    String res = "error";

    final String? name = _nameController.text;
    final String? description = _descriptionController.text;
    final double? price = double.tryParse(_priceController.text);

    // Update the room if image is not changed
    if (name != null && price != null && _image == null) {
      try {
        await _roomInfo
            .update({"Name": name, "Description": description, "Price": price});

        res = "success";
        return res;
      } catch (err) {
        return err.toString();
      }

      // Update the room if image is changed
    } else if (name != null && price != null && _image != null) {
      try {
        // showing the circularProgressIndicator
        setState(() {
          _isLoading = true;
        });

        // compressing the image
        File compressedImage = await compressImage(_image!);

        // uploading the photo to the firebase storage
        // sending the compressed image to storage
        String photoUrl = await StorageMethods().uploadImageToStorage(
          'Rooms',
          name,
          compressedImage,
        );

        // Update the product
        await _roomInfo.update({
          "imgName": photoUrl,
          "Name": name,
          "Description": description,
          "Price": price
        });

        res = "success";

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
    return res;
  }

  StreamBuilder updateRoom() {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Rooms')
          .doc(widget.roomId)
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
        var originalImage = data['imgName'];
        var price = data['Price'];
        var description = data['Description'];

        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {
          _nameController.text = roomName;
          _descriptionController.text = description;
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
                    // same as update_food_item.dart
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
                                  // size: 25,
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
                const SizedBox(height: 40),
                AdminTextFieldInput(
                  textEditingController: _nameController,
                  textInputType: TextInputType.text,
                  labelTextInput: 'Name',
                  maxlines: 1,
                ),
                const SizedBox(height: 20),
                AdminTextFieldInput(
                  textEditingController: _descriptionController,
                  textInputType: TextInputType.multiline,
                  labelTextInput: 'Description',
                  maxlines: 6,
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
                    String res = await updateImage();

                    if (res == "success") {
                      // Hide the bottom sheet
                      Navigator.of(context).pop();
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
        title: const Text('Manage Rooms'),
        centerTitle: true,
      ),
      body: updateRoom());
}
