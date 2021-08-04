import 'dart:convert';

import 'package:softflow_app/Helpers/getMethodHelperFunction.dart';
import 'package:softflow_app/Models/url_model.dart';

class Truck {
  String uid;
  String truckNo;
  String panNo;

  Truck({required this.panNo, required this.truckNo, required this.uid});

  String getNo() {
    return this.truckNo;
  }

  String getId() {
    return this.uid;
  }

  static Future<Map<String, dynamic>> getTrucks(
      String co, String pattern) async {
    final UrlGlobal urlObject = new UrlGlobal(
      p2: "select * from z_trk_000$co where truck_no like '%$pattern%' ",
    );
    final url = urlObject.getUrl();
    try {
      final result = await getMethod(url);
      final data = json.decode(result.body);
      final truckList = (data as List<dynamic>)
          .map((record) => new Truck(
                uid: record['uid'].toString(),
                truckNo: record['truck_no'].toString(),
                panNo: record['pan_no'].toString(),
              ))
          .toList();
      return {"message": 'success', 'data': truckList};
    } catch (e) {
      return {"message": "Error occurred while fetching Stations"};
    }
  }

  static Future<void> getTruckNoById(
    String co,
    String id,
  ) async {
    final UrlGlobal urlObject = new UrlGlobal(
      p2: "select truck_no from z_trk_000$co where uid = '$id'",
    );
    final url = urlObject.getUrl();
    print(url);
    try {
      final result = await getMethod(url);
      final data = json.decode(result.body);
      return data[0]['truck_no'];
    } catch (e) {
      // return {"message": "Error occurred while fetching party names"};
      print(e);
    }
  }
}
