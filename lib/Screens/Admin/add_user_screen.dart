import 'package:flutter/material.dart';
import 'package:softflow_app/Helpers/Snakebar.dart';
import 'package:softflow_app/Models/user_model.dart';
import 'package:softflow_app/Screens/Admin/registration_screen.dart';
import 'package:softflow_app/Widgets/User/userTile.dart';

class AddUserScreen extends StatefulWidget {
  static const routeName = "/add_user_screen";

  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  List<User> items = [];
  List<User> toShowItems = [];
  bool _isLoading = false;

  getAndSet() async {
    setState(() {
      _isLoading = true;
    });
    final result = await User.getAllUser();
    if (result['message'] == 'success') {
      setState(() {
        items = result['data'];
        toShowItems = items;
        _isLoading = false;
      });
    } else {
      showSnakeBar(context, result['message']);
      setState(() {
        _isLoading = false;
      });
    }
  }

  handleSearch(String value) {
    List<User> temp = items
        .where((element) =>
            element.name.toLowerCase().contains(value.toLowerCase()) ||
            element.email.toLowerCase().contains(value.toLowerCase()) ||
            element.mobile.toLowerCase().contains(value.toLowerCase()))
        .toList();
    setState(() {
      toShowItems = temp;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getAndSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Listing"),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onChanged: (value) => handleSearch(value),
                    initialValue: "",
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Search User',
                    ),
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => getAndSet(),
                    child: GridView.count(
                      crossAxisCount: 1,
                      childAspectRatio: (3.2),
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.all(8.0),
                      children:
                          toShowItems.map((data) => UserTile(data)).toList(),
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).accentColor,
        onPressed: () {
          Navigator.of(context)
              .pushNamed(RegistrationScreen.routeName, arguments: {
            'data': "",
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
