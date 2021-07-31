import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:softflow_app/Providers/main_provider.dart';
import '../Admin/all_do_screen.dart';
import '../Admin/do_entry_screen.dart';
import '../Admin/registration_screen.dart';
import '../TrafficMaster/traffic_master_do_screen.dart';

import '../../Widgets/option_tile_widget.dart';

class UserMasterScreen extends StatelessWidget {
  static const routeName = "/userMasterScreen";

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MainProvider>(context).user;
    user.show();
    return new Scaffold(
      appBar: new AppBar(
        title: Text("User Master Screen"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: new GridView(
          children: [
            new OptionWidget(
              text: "D.O. Entry",
              routeName: DoEntryScreen.routeName,
              arguments: {
                'data': "",
                'enable': true,
                'isTrafficMaster': false,
              },
            ),
            new OptionWidget(
              text: "All D.O.",
              routeName: AllDoScreen.routeName,
            ),
            new OptionWidget(
              text: "Traffic Master D.O.",
              routeName: TrafficMasterDoScreen.routeName,
            ),
            new OptionWidget(
              text: "Registration",
              routeName: RegistrationScreen.routeName,
            ),
          ],
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 3 / 2,
          ),
        ),
      ),
    );
  }
}
