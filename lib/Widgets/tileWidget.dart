import 'package:flutter/material.dart';
import 'package:softflow_app/Models/do_model.dart';
import 'package:softflow_app/Models/truck_model.dart';

// ignore: must_be_immutable
class TileWidget extends StatefulWidget {
  @override
  _TileWidgetState createState() => _TileWidgetState();
  late String co;
  late String userId;
  late DO receivedDo;
  late bool isDispatch;

  TileWidget({
    required this.co,
    required this.receivedDo,
    required this.userId,
    required this.isDispatch,
  });
}

class _TileWidgetState extends State<TileWidget> {
  bool _isTapped = false;
  bool _isLoading = false;
  bool _isVehReached = false;
  bool _isVehDispatched = false;

  handleVehReachedUpdate(bool value, receivedDo) async {
    setState(() {
      _isLoading = true;
    });
    switch (value) {
      case true:
        await (receivedDo as DO).updateIsVahReached(1, widget.userId);
        break;
      case false:
        await (receivedDo as DO).updateIsVahReached(0, 0);
        break;
    }
    setState(() {
      _isVehReached = value;
      _isLoading = false;
    });
  }

  handleDispatchedVehicle(bool value, receivedDo) async {
    setState(() {
      _isLoading = true;
    });
    switch (value) {
      case true:
        await (receivedDo as DO).dispatchVehicle(1, widget.userId);
        break;
      case false:
        await (receivedDo as DO).dispatchVehicle(0, 0);
        break;
    }
    setState(() {
      _isVehDispatched = value;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    this._isVehReached = widget.receivedDo.Veh_reached == '0' ? false : true;
    this._isVehDispatched = widget.receivedDo.compl == 0 ? false : true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 3,
      ),
      child: Column(
        children: [
          ListTile(
            tileColor: Theme.of(context).colorScheme.primary,
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.only(right: 12.0),
                  decoration: new BoxDecoration(
                      border: new Border(
                          right: new BorderSide(
                              width: 1.0, color: Colors.white24))),
                  child: Icon(
                    Icons.local_shipping,
                    color: Colors.white,
                    size: 35,
                  ),
                )
              ],
            ),
            subtitle: Row(
              children: [
                Icon(Icons.local_shipping, color: Colors.white),
                SizedBox(
                  width: 5,
                ),
                Text(
                  widget.receivedDo.frmplc,
                  style: TextStyle(color: Colors.white),
                  softWrap: true,
                ),
                Icon(Icons.arrow_right_alt, color: Colors.white),
                Text(
                  widget.receivedDo.toplc,
                  style: TextStyle(color: Colors.white),
                  softWrap: true,
                ),
              ],
            ),
            title: FutureBuilder(
              future:
                  Truck.getTruckNoById(widget.co, widget.receivedDo.truckid),
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
            ),
            onTap: () {
              setState(() {
                _isTapped = !_isTapped;
              });
            },
          ),
          _isLoading
              ? LinearProgressIndicator()
              : _isTapped
                  ? widget.isDispatch
                      ? CheckboxListTile(
                          tileColor: Theme.of(context).colorScheme.primary,
                          value: _isVehDispatched,
                          title: Text(
                            "To Dispatch Vehicle?",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onChanged: (value) => handleDispatchedVehicle(
                            value!,
                            widget.receivedDo,
                          ),
                        )
                      : CheckboxListTile(
                          tileColor: Theme.of(context).colorScheme.primary,
                          value: _isVehReached,
                          title: Text(
                            "Is Vehicle Reached?",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onChanged: (value) => handleVehReachedUpdate(
                            value!,
                            widget.receivedDo,
                          ),
                        )
                  : SizedBox(
                      width: 0,
                    ),
        ],
      ),
    );
  }
}
