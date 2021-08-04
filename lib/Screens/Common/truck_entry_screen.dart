import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:softflow_app/Helpers/Snakebar.dart';
import 'package:softflow_app/Models/truck_model.dart';
import 'package:softflow_app/Providers/main_provider.dart';
import 'package:softflow_app/Widgets/Truck/truckTile.dart';

class TruckEntryScreen extends StatefulWidget {
  static const routeName = "/truck-entry-screen";

  @override
  _TruckEntryScreenState createState() => _TruckEntryScreenState();
}

class _TruckEntryScreenState extends State<TruckEntryScreen> {
  List<Truck> _list = [];
  bool _isWholeLoading = false;

  handleSearch(String value) {
    // List<DO> temp = items
    //     .where(
    //       (element) =>
    //           (element.do_no.toLowerCase().contains(value.toLowerCase()) ||
    //               element.consignee
    //                   .toLowerCase()
    //                   .contains(value.toLowerCase()) ||
    //               element.toplc.toLowerCase().contains(value.toLowerCase()) ||
    //               element.frmplc.toLowerCase().contains(value.toLowerCase())) &&
    //           (dateFormatFromDataBase(element.do_dt)
    //                   .isAfter(selectedDate.subtract(Duration(days: 4))) &&
    //               dateFormatFromDataBase(element.do_dt)
    //                   .isBefore(selectedDate.add(Duration(days: 1)))),
    //     )
    //     .toList();
    // setState(() {
    //   toShowItems = temp;
    // });
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Truck Entry"),
      ),
      body: _isWholeLoading
          ? Center(child: CircularProgressIndicator())
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
                      itemCount: _list.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return TruckTile(
                          truck: _list[index],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
