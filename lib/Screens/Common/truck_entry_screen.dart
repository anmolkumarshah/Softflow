import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:softflow_app/Helpers/Snakebar.dart';
import 'package:softflow_app/Helpers/shimmerLoader.dart';
import 'package:softflow_app/Models/truck_model.dart';
import 'package:softflow_app/Providers/main_provider.dart';
import 'package:softflow_app/Screens/Common/truck_input_screen.dart';
import 'package:softflow_app/Widgets/Truck/truckTile.dart';

class TruckEntryScreen extends StatefulWidget {
  static const routeName = "/truck-entry-screen";

  @override
  _TruckEntryScreenState createState() => _TruckEntryScreenState();
}

class _TruckEntryScreenState extends State<TruckEntryScreen> {
  List<Truck> _list = [];
  List<Truck> toShowItems = [];
  bool _isWholeLoading = false;

  handleSearch(String value) {
    List<Truck> temp = _list
        .where((element) =>
            (element.truckNo.toLowerCase().contains(value.toLowerCase()) ||
                element.truck_no1.toLowerCase().contains(value.toLowerCase()) ||
                element.driver_nm.toLowerCase().contains(value.toLowerCase()) ||
                element.place.toLowerCase().contains(value.toLowerCase())))
        .toList();
    setState(() {
      toShowItems = temp;
    });
  }

  getAndSet() async {
    setState(() {
      _isWholeLoading = true;
    });
    final considerUser = Provider.of<MainProvider>(context, listen: false).user;
    final result = await Truck.getTrucks(considerUser.co, "");
    if (result['message'] == 'success') {
      setState(() {
        _list = result['data'];
        toShowItems = _list;
        _isWholeLoading = false;
      });
    } else {
      showSnakeBar(context, result['message']);
      _isWholeLoading = false;
    }
  }

  @override
  void initState() {
    super.initState();
    getAndSet();
  }

  @override
  Widget build(BuildContext context) {
    final currUser = Provider.of<MainProvider>(context, listen: false).mainUser;
    return Scaffold(
        appBar: AppBar(
          title: Text("Truck Entry"),
        ),
        body: _isWholeLoading
            ? LoadingListPage()
            : Column(
                children: [
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      onChanged: (value) => handleSearch(value),
                      initialValue: "",
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Search Truck',
                      ),
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () => getAndSet(),
                      child: ListView.builder(
                        itemCount: toShowItems.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return TruckTile(
                            truck: toShowItems[index],
                            getAndSet: getAndSet,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.of(context).pushNamed(
              TruckInputScreen.routeName,
              arguments: {'data': "", 'enable': true},
            );
            getAndSet();
          },
          child: Icon(
            Icons.add,
          ),
        ));
  }
}
