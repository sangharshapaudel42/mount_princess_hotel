import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mount_princess_hotel/resources/send_email.dart';
import 'package:mount_princess_hotel/utils/utils.dart';

import 'package:mount_princess_hotel/widgets/text_field_input.dart';
import 'package:mount_princess_hotel/utils/colors.dart';
import 'package:http/http.dart' as http;

class ContactUsDetail extends StatefulWidget {
  const ContactUsDetail({Key? key}) : super(key: key);

  @override
  _ContactUsDetailState createState() => _ContactUsDetailState();
}

class _ContactUsDetailState extends State<ContactUsDetail> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    _subjectController.dispose();
  }

  // // Email to the admin ////
  // Future sendEmail({
  //   required String name,
  //   required String phoneNumber,
  //   required String email,
  //   required String subject,
  //   required String message,
  // }) async {
  //   final serviceId = 'service_zckc95c';
  //   final templateId = 'template_xmxpd8n';
  //   final userId = 'o5HYmxK4h31SqZHS7';

  //   final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
  //   final response = await http.post(
  //     url,
  //     headers: {
  //       'origin': 'http://localhost',
  //       'Content-Type': 'application/json',
  //     },
  //     body: jsonEncode({
  //       'service_id': serviceId,
  //       'template_id': templateId,
  //       'user_id': userId,
  //       'template_params': {
  //         'user_name': name,
  //         'user_phoneNumber': phoneNumber,
  //         'to_email': "ishapanta0124@gmail.com",
  //         'to_name': "Hotel Application",
  //         'user_email': email,
  //         'user_subject': subject,
  //         'user_message': message,
  //       },
  //     }),
  //   );

  //   print(response.body);
  //   if (response.body.toString() == "OK") {
  //     _nameController.text = "";
  //     _phoneController.text = "";
  //     _emailController.text = "";
  //     _messageController.text = "";
  //     _subjectController.text = "";
  //     showSnackBar(context, "Email sent successfully.");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );
    return SingleChildScrollView(
      child: Column(
        children: [
          const Text(
            'Contact Us',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30),
          ),
          const SizedBox(height: 20),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                TextFieldInput(
                  hintText: "Name",
                  textInputType: TextInputType.text,
                  textEditingController: _nameController,
                  icon: Icons.person,
                  color: Colors.white,
                ),
                const SizedBox(height: 20),
                TextFieldInput(
                  hintText: "Phone number",
                  textInputType: TextInputType.phone,
                  textEditingController: _phoneController,
                  icon: Icons.phone,
                  color: Colors.white,
                ),
                const SizedBox(height: 20),
                TextFieldInput(
                  hintText: "Email",
                  textInputType: TextInputType.emailAddress,
                  textEditingController: _emailController,
                  icon: Icons.email,
                  color: Colors.white,
                ),
                const SizedBox(height: 20),
                TextFieldInput(
                  hintText: "Subject",
                  textInputType: TextInputType.phone,
                  textEditingController: _subjectController,
                  icon: Icons.subject,
                  color: Colors.white,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _messageController,
                  style: const TextStyle(fontSize: 20),
                  keyboardType: TextInputType.multiline,
                  maxLines: 6,
                  decoration: InputDecoration(
                    hintText: "Message",
                    hintStyle: const TextStyle(fontSize: 20),
                    fillColor: Colors.white,
                    border: inputBorder,
                    focusedBorder: inputBorder,
                    enabledBorder: inputBorder,
                    filled: true,
                    contentPadding: const EdgeInsets.all(8),
                  ),
                ),
                const SizedBox(height: 15),
                MaterialButton(
                  height: 45,
                  minWidth: double.infinity,
                  color: const Color(0xff024DB8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                  onPressed: () {
                    if (_nameController.text.isNotEmpty &&
                        _phoneController.text.isNotEmpty &&
                        _emailController.text.isNotEmpty &&
                        _subjectController.text.isNotEmpty &&
                        _messageController.text.isNotEmpty) {
                      sendEmail(
                        context: context,
                        name: _nameController.text,
                        phoneNumber: _phoneController.text,
                        email: _emailController.text,
                        subject: _subjectController.text,
                        message: _messageController.text,
                      );
                    } else {
                      FocusScope.of(context).unfocus();
                      showSnackBar(context, "Enter all the fields.");
                    }
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Column(
            children: const [
              Text(
                'Address',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30),
              ),
              Text(
                'Araniko Highway Dhulikhel Bus Park, 45200 Dhulikhel, Nepal\n\nPHONE:\n(+977) 011-490616\n\nEMAIL:\ninfo@hotelapplication.com',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
