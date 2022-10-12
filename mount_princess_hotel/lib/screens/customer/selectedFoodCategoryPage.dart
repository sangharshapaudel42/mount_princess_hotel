import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mount_princess_hotel/screens/admin/updates/add_food_item_screen.dart';

import 'package:mount_princess_hotel/utils/colors.dart';

import 'package:mount_princess_hotel/widgets/food_item_widget.dart';

class SelectedFoodCategory extends StatefulWidget {
  final String? referenceId;
  final String userRole;
  final String categoryName;
  const SelectedFoodCategory(
      {Key? key,
      required this.referenceId,
      required this.userRole,
      required this.categoryName})
      : super(key: key);

  @override
  State<SelectedFoodCategory> createState() => _SelectedFoodCategoryState();
}

class _SelectedFoodCategoryState extends State<SelectedFoodCategory> {
  final TextEditingController _searchController = TextEditingController();

  StreamBuilder createCard() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Menus')
          .doc(widget.referenceId)
          .collection('Food Item')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        List<DocumentSnapshot> docs = (snapshot.data! as QuerySnapshot).docs;

        List foodItemName = [];
        List image = [];
        List price = [];
        List foodIds = [];

        docs.forEach((item) {
          foodItemName.add(item['name']);
          image.add(item['image']);
          price.add(item['price']);
          foodIds.add(item.id);
        });

        return SizedBox(
          height: MediaQuery.of(context).size.height,
          child: GridView.builder(
            itemCount: docs.length,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: MediaQuery.of(context).size.width / 2,
              childAspectRatio: 1,
              crossAxisSpacing: 10,
              mainAxisSpacing: 5,
            ),
            itemBuilder: (context, index) {
              return FoodItemContainer(
                image: image[index],
                foodItemName: foodItemName[index],
                price: price[index],
                userRole: widget.userRole,
                foodId: foodIds[index],
                categoryId: widget.referenceId!,
                categoryName: widget.categoryName,
              );
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Category'),
        centerTitle: true,
        backgroundColor: backgroundColor,
      ),
      body: Container(
        // height: MediaQuery.of(context).size.height,
        // width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
        color: Colors.white,
        child: createCard(),
      ),
      // show floatingAction Button to admin only
      floatingActionButton: widget.userRole == "admin"
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddFoodItem(
                      categoryId: widget.referenceId!,
                      categoryName: widget.categoryName,
                    ),
                  ),
                );
              },
              backgroundColor: backgroundColor,
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 32,
              ),
            )
          : null,
    );
  }
}
