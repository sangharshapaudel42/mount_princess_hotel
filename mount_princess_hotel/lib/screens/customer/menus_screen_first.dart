// import 'package:flutter/material.dart';
// import 'package:mount_princess_hotel/models/category.dart';

// import 'package:mount_princess_hotel/widgets/navigation_drawer_widget.dart';
// import 'package:mount_princess_hotel/widgets/food_category_widget.dart';
// import 'package:mount_princess_hotel/widgets/food_item_widget.dart';
// import 'package:mount_princess_hotel/utils/colors.dart';
// import 'package:mount_princess_hotel/widgets/text_field_input.dart';

// class Menus extends StatefulWidget {
//   const Menus({Key? key}) : super(key: key);

//   @override
//   _MenusState createState() => _MenusState();
// }

// class _MenusState extends State<Menus> {
//   final TextEditingController _searchController = TextEditingController();

//   @override
//   void dispose() {
//     super.dispose();
//     _searchController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) => Scaffold(
//         drawer: NavigationDrawerWidget(),
//         appBar: AppBar(
//           title: Text('Menus'),
//           centerTitle: true,
//           backgroundColor: backgroundColor,
//         ),
//         body: Container(
//           margin: const EdgeInsets.symmetric(horizontal: 10),
//           child: Column(
//             children: [
//               const SizedBox(height: 20),
//               TextFieldInput(
//                 hintText: 'Search Food',
//                 textInputType: TextInputType.text,
//                 textEditingController: _searchController,
//                 icon: Icons.search,
//                 color: Colors.grey,
//               ),
//               SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   children: const [
//                     FoodCategoryContainer(
//                       image: "images/",
//                       categoryName: "Breakfast",
//                     ),
//                     FoodCategoryContainer(
//                       image: "images/",
//                       categoryName: "Snacks",
//                     ),
//                     FoodCategoryContainer(
//                       image: "images/",
//                       categoryName: "Starter",
//                     ),
//                     FoodCategoryContainer(
//                       image: "images/",
//                       categoryName: "Dinner",
//                     ),
//                     FoodCategoryContainer(
//                       image: "images/",
//                       categoryName: "Desert",
//                     ),
//                     FoodCategoryContainer(
//                       image: "images/",
//                       categoryName: "Beverage",
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Expanded(
//                 child: Container(
//                   height: 470,
//                   child: GridView.count(
//                     shrinkWrap: false,
//                     primary: false,
//                     crossAxisCount: 2,
//                     crossAxisSpacing: 20,
//                     mainAxisSpacing: 20,
//                     childAspectRatio: 0.9,
//                     children: const [
//                       FoodItemContainer(
//                         image: "assets/images/burger.jpg",
//                         foodItemName: "Burger",
//                         price: "\$25",
//                       ),
//                       FoodItemContainer(
//                         image: "assets/images/burger.jpg",
//                         foodItemName: "Burger",
//                         price: "\$25",
//                       ),
//                       FoodItemContainer(
//                         image: "assets/images/burger.jpg",
//                         foodItemName: "Burger",
//                         price: "\$25",
//                       ),
//                       FoodItemContainer(
//                         image: "assets/images/burger.jpg",
//                         foodItemName: "Burger",
//                         price: "\$25",
//                       ),
//                       FoodItemContainer(
//                         image: "assets/images/burger.jpg",
//                         foodItemName: "Burger",
//                         price: "\$25",
//                       ),
//                       FoodItemContainer(
//                         image: "assets/images/burger.jpg",
//                         foodItemName: "Burger",
//                         price: "\$25",
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
// //               // GridView.builder(
// //               //   scrollDirection: Axis.vertical,
// //               //   shrinkWrap: true,
// //               //   physics: const NeverScrollableScrollPhysics(),
// //               //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //               //       crossAxisCount: 2,
// //               //       crossAxisSpacing: 15,
// //               //       mainAxisSpacing: 15,
// //               //       childAspectRatio: 0.7),
// //               //   itemCount: 6,
// //               //   itemBuilder: (BuildContext context, int index) {
// //               //     return Row(
// //               //       children: const [
// //               //         Expanded(
// //               //           child: FoodItemContainer(
// //               //             image: "assets/images/burger.jpg",
// //               //             foodItemName: "Burger",
// //               //             price: "\$25",
// //               //           ),
// //               //         ),
// //               //       ],
// //               //     );
// //               //   },
// //               // ),
//             ],
//           ),
//         ),
//       );
// }
