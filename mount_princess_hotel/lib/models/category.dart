import 'package:flutter/cupertino.dart';

class Category {
  String name;
  String imgName;
  String icon;
  Color color;
  List<Category> subCategories;

  Category({
    required this.name,
    required this.imgName,
    required this.icon,
    required this.color,
    required this.subCategories,
  });
}
