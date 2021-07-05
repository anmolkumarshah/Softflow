import 'package:http/http.dart' as http;
import 'package:softflow_app/Models/partyName_model.dart';
import 'package:softflow_app/Models/product_model.dart';
import 'package:softflow_app/Models/station_model.dart';
import 'package:softflow_app/Models/truck_model.dart';
import 'package:softflow_app/Models/url_model.dart';
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
  String yr;

  User({
    required this.id,
    required this.password,
    this.name = "-1",
    this.coId = '-1',
    this.uId = '-1',
    this.co = '-1',
    this.yr = '-1',
  });

  // generic method for all get methods
  getMethod(url) async {
    try {
      final uri = Uri.parse(url);
      final result = await http.get(
        uri,
        // headers: {'Context-Type': 'application/json;charSet=UTF-8'},
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

  Future<Map<String, dynamic>> getProducts(String co, String pattern) async {
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

  Future<Map<String, dynamic>> getTrucks(String co, String pattern) async {
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

  Future<Map<String, dynamic>> getStations(String pattern) async {
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

  Future<Map<String, dynamic>> getPartyName(
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

  Future<Map<String, dynamic>> getYears() async {
    final UrlGlobal urlObject = new UrlGlobal(
      p2: "select * from co_yr where Co = '${this.co}'",
    );
    final url = urlObject.getUrl();
    try {
      final result = await getMethod(url);
      final data = json.decode(result.body);
      final yrList = (data as List<dynamic>)
          .map((record) => new Year(
                year: this.co + record['Yr'].toString(),
              ))
          .toList();
      return {"message": 'success', 'data': yrList};
    } catch (e) {
      return {"message": "Error occurred while fetching years"};
    }
  }

  Future<Map<String, dynamic>> getCompany() async {
    final UrlGlobal urlObject = new UrlGlobal(
      p2: "select * from co",
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

  Future<Map<String, dynamic>> login() async {
    final UrlGlobal urlObject = new UrlGlobal(
        p2: "select * from usr_mast where usr_nm = '${this.id}' and pwd = '${this.password}' ");
    final url = urlObject.getUrl();
    print(url);
    final result = await getMethod(url);
    try {
      final data = json.decode(result.body);
      if (result.statusCode == 200) {
        this.name = data[0]['usr_nm'].toString().trim();
        this.uId = data[0]['id'].toString().trim();
        return {"message": "Login successful", "result": data[0]};
      }
    } catch (e) {
      return {"message": "Login Error"};
    }
    return {"message": "Login Error"};
  }
}
