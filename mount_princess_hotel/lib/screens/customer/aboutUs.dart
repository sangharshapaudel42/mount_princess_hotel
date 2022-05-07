import 'package:flutter/material.dart';

import 'package:mount_princess_hotel/widgets/navigation_drawer_widget.dart';
import 'package:mount_princess_hotel/utils/colors.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: NavigationDrawerWidget(),
        appBar: AppBar(
          title: const Text('About Us'),
          centerTitle: true,
          backgroundColor: backgroundColor,
        ),
        body: Container(
          color: Colors.white,
          child: Stack(
            children: [
              Positioned.fill(
                child: Opacity(
                  opacity: 0.5,
                  child: Image.asset('assets/images/hotel_image.jpg',
                      fit: BoxFit.cover),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                margin: const EdgeInsets.only(
                    left: 20, right: 20, top: 40, bottom: 40),
                padding: const EdgeInsets.all(20.0),
                // color: Colors.black,
                decoration: BoxDecoration(
                  color: const Color(0xFFffffff).withOpacity(0.8),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: SingleChildScrollView(
                  child: RichText(
                    text: const TextSpan(
                        // text: 'About Us',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: "About Us",
                            style: TextStyle(
                              // fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                          TextSpan(
                            text:
                                '\n\nHotel Application is in the centre of exciting and Historic Dhulikhel which is a piece of heaven of Nepal from where you can feel the mountain touch. From the Hotel Application you can see the snow capped mountains and some of the extraordinary views of luscious hills. It is 30 km east of the capital city Kathmandu on the Araniko Highway.\n\nThe only hotel in Heart of little Dhulikhel.',
                            style: TextStyle(
                              height: 1.1,
                            ),
                          )
                        ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
