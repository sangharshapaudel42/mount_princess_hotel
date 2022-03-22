import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
  FutureBuilder createCard() {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('Menus').get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        List<QueryDocumentSnapshot> docs =
            (snapshot.data! as QuerySnapshot).docs;

        List names = [];
        List images = [];
        List itemReference = [];

        docs.forEach((item) {
          names.add(item['name']);
          images.add(item['image']);
          itemReference.add(item.id);
        });
        print(itemReference);

        return Container(
          height: MediaQuery.of(context).size.height - 135,
          child: ListView.builder(
            itemCount: names.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8),
                child: FoodCategory(
                  name: names[index],
                  image: images[index],
                  onCardClick: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SelectedFoodCategory(
                          referenceId: itemReference[index],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

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
                        // FoodCategory(onCardClick: () {
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => SelectedFoodCategory(),
                        //     ),
                        //   );
                        // }),
                        createCard()
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
