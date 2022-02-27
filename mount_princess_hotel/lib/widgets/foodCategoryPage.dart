import 'package:flutter/material.dart';
import 'package:mount_princess_hotel/utils/colors.dart';

class FoodCategory extends StatelessWidget {
  Function? onCardClick;
  FoodCategory({Key? key, this.onCardClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        this.onCardClick!();
      },
      child: Container(
        margin: const EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height / 4.55,
        // height: 150,
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset("assets/images/breakfast.jpg",
                    fit: BoxFit.cover),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                  height: MediaQuery.of(context).size.height / 4.7,
                  // height: 120,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                      gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.transparent
                          ]))),
            ),
            Positioned(
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    // icon
                    ClipOval(
                      child: Container(
                        color: backgroundColor,
                        padding: const EdgeInsets.all(10),
                        child: const Icon(
                          Icons.access_alarm,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Text(this.category!.name!,
                    //     style: TextStyle(
                    //         color: Colors.white, fontSize: 25))
                    const Text(
                      'hello world',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
