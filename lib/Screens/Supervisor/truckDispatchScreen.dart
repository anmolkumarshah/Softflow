import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:softflow_app/Models/do_model.dart';
import 'package:softflow_app/Models/user_model.dart';
import 'package:softflow_app/Providers/main_provider.dart';
import '../../Widgets/tileWidget.dart';

class TruckDispatchScreen extends StatefulWidget {
  @override
  static const routeName = "/truckDispatchScreen";

  @override
  _TruckDispatchScreenState createState() => _TruckDispatchScreenState();
}

class _TruckDispatchScreenState extends State<TruckDispatchScreen> {
  handleVehReachedUpdate(bool value, receivedDo) async {}

  Widget build(BuildContext context) {
    User currentUser = Provider.of<MainProvider>(context, listen: false).user;
    return Scaffold(
        appBar: new AppBar(
          title: Text("Trucks Dispatch"),
        ),
        body: FutureBuilder(
          future: DO.supervisorAllDO("""
        
        select * from domast where acc_id in (${currentUser.acc_id}, 
            ${currentUser.acc_id1}, ${currentUser.acc_id2}) and Veh_reached
             = 'true' and compl = 'false'
                
        """),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.connectionState == ConnectionState.done) {
              final List<DO> data =
              (snapshot.data as Map<String, dynamic>)['data'];
              if (data.length < 1) {
                return Center(
                  child: Text("List is Empty"),
                );
              }
              return ListView.builder(
                itemBuilder: (context, index) => TileWidget(
                  co: currentUser.co,
                  receivedDo: data[index],
                  userId: currentUser.acc_id,
                  isDispatch: true,
                ),
                itemCount: data.length,
              );
            }
            if (snapshot.hasError) {
              return Text("");
            }
            return Text("");
          },
        ));
  }
}

