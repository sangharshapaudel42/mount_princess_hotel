import 'package:flutter/material.dart';

import 'package:mount_princess_hotel/widgets/text_field_input.dart';
import 'package:mount_princess_hotel/utils/colors.dart';

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

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _messageController.dispose();
  }

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
                const SizedBox(height: 10),
                MaterialButton(
                  height: 45,
                  minWidth: double.infinity,
                  color: const Color(0xff024DB8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Column(
              children: const [
                Text(
                  'Address',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30),
                ),
                Text(
                  'Araniko Highway Dhulikhel Bus Park, 45200 Dhulikhel, Nepal\n\nPHONE:\n(+977) 011-490616\n\nEMAIL:\ninfo@mountprincess.com',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
