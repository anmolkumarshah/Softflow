import 'package:flutter/material.dart';
import 'package:softflow_app/Helpers/preCheck.dart';

class PartyWise {
  int? accId;
  String? name;
  PartyWise({this.accId, this.name});

  static fetch() async {
    var result = await check('''
  select distinct(p.party_nm),p.acc_id from z_par_0001 p right join domast d 
  on p.acc_id = d.acc_id order by p.acc_id
  ''');

    if (result['message'] == 'success') {
      List<PartyWise> li = (result['data'] as List<dynamic>)
          .map((e) => PartyWise(
                accId: e['acc_id'],
                name: e['party_nm'],
              ))
          .toList();

      return li;
    }
    return [];
  }

  static fetchItems(List<PartyWise> li) {
    var pwli = li
        .map((e) => DropdownMenuItem<PartyWise>(
              child: Text(
                e.name!,
              ),
              value: e,
            ))
        .toList();
    return pwli;
  }
}
