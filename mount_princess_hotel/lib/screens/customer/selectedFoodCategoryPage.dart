import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:mount_princess_hotel/utils/colors.dart';

import 'package:mount_princess_hotel/widgets/food_item_widget.dart';
import 'package:mount_princess_hotel/widgets/text_field_input.dart';
import 'package:flutter/services.dart';

class SelectedFoodCategory extends StatefulWidget {
  final String? referenceId;
  const SelectedFoodCategory({Key? key, @required this.referenceId})
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

        print(FirebaseFirestore.instance
            .collection('Menus')
            .doc(widget.referenceId)
            .collection('Food Item')
            .get());

        List<DocumentSnapshot> docs = (snapshot.data! as QuerySnapshot).docs;

        List foodItemName = [];
        List image = [];
        List price = [];

        docs.forEach((item) {
          print(item.data());
          foodItemName.add(item['name']);
          image.add(item['image']);
          price.add(item['price']);
        });

        return Container(
          height: MediaQuery.of(context).size.height,
          child: GridView.builder(
            itemCount: docs.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300,
                childAspectRatio: 0.9,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10),
            itemBuilder: (context, index) {
              return FoodItemContainer(
                  image: image[index],
                  foodItemName: foodItemName[index],
                  price: price[index]);
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
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
        color: Colors.white,
        child: createCard(),
        // child: GridView.count(
        //   shrinkWrap: false,
        //   primary: false,
        //   crossAxisCount: 2,
        //   crossAxisSpacing: 10,
        //   mainAxisSpacing: 5,
        //   childAspectRatio: 0.9,
        //   children: const [
        //     // FoodItemContainer(
        //     //   image: "assets/images/burger.jpg",
        //     //   foodItemName: "Burger",
        //     //   price: "\$25",
        //     // ),
        //   ],
        // ),
      ),
    );
  }
}
