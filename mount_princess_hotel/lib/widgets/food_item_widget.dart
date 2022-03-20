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
  /* Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.red,
            // color: const Color.fromRGBO(222, 225, 227, 0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image(
                  image: NetworkImage(
                    widget.image,
                  ),
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height / 15)),
        ),
        ListTile(
          leading: Text(
            widget.foodItemName,
            style: const TextStyle(fontSize: 18, color: Colors.black),
          ),
          trailing: Text(
            widget.price,
            style: const TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
      ],
    );
  } */
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(222, 225, 227, 0.8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image(
                image: NetworkImage(
                  widget.image,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            leading: Text(
              widget.foodItemName,
              style: const TextStyle(fontSize: 20, color: Colors.black),
            ),
            trailing: Text(
              widget.price,
              style: const TextStyle(fontSize: 20, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
