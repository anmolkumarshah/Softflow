import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:softflow_app/Providers/main_provider.dart';
import '../Helpers/Snakebar.dart';
import '../Screens/co_selection_screen.dart';
import '../Models/user_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
  static const routeName = '/loginScreen';
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = new GlobalKey<FormState>();
  final _userId = new FocusNode();
  final _password = new FocusNode();
  bool _isLoading = false;
  double height = 240;

  var _user = new User(email: "", password: "");

  void handleSubmit() async {
    setState(() {
      _isLoading = true;
    });
    _form.currentState!.save();
    if (_form.currentState!.validate() &&
        _user.email != "" &&
        _user.password != "") {
      final result = await _user.login();
      showSnakeBar(context, result['message']);
      setState(() {
        _isLoading = false;
      });
      if (result['message'] == "Login successful") {
        Provider.of<MainProvider>(context, listen: false).loginUpdate(_user);
        Navigator.of(context).pushNamed(CoSelectionScreen.routeName);
      }
    } else {
      setState(() {
        height = 280;
        _isLoading = false;
      });
      showSnakeBar(context, 'Please enter email and password');
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
            height: height,
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
              child: new Column(
                children: [
                  new TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        hintText: 'Enter valid email id as abc@gmail.com'),
                    validator: MultiValidator(
                      [
                        RequiredValidator(errorText: "* Required"),
                        EmailValidator(errorText: "Enter valid email id"),
                      ],
                    ),
                    style: TextStyle(
                        // fontSize: 25,
                        ),
                    onSaved: (value) {
                      _user = new User(
                          email: value.toString(), password: _user.password);
                    },
                    keyboardType: TextInputType.emailAddress,
                    focusNode: _userId,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus(_password);
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  new TextFormField(
                    obscureText: true,
                    style: TextStyle(
                        // fontSize: 25,
                        ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Password",
                    ),
                    validator: MultiValidator([
                      RequiredValidator(errorText: "* Required"),
                      MinLengthValidator(6,
                          errorText:
                              "Password should be at least 6 characters"),
                      MaxLengthValidator(15,
                          errorText:
                              "Password should not be greater than 15 characters")
                    ]),
                    keyboardType: TextInputType.visiblePassword,
                    focusNode: _password,
                    onSaved: (value) {
                      _user = new User(
                          email: _user.email,
                          password: value.toString().trim());
                    },
                  ),
                  Container(
                    width: double.infinity,
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
