import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:mount_princess_hotel/widgets/foodCategoryPage.dart';
import 'package:mount_princess_hotel/screens/customer/selectedFoodCategoryPage.dart';

class MenusScreenWidget extends StatefulWidget {
  const MenusScreenWidget({Key? key}) : super(key: key);

  @override
  State<MenusScreenWidget> createState() => _MenusScreenWidgetState();
}

class _MenusScreenWidgetState extends State<MenusScreenWidget> {
  late String userRole = "";

  Future<void> getUserRole() async {
    // get the current user
    final User user = FirebaseAuth.instance.currentUser!;

    // current user uid
    final userID = user.uid;

    // access it's document
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('Users').doc(userID).get();

    userRole = doc["role"];
  }

  StreamBuilder createCard() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('Menus').snapshots(),
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

        // get user role
        getUserRole();

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
                          userRole: userRole,
                          categoryName: names[index],
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
  Widget build(BuildContext context) {
    return createCard();
  }
}
