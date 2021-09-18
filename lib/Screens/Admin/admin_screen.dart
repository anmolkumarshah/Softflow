import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:softflow_app/Helpers/CurveHelper.dart';
import 'package:softflow_app/Helpers/Snakebar.dart';
import 'package:softflow_app/Models/company_model.dart';
import 'package:softflow_app/Models/user_model.dart';
import 'package:softflow_app/Providers/main_provider.dart';
import 'package:softflow_app/Screens/Admin/add_user_screen.dart';
import 'package:softflow_app/Screens/Common/party_entry_screen.dart';
import 'package:softflow_app/Screens/Common/truck_entry_screen.dart';
import 'package:softflow_app/Widgets/drawerContent.dart';
import 'all_do_screen.dart';
import '../Common/do_entry_screen.dart';

import '../../Widgets/MainScreenTile/option_tile_widget.dart';

class AdminScreen extends StatefulWidget {
  static const routeName = "/adminScreen";

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
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
        // title: Text("Admin Screen"),
        elevation: 0,
      ),
      endDrawer: Drawer(
        child: DrawerContent(),
      ),
      backgroundColor: Color(0xFFfaf3dd),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/back.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            ClipPath(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
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
                      Flexible(
                        child: Text(
                          this.userName,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: nameStyle,
                        ),
                      ),
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
                        // do entry
                        new OptionWidget(
                          text: "D.O. Entry",
                          routeName: DoEntryScreen.routeName,
                          arguments: {
                            'data': "",
                            'enable': true,
                            'isTrafficMaster': false,
                            'isAll': false,
                            'isSupervisor': false,
                            'isEntry': true,
                            'isUpdateButton': false,
                          },
                        ),
                        // do listing
                        new OptionWidget(
                          text: "D.O. Listing",
                          routeName: AllDoScreen.routeName,
                        ),
                        // add new user
                        new OptionWidget(
                          text: "Add New User",
                          routeName: AddUserScreen.routeName,
                        ),
                        new OptionWidget(
                          text: "Party Entry",
                          routeName: PartyEntryScreen.routeName,
                        ),
                        new OptionWidget(
                          text: "Truck Entry",
                          routeName: TruckEntryScreen.routeName,
                        ),
                      ],
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15,
                        childAspectRatio: 4,
                      ),
                    ),
                    height: 500,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
