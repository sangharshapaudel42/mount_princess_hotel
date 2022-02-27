import 'package:flutter/material.dart';
import 'package:mount_princess_hotel/models/category.dart';

import 'package:mount_princess_hotel/widgets/navigation_drawer_widget.dart';
import 'package:mount_princess_hotel/widgets/foodCategoryPage.dart';
import 'package:mount_princess_hotel/utils/colors.dart';
import 'package:mount_princess_hotel/screens/customer/selectedFoodCategoryPage.dart';

class Menus extends StatefulWidget {
  const Menus({Key? key}) : super(key: key);

  @override
  _MenusState createState() => _MenusState();
}

class _MenusState extends State<Menus> {
  @override
  Widget build(BuildContext context) => Scaffold(
        // if we want the navbar to be in the right side 'endDrawer'
        drawer: NavigationDrawerWidget(),
        appBar: AppBar(
          title: const Text('Menus'),
          centerTitle: true,
          backgroundColor: backgroundColor,
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    'Food Categories',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 30),
                  ),
                ),
                Container(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        FoodCategory(onCardClick: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SelectedFoodCategory(),
                            ),
                          );
                        }),
                        FoodCategory(onCardClick: () {}),
                        FoodCategory(onCardClick: () {}),
                        FoodCategory(onCardClick: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SelectedFoodCategory(),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
