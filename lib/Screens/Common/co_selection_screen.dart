import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:softflow_app/Models/company_model.dart';
import 'package:softflow_app/Models/user_model.dart';
import 'package:softflow_app/Models/year_model.dart';
import 'package:softflow_app/Providers/main_provider.dart';
import '../Supervisor/supervisor_screen.dart';
import '../TrafficMaster/traffic_department_screen.dart';
import '../UserMaster/user_master_screen.dart';
import '../../Helpers/Snakebar.dart';
import '../Admin/admin_screen.dart';

class CoSelectionScreen extends StatefulWidget {
  @override
  _CoSelectionScreenState createState() => _CoSelectionScreenState();
  static const routeName = "/co_selection_screen";
}

class _CoSelectionScreenState extends State<CoSelectionScreen> {
  late var _value = coList.length > 0 ? coList[0].id : 1;
  // ignore: avoid_init_to_null
  late var _year = null;
  var _coYr = [];
  late User user;
  var coList = []; // names of company

  void handleContinue() {
    if (user.co != '-1' && user.yr != '-1') {
      Navigator.of(context).pushNamed(TrafficDepartmentScreen.routeName);
      switch (user.deptCd1) {
        case '0':
          Navigator.of(context).pushReplacementNamed(AdminScreen.routeName);
          break;
        case '1':
          Navigator.of(context)
              .pushReplacementNamed(TrafficDepartmentScreen.routeName);
          break;
        case '2':
          Navigator.of(context)
              .pushReplacementNamed(SupervisorScreen.routeName);
          break;
        case '3':
          Navigator.of(context)
              .pushReplacementNamed(UserMasterScreen.routeName);
          break;
        default:
          showSnakeBar(context, "Invalid user type");
          break;
      }
    } else {
      showSnakeBar(context, "Error in setting Company name and year");
    }
  }

  void fetchCompany() async {
    user = Provider.of<MainProvider>(context, listen: false).user;
    Map<String, dynamic> result = await Company.getCompany();
    if (result['message'] == 'success') {
      List<Company> list = result['data'];
      setState(() {
        coList = list;
      });
      user.co = coList[0].id.toString();
      fetchCoYear();
    } else {
      showSnakeBar(context, result['message']);
    }
  }

  void fetchCoYear() async {
    user = Provider.of<MainProvider>(context, listen: false).user;
    Map<String, dynamic> result = await Year.getYears(co: user.co);
    if (result['message'] == 'success') {
      List<Year> list = result['data'];
      setState(() {
        _coYr = list;
      });
      user.yr = list[list.length - 1].year.substring(1);
    } else {
      showSnakeBar(context, result['message']);
    }
  }

  @override
  // ignore: must_call_super
  void initState() {
    fetchCompany();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              "https://cdn.pixabay.com/photo/2016/03/24/17/46/highway-1277246__340.jpg",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: new Container(
            height: 250,
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(20),
            decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 15,
                  )
                ]),
            child: Column(
              children: [
                new Column(
                  children: [
                    new Text(
                      "Select Company",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    coList.length == 0
                        ? CircularProgressIndicator()
                        : DropdownButton(
                            value: _value,
                            items: coList
                                .map((item) => DropdownMenuItem(
                                      child: FittedBox(
                                        child: Text(item.name),
                                      ),
                                      value: item.id,
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _coYr = [];
                              }); // for co name refresh and yr refresh
                              user.co = value.toString();
                              fetchCoYear();
                              setState(() {
                                _value = value;
                              });
                              _year = null;
                            },
                          ),
                    new SizedBox(
                      height: 20,
                    ),
                    new Text(
                      "Select Year",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    _coYr.length == 0
                        ? CircularProgressIndicator()
                        : DropdownButton(
                            value: _year == null
                                ? _coYr[_coYr.length - 1].year
                                : _year,
                            items: _coYr
                                .map((item) => DropdownMenuItem(
                                      child: FittedBox(
                                        child: Text(
                                            (item.year as String).substring(1)),
                                      ),
                                      value: item.year,
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                user.yr = (value as String).substring(1);
                                _year = value;
                              });
                            },
                          ),
                    _coYr.length != 0
                        ? ElevatedButton(
                            onPressed: handleContinue,
                            child: Text("Continue"),
                          )
                        : Text("")
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
