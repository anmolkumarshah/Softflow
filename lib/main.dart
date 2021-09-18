import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:softflow_app/Providers/main_provider.dart';
import 'package:softflow_app/Screens/Admin/add_user_screen.dart';
import 'package:softflow_app/Screens/Common/party_entry_screen.dart';
import 'package:softflow_app/Screens/Common/party_input_screen.dart';
import 'package:softflow_app/Screens/Common/tabulardataScreen.dart';
import 'package:softflow_app/Screens/Common/truck_entry_screen.dart';
import 'package:softflow_app/Screens/Common/truck_input_screen.dart';
import 'package:softflow_app/Screens/Supervisor/truckInLoading.dart';
import 'package:softflow_app/Screens/Supervisor/truckToReachScreen.dart';
import 'package:softflow_app/Screens/Common/image_viewer_screen.dart';
import 'package:softflow_app/Screens/loaderScreen.dart';
import 'Screens/Admin/admin_screen.dart';
import 'Screens/Admin/all_do_screen.dart';
import 'Screens/Common/do_entry_screen.dart';
import 'Screens/Admin/registration_screen.dart';
import 'Screens/Supervisor/supervisor_screen.dart';
import 'Screens/Supervisor/truckDispatchScreen.dart';
import 'Screens/TrafficMaster/traffic_master_do_screen.dart';
import 'Screens/UserMaster/user_master_screen.dart';
import 'Screens/Common/login_screen.dart';
import 'Screens/Common/co_selection_screen.dart';
import 'Screens/TrafficMaster/traffic_department_screen.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(SoftFlowApp());
}

class SoftFlowApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final prefs = (snapshot.data as SharedPreferences);
          final email = prefs.getString('email');
          final pass = prefs.getString('password');
          return ChangeNotifierProvider(
            create: (context) => new MainProvider(),
            child: new MaterialApp(
              theme: new ThemeData(
                colorScheme: ColorScheme.light(
                  primary: Color(0xFF4a4e69),
                  secondary: Color(0xFF9a8c98),
                ),
                appBarTheme: Theme.of(context)
                    .appBarTheme
                    .copyWith(brightness: Brightness.light),
              ),
              debugShowCheckedModeBanner: false,
              title: "JET - ERP",
              home: (email == null && pass == null)
                  ? LoginScreen()
                  : InitLoader(email: email!, pass: pass!),
              routes: {
                CoSelectionScreen.routeName: (context) =>
                    new CoSelectionScreen(),
                TrafficDepartmentScreen.routeName: (context) =>
                    new TrafficDepartmentScreen(),
                DoEntryScreen.routeName: (context) => new DoEntryScreen(),
                AllDoScreen.routeName: (context) => new AllDoScreen(),
                TrafficMasterDoScreen.routeName: (context) =>
                    new TrafficMasterDoScreen(),
                RegistrationScreen.routeName: (context) =>
                    new RegistrationScreen(),
                AdminScreen.routeName: (context) => new AdminScreen(),
                SupervisorScreen.routeName: (context) => new SupervisorScreen(),
                UserMasterScreen.routeName: (context) => new UserMasterScreen(),
                LoginScreen.routeName: (context) => new LoginScreen(),
                TruckInLoading.routeName: (context) => new TruckInLoading(),
                ImageViewerScreen.routeName: (context) =>
                    new ImageViewerScreen(),
                TruckToReachScreen.routeName: (context) =>
                    new TruckToReachScreen(),
                TruckDispatchScreen.routeName: (context) =>
                    new TruckDispatchScreen(),
                AddUserScreen.routeName: (context) => new AddUserScreen(),
                PartyEntryScreen.routeName: (context) => PartyEntryScreen(),
                TruckEntryScreen.routeName: (context) => TruckEntryScreen(),
                PartyInputScreen.routeName: (context) => PartyInputScreen(),
                TruckInputScreen.routeName: (context) => TruckInputScreen(),
                TabularDataScreen.routeName: (context) => TabularDataScreen(),
              },
            ),
          );
        });
  }
}
