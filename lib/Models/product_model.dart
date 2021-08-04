import 'dart:convert';

import 'package:softflow_app/Helpers/getMethodHelperFunction.dart';
import 'package:softflow_app/Models/url_model.dart';

class Product {
  String name;
  String id;
  Product({required this.id, required this.name});

  String showName() {
    return this.name;
  }

  String getId() {
    return this.id;
  }

  static Future<Map<String, dynamic>> getProducts(
      String co, String pattern) async {
    final UrlGlobal urlObject = new UrlGlobal(
      p2: "select * from z_prd_0001 where item_nm like '%$pattern%'",
    );
    final url = urlObject.getUrl();
    try {
      final result = await getMethod(url);
      final data = json.decode(result.body);
      final prodList = (data as List<dynamic>)
          .map((record) => new Product(
                name: record['item_nm'].toString().trim(),
                id: record['item_id'].toString().trim(),
              ))
          .toList();
      return {"message": 'success', 'data': prodList};
    } catch (e) {
      return {"message": "Error occurred while fetching products"};
    }
  }
}
