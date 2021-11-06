import 'package:flutter/material.dart';

// ignore: must_be_immutable
class OptionWidget extends StatelessWidget {
  String text;
  var routeName;
  var arguments;

  OptionWidget({this.text = "Title", this.routeName = "", this.arguments});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(this.routeName, arguments: arguments);
      },
      child: new Container(
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.secondary,
          boxShadow: [],
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              this.text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'Notoserif',
                fontSize: 30,
              ),
              softWrap: true,
              maxLines: 2,
            ),
          ),
        ),
      ),
    );
  }
}
