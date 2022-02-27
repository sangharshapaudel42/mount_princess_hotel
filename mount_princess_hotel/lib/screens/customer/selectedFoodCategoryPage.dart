import 'package:flutter/material.dart';

import 'package:mount_princess_hotel/utils/colors.dart';

import 'package:mount_princess_hotel/widgets/food_item_widget.dart';

class SelectedFoodCategory extends StatelessWidget {
  const SelectedFoodCategory({Key? key}) : super(key: key);

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
        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: GridView.count(
          shrinkWrap: false,
          primary: false,
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 10,
          childAspectRatio: 0.9,
          children: const [
            FoodItemContainer(
              image: "assets/images/burger.jpg",
              foodItemName: "Burger",
              price: "\$25",
            ),
            FoodItemContainer(
              image: "assets/images/burger.jpg",
              foodItemName: "Burger",
              price: "\$25",
            ),
            FoodItemContainer(
              image: "assets/images/burger.jpg",
              foodItemName: "Burger",
              price: "\$25",
            ),
            FoodItemContainer(
              image: "assets/images/burger.jpg",
              foodItemName: "Burger",
              price: "\$25",
            ),
            FoodItemContainer(
              image: "assets/images/burger.jpg",
              foodItemName: "Burger",
              price: "\$25",
            ),
            FoodItemContainer(
              image: "assets/images/burger.jpg",
              foodItemName: "Burger",
              price: "\$25",
            ),
          ],
        ),
      ),
    );
  }
}
