import 'dart:convert';

import 'package:softflow_app/Models/url_model.dart';

import 'getMethodHelperFunction.dart';

Future<Map<String, dynamic>> check(String query) async {
  final UrlGlobal urlObject = new UrlGlobal(
    p2: query,
  );
  final url = urlObject.getUrl();
  // print(url);
  try {
    final result = await getMethod(url);
    final data = json.decode(result.body);
    return {"message": 'success', 'data': data};
  } catch (e) {
    return {"message": "success", 'data': []};
  }
}
