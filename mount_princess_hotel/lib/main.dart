import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mount_princess_hotel/LandingPage.dart';

import 'package:mount_princess_hotel/screens/splash_screen.dart';
import 'package:mount_princess_hotel/screens/welcome_screen.dart';
import 'package:mount_princess_hotel/utils/colors.dart';
import 'package:mount_princess_hotel/widgets/date_picker_widget.dart';
import 'package:provider/provider.dart';

void main() async {
  // initilize firebase in our app
  WidgetsFlutterBinding.ensureInitialized();

  // for web need to provide with more info.
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDeeGl_DD6VtuhK4cVdrBugzwEp7KaOA3s",
        appId: "1:102907477996:web:3554a298c3e3201804cac9",
        messagingSenderId: "102907477996",
        projectId: "mount-princess-hotel",
        storageBucket: "mount-princess-hotel.appspot.com",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(
    const MyApp(),
    // MultiProvider(providers: [
    // ChangeNotifierProvider(create: (_) => DatePickerWidget()),
    // ]),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mount Princess Hotel',
      // theme: ThemeData(fontFamily: 'Roboto'),
      // theme: ThemeData.dark().copyWith(
      //   scaffoldBackgroundColor: backgroundColor,
      // ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              // if snapshot has data which means user is logged in then we go to landing page where we will decide weather it is customer or admin
              return LandingPage();
            } else if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            }
          }
          // means connection to future hasnt been made yet
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: backgroundColor,
              ),
            );
          }

          // if the connection hasnot been made (i.e. non-login)
          return SplashPage(duration: 1, goToPage: const WelcomePage());
        },
      ),
    );
  }
}
