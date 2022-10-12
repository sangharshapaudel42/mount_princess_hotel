import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mount_princess_hotel/resources/auth_method.dart';
import 'package:mount_princess_hotel/resources/forgot_password_page.dart';
import 'package:mount_princess_hotel/screens/customer/booking_screen.dart';
import 'package:mount_princess_hotel/screens/customer/customer_signup_screen.dart';
import 'package:mount_princess_hotel/screens/customer/phoneVerificationScreen.dart';

import 'package:mount_princess_hotel/widgets/text_field_input.dart';
import 'package:mount_princess_hotel/utils/colors.dart';
import 'package:mount_princess_hotel/utils/utils.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  // Initially password is obscure
  bool _isObscure = true;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // initilize twilio
  late TwilioFlutter twilioFlutter;

  // g-digit random number
  int code = Random().nextInt(900000) + 100000;

  @override
  void initState() {
    twilioFlutter = TwilioFlutter(
      accountSid: "ACd93747d0d38729e77ebbf0538c6c0a06",
      authToken: "ed86ae256314451f8d9bcc9d8a5cc44f",
      twilioNumber: "+19793169548",
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  // called after click of login button
  void loginUser() async {
    setState(() {
      _isLoading = true;
    });

    String res = "Some error Occured.";

    try {
      // check if email and password are empty or not.
      if (_emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty) {
        // sign in if given user exists
        final finalUser = await _auth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        if (finalUser != null) {
          final User user = _auth.currentUser!;
          final userID = user.uid;
          print(userID);

          DocumentSnapshot doc = await FirebaseFirestore.instance
              .collection('Users')
              .doc(userID)
              .get();
          print(doc['role']);

          // if role is admin then navigate it to the phone verification code
          // and verify the user and if owner then only login else decline.
          if (doc['role'] == "admin") {
            // twilioFlutter.sendSMS(
            //   // toNumber: "+977${_phoneNumberController.text}",
            //   toNumber: "+9779861963866",
            //   messageBody: code.toString() +
            //       " is your verification code for the Hotel app.",
            // );

            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => OTPScreen(
                      name: "owner-account-ho",
                      email: _emailController.text,
                      password: _passwordController.text,
                      phone: "+9779861963866",
                      verificationCode: code.toString(),
                    )));

            // if the role is customer then navigate to BookingPage();
          } else {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const BookingPage(),
            ));
          }
          res = "Success";
        }
      } else {
        res = "Please enter all the fields";
      }
    }
    // if wants to costumize the error given by the firebase
    on FirebaseAuthException catch (e) {
      if (e.code == "wrong-password") {
        res = "Wrong password.";
      } else if (e.code == "user-not-found") {
        res = "User not found.";
      } else if (e.code == "invalid-email") {
        res = "Invalid Email.";
      }
    } catch (err) {
      print(err.toString());
    }

    /*String res = await AuthMethods().loginUser(
        email: _emailController.text,
        password: _passwordController.text,
        context: context);

    if (res == "Success") {
      // customer/admin login successfull
    } else {
      showSnackBar(context, res);
    }*/

    if (res == "Success") {
      // customer/admin login successfull
    } else {
      showSnackBar(context, res);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );

    var size = MediaQuery.of(context).size;

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: size.width,
            height: size.height - 22,
            color: backgroundColor,
            padding: EdgeInsets.symmetric(
              horizontal: size.width / 13,
            ),
            // width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Container(),
                  flex: 2,
                ),
                // logo
                // SvgPicture.asset(
                Image.asset(
                  "assets/images/logo.jpg",
                  // color: Colors.white,
                  height: size.height / 8.5,
                  width: double.infinity,
                ),
                SizedBox(height: size.height / 20),

                // text field input for login
                Container(
                  padding: EdgeInsets.all(size.height / 80),
                  child: SingleChildScrollView(
                    child: Container(
                      child: Column(
                        children: [
                          TextFieldInput(
                            hintText: "Enter your email",
                            textInputType: TextInputType.emailAddress,
                            textEditingController: _emailController,
                            icon: Icons.person,
                            color: Colors.white,
                          ),

                          SizedBox(height: size.height / 28),

                          // text field input for password
                          TextField(
                            controller: _passwordController,
                            style: const TextStyle(fontSize: 20),
                            obscureText: _isObscure,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock,
                                  color: Colors.grey.shade700, size: 25),
                              hintText: "Enter your password",
                              hintStyle: const TextStyle(fontSize: 20),
                              fillColor: Colors.white,
                              border: inputBorder,
                              focusedBorder: inputBorder,
                              enabledBorder: inputBorder,
                              filled: true,
                              contentPadding: EdgeInsets.all(size.height / 80),
                              suffixIcon: IconButton(
                                icon: Icon(_isObscure
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                },
                              ),
                            ),
                          ),

                          SizedBox(height: size.height / 28),

                          // login button
                          InkWell(
                            onTap: loginUser,
                            child: Container(
                              child: _isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      'Log in',
                                      style: GoogleFonts.roboto(
                                          fontSize: 25, color: Colors.white),
                                    ),
                              width: double.infinity,
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  vertical: size.height / 63),
                              decoration: const ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6)),
                                ),
                                color: buttonBlueColor,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 2,
                          ),

                          // Forgot password
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                child: InkWell(
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgotPasswordpage(),
                                    ),
                                  ),
                                  child: Text(
                                    'Forgot Password?',
                                    style: GoogleFonts.roboto(
                                      decoration: TextDecoration.underline,
                                      fontSize: 17,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                              )
                            ],
                          ),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: <TextSpan>[
                                const TextSpan(
                                  text: "No account?",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                // after clicking to resend send code and verify.
                                TextSpan(
                                  text: " Sign Up",
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.of(context)
                                          .pushReplacement(MaterialPageRoute(
                                        builder: (context) =>
                                            const CustomerSignUp(),
                                      ));
                                    },
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Container(),
                  flex: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
