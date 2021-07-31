import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:softflow_app/Helpers/dateFormatfromDataBase.dart';
import '../Admin/do_entry_screen.dart';
import 'package:softflow_app/Widgets/doItem.dart';
import '../../Models/do_model.dart';

class TrafficMasterDoScreen extends StatelessWidget {
  static const routeName = '/traffic_master_do_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("Traffic Master DO Screen"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TypeAheadField(
          textFieldConfiguration: TextFieldConfiguration(
            autofocus: true,
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: "Search by DO number"),
          ),
          suggestionsCallback: (pattern) async {
            final result = await DO.getAllUnAllotedDo(pattern);
            return result['data'];
          },
          itemBuilder: (context, suggestion) {
            final data = suggestion as DO;
            return DoItem(
      receivedDO: data,
            );
          },
          onSuggestionSelected: (suggestion) {
            Navigator.of(context).pushNamed(
              DoEntryScreen.routeName,
              arguments: {
                'data': suggestion,
                'heading': (suggestion as DO).do_no,
                'enable': true,
                'isTrafficMaster' : true,
                'isAll' : false,
                'isSupervisor' : false,
              },
            );
          },
          hideSuggestionsOnKeyboardHide: false,
        ),
      ),
    );
  }
}
