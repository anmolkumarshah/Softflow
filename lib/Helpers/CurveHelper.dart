import 'package:flutter/cupertino.dart';

class ClipPathClass extends CustomClipper<Path> {
  // @override
  // Path getClip(Size size) {
  //   var path = Path();
  //   path.lineTo(0.0, size.height - 30);
  //
  //   var firstControlPoint = Offset(size.width / 4, size.height);
  //   var firstPoint = Offset(size.width / 2, size.height);
  //   path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
  //       firstPoint.dx, firstPoint.dy);
  //
  //   var secondControlPoint = Offset(size.width - (size.width / 4), size.height);
  //   var secondPoint = Offset(size.width, size.height - 30);
  //   path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
  //       secondPoint.dx, secondPoint.dy);
  //
  //   path.lineTo(size.width, 0.0);
  //   path.close();
  //
  //   return path;
  //
  //
  // }

  @override
  getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height);
    var firstControlPoint = Offset(55, size.height / 1.4);
    var firstEndPoint = Offset(size.width / 1.7, size.height / 1.3);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    var secondControlPoint = Offset(size.width - (35), size.height - 95);
    var secondEndPoint = Offset(size.width, size.height / 2.4);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height - 40);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}