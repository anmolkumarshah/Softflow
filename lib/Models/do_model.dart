import 'dart:convert';
import 'dart:core';
import 'package:softflow_app/Helpers/dateFormatfromDataBase.dart';
import 'package:softflow_app/Helpers/getMethodHelperFunction.dart';
import 'package:softflow_app/Models/url_model.dart';

class DO {
  String uid;
  String do_no;
  String do_dt;
  String acc_id;
  String consignee;
  String frmplc;
  String toplc;
  String frdt;
  String todt;
  double tmt;
  double rt;
  double deltmt;
  int compl;
  double doamt;
  double place_rt;
  double lias_rt;
  double km_levl;
  double shr_perc;
  String pono;
  String itemnm;
  String consrcd;
  String consecd;
  String indno;
  String inddt;
  String broker;
  String truckid;
  String Veh_reached; // boolean
  String Veh_intime;
  String Veh_inby; // id of user input by
  String grn_no1;
  int GRN_NO;
  String INV_no;
  String inv_date;
  String EwayNo;
  String EwayQrcode;
  String Consignor_GST;
  String valid_till;
  double Wt;
  String lr_photo;
  String Eway_photo;
  String pinv_photo;
  String drv_photo;
  String drv_name;
  String drv_mobile;
  String desp_time;
  int desp_by;
  String br_cd;

  double adv;
  double truck_wt;
  double dies;

  double rate;
  double frt;
  double penalty;
  double advperc;
  double actwt;

  int adv_typ;
  int lefdays;

  DO({
    this.uid = '-1',
    this.consecd = '-1',
    this.consignee = '-1',
    this.acc_id = '-1',
    this.compl = 0,
    this.consrcd = '-1',
    this.deltmt = 0.0,
    this.do_dt = '-1',
    this.do_no = '-1',
    this.doamt = 0.0,
    this.frdt = '-1',
    this.frmplc = '-1',
    this.inddt = '-1',
    this.indno = '-1',
    this.itemnm = '-1',
    this.km_levl = 0.0,
    this.lias_rt = 0.0,
    this.place_rt = 0.0,
    this.pono = '-1',
    this.rt = 0.0,
    this.shr_perc = 0.0,
    this.tmt = 0.0,
    this.todt = '-1',
    this.toplc = '-1',
    this.broker = '-1',
    this.truckid = '-1',
    this.Veh_reached = '0',
    this.Veh_inby = '0',
    this.Consignor_GST = "",
    this.desp_by = 0,
    this.desp_time = "",
    this.drv_mobile = "",
    this.drv_name = "",
    this.drv_photo = "",
    this.Eway_photo = "",
    this.EwayNo = "",
    this.EwayQrcode = "",
    this.GRN_NO = 0,
    this.grn_no1 = "",
    this.inv_date = "",
    this.INV_no = "",
    this.lr_photo = "",
    this.pinv_photo = "",
    this.valid_till = "",
    this.Veh_intime = "",
    this.Wt = 0.0,
    this.br_cd = '0',
    this.adv = 0,
    this.dies = 0,
    this.truck_wt = 0,
    this.advperc = 0,
    this.frt = 0,
    this.penalty = 0,
    this.rate = 0,
    this.actwt = 0,
    this.adv_typ = 0,
    this.lefdays = 0,
  });

