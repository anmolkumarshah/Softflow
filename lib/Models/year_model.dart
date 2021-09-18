import 'dart:convert';

import 'package:softflow_app/Helpers/getMethodHelperFunction.dart';
import 'package:softflow_app/Models/url_model.dart';

class Year {
  String year;
  Year({required this.year});

  static Future<Map<String, dynamic>> getYears(
      {String query = '', required String co}) async {
    final UrlGlobal urlObject = new UrlGlobal(
      p2: query != ""
          ? query
          : "select * from co_yr where Co = '$co' order by Yr",
    );
    final url = urlObject.getUrl();
    try {
      final result = await getMethod(url);
      final data = json.decode(result.body);
      final yrList = (data as List<dynamic>)
          .map((record) => new Year(
                year: co + record['Yr'].toString(),
              ))
          .toList();
      return {"message": 'success', 'data': yrList};
    } catch (e) {
      return {"message": "Error occurred while fetching years"};
    }
  }
}
