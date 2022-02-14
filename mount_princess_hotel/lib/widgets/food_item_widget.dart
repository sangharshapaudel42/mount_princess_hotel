import 'package:flutter/material.dart';

class FoodItemContainer extends StatefulWidget {
  final String image;
  final String foodItemName;
  final String price;
  const FoodItemContainer({
    Key? key,
    required this.image,
    required this.foodItemName,
    required this.price,
  }) : super(key: key);

  @override
  _FoodItemContainerState createState() => _FoodItemContainerState();
}

class _FoodItemContainerState extends State<FoodItemContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      width: 150,
      decoration: BoxDecoration(
          color: Colors.grey, borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image.asset(
          //   "assets/images/burger.jpg",
          //   height: 80,
          //   fit: BoxFit.cover,
          // )
          CircleAvatar(
            radius: 60,
            backgroundImage: AssetImage(widget.image),
          ),
          ListTile(
            leading: Text(
              widget.foodItemName,
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
            trailing: Text(
              widget.price,
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
