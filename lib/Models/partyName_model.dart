import 'dart:convert';

import 'package:softflow_app/Helpers/getMethodHelperFunction.dart';
import 'package:softflow_app/Models/url_model.dart';

class PartyName {
  String name;
  String id; // it is account id acc_id
  PartyName({required this.id, required this.name});

  String showName() {
    return this.name;
  }

  String getId() {
    return this.id;
  }

  static Future<Map<String, dynamic>> getPartyName(
    String co,
    String yr,
    String pattern,
    String balCd,
  ) async {
    yr = yr.substring(2);
    final UrlGlobal urlObject = new UrlGlobal(
      p2: "select n.acc_id,n.party_nm from z_par_000$co n left outer join z_par_000${co}_$yr i on n.acc_id = i.acc_id where n.party_nm like '%$pattern%' and  n.bal_cd='$balCd'",
    );
    final url = urlObject.getUrl();
    try {
      final result = await getMethod(url);
      final data = json.decode(result.body);
      final partyNameList = (data as List<dynamic>)
          .map(
            (record) => new PartyName(
              id: record['acc_id'].toString(),
              name: record['party_nm'].toString(),
            ),
          )
          .toList();
      if (partyNameList.isEmpty) {
        return {"message": "No Result for this search"};
      }
      return {"message": 'success', 'data': partyNameList};
    } catch (e) {
      return {"message": "Error occurred while fetching party names"};
    }
  }

  static Future<void> getNameOfPartyById(
    String id,
  ) async {
    final UrlGlobal urlObject = new UrlGlobal(
      p2: "select party_nm from  z_par_0001 where acc_id = $id and  bal_cd='A5'",
    );
    final url = urlObject.getUrl();
    print(url);
    try {
      final result = await getMethod(url);
      final data = json.decode(result.body);
      return data[0]['party_nm'];
    } catch (e) {
      // return {"message": "Error occurred while fetching party names"};
      print(e);
    }
  }
}
