import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:softflow_app/Helpers/dateFormatfromDataBase.dart';
import 'package:softflow_app/Models/do_model.dart';
import 'package:softflow_app/Models/partyName_model.dart';
import 'package:softflow_app/Models/truck_model.dart';
import 'package:softflow_app/Providers/main_provider.dart';
import 'package:softflow_app/Screens/Common/do_entry_screen.dart';
import 'package:softflow_app/Screens/Supervisor/superVisorDo.dart';

// ignore: must_be_immutable
class DoItem extends StatelessWidget {
  late DO receivedDO;
  Function getAndSet;
  late bool forTrafficDetailsColumns;
  bool isAll;
  bool isSup;

  checkPenalty(String dt, int n) {
    double charge = 1000;
    DateTime limitDay = dateFormatFromDataBase(dt).add(Duration(days: n));
    if (DateTime.now().isBefore(limitDay) || DateTime.now() == limitDay) {
      return '0';
    } else {
      Duration diff = DateTime.now().difference(limitDay);
      return (charge * diff.inDays).toString();
    }
  }

  DoItem({
    required this.receivedDO,
    required this.getAndSet,
    this.forTrafficDetailsColumns = true,
    this.isAll = true,
    this.isSup = false,
  });

  @override
  Widget build(BuildContext context) {
    var panelty = checkPenalty(receivedDO.do_dt, receivedDO.lefdays);
    return GestureDetector(
      onTap: this.isSup
          ? () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SuperVisorDo(
                      receivedDo: this.receivedDO,
                    ),
                  ));
            }
          : () async {
              final considerUser =
                  Provider.of<MainProvider>(context, listen: false).user;
              await Navigator.of(context)
                  .pushNamed(DoEntryScreen.routeName, arguments: {
                'data': receivedDO,
                'heading': (receivedDO).do_no,
                'enable':
                    considerUser.deptCd1 == '0' || considerUser.deptCd1 == '1'
                        ? true
                        : false,
                'isTrafficMaster': considerUser.deptCd1 == '1' ? true : false,
                'isAll': isAll,
                'isSupervisor': considerUser.deptCd1 == '2' ? true : false,
                'isUpdate': considerUser.deptCd1 == '0' ? true : false,
                'isEntry': false,
                'isDetailTraffic': forTrafficDetailsColumns,
                'isUpdateButton': true,
              });
              getAndSet();
            },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: ListTile(
          tileColor: this.receivedDO.compl == 1
              ? Colors.brown[400]
              : this.receivedDO.broker != '-1' &&
                      this.receivedDO.truckid != '-1'
                  ? Colors.green
                  : Theme.of(context).colorScheme.primary,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: EdgeInsets.only(right: 12.0),
                decoration: new BoxDecoration(
                  border: new Border(
                    right: new BorderSide(width: 1.0, color: Colors.white24),
                  ),
                ),
                child: Icon(
                  Icons.description,
                  color: Colors.white,
                  size: 35,
                ),
              ),
            ],
          ),
          title: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.mark_chat_read_rounded, color: Colors.white),
                  SizedBox(
                    width: 5,
                  ),
                  Flexible(
                    child: Text(
                      this.receivedDO.do_no,
                      style: TextStyle(color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                  ),
                ],
              ),
              this.receivedDO.truckid != '-1'
                  ? FutureBuilder(
                      future:
                          Truck.getTruckNoById('1', this.receivedDO.truckid),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Column(
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              LinearProgressIndicator(
                                minHeight: 3,
                              ),
                            ],
                          );
                        } else if (snapshot.connectionState ==
                            ConnectionState.done) {
                          if (snapshot.hasData) {
                            return Row(
                              children: <Widget>[
                                Icon(Icons.confirmation_number_outlined,
                                    color: Colors.white),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Text(snapshot.data.toString(),
                                      style: TextStyle(color: Colors.white)),
                                )
                              ],
                            );
                          }
                        }
                        return Text("Error");
                      },
                    )
                  : SizedBox(
                      width: 0,
                    ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                future: PartyName.getNameOfPartyById(this.receivedDO.acc_id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Column(
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        LinearProgressIndicator(
                          minHeight: 3,
                        ),
                      ],
                    );
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return Row(
                        children: <Widget>[
                          Icon(Icons.person, color: Colors.white),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Text(snapshot.data.toString(),
                                style: TextStyle(color: Colors.white)),
                          )
                        ],
                      );
                    }
                  }
                  return Text("Error");
                },
              ),
              FutureBuilder(
                future: PartyName.getNameOfPartyById(this.receivedDO.consrcd),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Column(
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        LinearProgressIndicator(
                          minHeight: 3,
                        ),
                      ],
                    );
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return Row(
                        children: <Widget>[
                          Icon(Icons.people, color: Colors.white),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Text(
                              snapshot.data.toString(),
                              style: TextStyle(color: Colors.white),
                              softWrap: true,
                            ),
                          )
                        ],
                      );
                    }
                  }
                  return Text("Error Anmol");
                },
              ),
              Row(
                children: [
                  Icon(Icons.local_shipping, color: Colors.white),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    this.receivedDO.frmplc,
                    style: TextStyle(color: Colors.white),
                    softWrap: true,
                  ),
                  Icon(Icons.arrow_right_alt, color: Colors.white),
                  Text(
                    this.receivedDO.toplc,
                    style: TextStyle(color: Colors.white),
                    softWrap: true,
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Icon(Icons.date_range, color: Colors.white),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                      DateFormat.yMMMMd()
                          .format(dateFormatFromDataBase(this.receivedDO.do_dt))
                          .toString(),
                      style: TextStyle(color: Colors.white)),
                ],
              ),
              panelty != '0'
                  ? Chip(
                      label: Text(
                        'Penalty $panelty',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.red,
                    )
                  : SizedBox(
                      height: 0,
                    ),
            ],
          ),
          trailing: Chip(
            label: Text(
              "qty  " + receivedDO.Wt.toString(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
