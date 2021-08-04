import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:softflow_app/Helpers/Snakebar.dart';
import 'package:softflow_app/Helpers/dateFormatfromDataBase.dart';
import 'package:softflow_app/Models/user_model.dart';
import 'package:softflow_app/Providers/main_provider.dart';
import 'package:softflow_app/Widgets/doItem.dart';
import '../../Models/do_model.dart';

class AllDoScreen extends StatefulWidget {
  static const routeName = '/allDoScreen';

  @override
  _AllDoScreenState createState() => _AllDoScreenState();
}

class _AllDoScreenState extends State<AllDoScreen> {
  List<DO> items = [];

  List<DO> toShowItems = [];

  bool _isLoading = false;

  DateTime selectedDate = DateTime.now();

  getAndSet() async {
    final User currentUser =
        Provider.of<MainProvider>(context, listen: false).user;
    setState(() {
      _isLoading = true;
    });
    final result = await DO.getAllDO('', branch: currentUser.deptCd);
    if (result['message'] == 'success') {
      setState(() {
        items = result['data'];
        toShowItems = items;
        _isLoading = false;
      });
    } else {
      showSnakeBar(context, result['message']);
      setState(() {
        _isLoading = false;
      });
    }
    handleSearch("");
  }

  handleSearch(String value) {
    List<DO> temp = items
        .where(
          (element) =>
              (element.do_no.toLowerCase().contains(value.toLowerCase()) ||
                  element.consignee
                      .toLowerCase()
                      .contains(value.toLowerCase()) ||
                  element.toplc.toLowerCase().contains(value.toLowerCase()) ||
                  element.frmplc.toLowerCase().contains(value.toLowerCase())) &&
              (dateFormatFromDataBase(element.do_dt)
                      .isAfter(selectedDate.subtract(Duration(days: 4))) &&
                  dateFormatFromDataBase(element.do_dt)
                      .isBefore(selectedDate.add(Duration(days: 1)))),
        )
        .toList();
    setState(() {
      toShowItems = temp;
    });
  }

  dynamic _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
      handleSearch('');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    getAndSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("D.O. Listing"),
        actions: [
          IconButton(
              onPressed: () => _selectDate(context),
              icon: Icon(Icons.date_range_rounded))
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
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
                      labelText: 'Search User',
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Chip(
                          label: Text(
                        "Results for Date " +
                            DateFormat.yMMMd().format(selectedDate).toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                    ],
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => getAndSet(),
                    child: ListView.builder(
                      itemCount: toShowItems.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return DoItem(
                          receivedDO: toShowItems[index],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
