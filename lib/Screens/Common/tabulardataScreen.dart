import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:softflow_app/Helpers/dateFormatfromDataBase.dart';
import 'package:softflow_app/Helpers/shimmerLoader.dart';
import 'package:softflow_app/Models/branch_model.dart';
import 'package:softflow_app/Models/do_model.dart';
import 'package:softflow_app/Models/partyName_model.dart';
import 'package:softflow_app/Models/truck_model.dart';
import 'package:softflow_app/Providers/main_provider.dart';
import 'package:data_table_2/data_table_2.dart';

class TabularDataScreen extends StatefulWidget {
  List<DO>? filterDo;
  TabularDataScreen({Key? key, this.filterDo}) : super(key: key);
  static const routeName = "/tabular-data";

  @override
  State<TabularDataScreen> createState() => _TabularDataScreenState();
}

class _TabularDataScreenState extends State<TabularDataScreen> {
  List<Branch> _branchItems = [];
  List<Truck> _truckItems = [];
  List<PartyName> _brokerItems = [];
  List<PartyName> _allPartyItems = [];
  // List<DO> _allDo = widget.filterDo!;

  Future<Map<String, List<dynamic>>> getSet() async {
    final considerUser = Provider.of<MainProvider>(context, listen: false).user;
    final branchResult = await Branch.getBranchItem(considerUser.co);
    final brokerList = await PartyName.getPartyName(
        considerUser.co, considerUser.yr, "", 'L5');
    final partyList = await PartyName.getPartyName(
        considerUser.co, considerUser.yr, "", 'A5',
        balCd2: 'L5');

    final truckList = await Truck.getTrucks(considerUser.co, '');
    // final doList = await DO.getAllDO('', branch: considerUser.deptCd);

    _branchItems = branchResult['data'];
    _brokerItems = brokerList['data'];
    _truckItems = truckList['data'];
    _allPartyItems = partyList['data'];

    return {
      'branchItems': _branchItems,
      'brokerItems': _brokerItems,
      'truckItems': _truckItems,
      'allPartyItems': _allPartyItems,
    };
  }

  @override
  Widget build(BuildContext context) {
    List<String> col_names = [
      'SR.NO',
      "Date",
      'Branch',
      'Party Name',
      'From Station',
      "To Station",
      "DO No.",
      "Product",
      "Qty",
      "Consigner",
      "Broker",
      "Truck"
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text("Report"),
      ),
      body: Container(
        child: FutureBuilder(
            future: getSet(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LoadingListPage();
              }
              if (snapshot.hasData) {
                final data = snapshot.data as Map<String, dynamic>;
                List<DO> list = widget.filterDo!;
                return DataTable2(
                  smRatio: 5,
                  lmRatio: 5,
                  columnSpacing: 12,
                  horizontalMargin: 12,
                  minWidth: 1500,
                  sortAscending: true,
                  columns: col_names
                      .map((e) => DataColumn(
                            label: Text(
                              e,
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ))
                      .toList(),
                  rows: list
                      .map(
                        (e) => DataRow(
                          cells: <DataCell>[
                            DataCell(
                              Text((list.indexOf(e) + 1).toString()),
                            ),
                            DataCell(Text(DateFormat.yMMMMd()
                                .add_jm()
                                .format(dateFormatFromDataBase(e.do_dt))
                                .toString())),
                            DataCell(
                              Text(_branchItems
                                  .firstWhere((i) => i.id == e.br_cd)
                                  .name),
                            ),
                            DataCell(
                              Text(_allPartyItems
                                  .firstWhere((i) => i.id == e.acc_id)
                                  .name),
                            ),
                            DataCell(Text(e.frmplc)),
                            DataCell(Text(e.toplc)),
                            DataCell(Text(e.do_no)),
                            DataCell(Text(e.itemnm)),
                            DataCell(Text(e.Wt.toString())),
                            // DataCell(
                            //   Text(_allPartyItems
                            //       .firstWhere((i) => i.id == e.consecd)
                            //       .name),
                            // ),
                            DataCell(
                              Text(_allPartyItems
                                  .firstWhere((i) => i.id == e.consrcd)
                                  .name),
                            ),
                            DataCell(
                              Text(_brokerItems.firstWhere(
                                  (i) => i.id == e.broker, orElse: () {
                                return PartyName(name: "Not Set");
                              }).name),
                            ),
                            DataCell(
                              Text(
                                _truckItems.firstWhere(
                                    (i) => i.uid == e.truckid, orElse: () {
                                  return Truck(
                                    panNo: "",
                                    truckNo: "Not Set",
                                    uid: "",
                                  );
                                }).truckNo,
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                );
              }
              return Center(
                child: Text("Error"),
              );
            }),
      ),
    );
  }
}

String find(List<dynamic> li, String prop, String value) {
  return li.firstWhere((element) => element.id == value);
}


// DataTable2(
//                   dataRowHeight: 50,
//                   dividerThickness: 1,
//                   columns: col_names
//                       .map((e) => DataColumn(
//                             label: Text(
//                               e,
//                               style: TextStyle(
//                                 fontStyle: FontStyle.italic,
//                               ),
//                               textAlign: TextAlign.center,
//                             ),
//                           ))
//                       .toList(),
                  // rows: list
                  //     .map(
                  //       (e) => DataRow(
                  //         cells: <DataCell>[
                  //           DataCell(
                  //             Text(_branchItems
                  //                 .firstWhere((i) => i.id == e.br_cd)
                  //                 .name),
                  //           ),
                  //           DataCell(
                  //             Text(_allPartyItems
                  //                 .firstWhere((i) => i.id == e.acc_id)
                  //                 .name),
                  //           ),
                  //           DataCell(Text(e.do_no)),
                  //           DataCell(Text(DateFormat.yMMMMd()
                  //               .add_jm()
                  //               .format(dateFormatFromDataBase(e.do_dt))
                  //               .toString())),
                  //           DataCell(Text(e.frmplc)),
                  //           DataCell(Text(e.toplc)),
                  //           DataCell(Text(e.itemnm)),
                  //           DataCell(Text(e.Wt.toString())),
                  //           DataCell(
                  //             Text(_allPartyItems
                  //                 .firstWhere((i) => i.id == e.consrcd)
                  //                 .name),
                  //           ),
                  //           DataCell(
                  //             Text(_allPartyItems
                  //                 .firstWhere((i) => i.id == e.consecd)
                  //                 .name),
                  //           ),
                  //           DataCell(
                  //             Text(_brokerItems.firstWhere(
                  //                 (i) => i.id == e.broker, orElse: () {
                  //               return PartyName(name: "Not Set");
                  //             }).name),
                  //           ),
                  //           DataCell(
                  //             Text(
                  //               _truckItems.firstWhere(
                  //                   (i) => i.uid == e.truckid, orElse: () {
                  //                 return Truck(
                  //                   panNo: "",
                  //                   truckNo: "Not Set",
                  //                   uid: "",
                  //                 );
                  //               }).truckNo,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     )
                  //     .toList(),
//                 );