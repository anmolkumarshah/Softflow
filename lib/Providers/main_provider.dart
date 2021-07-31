import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Models/user_model.dart';

class MainProvider with ChangeNotifier {
  User mainUser = new User(email: '-1', password: "-1");

  Map<String, List<XFile>> files = {'first': []};

  Map<String, List<XFile>> getFile(){
    return files;
  }

  void setFirst(list){
    files['first'] = list;
    notifyListeners();
  }



   void loginUpdate(User newUser) {
    this.mainUser = newUser;
    mainUser.show();
    notifyListeners();
  }

  User get user {
    return mainUser;
  }
}
