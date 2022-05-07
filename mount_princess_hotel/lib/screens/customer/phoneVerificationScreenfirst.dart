import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mount_princess_hotel/resources/auth_method.dart';
import 'package:mount_princess_hotel/screens/customer/booking_screen.dart';
import 'package:pinput/pin_put/pin_put.dart';

import '../../utils/utils.dart';

class OTPScreen extends StatefulWidget {
  final String phone;
  final String name;
  final String email;
  final String password;
  const OTPScreen({
    Key? key,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
  }) : super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  late String _verificationCode;
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  bool _isLoading = false;

  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: const Color.fromRGBO(43, 46, 66, 1),
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: const Color.fromRGBO(126, 203, 224, 1),
    ),
  );

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
                'Verify +1-${widget.phone}',
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
                  print(pin);
                  print(_verificationCode);
                  if (pin == _verificationCode) {}
                  // signUpUser();
                  // if (pin == _verificationCode) {
                  //   print("done");
                  //   print(_verificationCode);
                  //   print(pin);
                  // } else {
                  //   print("fuck");
                  //   print(_verificationCode);
                  //   print(pin.hashCode);
                  //   print(PhoneAuthProvider.credential(
                  //       verificationId: _verificationCode, smsCode: pin));
                  // }
                  // await FirebaseAuth.instance
                  //     .signInWithCredential(PhoneAuthProvider.credential(
                  //         verificationId: _verificationCode, smsCode: pin))
                  //     .then((value) async {
                  //   if (value.user != null) {
                  //     Navigator.pushAndRemoveUntil(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => const BookingPage()),
                  //         (route) => false);
                  //   }
                  // });
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
  }

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+1 1234567891',
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Navigator.pushAndRemoveUntil(
          //     context,
          //     MaterialPageRoute(builder: (context) => const BookingPage()),
          //     (route) => false);
          // await FirebaseAuth.instance
          //     .signInWithCredential(credential)
          //     .then((value) async {
          //   if (value.user != null) {
          //     Navigator.pushAndRemoveUntil(
          //         context,
          //         MaterialPageRoute(builder: (context) => const BookingPage()),
          //         (route) => false);
          //   }
          // });
          print("success");
        },

        // await FirebaseAuth.instance
        //     .createUserWithEmailAndPassword(
        //   email: widget.email,
        //   password: widget.password,
        // )
        //     .then((value) async {
        //   signUpUser();
        // });
        // print(credential);
        // Navigator.of(context).pushReplacement(
        //     MaterialPageRoute(builder: (context) => const BookingPage()));
        // },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (verficationID, resendToken) {
          setState(() {
            _verificationCode = verficationID;
          });
          print("code sent");
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: const Duration(seconds: 120));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verifyPhone();
  }
}
