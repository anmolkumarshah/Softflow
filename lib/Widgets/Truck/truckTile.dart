import 'package:flutter/material.dart';
import 'package:softflow_app/Models/truck_model.dart';
import 'package:softflow_app/Screens/Common/truck_input_screen.dart';

// ignore: must_be_immutable
class TruckTile extends StatelessWidget {
  late Truck truck;
  Function getAndSet;

  TruckTile({required this.truck, required this.getAndSet});

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
                Icons.airport_shuttle,
                color: Colors.white,
                size: 35,
              ),
            )
          ],
        ),
        title: Text(
          truck.truckNo,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            // fontSize: 20,
          ),
        ),
        subtitle: Text(
          truck.panNo,
          style: TextStyle(
            color: Colors.white,
            // fontWeight: FontWeight.bold,
            // fontSize: 20,
          ),
        ),
        onTap: () async {
          await Navigator.of(context).pushNamed(
            TruckInputScreen.routeName,
            arguments: {'data': truck, 'enable': false},
          );
          getAndSet();
        },
      ),
    );
  }
}
