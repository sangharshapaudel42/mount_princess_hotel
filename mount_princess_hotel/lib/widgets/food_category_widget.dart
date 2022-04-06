import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FoodCategoryContainer extends StatefulWidget {
  final String image;
  final String categoryName;
  const FoodCategoryContainer({
    Key? key,
    required this.image,
    required this.categoryName,
  }) : super(key: key);

  @override
  _FoodCategoryContainerState createState() => _FoodCategoryContainerState();
}

class _FoodCategoryContainerState extends State<FoodCategoryContainer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Container(
          margin: const EdgeInsets.only(left: 20),
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(widget.image)),
            color: Colors.grey,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          margin: const EdgeInsets.only(left: 15),
          child: Text(
            widget.categoryName,
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
        ),
      ],
    );
  }
}
