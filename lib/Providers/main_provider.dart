import 'package:flutter/material.dart';
import '../Models/user_model.dart';

class MainProvider with ChangeNotifier {
  User mainUser = new User(id: '-1', password: "-1");

  void loginUpdate(User newUser) {
    this.mainUser = newUser;
    print(this.mainUser);
    notifyListeners();
  }

  User get user {
    return mainUser;
  }
}
