import 'dart:math';

import 'package:flutter/material.dart';
import 'package:softflow_app/Helpers/Snakebar.dart';
import 'package:softflow_app/Models/user_model.dart';
import 'package:softflow_app/Screens/Admin/registration_screen.dart';

class RandomColorModel {
  Random random = Random();

  Color getColor() {
    return Color.fromARGB(random.nextInt(300), random.nextInt(300),
        random.nextInt(200), random.nextInt(300));
  }
}

class AddUserScreen extends StatefulWidget {
  static const routeName = "/add_user_screen";

  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  List<User> items = [];
  bool _isLoading = false;

  getAndSet() async {
    setState(() {
      _isLoading = true;
    });
    final result = await User.getAllUser();
    if (result['message'] == 'success') {
      setState(() {
        items = result['data'];
        _isLoading = false;
      });
    } else {
      showSnakeBar(context, result['message']);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getAndSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GridView.count(
              crossAxisCount: 2,
              childAspectRatio: (2 / 1),
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              //physics:BouncingScrollPhysics(),
              padding: EdgeInsets.all(10.0),
              children: items
                  .map(
                    (data) => GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.all(16),

                          //  margin:EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                          //color:data.color,
                          color: RandomColorModel().getColor(),
                          child: Column(
                            children: [
                              // Icon(
                              //   data.icon,
                              //   size: 25,
                              //   color: Colors.black,
                              // ),
                              Text('data.title',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black),
                                  textAlign: TextAlign.center)
                            ],
                          ),
                        )),
                  )
                  .toList(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(RegistrationScreen.routeName);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
