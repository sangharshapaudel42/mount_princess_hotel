import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mount_princess_hotel/resources/auth_method.dart';
import 'package:mount_princess_hotel/screens/customer/booking_screen.dart';
import 'package:mount_princess_hotel/screens/customer/phoneVerificationScreen.dart';
import 'package:mount_princess_hotel/screens/login_screen.dart';

import 'package:mount_princess_hotel/widgets/text_field_input.dart';
import 'package:mount_princess_hotel/utils/colors.dart';
import 'package:mount_princess_hotel/utils/utils.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

class CustomerSignUp extends StatefulWidget {
  const CustomerSignUp({Key? key}) : super(key: key);

  @override
  _CustomerSignUpState createState() => _CustomerSignUpState();
}

class _CustomerSignUpState extends State<CustomerSignUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;
  // Initially password is obscure
  bool _isObscure = true;

  // initilize
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
    _phoneNumberController.dispose();
    _nameController.dispose();
  }

  void signUpUser() async {
    // set loading to true
    setState(() {
      _isLoading = true;
    });

    // signup user using our authmethodds
    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      name: _nameController.text,
      phoneNumber: _phoneNumberController.text,
    );
    // if string returned is sucess, user has been created
    if (res == "success") {
      setState(() {
        _isLoading = false;
      });
      // navigate to the home screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const BookingPage()),
      );
    } else {
      setState(() {
        _isLoading = false;
      });
      // show the error
      showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          color: backgroundColor,
          // color: Colors.red,
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 13,
          ),
          width: double.infinity,
          child: SingleChildScrollView(
            child: Container(
              // color: Colors.blue,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(),
                    flex: 2,
                  ),
                  // logo
                  Image.asset(
                    "assets/images/logo.jpg",
                    // color: Colors.white,
                    height: 80,
                    width: double.infinity,
                  ),
                  const SizedBox(height: 50),

                  // text field input for signup
                  TextFieldInput(
                    hintText: "Enter your Full Name",
                    textInputType: TextInputType.name,
                    textEditingController: _nameController,
                    icon: Icons.person,
                    color: Colors.white,
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  TextFieldInput(
                    hintText: "Enter your email",
                    textInputType: TextInputType.emailAddress,
                    textEditingController: _emailController,
                    icon: Icons.email,
                    color: Colors.white,
                  ),

                  const SizedBox(
                    height: 24,
                  ),

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
                      contentPadding: const EdgeInsets.all(8),
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

                  const SizedBox(
                    height: 24,
                  ),

                  // text field input for password
                  TextFieldInput(
                    hintText: "Enter your phone number",
                    textInputType: TextInputType.phone,
                    textEditingController: _phoneNumberController,
                    icon: Icons.phone,
                    color: Colors.white,
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  // login button
                  InkWell(
                    onTap: () async {
                      twilioFlutter.sendSMS(
                        toNumber: "+977${_phoneNumberController.text}",
                        messageBody: code.toString() +
                            " is your verification code for the Hotel app.",
                      );
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => OTPScreen(
                                name: _nameController.text,
                                email: _emailController.text,
                                password: _passwordController.text,
                                phone: _phoneNumberController.text,
                                verificationCode: code.toString(),
                              )));
                    },
                    child: Container(
                      child: _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'Sign Up',
                              style: GoogleFonts.roboto(
                                  fontSize: 25, color: Colors.white),
                            ),
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: const ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        color: buttonBlueColor,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),

                  // Forgot password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Text(
                          "Already have an account?",
                          style: GoogleFonts.roboto(
                              fontSize: 17, color: Colors.white),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => const Login(),
                          ));
                        },
                        child: Container(
                          child: Text(
                            " Login",
                            style: GoogleFonts.roboto(
                                fontSize: 17,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ],
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
      ),
    );
  }
}
