import 'package:mount_princess_hotel/models/category.dart';

class Utils {
  List<Category> getMockedCategories() {
    return [
      Category(
          name: "Breakfast",
          imgName: "assets/images/breakfast.jpg",
          iconName: "assets/images/breakfast.png",
          subCategories: []),
      Category(
          name: "Main Course",
          imgName: "assets/images/desert.jpg",
          iconName: "assets/images/breakfast.png",
          subCategories: []),
      Category(
          name: "Starter",
          imgName: "assets/images/breakfast.jpg",
          iconName: "assets/images/breakfast.png",
          subCategories: []),
      Category(
          name: "Breakfast",
          imgName: "assets/images/desert.jpg",
          iconName: "assets/images/breakfast.png",
          subCategories: []),
      Category(
          name: "Breakfast",
          imgName: "assets/images/breakfast.jpg",
          iconName: "assets/images/breakfast.png",
          subCategories: []),
      Category(
          name: "Breakfast",
          imgName: "assets/images/desert.jpg",
          iconName: "assets/images/breakfast.png",
          subCategories: []),
      Category(
          name: "Breakfast",
          imgName: "assets/images/desert.jpg",
          iconName: "assets/images/breakfast.png",
          subCategories: []),
    ];
  }
}
