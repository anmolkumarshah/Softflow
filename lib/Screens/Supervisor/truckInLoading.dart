import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:softflow_app/Models/user_model.dart';
import 'package:softflow_app/Providers/main_provider.dart';
import '../Common/do_entry_screen.dart';
import 'package:softflow_app/Widgets/doItem.dart';
import '../../Models/do_model.dart';

class TruckInLoading extends StatelessWidget {
  static const routeName = '/supervisorAllDoScreen';

  @override
  Widget build(BuildContext context) {
    User currentUser = Provider.of<MainProvider>(context, listen: false).user;
    return Scaffold(
      appBar: new AppBar(
        title: Text("Trucks In Loading"),
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
            final result = await DO.supervisorAllDO(""" 
            
            select * from domast where acc_id in (${currentUser.acc_id}, 
            ${currentUser.acc_id1}, ${currentUser.acc_id2}) and Veh_reached
             = 'true' and compl = 'false' and do_no like 
            '%$pattern%' and br_cd = ${currentUser.deptCd}
            
            """);
            return result['data'];
          },
          itemBuilder: (context, suggestion) {
            final data = suggestion as DO;
            return DoItem(
              receivedDO: data,
            );
          },
          onSuggestionSelected: (suggestion) {
            Navigator.of(context)
                .pushNamed(DoEntryScreen.routeName, arguments: {
              'data': suggestion,
              'heading': (suggestion as DO).do_no,
              'enable': false,
              'isTrafficMaster': false,
              'isAll': true,
              'isSupervisor': true,
            });
          },
          hideSuggestionsOnKeyboardHide: false,
        ),
      ),
    );
  }
}
