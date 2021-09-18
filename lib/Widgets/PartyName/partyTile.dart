import 'package:flutter/material.dart';
import 'package:softflow_app/Models/partyName_model.dart';
import 'package:softflow_app/Screens/Common/party_input_screen.dart';

// ignore: must_be_immutable
class PartyTile extends StatelessWidget {
  late PartyName party;
  Function getAndSet;

  PartyTile({required this.party, required this.getAndSet});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: ListTile(
        tileColor: Theme.of(context).colorScheme.primary,
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
          "Name : ${party.name}",
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          "Place : ${party.place}",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            // fontSize: 20,
          ),
        ),
        onTap: () async {
          await Navigator.of(context).pushNamed(
            PartyInputScreen.routeName,
            arguments: {'data': party, 'enable': false},
          );
          getAndSet();
        },
      ),
    );
  }
}
