import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:softflow_app/Helpers/Snakebar.dart';
import 'package:softflow_app/Models/user_model.dart';
import 'package:softflow_app/Providers/main_provider.dart';
import 'package:softflow_app/Screens/Common/co_selection_screen.dart';

class InitLoader extends StatefulWidget {
  String email;
  String pass;
  InitLoader({required this.email, required this.pass});
  @override
  State<InitLoader> createState() => _InitLoaderState();
}

class _InitLoaderState extends State<InitLoader> {
  login() async {
    var _user = new User(email: widget.email, password: widget.pass);
    final result = await _user.login();
    showSnakeBar(context, result['message']);
    if (result['message'] == "Login successful") {
      Provider.of<MainProvider>(context, listen: false).loginUpdate(_user);
      Navigator.of(context).pushNamed(CoSelectionScreen.routeName);
    }
  }

  @override
  void initState() {
    super.initState();
    login();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/back.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
