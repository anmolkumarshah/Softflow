import 'package:flutter/material.dart';

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
          gradient: LinearGradient(
            colors: [
    Colors.pinkAccent,
              Theme.of(context).accentColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          color: Theme.of(context).accentColor,
          boxShadow: [
            // BoxShadow(
            //   color: Colors.grey.withOpacity(0.5),
            //   spreadRadius: 3,
            //   blurRadius: 2,
            //   offset: Offset(0, 3), // changes position of shadow
            // ),
          ],
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
            ),
          ),
        ),
      ),
    );
  }
}
