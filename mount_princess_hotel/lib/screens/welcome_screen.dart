import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mount_princess_hotel/screens/login_screen.dart';
import 'package:mount_princess_hotel/screens/customer/customer_login_screen.dart';
import 'package:mount_princess_hotel/screens/customer/customer_signup_screen.dart';
import 'package:mount_princess_hotel/utils/colors.dart';
import 'package:mount_princess_hotel/widgets/themeButton.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.3,
                child: Image.asset('assets/images/hotel_image.jpg',
                    fit: BoxFit.cover),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Align(
                      child: Image.asset(
                        "assets/images/logo.jpg",
                        // color: Colors.white,
                        height: size.height / 8,
                        width: double.infinity,
                      ),
                      alignment: Alignment.center,
                    ),
                  ),
                  SizedBox(height: size.height / 25),
                  Text(
                    'Welcome',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.height / 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: size.height / 70),
                  Text(
                    'Stay With Us & Relax',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.height / 38,
                    ),
                  ),
                  SizedBox(height: size.height / 25),
                  ThemeButton(
                    label: 'Customer Sign Up',
                    onClick: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CustomerSignUp(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: size.height / 70),
                  ThemeButton(
                    label: "Login",
                    labelColor: backgroundColor,
                    color: Colors.transparent,
                    highlight: backgroundColor,
                    borderColor: backgroundColor,
                    borderWidth: 4,
                    onClick: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Login(),
                        ),
                      );
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
