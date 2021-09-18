import 'dart:convert';
import 'package:softflow_app/Models/url_model.dart';
import '../Helpers/getMethodHelperFunction.dart';

class BalCd {
  String bal_cd; // ": "A1",
  String name; // ": "FIXED ASSETS",
  String bal_cd1; // ": "  ",
  String grp; // ": 0,

  BalCd({
    required this.bal_cd,
    required this.bal_cd1,
    required this.grp,
    required this.name,
  });

  static Future<Map<String, dynamic>> getBalCd() async {
    final UrlGlobal urlObject = new UrlGlobal(
      p2: "select * from sch where bal_cd in ('A5','L5')",
    );
    final url = urlObject.getUrl();
    try {
      final result = await getMethod(url);
      final data = json.decode(result.body);
      final balCdList = (data as List<dynamic>)
          .map((record) => new BalCd(
                bal_cd: record['bal_cd'].toString(),
                bal_cd1: record['bal_cd1'].toString(),
                grp: record['grp'].toString(),
                name: record['name'].toString(),
              ))
          .toList();
      return {"message": 'success', 'data': balCdList};
    } catch (e) {
      return {"message": "Error occurred while Bal cd items "};
    }
  }
}