  DO clone(DO refDO) {
    refDO.inddt = dateFormatFromDataBase(this.inddt).toString().split(" ")[0];
    refDO.consecd = this.consecd;
    refDO.consrcd = this.consrcd;
    refDO.itemnm = this.itemnm;
    refDO.todt = dateFormatFromDataBase(this.todt).toString().split(" ")[0];
    refDO.toplc = this.toplc;
    refDO.frmplc = this.frmplc;
    refDO.consignee = this.consignee;
    refDO.do_dt = dateFormatFromDataBase(this.do_dt).toString().split(" ")[0];
    refDO.acc_id = this.acc_id;
    refDO.uid = this.uid;
    refDO.broker = this.broker;
    refDO.compl = this.compl;
    refDO.deltmt = this.deltmt;
    refDO.do_no = this.do_no;
    refDO.doamt = this.doamt;
    refDO.frdt = dateFormatFromDataBase(this.frdt).toString().split(" ")[0];
    refDO.indno = this.indno;
    refDO.km_levl = this.km_levl;
    refDO.lias_rt = this.lias_rt;
    refDO.place_rt = this.place_rt;
    refDO.pono = this.pono;
    refDO.rt = this.shr_perc;
    refDO.shr_perc = this.shr_perc;
    refDO.tmt = this.tmt;
    refDO.truckid = this.truckid;
    refDO.Wt = this.Wt;
    refDO.Veh_reached = this.Veh_reached;
    refDO.Consignor_GST = this.Consignor_GST;
    refDO.desp_by = this.desp_by;
    refDO.desp_time = this.desp_time;
    refDO.drv_mobile = this.drv_mobile;
    refDO.drv_name = this.drv_name;
    refDO.drv_photo = this.drv_photo;
    refDO.Eway_photo = this.Eway_photo;
    refDO.EwayNo = this.EwayNo;
    refDO.EwayQrcode = this.EwayQrcode;
    refDO.grn_no1 = this.grn_no1;
    refDO.GRN_NO = this.GRN_NO;
    refDO.inv_date =
        dateFormatFromDataBase(this.inv_date).toString().split(" ")[0];
    refDO.INV_no = this.INV_no;
    refDO.lr_photo = this.lr_photo;
    refDO.pinv_photo = this.pinv_photo;
    refDO.valid_till = this.valid_till;
    refDO.Veh_inby = this.Veh_intime;
    refDO.Veh_intime = this.Veh_intime;
    refDO.br_cd = this.br_cd;
    refDO.adv = this.adv;
    refDO.dies = this.dies;
    refDO.truck_wt = this.truck_wt;
    refDO.advperc = this.advperc;
    refDO.frt = this.frt;
    refDO.penalty = this.penalty;
    refDO.rate = this.rate;
    refDO.actwt = this.actwt;
    refDO.actwt = this.actwt;
    refDO.lefdays = this.lefdays;

    return refDO;
  }

  static Future<Map<String, dynamic>> getAllUnAllotedDo(
      String pattern, String branch) async {
    final UrlGlobal urlObject = new UrlGlobal(
      p2: "select * from domast where do_no like '%$pattern%' and (broker in (0,-1) and truckid in (0,-1)) and br_cd = $branch order by do_dt desc",
    );
    final url = urlObject.getUrl();
    print(url);
    try {
      final result = await getMethod(url);
      final data = json.decode(result.body);

      final doList = (data as List<dynamic>)
          .map((record) => new DO(
                inddt: record['inddt'].toString().trim(),
                consecd: record['consecd'].toString().trim(),
                consrcd: record['consrcd'].toString().trim(),
                itemnm: record['itemnm'].toString().trim(),
                todt: record['todt'].toString().trim(),
                toplc: record['toplc'].toString().trim(),
                frmplc: record['frmplc'].toString().trim(),
                consignee: record['consignee'].toString().trim(),
                do_dt: record['do_dt'].toString().trim(),
                acc_id: record['acc_id'].toString().trim(),
                uid: record['uid'].toString().trim(),
                broker: record['broker'].toString().trim(),
                compl: record['compl'] == true ? 1 : 0,
                deltmt: record['deltmt'],
                do_no: record['do_no'].toString().trim(),
                doamt: record['doamt'],
                frdt: record['frdt'].toString().trim(),
                indno: record['indno'].toString().trim(),
                km_levl: record['km_levl'],
                lias_rt: record['lias_rt'],
                place_rt: record['place_rt'],
                pono: record['pono'].toString().trim(),
                rt: record['rt'],
                shr_perc: record['shr_perc'],
                tmt: record['tmt'],
                truckid: record['truckid'].toString().trim(),
                Wt: record['Wt'],
                Veh_reached: record['Veh_reached'] ? '1' : '0',
                Consignor_GST: record['Consignor_GST'].toString(),
                desp_by: record['desp_by'],
                desp_time: record['desp_time'].toString(),
                drv_mobile: record['drv_mobile'].toString(),
                drv_name: record['drv_name'].toString(),
                drv_photo: record['drv_photo'].toString(),
                Eway_photo: record['Eway_photo'].toString(),
                EwayNo: record['EwayNo'].toString(),
                EwayQrcode: record['EwayQrcode'].toString(),
                grn_no1: record['grn_no1'].toString(),
                GRN_NO: record['GRN_NO'],
                inv_date: record['inv_date'].toString(),
                INV_no: record['INV_no'].toString(),
                lr_photo: record['lr_photo'].toString(),
                pinv_photo: record['pinv_photo'].toString(),
                valid_till: record['valid_till'].toString(),
                Veh_inby: record['Veh_inby'].toString(),
                Veh_intime: record['Veh_intime'].toString(),
                br_cd:
                    record['br_cd'] == null ? '0' : record['br_cd'].toString(),
                adv: record['adv'] == null ? 0 : record['adv'],
                dies: record['dies'] == null ? 0 : record['dies'],
                truck_wt: record['truck_wt'] == null ? 0 : record['truck_wt'],
                advperc: record['advperc'] != null ? record['advperc'] : 0,
                frt: record['frt'] != null ? record['frt'] : 0,
                penalty: record['penalty'] != null ? record['penalty'] : 0,
                rate: record['rate'] != null ? record['rate'] : 0,
                actwt: record['actwt'] != null ? record['actwt'] : 0,
                adv_typ: record['adv_typ'] != null ? record['adv_typ'] : 0,
                lefdays: record['lefdays'] != null ? record['lefdays'] : 0,
              ))
          .toList();
      return {"message": 'success', 'data': doList};
    } catch (e) {
      print(e);
      return {"message": "Error occurred while fetching DO"};
    }
  }

