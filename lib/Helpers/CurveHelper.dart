import 'package:flutter/cupertino.dart';

class ClipPathClass extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, 600);
    // var firstControlPoint = Offset(55, size.height / 1.4);
    // var firstEndPoint = Offset(size.width / 1.7, size.height / 1.3);
    // path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
    //     firstEndPoint.dx, firstEndPoint.dy);
    // var secondControlPoint = Offset(size.width - (35), size.height - 85);
    // var secondEndPoint = Offset(size.width, size.height / 2.4);
    // // path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
    // //     secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, 200);
    path.lineTo(400, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
