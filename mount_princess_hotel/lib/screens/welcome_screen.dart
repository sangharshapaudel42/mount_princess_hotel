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
                        height: 100,
                        width: double.infinity,
                      ),
                      alignment: Alignment.center,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Welcome',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Stay With Us & Relax',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 30),
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
                  const SizedBox(height: 10),
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
