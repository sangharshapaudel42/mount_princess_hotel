import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mount_princess_hotel/utils/utils.dart';

class DeletePopUpDialog extends StatefulWidget {
  final String categoryId;
  final String imageId;
  final String deleteType;
  const DeletePopUpDialog({
    Key? key,
    required this.categoryId,
    required this.imageId,
    required this.deleteType,
  }) : super(key: key);

  @override
  State<DeletePopUpDialog> createState() => _DeletePopUpDialogState();
}

class _DeletePopUpDialogState extends State<DeletePopUpDialog> {
  final _menusCategory = FirebaseFirestore.instance.collection("Menus");
  final _galleryCategory = FirebaseFirestore.instance.collection('Gallery');

  // Delete image from database
  Future<String> deleteImage(String imageId) async {
    String res = "error";
    try {
      if (widget.deleteType == "food") {
        // this is food items
        final _foodItems =
            _menusCategory.doc(widget.categoryId).collection("Food Item");
        await _foodItems.doc(imageId).delete();
      } else if (widget.deleteType == "gallery") {
        // this is gallery image
        final _image =
            _galleryCategory.doc(widget.categoryId).collection("Images");
        await _image.doc(imageId).delete();
      }
      // FirebaseStorage.instance.refFromURL("Images/Gallery/$imageName").delete();
      res = "success";
      return res;
    } catch (err) {
      return err.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 1.9,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              children: [
                const Icon(
                  Icons.cancel_outlined,
                  size: 120,
                  color: Colors.red,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Are you sure?",
                  style: TextStyle(fontSize: 30),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Do you really want to delete this image? This process cannot be undone.",
                  style: TextStyle(fontSize: 21, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(
                      height: 50,
                      minWidth: MediaQuery.of(context).size.width / 4,
                      color: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(width: 30),
                    MaterialButton(
                      height: 50,
                      minWidth: MediaQuery.of(context).size.width / 4,
                      color: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        "Delete",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                      onPressed: () async {
                        String res = await deleteImage(widget.imageId);

                        if (res == "success") {
                          Navigator.pop(context);

                          if (widget.deleteType == "food") {
                            showSnackBar(context,
                                "You have succesfully deleted Food Item.");
                          } else if (widget.deleteType == "gallery") {
                            showSnackBar(context,
                                "You have succesfully deleted an Image.");
                          }
                        }
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
