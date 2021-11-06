import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:softflow_app/Models/user_model.dart';
import 'package:softflow_app/Providers/main_provider.dart';
import '../Common/do_entry_screen.dart';
import 'package:softflow_app/Widgets/doItem.dart';
import '../../Models/do_model.dart';

class TrafficMasterDoScreen extends StatelessWidget {
  static const routeName = '/traffic_master_do_screen';

  @override
  Widget build(BuildContext context) {
    final User currentUser =
        Provider.of<MainProvider>(context, listen: false).user;
    return Scaffold(
      appBar: new AppBar(
        title: Text("Truck Not Alloted"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TypeAheadField(
          textFieldConfiguration: TextFieldConfiguration(
            autofocus: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Search by DO number",
            ),
          ),
          suggestionsCallback: (pattern) async {
            final result = await DO.getAllUnAllotedDo('', currentUser.deptCd);
            List<DO> updatedResult = (result['data'] as List<DO>)
                .where((element) => element.do_no
                    .toLowerCase()
                    .contains(pattern.toString().toLowerCase()))
                .toList();
            return updatedResult;
          },
          itemBuilder: (context, suggestion) {
            final data = suggestion as DO;
            return DoItem(
              receivedDO: data,
              getAndSet: () {},
              forTrafficDetailsColumns: true,
              isAll: false,
            );
          },
          onSuggestionSelected: (suggestion) {
            Navigator.of(context).pushNamed(
              DoEntryScreen.routeName,
              arguments: {
                //  ye kuch ni karra h
              },
            );
          },
          hideKeyboard: false,
          hideOnLoading: false,
        ),
      ),
    );
  }
}
