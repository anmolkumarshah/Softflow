import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:softflow_app/Helpers/Snakebar.dart';
import 'package:softflow_app/Helpers/shimmerLoader.dart';
import 'package:softflow_app/Models/partyName_model.dart';
import 'package:softflow_app/Providers/main_provider.dart';
import 'package:softflow_app/Screens/Common/party_input_screen.dart';
import 'package:softflow_app/Widgets/PartyName/partyTile.dart';

class PartyEntryScreen extends StatefulWidget {
  static const routeName = "/party-entry-screen";

  @override
  _PartyEntryScreenState createState() => _PartyEntryScreenState();
}

class _PartyEntryScreenState extends State<PartyEntryScreen> {
  List<PartyName> _list = [];
  List<PartyName> toShowItems = [];
  bool _isWholeLoading = false;

  handleSearch(String value) {
    List<PartyName> temp = _list
        .where(
          (element) =>
              (element.name.toLowerCase().contains(value.toLowerCase()) ||
                  element.bal_cd.toLowerCase().contains(value.toLowerCase()) ||
                  element.mobile.toLowerCase().contains(value.toLowerCase()) ||
                  element.place.toLowerCase().contains(value.toLowerCase())),
        )
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
    final result = await PartyName.getPartyName(
        considerUser.co, considerUser.yr, "", 'A5',
        balCd2: 'L5');
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Party Entry"),
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
                      labelText: 'Search Party',
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
                        return PartyTile(
                          party: toShowItems[index],
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
            PartyInputScreen.routeName,
            arguments: {'data': "", 'enable': true},
          );
          getAndSet();
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
