import 'package:flutter/material.dart';
import 'package:softflow_app/Models/partyName_model.dart';

// ignore: must_be_immutable
class PartyTile extends StatelessWidget {
  late PartyName party;

  PartyTile({required this.party});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: ListTile(
        tileColor: Theme.of(context).primaryColor,
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
                Icons.account_circle,
                color: Colors.white,
                size: 35,
              ),
            )
          ],
        ),
        title: Text(
          party.name,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            // fontSize: 20,
          ),
        ),
        onTap: () {},
      ),
    );
  }
}
