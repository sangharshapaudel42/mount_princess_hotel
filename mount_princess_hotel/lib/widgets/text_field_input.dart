import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;
  final IconData icon;
  final Color color;
  const TextFieldInput({
    Key? key,
    required this.textEditingController,
    this.isPass = false,
    required this.hintText,
    required this.textInputType,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );

    var size = MediaQuery.of(context).size;
    // final focusedBorder = OutlineInputBorder(
    //   borderSide: BorderSide(color: Colors.blue, width: 5.0),
    // );
    return TextField(
      controller: textEditingController,
      style: const TextStyle(fontSize: 20),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.grey.shade700, size: 25),
        hintText: hintText,
        hintStyle: const TextStyle(fontSize: 20),
        fillColor: color,
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        contentPadding: EdgeInsets.all(size.height / 80),
      ),
      keyboardType: textInputType,
      obscureText: isPass,
    );
  }
}
