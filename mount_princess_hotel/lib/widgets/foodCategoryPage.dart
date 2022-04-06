import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mount_princess_hotel/utils/colors.dart';

class FoodCategory extends StatefulWidget {
  Function? onCardClick;
  final String? name;
  final String? image;
  FoodCategory(
      {Key? key, required this.image, this.onCardClick, required this.name})
      : super(key: key);

  @override
  State<FoodCategory> createState() => _FoodCategoryState();
}

class _FoodCategoryState extends State<FoodCategory> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onCardClick!();
      },
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 4.55,
        // height: 150,
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: widget.image!,
                  fit: BoxFit.cover,
                ),
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
                    Text(
                      widget.name!,
                      style: const TextStyle(color: Colors.white, fontSize: 25),
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
