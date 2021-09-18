import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class StyleContainer extends StatelessWidget {
  late Widget child;
  late String name;
  late IconData icon;
  StyleContainer({
    required this.child,
    required this.name,
    required this.icon,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          width: 1,
          color: Colors.grey,
        ),
      ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.,
        children: [
          Icon(
            icon,
            color: Colors.blue,
          ),
          SizedBox(
            width: 20,
          ),
          Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              // fontSize: 20,
            ),
          ),
          Expanded(child: Text("")),
          this.child,
        ],
      ),
    );
  }
}
