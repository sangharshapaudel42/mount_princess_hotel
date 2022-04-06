import 'package:mount_princess_hotel/models/category.dart';
import 'package:flutter/cupertino.dart';
import 'dart:core';
import 'dart:ui';

class AppColors {
  static const Color A = Color(0xFFC02828);
  static const Color B = Color(0xFFC028BA);
  static const Color C = Color(0xFF28C080);
  static const Color D = Color(0xFFC05D28);
  static const Color E = Color(0xFF5D28C0);
  static const Color F = Color(0xFF1BB1DE);
}

class IconFontHelper {
  static const String A = 'c';
  static const String B = 'd';
  static const String C = 'e';
  static const String D = 'f';
  static const String E = 'g';
  static const String F = 'h';
}

class Utils {
  List<Category> getMockedCategories() {
    return [
      Category(
          name: "Breakfast",
          imgName: "assets/images/breakfast.jpg",
          icon: IconFontHelper.A,
          color: AppColors.A,
          subCategories: []),
      Category(
          name: "Main Course",
          imgName: "assets/images/desert.jpg",
          icon: "IconFontHelper.B",
          color: AppColors.B,
          subCategories: []),
      Category(
          name: "Starter",
          imgName: "assets/images/breakfast.jpg",
          icon: "IconFontHelper.C",
          color: AppColors.C,
          subCategories: []),
      Category(
          name: "Breakfast",
          imgName: "assets/images/desert.jpg",
          icon: "IconFontHelper.D",
          color: AppColors.D,
          subCategories: []),
      Category(
          name: "Breakfast",
          imgName: "assets/images/breakfast.jpg",
          icon: "IconFontHelper.E",
          color: AppColors.E,
          subCategories: []),
      Category(
          name: "Breakfast",
          imgName: "assets/images/desert.jpg",
          icon: "IconFontHelper.F",
          color: AppColors.F,
          subCategories: []),
      Category(
          name: "Breakfast",
          imgName: "assets/images/desert.jpg",
          icon: "IconFontHelper.A",
          color: AppColors.A,
          subCategories: []),
    ];
  }
}
