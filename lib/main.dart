import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//login Screen
import './Screens/login_screen.dart';

void main() {
  runApp(new SoftFlowApp());
}

class SoftFlowApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => null,
      child: new MaterialApp(
        theme: new ThemeData(
          primaryColor: Colors.deepOrange,
          accentColor: Colors.blueAccent,
        ),
        debugShowCheckedModeBanner: false,
        home: new LoginScreen(),
        routes: {},
      ),
    );
  }
}
