import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: non_constant_identifier_names
Widget DateSelectorHelper({
  required DateTime selectedDate,
  required BuildContext context,
  required Function onPress,
  required String labelText,
  required bool enable,
}) {
  return Container(
    padding: EdgeInsets.all(5),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      border: Border.all(
        width: 1,
        color: Colors.grey,
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // ignore: unnecessary_null_comparison
        selectedDate != null
            ? FittedBox(
                child: Text(
                  DateFormat.yMMMMd().add_jms().format(selectedDate).toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            : Text(
                labelText,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
        ElevatedButton(
          onPressed: () => onPress(),
          child: Text(
            'Change date',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}
