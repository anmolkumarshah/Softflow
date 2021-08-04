import 'dart:convert';

import 'package:softflow_app/Helpers/getMethodHelperFunction.dart';
import 'package:softflow_app/Models/url_model.dart';

class Station {
  String id;
  String name;
  Station({required this.id, required this.name});

  String showName() {
    return this.name;
  }

  String getId() {
    return this.id;
  }

  static Future<Map<String, dynamic>> getStations(String pattern) async {
    final UrlGlobal urlObject = new UrlGlobal(
      p2: "select unit_id,unit_nm from z_units where sub_id = 4 and unit_nm like '$pattern%'",
    );
    final url = urlObject.getUrl();
    try {
      final result = await getMethod(url);
      final data = json.decode(result.body);
      final stationList = (data as List<dynamic>)
          .map((record) => new Station(
                id: record['unit_id'].toString(),
                name: record['unit_nm'].toString(),
              ))
          .toList();
      if (stationList.isEmpty) {
        return {"message": "No Result for this search"};
      }
      return {"message": 'success', 'data': stationList};
    } catch (e) {
      return {"message": "Error occurred while fetching Stations"};
    }
  }
}
