import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mount_princess_hotel/screens/admin/updates/deleteImagePopUp.dart';
import 'package:mount_princess_hotel/screens/admin/updates/update_food_item.dart';
import 'package:mount_princess_hotel/utils/colors.dart';
import 'package:mount_princess_hotel/widgets/individual_gallery_category.dart';
// TO DO: need to manage the size of container dynamic.

class FoodItemContainer extends StatefulWidget {
  final String image;
  final String foodItemName;
  final double price;
  final String userRole;
  final String foodId;
  final String categoryId;
  final String categoryName;
  const FoodItemContainer({
    Key? key,
    required this.image,
    required this.foodItemName,
    required this.price,
    required this.userRole,
    required this.foodId,
    required this.categoryId,
    required this.categoryName,
  }) : super(key: key);

  @override
  _FoodItemContainerState createState() => _FoodItemContainerState();
}

class _FoodItemContainerState extends State<FoodItemContainer> {
  // individual food item
  individualFoodItem() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(222, 225, 227, 0.8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Container(
              // color: Colors.blue,
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height / 7),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: CachedNetworkImage(
                  imageUrl: widget.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          ListTile(
            leading: Text(
              widget.foodItemName,
              style: const TextStyle(fontSize: 20, color: Colors.black),
            ),
            trailing: Text(
              "\$ " + widget.price.toString(),
              style: const TextStyle(fontSize: 20, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.userRole == "customer"
        // if user is customer then just showing food detail
        ? individualFoodItem()
        // if user is admin then edit, delete, add new food
        : Stack(
            children: [
              individualFoodItem(),

              // delete the food item
              Align(
                alignment: Alignment.topRight,
                child: ClipOval(
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => DeletePopUpDialog(
                          categoryId: widget.categoryId,
                          imageId: widget.foodId,
                          deleteType: "food",
                        ),
                      );
                    },
                    child: Container(
                      color: backgroundColor,
                      padding: const EdgeInsets.all(10),
                      child: const Icon(
                        Icons.delete,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              // edit food item
              Padding(
                padding: EdgeInsets.only(
                    right: (MediaQuery.of(context).size.width / 8)),
                child: Align(
                  alignment: Alignment.topRight,
                  child: ClipOval(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateFoodItem(
                              image: widget.image,
                              foodItemName: widget.foodItemName,
                              foodId: widget.foodId,
                              categoryId: widget.categoryId,
                              categoryName: widget.categoryName,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        color: backgroundColor,
                        padding: const EdgeInsets.all(10),
                        child: const Icon(
                          Icons.edit,
                          size: 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}
