import 'dart:convert';

import 'package:softflow_app/Helpers/getMethodHelperFunction.dart';
import 'package:softflow_app/Helpers/preCheck.dart';
import 'package:softflow_app/Models/url_model.dart';

class PartyName {
  String name;
  String id; // it is account id acc_id
  String addr;
  String place;
  String group_id;
  String it_no;
  String ward;
  String off_ph;
  String res_ph;
  String mobile;
  String email;
  String cprt;
  String bprt;
  double limit; // ": 0.0,
  String clnt_id;
  String dp_no;
  String depositry;
  String party_cd; // ": "238       ",
  String bal_cd; // "A5",
  String doj; // ": "\/Date(-2209008600000+0530)\/",
  String mapin; // : "",
  String cdsl; //: "C",
  String del_dp_a; // : "Y",
  String rcv_dp_a; // : "Y",
  double del_limit; // 0.0,
  String prep_chq; // : "R",
  int main_exchg; // ": 1,
  String trd_mem; // ": "N",
  int cl_profile; // : 0,
  String multi_pcd; //": "",
  double secdeposit; // : 0.0,
  int br_cd; //": 0,
  String pwd; // : null,
  String can_mail; // ": null,
  double oth_sec; //": 0.0,
  int margin_acc; // ": 0,
  int pincode; // ": 0,
  String is_active; //": "Y",
  String st_no; // ": null,
  int StateID; // ": 16,
  int QualID; // ": 0,
  String BirthDt; // ": "\/Date(-2209008600000+0530)\/",
  int tdsFormID; // ": 0,
  int duedays; //": 0,
  String PwrAttorny; // ": "N",
  String delv_mode; // ": null,
  double bnk_opbal; // ": 0.0,
  String acc_title; // ": null,
  String fax_no; // ": null,
  int flg_f1; // ": 0,
  String NIKNAME; // ": "",
  String bse_mem_id; // ": null,
  double intrperc; // ": 0.0,
  String is_pro_dp; // ": "N",
  int schcde; // ": 164,
  int ismainco_id; // ": 0,
  int co_id; // ": 0,
  int ismain; // ": 0,
  String lbtno; // ": "",
  String addr1; // ": "",
  String addr2; // ": "",
  String addr3; // ": "",
  int party_block; // ": 0,
  int inv_yn; // ": 0,
  int cd_slab; // ": 0,
  String tah; // ": "",
  String dist; // ": "",
  String state; // ": "",
  int pdys; // ": 0,
  String hinaddr; // ": "",
  int gsttyp; // ": 3,
  String gsttin; // ": "",
  int wostate; // ": false,
  int bptype; // ": 2,
  int isecom; // ": false,
  String aadhar; // ": "",
  String cin; // ": "",
  double disc_perc; // ": 0.0,
  String vat_no; // ": null,
  String str1; // ": "",
  String str2; // ": "",
  String str3; //": "",
  int opweb; // ": false,
  String ecc_no; // ": "",
  String ecc_range; // ": "",
  String ecc_divn; // ": "",
  String cperson; // ": "",
  int sman1; // ": 0,
  String delv_at; // ": "",
  int web; // ": false,
  int cash_code; // ": 0,
  int sd_code; // ": 0,
  int ledg_code; // ": 0,
  int disc_code; // ": 0,
  int macid; // ": "0",
  int issue_code; // ": 0,
  int schm_code; // ": 0,
  String vgrade; //": "",
  String remarks_case; // ": "",
  int stage; //": 0,
  String remarks_date; //": "",
  int msme; //": 0,
  int mstyp; //": 0,
  int totkm; // ": 0,
  int transid; // ": 0,
  String madt; // ": "\/Date(-2209008600000+0530)\/",
  String tcsfrom; // ": "\/Date(-2209008600000+0530)\/",
  int tcsthere; // ": false,
  String tdsfrom; // ": "\/Date(-2209008600000+0530)\/",
  int tdsthere; // ": false,
  int mainpar; // ": 0,
  String agrade; // ": "",
  String msmeregno; // ": "",
  int gstfilon; // ": 0
  PartyName({
    this.id = '',
    required this.name,
    this.BirthDt = '',
    this.NIKNAME = '',
    this.PwrAttorny = '',
    this.QualID = 0,
    this.StateID = 0,
    this.aadhar = '',
    this.acc_title = '',
    this.addr = '',
    this.addr1 = '',
    this.addr2 = '',
    this.addr3 = '',
    this.agrade = '',
    this.bal_cd = '',
    this.bnk_opbal = 0.0,
    this.bprt = '',
    this.bptype = 0,
    this.br_cd = 0,
    this.bse_mem_id = '',
    this.can_mail = '',
    this.cash_code = 0,
    this.cd_slab = 0,
    this.cdsl = 'C',
    this.cin = '',
    this.cl_profile = 0,
    this.clnt_id = '',
    this.co_id = 0,
    this.cperson = '',
    this.cprt = '',
    this.del_dp_a = 'Y',
    this.del_limit = 0,
    this.delv_at = '',
    this.delv_mode = '',
    this.depositry = '',
    this.disc_code = 0,
    this.disc_perc = 0,
    this.dist = '',
    this.doj = "",
    this.dp_no = '',
    this.duedays = 0,
    this.ecc_divn = '',
    this.ecc_no = '',
    this.ecc_range = '',
    this.email = '',
    this.fax_no = '',
    this.flg_f1 = 0,
    this.group_id = '',
    this.gstfilon = 0,
    this.gsttin = '',
    this.gsttyp = 0,
    this.hinaddr = '',
    this.intrperc = 0,
    this.inv_yn = 0,
    this.is_active = 'Y',
    this.is_pro_dp = '',
    this.isecom = 0,
    this.ismain = 0,
    this.ismainco_id = 0,
    this.issue_code = 0,
    this.it_no = '',
    this.lbtno = '',
    this.ledg_code = 0,
    this.limit = 0,
    this.macid = 0,
    this.madt = '',
    this.main_exchg = 0,
    this.mainpar = 0,
    this.mapin = '',
    this.margin_acc = 0,
    this.mobile = '',
    this.msme = 0,
    this.msmeregno = '',
    this.mstyp = 0,
    this.multi_pcd = '',
    this.off_ph = '',
    this.opweb = 0,
    this.oth_sec = 0,
    this.party_block = 0,
    this.party_cd = '',
    this.pdys = 0,
    this.pincode = 0,
    this.place = '',
    this.prep_chq = 'R',
    this.pwd = '',
    this.rcv_dp_a = 'Y',
    this.remarks_case = '',
    this.remarks_date = '',
    this.res_ph = '',
    this.schcde = 0,
    this.schm_code = 0,
    this.sd_code = 0,
    this.secdeposit = 0,
    this.sman1 = 0,
    this.st_no = '',
    this.stage = 0,
    this.state = '',
    this.str1 = '',
    this.str2 = '',
    this.str3 = '',
    this.tah = '',
    this.tcsfrom = '',
    this.tcsthere = 0,
    this.tdsFormID = 0,
    this.tdsfrom = '',
    this.tdsthere = 0,
    this.totkm = 0,
    this.transid = 0,
    this.trd_mem = 'N',
    this.vat_no = '',
    this.vgrade = '',
    this.ward = '',
    this.web = 0,
    this.wostate = 0,
  });

