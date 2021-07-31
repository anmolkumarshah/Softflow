import 'package:flutter/material.dart';

Widget TextFieldHelper(
  TextEditingController controller,
  String labelText,
  TextInputType inputType, {
  bool enable = true,
}) {
  return TextField(
    controller: controller,
    enabled: enable,
    keyboardType: inputType,
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(
        // fontSize: 25,
      ),
      border: OutlineInputBorder(),
    ),
  );
}
