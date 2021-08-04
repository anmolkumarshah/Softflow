import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
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
