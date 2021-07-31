import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:softflow_app/Helpers/dateFormatfromDataBase.dart';
import 'package:softflow_app/Models/do_model.dart';
import 'package:softflow_app/Models/user_model.dart';

class DoItem extends StatelessWidget {
  late DO receivedDO;

  DoItem({
    required this.receivedDO,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: ListTile(
        tileColor:
            this.receivedDO.broker != '-1' && this.receivedDO.truckid != '-1'
                ? Colors.green
                : Theme.of(context).primaryColor,
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(right: 12.0),
              decoration: new BoxDecoration(
                  border: new Border(
                      right:
                          new BorderSide(width: 1.0, color: Colors.white24))),
              child: Icon(
                Icons.description,
                color: Colors.white,
                size: 35,
              ),
            )
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
                Text(
                  this.receivedDO.do_no,
                  style: TextStyle(color: Colors.white),
                  softWrap: true,
                ),
              ],
            ),
            this.receivedDO.truckid != '-1' ? FutureBuilder(
              future: User.getTruckNoById('1', this.receivedDO.truckid),
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
            ) : SizedBox(width: 0,),
          ],
        ),
        subtitle: Column(
          children: [
            FutureBuilder(
              future: User.getNameOfPartyById(this.receivedDO.consecd),
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
              future: User.getNameOfPartyById(this.receivedDO.consrcd),
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
                return Text("Error");
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
                        .add_jms()
                        .format(dateFormatFromDataBase(this.receivedDO.do_dt))
                        .toString(),
                    style: TextStyle(color: Colors.white)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
