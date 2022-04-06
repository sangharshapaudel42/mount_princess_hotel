import 'package:flutter/material.dart';

class AdminTextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final TextInputType textInputType;
  final String labelTextInput;
  final int maxlines;
  const AdminTextFieldInput({
    Key? key,
    required this.textEditingController,
    required this.textInputType,
    required this.labelTextInput,
    required this.maxlines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );
    // final focusedBorder = OutlineInputBorder(
    //   borderSide: BorderSide(color: Colors.blue, width: 5.0),
    // );
    return TextField(
      controller: textEditingController,
      style: const TextStyle(fontSize: 20),
      decoration: InputDecoration(
        labelText: labelTextInput,
        labelStyle: const TextStyle(fontSize: 25),
        fillColor: Colors.grey[450],
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
      keyboardType: textInputType,
      maxLines: maxlines,
      // maxLines: maxlines == 0 ? null : maxlines,
    );
  }
}
