import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mount_princess_hotel/resources/auth_method.dart';
import 'package:mount_princess_hotel/screens/customer/booking_screen.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:lottie/lottie.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

import '../../utils/utils.dart';

class OTPScreen extends StatefulWidget {
  final String name;
  final String email;
  final String password;
  final String phone;
  final String verificationCode;
  const OTPScreen({
    Key? key,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.verificationCode,
  }) : super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  bool _isLoading = false;
  bool _isCodeResend = false;

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

  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: const Color.fromRGBO(43, 46, 66, 1),
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: const Color.fromRGBO(126, 203, 224, 1),
    ),
  );

  // for owner login
  void ownerLogin() async {
    // set loading to true
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().loginUser(
      email: widget.email,
      password: widget.password,
      context: context,
    );

    if (res == "Success") {
      // customer/admin login successfull
      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      showSnackBar(context, res);
    }
  }

  // sign up the user after the verification is completed.
  void signUpUser() async {
    // set loading to true
    setState(() {
      _isLoading = true;
    });

    // signup user using our authmethodds
    String res = await AuthMethods().signUpUser(
      email: widget.email,
      password: widget.password,
      name: widget.name,
      phoneNumber: widget.phone,
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
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          // Container(
          //   width: double.infinity,
          //   child: Image.asset(
          //     "assets/images/phoneVerfication.jpg",
          //     height: 300.0,
          //     width: 250.0,
          //   ),
          // ),
          Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 40),
                // height: size.height * 0.45,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10.0,
                      spreadRadius: 0.0,
                      offset: Offset(2.0, 5.0),
                    ),
                  ],
                ),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 10.0,
                  margin: EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 40.0),
                        padding: EdgeInsets.all(20.0),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: <TextSpan>[
                              const TextSpan(
                                text: "Verification\n\n",
                                style: TextStyle(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0278AE),
                                ),
                              ),
                              const TextSpan(
                                text: "Enter the OTP send to ",
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFF373A40),
                                ),
                              ),
                              TextSpan(
                                text: "${widget.phone}",
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF373A40),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(20.0),
                        child: PinPut(
                          fieldsCount: 6,
                          // onTap: () {
                          //   FocusScope.of(context).unfocus();
                          // },
                          textStyle: const TextStyle(
                              fontSize: 25.0, color: Colors.white),
                          eachFieldWidth: 40.0,
                          eachFieldHeight: 55.0,
                          focusNode: _pinPutFocusNode,
                          controller: _pinPutController,
                          submittedFieldDecoration: pinPutDecoration,
                          selectedFieldDecoration: pinPutDecoration,
                          followingFieldDecoration: pinPutDecoration,
                          pinAnimationType: PinAnimationType.fade,
                          onSubmit: (pin) async {
                            try {
                              // if entered pin is same as the random number. Then create account

                              // in case of original phone verification
                              if (_isCodeResend == false &&
                                  pin.toString() == widget.verificationCode) {
                                if (widget.name == "owner-account-ho") {
                                  ownerLogin();
                                } else {
                                  signUpUser();
                                }

                                // in case of code resend
                              } else if (_isCodeResend == true &&
                                  pin.toString() == code.toString()) {
                                if (widget.name == "owner-account-ho") {
                                  ownerLogin();
                                } else {
                                  signUpUser();
                                }
                              } else {
                                FocusScope.of(context).unfocus();
                                showSnackBar(context, "invalid OTP");
                              }
                            } catch (e) {
                              FocusScope.of(context).unfocus();
                              showSnackBar(context, "invalid OTP");
                              // _scaffoldkey.currentState?.showSnackBar(SnackBar(content: Text('invalid OTP')));
                            }
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10.0),
                        child:
                            // Row(
                            //   children: [
                            //     Text(
                            //       "Didn't receive the code?",
                            //       style: TextStyle(
                            //         fontSize: 19.0,
                            //         fontWeight: FontWeight.bold,
                            //         color: Color(0xFF0278AE),
                            //       ),
                            //     ),
                            //   ],
                            // )
                            RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: <TextSpan>[
                              const TextSpan(
                                text: "Didn't receive the code?",
                                style: TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF373A40),
                                ),
                              ),
                              // after clicking to resend send code and verify.
                              TextSpan(
                                text: " Resend",
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // after resend is clicked _isCodeResend is true
                                    setState(() {
                                      _isCodeResend = true;
                                    });

                                    // send code to the phone number
                                    twilioFlutter.sendSMS(
                                      toNumber: widget.phone,
                                      messageBody: code.toString() +
                                          " is your verification code for the Hotel app.",
                                    );

                                    showSnackBar(context, "Code sent again");
                                  },
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFF0278AE),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  /* @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      // appBar: AppBar(
      //   title: const Text('OTP Verification'),
      // ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 40),
            child: Center(
              child: Text(
                'Verify +977-${widget.phone}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: PinPut(
              fieldsCount: 6,
              textStyle: const TextStyle(fontSize: 25.0, color: Colors.white),
              eachFieldWidth: 40.0,
              eachFieldHeight: 55.0,
              focusNode: _pinPutFocusNode,
              controller: _pinPutController,
              submittedFieldDecoration: pinPutDecoration,
              selectedFieldDecoration: pinPutDecoration,
              followingFieldDecoration: pinPutDecoration,
              pinAnimationType: PinAnimationType.fade,
              onSubmit: (pin) async {
                try {
                  // if entered pin is same as the random number. Then create account
                  if (pin.toString() == widget.verificationCode) {
                    signUpUser();
                  } else {
                    FocusScope.of(context).unfocus();
                    showSnackBar(context, "invalid OTP");
                  }
                } catch (e) {
                  FocusScope.of(context).unfocus();
                  showSnackBar(context, "invalid OTP");
                  // _scaffoldkey.currentState?.showSnackBar(SnackBar(content: Text('invalid OTP')));
                }
              },
            ),
          )
        ],
      ),
    );
  } */
}
