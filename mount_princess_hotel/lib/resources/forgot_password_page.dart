import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mount_princess_hotel/utils/colors.dart';
import 'package:mount_princess_hotel/utils/utils.dart';

class ForgotPasswordpage extends StatefulWidget {
  const ForgotPasswordpage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordpage> createState() => _ForgotPasswordpageState();
}

class _ForgotPasswordpageState extends State<ForgotPasswordpage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: const Text("Reset Password"),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Receive an email to\nreset your password.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: const TextStyle(fontSize: 20),
                  fillColor: Colors.grey[450],
                  border: inputBorder,
                  focusedBorder: inputBorder,
                  enabledBorder: inputBorder,
                  filled: true,
                  contentPadding: const EdgeInsets.all(8),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) =>
                    email != null && !EmailValidator.validate(email)
                        ? "Enter a valid email"
                        : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () => resetPassword(),
                icon: const Icon(Icons.email_outlined),
                label: const Text(
                  "Reset Password",
                  style: TextStyle(fontSize: 24),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future resetPassword() async {
    try {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
                child: CircularProgressIndicator(),
              ));
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());

      showSnackBar(context, "Password Reset Email Sent");

      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);

      Navigator.pop(context);
    }
  }
}
