import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:softflow_app/Providers/main_provider.dart';
import '../Helpers/Snakebar.dart';

import '../Screens/co_selection_screen.dart';
import '../Models/user_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = new GlobalKey<FormState>();
  final _userId = new FocusNode();
  final _password = new FocusNode();
  bool _isLoading = false;

  var _user = new User(id: "", password: "");


  void handleSubmit() async {
    setState(() {
      _isLoading = true;
    });
    _form.currentState!.save();
    if (_user.id != "" && _user.password != "") {
      final result = await _user.login();
      showSnakeBar(context, result['message']);
      setState(() {
        _isLoading = false;
      });
      if(result['message'] == "Login successful"){
        Provider.of<MainProvider>(context, listen: false).loginUpdate(_user);
        Navigator.of(context).pushReplacementNamed(CoSelectionScreen.routeName);
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      showSnakeBar(context, 'Please enter user id and password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              "https://cdn.pixabay.com/photo/2016/03/24/17/46/highway-1277246__340.jpg",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: new Center(
          child: new Container(
            height: 330,
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(20),
            decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 15,
                  )
                ]),
            child: new Form(
              key: _form,
              child: new ListView(
                children: [
                  new TextFormField(
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      labelText: "User Id",
                    ),
                    style: TextStyle(fontSize: 25,),
                    onSaved: (value) {
                      _user = new User(
                          id: value.toString().toUpperCase(),
                          password: _user.password);
                    },
                    focusNode: _userId,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus(_password);
                    },
                  ),
                  new TextFormField(
                    obscureText: true,
                    style: TextStyle(fontSize: 25,),
                    decoration: InputDecoration(
                      labelText: "Password",
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    focusNode: _password,
                    onSaved: (value) {
                      _user = new User(
                          id: _user.id,
                          password: value.toString().toUpperCase());
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: handleSubmit,
                      child: _isLoading
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: new CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : new Text(
                              "Login",
                              style: TextStyle(
                                  // color: Colors.black,
                                  // fontWeight: FontWeight.bold,
                                  // fontSize: 20,
                                  ),
                            ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
