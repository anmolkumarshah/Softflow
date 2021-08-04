import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:softflow_app/Helpers/Snakebar.dart';
import 'package:softflow_app/Models/partyName_model.dart';
import 'package:softflow_app/Providers/main_provider.dart';
import 'package:softflow_app/Widgets/PartyName/partyTile.dart';

class PartyEntryScreen extends StatefulWidget {
  static const routeName = "/party-entry-screen";

  @override
  _PartyEntryScreenState createState() => _PartyEntryScreenState();
}

class _PartyEntryScreenState extends State<PartyEntryScreen> {
  List<PartyName> _list = [];
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
    final result = await PartyName.getPartyName(
        considerUser.co, considerUser.yr, "", 'A5');
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
        title: Text("Party Entry"),
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
                      labelText: 'Search Party',
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
                        return PartyTile(party: _list[index]);
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
