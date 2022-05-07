import 'package:flutter/material.dart';
import 'package:mount_princess_hotel/utils/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashPage extends StatelessWidget {
  int? duration = 0;
  Widget? goToPage;

  SplashPage({this.duration, this.goToPage});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: this.duration!), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => this.goToPage!));
    });

    return Material(
      child: Container(
        color: backgroundColor,
        alignment: Alignment.center,
        child: Stack(
          children: [
            Align(
              child: Image.asset(
                "assets/images/logo.jpg",
                // color: Colors.white,
                height: 80,
                width: double.infinity,
              ),
              alignment: Alignment.center,
            ),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 150,
                height: 150,
                child: CircularProgressIndicator(
                  strokeWidth: 10,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white.withOpacity(0.5)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