  static Future<Map<String, dynamic>> getAllDO(String pattern,
      {String query = "select * from domast order by uid desc",
      String branch = '0'}) async {
    // String query = "select * from domast order by uid desc";
    if (branch != '0' && branch != '1') {
      query = "select * from domast where br_cd = $branch";
    }
    final UrlGlobal urlObject = new UrlGlobal(
      p2: query,
    );
    final url = urlObject.getUrl();
    try {
      final result = await getMethod(url);
      final data = json.decode(result.body);
      final doList = (data as List<dynamic>)
          .map(
            (record) => new DO(
              inddt: record['inddt'].toString().trim(),
              consecd: record['consecd'].toString().trim(),
              consrcd: record['consrcd'].toString().trim(),
              itemnm: record['itemnm'].toString().trim(),
              todt: record['todt'].toString().trim(),
              toplc: record['toplc'].toString().trim(),
              frmplc: record['frmplc'].toString().trim(),
              consignee: record['consignee'].toString().trim(),
              do_dt: record['do_dt'].toString().trim(),
              acc_id: record['acc_id'].toString().trim(),
              uid: record['uid'].toString().trim(),
              broker: record['broker'].toString().trim(),
              compl: record['compl'] == true ? 1 : 0,
              deltmt: record['deltmt'],
              do_no: record['do_no'].toString().trim(),
              doamt: record['doamt'],
              frdt: record['frdt'].toString().trim(),
              indno: record['indno'].toString().trim(),
              km_levl: record['km_levl'],
              lias_rt: record['lias_rt'],
              place_rt: record['place_rt'],
              pono: record['pono'].toString().trim(),
              rt: record['rt'],
              shr_perc: record['shr_perc'],
              tmt: record['tmt'],
              truckid: record['truckid'].toString().trim(),
              Wt: record['Wt'],
              Veh_reached: record['Veh_reached'] ? '1' : '0',
              Consignor_GST: record['Consignor_GST'].toString(),
              desp_by: record['desp_by'],
              desp_time: record['desp_time'].toString(),
              drv_mobile: record['drv_mobile'].toString(),
              drv_name: record['drv_name'].toString(),
              drv_photo: record['drv_photo'].toString(),
              Eway_photo: record['Eway_photo'].toString(),
              EwayNo: record['EwayNo'].toString(),
              EwayQrcode: record['EwayQrcode'].toString(),
              grn_no1: record['grn_no1'].toString(),
              GRN_NO: record['GRN_NO'],
              inv_date: record['inv_date'].toString(),
              INV_no: record['INV_no'].toString(),
              lr_photo: record['lr_photo'].toString(),
              pinv_photo: record['pinv_photo'].toString(),
              valid_till: record['valid_till'].toString(),
              Veh_inby: record['Veh_inby'].toString(),
              Veh_intime: record['Veh_intime'].toString(),
              br_cd: record['br_cd'] == null ? '0' : record['br_cd'].toString(),
              adv: record['adv'] == null ? 0 : record['adv'],
              dies: record['dies'] == null ? 0 : record['dies'],
              truck_wt: record['truck_wt'] == null ? 0 : record['truck_wt'],
              advperc: record['advperc'] != null ? record['advperc'] : 0,
              frt: record['frt'] != null ? record['frt'] : 0,
              penalty: record['penalty'] != null ? record['penalty'] : 0,
              rate: record['rate'] != null ? record['rate'] : 0,
              actwt: record['actwt'] != null ? record['actwt'] : 0,
              adv_typ: record['adv_typ'] != null ? record['adv_typ'] : 0,
              lefdays: record['lefdays'] != null ? record['lefdays'] : 0,
            ),
          )
          .toList();
      return {"message": 'success', 'data': doList};
    } catch (e) {
      print(e);
      return {"message": "Error occurred while fetching DO"};
    }
  }