  String showName() {
    return this.name;
  }

  String getId() {
    return this.id;
  }

  Future save(String co) async {
    final preResult = await check("""
      select * from  z_par_000$co where party_nm = '${this.name}' and place = '${this.place}'
      and bal_cd = '${this.bal_cd}'
      """);

    if (preResult['message'] == 'success' &&
        (preResult['data'] as List<dynamic>).length < 1) {
      final query = """
        insert into z_par_000$co
        (
          acc_id, party_nm, addr, place, it_no, mapin, ward, off_ph,
          res_ph , mobile, email, cprt, bprt, can_mail, limit, clnt_id, dp_no,
          depositry, party_cd, bal_cd, nikname, pincode, secdeposit, br_cd, pwd, margin_acc,
          oth_sec, multi_pcd, cdsl, del_dp_a, rcv_dp_a, del_limit, prep_chq, main_exchg,
          doj, trd_mem, cl_profile, is_active, st_no, StateID, QualID, BirthDt, PwrAttorny,
          delv_mode, bnk_opbal, acc_title, fax_no, flg_f1, intrperc, bse_mem_id, is_pro_dp,
          gsttyp, gsttin, wostate, bptype, isecom, aadhar, cin, vat_no, duedays, tdsFormID,
          schcde, ismainco_id, co_id, ismain, lbtno, addr1, addr2, addr3, party_block,
          inv_yn, cd_slab, tah, dist, state, pdys, hinaddr, disc_perc, str1, str2, str3, opweb
        )

        values
        (
        '${this.id}', '${this.name}', '${this.addr}', '${this.place}', '${this.it_no}',
        '${this.mapin}', '${this.ward}', '${this.off_ph}','${this.res_ph}' , '${this.mobile}', '${this.email}','${this.cprt}', '${this.bprt}', '${this.can_mail}', ${this.limit}, '${this.clnt_id}',
        '${this.dp_no}','${this.depositry}', '${this.party_cd}', '${this.bal_cd}', '${this.NIKNAME}',
        ${this.pincode}, ${this.secdeposit}, ${this.br_cd}, '${this.pwd}', ${this.margin_acc},
        ${this.oth_sec}, '${this.multi_pcd}','${this.cdsl}', '${this.del_dp_a}', '${this.rcv_dp_a}',
        ${this.del_limit}, '${this.prep_chq}', ${this.main_exchg},
        '${DateTime(1900).toString().split(" ")[0]}', '${this.trd_mem}',
        ${this.cl_profile}, '${this.is_active}', '${this.st_no}', ${this.StateID}, ${this.QualID},
        '${DateTime(1900).toString().split(" ")[0]}', '${this.PwrAttorny}','${this.delv_mode}', ${this.bnk_opbal},
        '${this.acc_title}', '${this.fax_no}', ${this.flg_f1}, ${this.intrperc}, '${this.bse_mem_id}',
        '${this.is_pro_dp}',${this.gsttyp}, '${this.gsttin}', ${this.wostate}, ${this.bptype},
        ${this.isecom}, '${this.aadhar}', '${this.cin}', '${this.vat_no}', ${this.duedays},
        ${this.tdsFormID},${this.schcde}, ${this.ismainco_id}, ${this.co_id}, ${this.ismain},
        '${this.lbtno}', '${this.addr1}', '${this.addr2}', '${this.addr3}', ${this.party_block},
        ${this.inv_yn}, ${this.cd_slab}, '${this.tah}',
        '${this.dist}', '${this.state}', ${this.pdys}, '${this.hinaddr}', ${this.disc_perc},
        '${this.str1}', '${this.str2}', '${this.str3}', ${this.opweb}

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
        print(data);
        return {"message": data['status']};
      } catch (e) {
        print(e);
        return {"message": "Error occurred while saving Party"};
      }
    } else {
      return {"message": "Party With This Name, Place & BalCD Exist"};
    }
  }

  static Future getUid() async {
    final UrlGlobal urlObject = new UrlGlobal(
        p2: "",
        p1: '2',
        p: '2',
        last: 'tblno=1&cid=1&yr=0&xdt=04/01/2000&serno=0');
    try {
      final url = urlObject.getUrl();
      final result = await getMethod(url);
      final data = json.decode(result.body);
      return data['uid'];
    } catch (e) {
      return {
        "message": "Error occurred while getting and setting uid for party"
      };
    }
  }

  static Future<Map<String, dynamic>> getPartyName(
      String co, String yr, String pattern, String balCd,
      {String balCd2 = ''}) async {
    yr = yr.substring(2);
    final UrlGlobal urlObject = new UrlGlobal(
      p2: "select n.acc_id,n.party_nm,n.bal_cd,n.mobile,n.place,n.it_no,n.gsttin from z_par_000$co n left outer join z_par_000${co}_$yr i on n.acc_id = i.acc_id where n.party_nm like '%$pattern%' and  (n.bal_cd='$balCd' or n.bal_cd='$balCd2') order by n.party_nm",
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
              bal_cd: record['bal_cd'].toString(),
              mobile: record['mobile'].toString(),
              place: record['place'].toString(),
              it_no: record['it_no'].toString(),
              addr: record['addr'].toString(),
              gsttin: record['gsttin'].toString(),
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
      p2: "select party_nm from  z_par_0001 where acc_id = $id and  bal_cd in ('A5','L5')",
    );
    final url = urlObject.getUrl();
    try {
      final result = await getMethod(url);
      final data = json.decode(result.body);
      return data[0]['party_nm'];
    } catch (e) {
      print(e);
    }
  }
}
