import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

// ignore: non_constant_identifier_names
Widget TextFieldHelper(
  TextEditingController controller,
  String labelText,
  TextInputType inputType, {
  bool enable = true,
  bool noValidate = false,
}) {
  return TextFormField(
    controller: controller,
    enabled: enable,
    keyboardType: inputType,
    validator: noValidate
        ? MultiValidator([])
        : MultiValidator(
            [
              RequiredValidator(errorText: "* Required"),
              inputType == TextInputType.phone
                  ? MinLengthValidator(10,
                      errorText: "Enter Valid Mobile Number")
                  : MinLengthValidator(2,
                      errorText: 'Must be 2 Characters long')
            ],
          ),
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(
          // fontSize: 25,
          ),
      border: OutlineInputBorder(),
    ),
  );
}
