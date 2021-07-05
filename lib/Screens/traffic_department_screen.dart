import 'package:flutter/material.dart';
import 'package:softflow_app/Screens/do_entry_screen.dart';

import '../Widgets/option_tile_widget.dart';

class TrafficDepartmentScreen extends StatelessWidget {
  static const routeName = "/trafficDepartmentScreen";
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Truck Master"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: new GridView(
          children: [
            new OptionWidget(
              text: "D.O. Entry",
              routeName: DoEntryScreen.routeName,
            ),
            new OptionWidget(),
            new OptionWidget(),
            new OptionWidget(),
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

