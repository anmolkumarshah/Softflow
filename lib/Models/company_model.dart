import 'dart:convert';

import 'package:softflow_app/Helpers/getMethodHelperFunction.dart';
import 'package:softflow_app/Models/url_model.dart';

class Company {
  String id;
  String name;
  Company({required this.name, required this.id});

  static Future<Map<String, dynamic>> getCompany({String query = ''}) async {
    final UrlGlobal urlObject = new UrlGlobal(
      p2: query != "" ? query : "select * from co",
    );
    final url = urlObject.getUrl();
    try {
      final result = await getMethod(url);
      final data = json.decode(result.body);
      final coList = (data as List<dynamic>)
          .map((record) => new Company(
                name: record['Name'].toString(),
                id: record['Id'].toString(),
              ))
          .toList();
      return {'message': 'success', 'data': coList};
    } catch (e) {
      return {'message': 'Error occurred while fetching Company names'};
    }
  }
}
