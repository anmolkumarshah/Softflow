import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:softflow_app/Helpers/CurveHelper.dart';
import 'package:softflow_app/Helpers/Snakebar.dart';
import 'package:softflow_app/Models/company_model.dart';
import 'package:softflow_app/Models/user_model.dart';
import 'package:softflow_app/Providers/main_provider.dart';
import 'package:softflow_app/Screens/Supervisor/truckDispatchScreen.dart';
import 'package:softflow_app/Screens/Supervisor/truckInLoading.dart';
import 'package:softflow_app/Screens/Supervisor/truckToReachScreen.dart';

import '../../Widgets/option_tile_widget.dart';
import '../Common/login_screen.dart';

class SupervisorScreen extends StatefulWidget {
  static const routeName = "/supervisorScreen";

  @override
  _SupervisorScreenState createState() => _SupervisorScreenState();
}

class _SupervisorScreenState extends State<SupervisorScreen> {
  TextStyle hiStyle = TextStyle(
    color: Colors.white,
    fontSize: 80,
    fontWeight: FontWeight.bold,
    fontFamily: 'NotoSerif',
  );

  TextStyle nameStyle = TextStyle(
    color: Colors.white,
    fontSize: 40,
    fontWeight: FontWeight.bold,
    fontFamily: 'NotoSerif',
  );

  TextStyle subTitleStyle = TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontFamily: 'NotoSerif',
  );

  TextStyle dataStyle = TextStyle(
    color: Colors.white,
    fontSize: 20,
    // fontWeight: FontWeight.bold,
    fontFamily: 'NotoSerif',
  );

  late String companyName = "";

  late String year = "";

  late String userName = "";
  bool _isLoading = false;

  getSetData() async {
    setState(() {
      _isLoading = true;
    });
    final User currentUser =
        Provider.of<MainProvider>(context, listen: false).user;

    userName = currentUser.name;
    year = currentUser.yr;

    Map<String, dynamic> result = await Company.getCompany(query: """
      select * from Co where Id = ${currentUser.co}
    """);
    if (result['message'] == 'success') {
      final name = (result['data'][0] as Company).name.toString();
      setState(() {
        companyName = name;
      });
    } else {
      showSnakeBar(context, result['message']);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getSetData();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MainProvider>(context).user;
    user.show();
    return new Scaffold(
      appBar: new AppBar(
        // title: Text("Supervisor Screen"),
        elevation: 0,
      ),
      endDrawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.logout_rounded,
                    size: 40,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Logout",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
              onTap: () {
                Navigator.of(context).pushNamed(LoginScreen.routeName);
              },
            ),
          ],
        ),
      ),
      backgroundColor: Color(0xFFfaf3dd),
      body: Stack(
        children: [
          ClipPath(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Text(
                        //   "Hi,",
                        //   style: hiStyle,
                        // ),
                      ],
                    ),
                    Flexible(
                      child: Text(
                        this.userName,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: nameStyle,
                      ),
                    ),

                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: [
                    //     Icon(
                    //       Icons.business,
                    //       color: Colors.white,
                    //     ),
                    //     SizedBox(
                    //       width: 10,
                    //     ),
                    //     Text(
                    //       "Selected Company",
                    //       style: subTitleStyle,
                    //     )
                    //   ],
                    // ),
                    _isLoading
                        ? LinearProgressIndicator()
                        : Row(
                            children: [
                              Icon(
                                Icons.account_box_outlined,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                this.companyName,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: dataStyle,
                              ),
                            ],
                          ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: [
                    //     Icon(
                    //       Icons.event,
                    //       color: Colors.white,
                    //     ),
                    //     SizedBox(
                    //       width: 10,
                    //     ),
                    //     Text(
                    //       "Selected Year",
                    //       style: subTitleStyle,
                    //     ),
                    //   ],
                    // ),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_view_day,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          this.year,
                          style: dataStyle,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            clipper: ClipPathClass(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  child: GridView(
                    shrinkWrap: true,
                    children: [
                      new OptionWidget(
                        text: "Trucks To Reach",
                        routeName: TruckToReachScreen.routeName,
                      ),
                      new OptionWidget(
                        text: "Trucks In Loading",
                        routeName: TruckInLoading.routeName,
                      ),
                      new OptionWidget(
                        text: "Truck Dispatch Entry",
                        routeName: TruckDispatchScreen.routeName,
                      ),
                    ],
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                      childAspectRatio: 4,
                    ),
                  ),
                  height: 350,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
