import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mount_princess_hotel/resources/auth_method.dart';

import 'package:mount_princess_hotel/widgets/text_field_input.dart';
import 'package:mount_princess_hotel/utils/colors.dart';
import 'package:mount_princess_hotel/utils/utils.dart';

import 'package:firebase_auth/firebase_auth.dart';

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

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().loginUser(
        email: _emailController.text,
        password: _passwordController.text,
        context: context);

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

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          color: backgroundColor,
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
          ),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Container(),
                flex: 2,
              ),
              // logo
              SvgPicture.asset(
                "assets/images/logo.svg",
                // color: Colors.white,
                height: 80,
                width: double.infinity,
              ),
              const SizedBox(height: 30),

              // text field input for login
              Container(
                padding: const EdgeInsets.all(8.0),
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
                            padding: const EdgeInsets.symmetric(vertical: 12),
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
                          height: 12,
                        ),

                        // Forgot password
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Text(
                                'Forgot Password?',
                                style: GoogleFonts.roboto(
                                    fontSize: 17, color: Colors.white),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            )
                          ],
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
    );
  }
}
