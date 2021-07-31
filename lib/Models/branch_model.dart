import 'dart:convert';
import 'package:softflow_app/Models/url_model.dart';
import '../Helpers/getMethodHelperFunction.dart';

class Branch {
  String id;
  String name;

  Branch({required this.id, required this.name});

  static Future<Map<String, dynamic>> getBranchItem(String coId) async {
    final UrlGlobal urlObject = new UrlGlobal(
      p2: "select * from brnch where co_id = '$coId' ",
    );
    final url = urlObject.getUrl();
    try {
      final result = await getMethod(url);
      final data = json.decode(result.body);
      final branchItemList = (data as List<dynamic>)
          .map((record) => new Branch(
                id: record['id'].toString(),
                name: record['name'].toString(),
              ))
          .toList();
      return {"message": 'success', 'data': branchItemList};
    } catch (e) {
      return {"message": "Error occurred while Branch items"};
    }
  }
}