  static Future<Map<String, dynamic>> supervisorAllDO(String query) async {
    final UrlGlobal urlObject = new UrlGlobal(
      p2: query,
    );
    final url = urlObject.getUrl();
    print(url);
    try {
      final result = await getMethod(url);
      final data = json.decode(result.body);

      final doList = (data as List<dynamic>)
          .map((record) => new DO(
                inddt: record['inddt'].toString().trim(),
                consecd: record['consecd'].toString().trim(),
                consrcd: record['consrcd'].toString().trim(),
                itemnm: record['itemnm'].toString().trim(),
                todt: record['todt'].toString().trim(),
                toplc: record['toplc'].toString().trim(),
                frmplc: record['frmplc'].toString().trim(),
                consignee: record['consignee'].toString().trim(),
                do_dt: record['do_dt'].toString().trim(),
                acc_id: record['acc_id'].toString().trim(),
                uid: record['uid'].toString().trim(),
                broker: record['broker'].toString().trim(),
                compl: record['compl'] == true ? 1 : 0,
                deltmt: record['deltmt'],
                do_no: record['do_no'].toString().trim(),
                doamt: record['doamt'],
                frdt: record['frdt'].toString().trim(),
                indno: record['indno'].toString().trim(),
                km_levl: record['km_levl'],
                lias_rt: record['lias_rt'],
                place_rt: record['place_rt'],
                pono: record['pono'].toString().trim(),
                rt: record['rt'],
                shr_perc: record['shr_perc'],
                tmt: record['tmt'],
                truckid: record['truckid'].toString().trim(),
                Wt: record['Wt'],
                Veh_reached: record['Veh_reached'] ? '1' : '0',
                Consignor_GST: record['Consignor_GST'].toString(),
                desp_by: record['desp_by'],
                desp_time: record['desp_time'].toString(),
                drv_mobile: record['drv_mobile'].toString(),
                drv_name: record['drv_name'].toString(),
                drv_photo: record['drv_photo'].toString(),
                Eway_photo: record['Eway_photo'].toString(),
                EwayNo: record['EwayNo'].toString(),
                EwayQrcode: record['EwayQrcode'].toString(),
                grn_no1: record['grn_no1'].toString(),
                GRN_NO: record['GRN_NO'],
                inv_date: record['inv_date'].toString(),
                INV_no: record['INV_no'].toString(),
                lr_photo: record['lr_photo'].toString(),
                pinv_photo: record['pinv_photo'].toString(),
                valid_till: record['valid_till'].toString(),
                Veh_inby: record['Veh_inby'].toString(),
                Veh_intime: record['Veh_intime'].toString(),
                br_cd:
                    record['br_cd'] == null ? '1' : record['br_cd'].toString(),
                advperc: record['advperc'] != null ? record['advperc'] : 0,
                frt: record['frt'] != null ? record['frt'] : 0,
                penalty: record['penalty'] != null ? record['penalty'] : 0,
                rate: record['rate'] != null ? record['rate'] : 0,
                actwt: record['actwt'] != null ? record['actwt'] : 0,
                adv: record['adv'] != null ? record['adv'] : 0,
                dies: record['dies'] != null ? record['dies'] : 0,
                truck_wt: record['truck_wt'] != null ? record['truck_wt'] : 0,
                adv_typ: record['adv_typ'] != null ? record['adv_typ'] : 0,
                lefdays: record['lefdays'] != null ? record['lefdays'] : 0,
              ))
          .toList();
      print(url);
      return {"message": 'success', 'data': doList};
    } catch (e) {
      print(e);
      List<DO> list = [];
      return {"message": "Error occurred while fetching DO", 'data': list};
    }
  }

  Future getSetUid() async {
    final UrlGlobal urlObject = new UrlGlobal(
        p2: "",
        p1: '2',
        p: '2',
        last: 'tblno=1767&cid=0&yr=0&xdt=04/01/2000&serno=0');
    try {
      final url = urlObject.getUrl();
      final result = await getMethod(url);
      final data = json.decode(result.body);
      this.uid = data['uid'].toString();
      print("GetSetUId");
    } catch (e) {
      return {"message": "Error occurred while getting and setting uid for DO"};
    }
  }

