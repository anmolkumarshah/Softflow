import 'dart:convert';
import 'package:softflow_app/Helpers/getMethodHelperFunction.dart';
import 'package:softflow_app/Helpers/preCheck.dart';
import 'package:softflow_app/Models/url_model.dart';

class Truck {
  String uid;
  String truckNo;
  String panNo;

  String owner; // ": "",
  String addr; // ": "",
  String place; // ": "                    ",
  int tds; // ": false,
  int own; // ": false,
  String truck_no1; // ": "1234",
  int rc_recd; // ": false,
  String str1; // ": "",
  int owner_id; // ": 0,
  String engin_no; // ": "0",
  String chases_no; // ": "0",
  String dt_purc; // ": "\/Date(-2209008600000+0530)\/",
  String type; // ": "0         ",
  String Model; // ": null,
  String purc_frm; // ": "0         ",
  double amt_purc; // ": 0.0,
  String body_done; // ": "0         ",
  String tds_form_no; // ": "",
  String tds_form_no16; // ": "",
  String tds_form_no17; // ": "",
  String driver_nm; // ": "",
  String driver_mobile; // ": "",
  int unqid; // ": 0,
  String tds_form_no18; // ": "",
  String tds_form_no19; // ": "",
  String tds_form_no20; // ": ""

  Truck({
    required this.panNo,
    required this.truckNo,
    required this.uid,
    this.Model = '',
    this.addr = '',
    this.amt_purc = 0,
    this.body_done = '',
    this.chases_no = '',
    this.driver_mobile = '',
    this.driver_nm = '',
    this.dt_purc = '',
    this.engin_no = '',
    this.own = 0,
    this.owner = '',
    this.owner_id = 0,
    this.place = '',
    this.purc_frm = '',
    this.rc_recd = 0,
    this.str1 = '',
    this.tds = 0,
    this.tds_form_no = '',
    this.tds_form_no16 = '',
    this.tds_form_no17 = '',
    this.tds_form_no18 = '',
    this.tds_form_no19 = '',
    this.tds_form_no20 = '',
    this.truck_no1 = '',
    this.type = '',
    this.unqid = 0,
  });

  String getNo() {
    return this.truckNo;
  }

  String getId() {
    return this.uid;
  }

  static Future getUid() async {
    final UrlGlobal urlObject = new UrlGlobal(
        p2: "",
        p1: '2',
        p: '2',
        last: 'tblno=751&cid=0&yr=0&xdt=04/01/2000&serno=0');
    try {
      final url = urlObject.getUrl();
      final result = await getMethod(url);
      final data = json.decode(result.body);
      return data['uid'];
    } catch (e) {
      return {
        "message": "Error occurred while getting and setting uid for truck"
      };
    }
  }

  Future update(String co) async {
    final query = """         
        update z_trk_000$co
        set 
        truck_no = '${this.truckNo}', owner = '${this.owner}', addr = '${this.addr}', 
        place = '${this.place}', pan_no = '${this.panNo}', own = ${this.own}, 
        truck_no1 = '${this.truck_no1}', driver_nm = '${this.driver_nm}', 
        driver_mobile = '${this.driver_mobile}'
        where 
        uid = ${this.uid}
        """;
    final UrlGlobal urlObject = new UrlGlobal(
      p2: query,
      p1: '1',
      p: '2',
    );
    try {
      final url = urlObject.getUrl();
      final result = await getMethod(url);
      final data = json.decode(result.body);
      print(url);
      print(data);
      return {"message": data['status']};
    } catch (e) {
      return {"message": "Error occurred while Updating Truck"};
    }
  }

  Future save(String co) async {
    final preResult = await check("""
      select * from  z_trk_000$co where truck_no = '${this.truckNo}'
      """);

    if (preResult['message'] == 'success' &&
        (preResult['data'] as List<dynamic>).length < 1) {
      final query = """ 
        insert into z_trk_000$co
        (
          uid, truck_no, owner, addr, place, pan_no, tds, own, truck_no1, rc_recd,
          str1, owner_id, engin_no, chases_no, dt_purc, type, Model, purc_frm,
          amt_purc, body_done, tds_form_no, tds_form_no16, tds_form_no17,
          driver_nm, driver_mobile, unqid, tds_form_no18, tds_form_no19, tds_form_no20
        )

        values 
        (          
        
        ${this.uid}, '${this.truckNo}', '${this.owner}', '${this.addr}', '${this.place}', 
        '${this.panNo}',
        ${this.tds}, ${this.own}, '${this.truck_no1}', ${this.rc_recd},
        '${this.str1}', ${this.owner_id}, '${this.engin_no}', '${this.chases_no}', 
        '${DateTime(1900).toString().split(" ")[0]}', 
        '${this.type}', '${this.Model}', '${this.purc_frm}',
        ${this.amt_purc}, '${this.body_done}', '${this.tds_form_no}', '${this.tds_form_no16}', 
        '${this.tds_form_no17}',
        '${this.driver_nm}', '${this.driver_mobile}', ${this.unqid}, '${this.tds_form_no18}', 
        '${this.tds_form_no19}', '${this.tds_form_no20}'
        
        ) 
        
        """;
      final UrlGlobal urlObject = new UrlGlobal(
        p2: query,
        p1: '1',
        p: '2',
      );
      try {
        final url = urlObject.getUrl();
        final result = await getMethod(url);
        final data = json.decode(result.body);
        return {"message": data['status']};
      } catch (e) {
        return {"message": "Error occurred while saving Truck"};
      }
    } else {
      return {"message": "Truck With Same Truck Number Exist"};
    }
  }

  static Future<Map<String, dynamic>> getTrucks(
      String co, String pattern) async {
    final UrlGlobal urlObject = new UrlGlobal(
      p2: """
      select * from z_trk_000$co where CONVERT(varchar(30),truck_no)  
      like '%$pattern%' order by  truck_no
      
      """,
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
              truck_no1: record['truck_no1'].toString(),
              addr: record['addr'].toString(),
              driver_nm: record['driver_nm'].toString(),
              driver_mobile: record['driver_mobile'].toString(),
              owner: record['owner'].toString(),
              place: record['place'].toString()))
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
