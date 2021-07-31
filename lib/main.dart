import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:softflow_app/Providers/main_provider.dart';
import 'package:softflow_app/Screens/Admin/add_user_screen.dart';
import 'package:softflow_app/Screens/Supervisor/truckInLoading.dart';
import 'package:softflow_app/Screens/Supervisor/truckToReachScreen.dart';
import 'package:softflow_app/Screens/image_viewer_screen.dart';
import 'Screens/Admin/admin_screen.dart';
import 'Screens/Admin/all_do_screen.dart';
import 'Screens/Admin/do_entry_screen.dart';
import 'Screens/Admin/registration_screen.dart';
import 'Screens/Supervisor/supervisor_screen.dart';
import 'Screens/Supervisor/truckDispatchScreen.dart';
import 'Screens/TrafficMaster/traffic_master_do_screen.dart';
import 'Screens/UserMaster/user_master_screen.dart';

//login Screen
import './Screens/login_screen.dart';
//co Screen
import './Screens/co_selection_screen.dart';
// traffic department screen
import 'Screens/TrafficMaster/traffic_department_screen.dart';

void main() {
  runApp(new SoftFlowApp());
}

class SoftFlowApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => new MainProvider(),
      child: new MaterialApp(
        theme: new ThemeData(
          primaryColor: Colors.blueGrey,
          accentColor: Colors.pink,
        ),
        debugShowCheckedModeBanner: false,
        title: "ERP",
        home: new LoginScreen(),
        routes: {
          CoSelectionScreen.routeName : (context) => new CoSelectionScreen(),
          TrafficDepartmentScreen.routeName : (context) => new TrafficDepartmentScreen(),
          DoEntryScreen.routeName : (context) => new DoEntryScreen(),
          AllDoScreen.routeName : (context) => new AllDoScreen(),
          TrafficMasterDoScreen.routeName : (context) => new TrafficMasterDoScreen(),
          RegistrationScreen.routeName : (context) => new RegistrationScreen(),
          AdminScreen.routeName : (context) => new AdminScreen(),
          SupervisorScreen.routeName : (context) => new SupervisorScreen(),
          UserMasterScreen.routeName : (context) => new UserMasterScreen(),
          LoginScreen.routeName : (context) => new LoginScreen(),
          TruckInLoading.routeName :  (context) => new TruckInLoading(),
          ImageViewerScreen.routeName : (context) => new ImageViewerScreen(),
          TruckToReachScreen.routeName : (context) => new TruckToReachScreen(),
          TruckDispatchScreen.routeName : (context) => new TruckDispatchScreen(),
          AddUserScreen.routeName : (context) => new AddUserScreen(),
        },
      ),
    );
  }
}
