import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:softflow_app/Providers/main_provider.dart';

//login Screen
import './Screens/login_screen.dart';
//co Screen
import './Screens/co_selection_screen.dart';

void main() {
  runApp(new SoftFlowApp());
}

class SoftFlowApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => new MainProvider(),
      child: new MaterialApp(
        theme: new ThemeData(
          primaryColor: Colors.blueAccent,
          accentColor: Colors.redAccent,
        ),
        debugShowCheckedModeBanner: false,
        home: new LoginScreen(),
        routes: {
          CoSelectionScreen.routeName : (context) => new CoSelectionScreen(),
        },
      ),
    );
  }
}
