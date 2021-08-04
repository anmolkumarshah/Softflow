import 'package:flutter/material.dart';
import 'package:softflow_app/Helpers/typeAccountHelper.dart';
import 'package:softflow_app/Models/user_model.dart';
import 'package:softflow_app/Screens/Admin/registration_screen.dart';

// ignore: must_be_immutable
class UserTile extends StatelessWidget {
  late User userItem;

  UserTile(this.userItem);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(RegistrationScreen.routeName,
            arguments: {'data': userItem});
      },
      child: ListTile(
        tileColor: Theme.of(context).primaryColor,
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(right: 12.0),
              decoration: new BoxDecoration(
                  border: new Border(
                      right:
                          new BorderSide(width: 1.0, color: Colors.white24))),
              child: Icon(
                Icons.perm_contact_cal,
                color: Colors.white,
                size: 35,
              ),
            )
          ],
        ),
        subtitle: Column(
          children: [
            rowTextIcon(
              text: userItem.name,
              icon: Icons.badge,
            ),
            Divider(
              height: 3,
            ),
            rowTextIcon(
              text: userItem.email,
              icon: Icons.account_circle,
            ),
            Divider(
              height: 3,
            ),
            rowTextIcon(
              text: userItem.mobile,
              icon: Icons.call,
            ),
            Divider(
              height: 3,
            ),
            rowTextIcon(
              text: typeAccount(int.parse(userItem.deptCd1)),
              icon: Icons.engineering,
            ),
          ],
        ),
      ),
    );
  }

  Row rowTextIcon({required String text, required IconData icon}) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.white,
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          text,
          style: TextStyle(fontSize: 15, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
