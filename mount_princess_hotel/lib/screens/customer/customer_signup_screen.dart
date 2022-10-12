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
                  height: size.height / 8.5,
                  width: double.infinity,
                ),
                SizedBox(height: size.height / 15),

                // text field input for signup
                TextFieldInput(
                  hintText: "Enter your Full Name",
                  textInputType: TextInputType.name,
                  textEditingController: _nameController,
                  icon: Icons.person,
                  color: Colors.white,
                ),

                SizedBox(height: size.height / 28),

                TextFieldInput(
                  hintText: "Enter your email",
                  textInputType: TextInputType.emailAddress,
                  textEditingController: _emailController,
                  icon: Icons.email,
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
                    prefixIcon:
                        Icon(Icons.lock, color: Colors.grey.shade700, size: 25),
                    hintText: "Enter your password",
                    hintStyle: const TextStyle(fontSize: 20),
                    fillColor: Colors.white,
                    border: inputBorder,
                    focusedBorder: inputBorder,
                    enabledBorder: inputBorder,
                    filled: true,
                    contentPadding: EdgeInsets.all(size.height / 80),
                    suffixIcon: IconButton(
                      icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                  ),
                ),

                SizedBox(height: size.height / 28),

                // text field input for password
                TextFieldInput(
                  hintText: "Enter your phone number",
                  textInputType: TextInputType.phone,
                  textEditingController: _phoneNumberController,
                  icon: Icons.phone,
                  color: Colors.white,
                ),

                SizedBox(height: size.height / 28),

                // login button
                InkWell(
                  onTap: () async {
                    // send code and redirect only if all the fields are entered.
                    if (_nameController.text.isNotEmpty &&
                        _emailController.text.isNotEmpty &&
                        _passwordController.text.isNotEmpty &&
                        _phoneNumberController.text.isNotEmpty &&
                        code.toString().isNotEmpty) {
                      // twilioFlutter.sendSMS(
                      //   toNumber: "+977${_phoneNumberController.text}",
                      //   messageBody: code.toString() +
                      //       " is your verification code for the Hotel app.",
                      // );
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => OTPScreen(
                                name: _nameController.text,
                                email: _emailController.text,
                                password: _passwordController.text,
                                phone: _phoneNumberController.text,
                                verificationCode: code.toString(),
                              )));
                    }
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
                    padding: EdgeInsets.symmetric(vertical: size.height / 63),
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                      color: buttonBlueColor,
                    ),
                  ),
                ),
                SizedBox(height: size.height / 45),

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
                      padding: EdgeInsets.symmetric(vertical: size.height / 80),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
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
                        padding:
                            EdgeInsets.symmetric(vertical: size.height / 80),
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
    );
  }
}