  Future update({String q = ''}) async {
    String query = """
     
     update domast
     set broker = '${this.broker}', truckid = '${this.truckid}',
        adv = ${this.adv}, truck_wt = ${this.truck_wt}, dies = ${this.dies},
        do_dt = '${this.do_dt}',consignee = '${this.consignee}',frmplc = '${this.frmplc}',
        toplc = '${this.toplc}',itemnm = '${this.itemnm}',
        consrcd = ${this.consrcd},consecd = ${this.consecd},indno = '${this.indno}',
        inddt = '${this.inddt}',do_no = '${this.do_no}',
        Wt = ${this.Wt},br_cd = '${this.br_cd}',rt = ${this.rt},
        rate = ${this.rate}, frt = ${this.frt}, penalty = ${this.penalty}, advperc = ${this.advperc},
        adv_typ = ${this.adv_typ}

     where uid = '${this.uid}'; 
     
     """;

    if (q != '') {
      query = q;
    }
    print(query);
    final UrlGlobal urlObject = new UrlGlobal(
      p2: query,
      p1: '1',
      p: '2',
    );
    try {
      final url = urlObject.getUrl();
      final result = await getMethod(url);
      final data = json.decode(result.body);
      print(data);
      return {"message": data['status']};
    } catch (e) {
      return {"message": "Error occurred while updating DO"};
    }
  }

  Future updateBySupervisor() async {
    final query = """
     
     update domast
     set grn_no1 = '${this.grn_no1}', GRN_NO = ${this.GRN_NO}, INV_no = '${this.INV_no}',
     inv_date = '${this.inv_date}', EwayNo = '${this.EwayNo}', EwayQrcode = '${this.EwayQrcode}',
     Consignor_GST = '${this.Consignor_GST}', valid_till = '${this.valid_till}',
     drv_name = '${this.drv_name}', drv_mobile = '${this.drv_mobile}',
     penalty = ${this.penalty}, frt = ${this.frt}, adv = ${this.adv}, actwt = ${this.actwt},
     advperc = ${this.advperc}, rate = ${this.rate}, rt = ${this.rt}
     where uid = '${this.uid}' and do_no = '${this.do_no}'; 

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
      print(query);
      print(data);
      return {"message": data['status']};
    } catch (e) {
      return {"message": "Error occurred while updating DO"};
    }
  }

  Future updateIsVahReached(value, userId) async {
    final query = """
     
     update domast
     set Veh_reached = $value, Veh_inby = $userId, Veh_intime = GETDATE()
     where uid = '${this.uid}'; 
     
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
      return {"message": "Error occurred while updating DO"};
    }
  }

  Future dispatchVehicle(value, userId) async {
    final query = """
     
     update domast
     set compl = $value, desp_by = $userId, desp_time = GETDATE()
     where uid = '${this.uid}'; 
     
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
      return {"message": "Error occurred while updating DO"};
    }
  }

  Future save() async {
    final query =
        """ insert into domast(uid,do_no,do_dt,acc_id,consignee,frmplc,toplc,
        frdt,todt,tmt,rt,deltmt,compl,doamt,place_rt,lias_rt,km_levl,shr_perc,
        pono,itemnm,consrcd,consecd,indno,inddt,broker,truckid,Wt, br_cd, 
        advperc, rate, adv, lefdays) 
        values ('${this.uid}','${this.do_no}','${this.do_dt}','${this.acc_id}',
        '${this.acc_id}','${this.frmplc}',
        '${this.toplc}','${this.frdt}','${this.todt}',${this.tmt},${this.rt},
        ${this.deltmt},${this.compl},${this.doamt},${this.place_rt},${this.lias_rt},
        ${this.km_levl},${this.shr_perc},'${this.pono}','${this.itemnm}',
        ${this.consrcd},${this.consecd},'${this.indno}','${this.inddt}',
        '${this.broker}','${this.truckid}',${this.Wt},'${this.br_cd}', 
        ${this.advperc}, ${this.rate}, ${this.adv}, '${this.lefdays}')
         """;

    print(query);

    final UrlGlobal urlObject = new UrlGlobal(
      p2: query,
      p1: '1',
      p: '2',
    );
    try {
      final url = urlObject.getUrl();
      final result = await getMethod(url);
      final data = json.decode(result.body);
      print(data);
      return {"message": data['status']};
    } catch (e) {
      return {"message": "Error occurred while saving DO"};
    }
  }
}
