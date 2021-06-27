import 'package:http/http.dart' as http;
import 'package:softflow_app/Models/year_model.dart';
import 'dart:convert';
import '../Models/company_model.dart';

class User {
  String id;
  String password;
  String name;
  String coId;
  String uId;
  String co;

  User({
    required this.id,
    required this.password,
    this.name = "-1",
    this.coId = '-1',
    this.uId = '-1',
    this.co = '-1',
  });

  // generic method for all get methods
  getMethod(url) async {
    try {
      final uri = Uri.parse(url);
      final result = await http.get(
        uri,
        headers: {'Context-Type': 'application/json;charSet=UTF-8'},
      );
      return result;
    } catch (e) {
      print(e);
    }
  }

  // generic post method for all post methods
  postMethod(url, bodyObject) async {
    try {
      final uri = Uri.parse(url);
      final result = await http.post(
        uri,
        headers: {'Context-Type': 'application/json;charSet=UTF-8'},
        body: bodyObject,
      );
      return result;
    } catch (e) {
      print(e);
    }
  }

  Future<List<Year>> getYears() async {
    const url = "http://10.0.2.2:5000/user/coYr";
    final result = await postMethod(url, {'co': this.co});
    final data = json.decode(result.body) as Map<String, dynamic>;
    final yrList = (data['result']['recordset'] as List<dynamic>)
        .map((record) => new Year(
              year: this.co + record['Yr'].toString(),
            ))
        .toList();
    return yrList;
  }

  Future<List<Company>> getCompany() async {
    const url = "http://10.0.2.2:5000/user/allCo";
    final result = await getMethod(url);
    final data = json.decode(result.body) as Map<String, dynamic>;
    final coList = (data['result']['recordset'] as List<dynamic>)
        .map((record) => new Company(
              name: record['Name'].toString(),
              id: record['Id'].toString(),
            ))
        .toList();
    return coList;
  }

  Future<Map<String, dynamic>> login() async {
    const url = "http://10.0.2.2:5000/user/login";
    final result = await postMethod(url, {
      'id': this.id,
      'password': this.password,
    });
    final data = json.decode(result.body) as Map<String, dynamic>;
    if (result.statusCode == 200) {
      this.name = data['user']['usr_nm'].toString().trim();
      this.coId = data['user']['co_id'].toString().trim();
      this.uId = data['user']['u_id'].toString().trim();
    }
    return data;
  }
}
