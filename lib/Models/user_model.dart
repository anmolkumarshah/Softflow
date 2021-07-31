import 'dart:io';
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
  String deptCd; // for branch
  String deptCd1; // for role
  String co;
  String yr;
  String email;
  String mobile;
  String acc_id;
  String acc_id1;
  String acc_id2;
  String station;
  String station1;
  String station2;

  show() {
    print(this.id);
    print(this.name);
    print(this.co);
    print("year" + this.yr);
    print(this.deptCd);
    print(this.email);
    print(this.acc_id);
    print(this.station);
  }

  User({
    required this.password,
    required this.email,
    this.id = '-1',
    this.mobile = '-1',
    this.name = "-1",
    this.deptCd = '-1',
    this.co = '-1',
    this.yr = '-1',
    this.acc_id = '-1',
    this.acc_id1 = '-1',
    this.acc_id2 = '-1',
    this.station = '-1',
    this.station1 = '-1',
    this.station2 = '-1',
    this.deptCd1 = '-1'
  });

  // generic method for all get methods
  static Future getMethod(url) async {
    try {
      final uri = Uri.parse(url);
      final result = await http.get(
        uri,
        // headers: {'Context-Type': 'application/json;charSet=UTF-8'},
        //   header("Access-Control-Allow-Origin: *");
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

  static Future fileUpload(String co, File file) async {
    final byte = await file.readAsBytes();
    String buffer =  base64Encode(byte);
    print(buffer);
    final UrlGlobal urlObject = UrlGlobal(
      host:
          "http://167.114.35.29/sfs_api/bill.asmx/xUploadFile_With_ANY_FORMAT?fileName=${'anmol.jpg'}&xstoragePath='http://167.114.35.29/sfs_api/bill.asmx/WebSrvERPConfigMaster?coid=2'&buffer=$buffer",
    );
    try {
      final url = urlObject.fileUploadUrl();
      final result = await User.getMethod(url);
      // final data = json.decode(result.body);
      print(result.body);
      return 'url';
    } catch (e) {
      print("ANmol" + e.toString());
      return {
        "message": "Error occurred while getting and setting uid for New User"
      };
    }
  }

  static Future getUid() async {
    final UrlGlobal urlObject = new UrlGlobal(
        p2: "",
        p1: '2',
        p: '2',
        last: 'tblno=602&cid=0&yr=0&xdt=04/01/2000&serno=0');
    try {
      final url = urlObject.getUrl();
      final result = await User.getMethod(url);
      final data = json.decode(result.body);
      return data['uid'];
    } catch (e) {
      return {
        "message": "Error occurred while getting and setting uid for New User"
      };
    }
  }

  // dept_cd1 for role , dept_cd for branch
  static Future<Map<String, dynamic>> addNewUser(
      Map<String, dynamic> user) async {
    final uid = await User.getUid();
    final query = """
    
    insert into usr_mast(usr_nm,pwd,dept_cd1,mobile,email,id,acc_id,acc_id1,
    acc_id2,station,station1,station2,dept_cd)
    
    values ('${user['name']}', '${user['password']}', '${user['type']}', 
    '${user['mobile']}', '${user['email']}','$uid', '${user['acc_id']}',
    '${user['acc_id1']}','${user['acc_id2']}', '${user['station']}', 
    '${user['station1']}', '${user['station2']}', '${user['branch']}') 
    
    """;
    final UrlGlobal urlObject = new UrlGlobal(
      p2: query,
      p1: '1',
      p: '2',
    );
    final url = urlObject.getUrl();
    print(url);
    try {
      final result = await getMethod(url);
      final data = json.decode(result.body);
      return {"message": 'success', 'data': 'prodList'};
    } catch (e) {
      return {"message": "Error occurred while fetching products"};
    }
  }

  static Future<Map<String, dynamic>> getAllUser() async {
    final UrlGlobal urlObject = new UrlGlobal(
      p2: "select * from usr_mast",
    );
    final url = urlObject.getUrl();
    try {
      final result = await getMethod(url);
      final data = json.decode(result.body);
      final userList = (data as List<dynamic>)
          .map((record) => new User(
        email: record['email'].toString().trim(),
        password: record['pwd'].toString().trim(),
        id: record['id'].toString().trim(),
        name: record['usr_nm'].toString().trim(),
        mobile: record['mobile'].toString().trim(),
        deptCd1: record['dept_cd1'].toString().trim(),
        deptCd: record['dept_cd'].toString().trim(),
        acc_id: record['acc_id'].toString().trim(),
        acc_id1: record['acc_id1'].toString().trim(),
        acc_id2: record['acc_id2'].toString().trim(),
        station1: record['station'].toString().trim(),
        station2: record['station1'].toString().trim(),
        station: record['station2'].toString().trim(),
      ))
          .toList();
      return {"message": 'success', 'data': userList};
    } catch (e) {
      return {"message": "Error occurred while fetching user list"};
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

  Future<Map<String, dynamic>> getYears({String query = ''}) async {
    final UrlGlobal urlObject = new UrlGlobal(
      p2: query != "" ? query : "select * from co_yr where Co = '${this.co}'",
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

  Future<Map<String, dynamic>> getCompany({String query = ''}) async {
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

  Future<Map<String, dynamic>> login() async {
    final UrlGlobal urlObject = new UrlGlobal(
        p2: "select * from usr_mast where email = '${this.email}' and pwd = '${this.password}' ");
    final url = urlObject.getUrl();
    print(url);
    final result = await getMethod(url);
    try {
      final data = json.decode(result.body);
      if (result.statusCode == 200) {
        this.name = data[0]['usr_nm'].toString().trim();
        this.deptCd = data[0]['dept_cd'].toString().trim();
        this.deptCd1 = data[0]['dept_cd1'].toString().trim();
        this.id = data[0]['id'].toString().trim();
        this.mobile = data[0]['mobile'].toString().trim();
        this.station = data[0]['station'].toString().trim();
        this.station1 = data[0]['station1'].toString().trim();
        this.station2 = data[0]['station2'].toString().trim();
        this.acc_id = data[0]['acc_id'].toString().trim();
        this.acc_id1 = data[0]['acc_id1'].toString().trim();
        this.acc_id2 = data[0]['acc_id2'].toString().trim();
        return {"message": "Login successful", "result": data[0]};
      }
    } catch (e) {
      return {"message": "Login Error"};
    }
    return {"message": "Login Error"};
  }
}
