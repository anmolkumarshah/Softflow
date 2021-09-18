import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:softflow_app/Helpers/Snakebar.dart';
import 'package:softflow_app/Helpers/shimmerLoader.dart';
import 'package:softflow_app/Helpers/typeAccountHelper.dart';
import 'package:softflow_app/Models/branch_model.dart';
import 'package:softflow_app/Models/partyName_model.dart';
import 'package:softflow_app/Models/station_model.dart';
import 'package:softflow_app/Models/user_model.dart';
import 'package:softflow_app/Providers/main_provider.dart';

class RegistrationScreen extends StatefulWidget {
  static const routeName = "/registrationScreen";

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  static List<PartyName> _partyNames = [];
  static List<Station> _stationNames = [];

  List<PartyName> _selectedPartyNames = [];
  List<Station> _selectedStationName = [];

  TextEditingController _nameController = TextEditingController(text: "");
  TextEditingController _emailController = TextEditingController(text: "");
  TextEditingController _mobileController = TextEditingController(text: "");
  TextEditingController _passwordController = TextEditingController(text: "");

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int _value = 0;
  int initCount = 0;
  bool _isEdit = false;
  bool _toChange = false;
  List<int> items = [0, 1, 2, 3];
  List<Branch> _branchItems = [];
  String _selectedBranch = '1';
  bool _isLoading = false;
  bool _isWholeLoading = false;
  bool _isSupervisor = false;

  // USER IS NOT A CLASS / OBJECT HERE BUT JUST A MAP OF VALUES
  final user = {
    "id": "",
    "name": "",
    "email": "",
    "mobile": "",
    "password": "",
    'type': 3,
    "acc_id": "-1",
    "acc_id1": "-1",
    "acc_id2": "-1",
    "station": "-1",
    "station1": "-1",
    "station2": "-1",
    "branch": "",
  };

  handleSubmit({bool isUpdate = false}) async {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      user['name'] = _nameController.value.text;
      user['email'] = _emailController.value.text;
      user['mobile'] = _mobileController.value.text;
      user['password'] = _passwordController.value.text;
      switch (_value) {
        // for supervisor user
        case 2:
          {
            _formKey.currentState!.save();
            if (_selectedStationName.length < 1 ||
                _selectedStationName.length > 3 ||
                _selectedPartyNames.length < 1 ||
                _selectedPartyNames.length > 3) {
              showSnakeBar(context,
                  "Please select at most 3 party and 3 stations name for Supervisor role");
              setState(() {
                _isLoading = false;
              });
              // check for proper 3 selection
              break;
            }

            // for case of supervisor
            user['type'] = _value;
            user['branch'] = _selectedBranch;

            if (_selectedPartyNames.length == 1) {
              user['acc_id'] = _selectedPartyNames[0].getId();
            } else if (_selectedPartyNames.length == 2) {
              user['acc_id'] = _selectedPartyNames[0].getId();
              user['acc_id1'] = _selectedPartyNames[1].getId();
            } else {
              user['acc_id'] = _selectedPartyNames[0].getId();
              user['acc_id1'] = _selectedPartyNames[1].getId();
              user['acc_id2'] = _selectedPartyNames[2].getId();
            }

            if (_selectedStationName.length == 1) {
              user['station'] = _selectedStationName[0].id;
            } else if (_selectedStationName.length == 2) {
              user['station'] = _selectedStationName[0].id;
              user['station1'] = _selectedStationName[1].id;
            } else {
              user['station'] = _selectedStationName[0].id;
              user['station1'] = _selectedStationName[1].id;
              user['station2'] = _selectedStationName[2].id;
            }

            //

            final result = await User.addNewUser(user, isUpdate: isUpdate);
            if (result['message'] == 'success') {
              showSnakeBar(context, "New User added successfully");
              Navigator.of(context).pop();
              setState(() {
                _isLoading = false;
              });
            } else {
              showSnakeBar(context, result['message']);
              setState(() {
                _isLoading = false;
              });
            }
            break;
          }
        default:
          {
            _formKey.currentState!.save();
            user['type'] = _value;
            user['branch'] = _selectedBranch;
            final result = await User.addNewUser(user, isUpdate: isUpdate);
            if (result['message'] == 'success') {
              showSnakeBar(context, "New User added successfully");
              Navigator.of(context).pop();
            } else {
              showSnakeBar(context, result['message']);
              setState(() {
                _isLoading = false;
              });
            }
          }
      }
    } else {
      showSnakeBar(context, "Error");
      setState(() {
        _isLoading = false;
      });
    }
  }

  getSet() async {
    setState(() {
      _isWholeLoading = true;
    });
    final currentUser = Provider.of<MainProvider>(context, listen: false).user;
    final branchResult = await Branch.getBranchItem(currentUser.co);
    final result =
        await PartyName.getPartyName(currentUser.co, currentUser.yr, '', 'A5');
    final result2 = await Station.getStations("");
    if (result['message'] == 'success') {
      setState(() {
        _branchItems = branchResult['data'];
        _partyNames = result['data'] as List<PartyName>;
        _stationNames = result2['data'] as List<Station>;
        _isWholeLoading = false;
      });
    } else {
      showSnakeBar(context, "Error Occured, Please Try Again");
      Navigator.of(context).pop();
    }
  }

  handleChangeStaPar() async {
    setState(() {
      _toChange = true;
    });
  }

  lock(User userItem) async {
    print("Yes");
    initCount++;
    _nameController = TextEditingController(text: userItem.name);
    _emailController = TextEditingController(text: userItem.email);
    _mobileController = TextEditingController(text: userItem.mobile);
    _passwordController = TextEditingController(text: userItem.password);
    user['id'] = userItem.id;
    List<PartyName> tempPartyList = _partyNames
        .where((element) =>
            element.id == userItem.acc_id ||
            element.id == userItem.acc_id1 ||
            element.id == userItem.acc_id2)
        .toList();
    List<Station> tempStationList = _stationNames
        .where((element) =>
            element.id == userItem.station ||
            element.id == userItem.station1 ||
            element.id == userItem.station2)
        .toList();
    setState(() {
      _isEdit = true;
      _selectedBranch = userItem.deptCd != '0' ? userItem.deptCd : '1';
      _value = userItem.deptCd1 != '-1' ? int.parse(userItem.deptCd1) : 0;
    });

    if (userItem.deptCd1 == '2') {
      setState(() {
        _isSupervisor = true;
        _selectedPartyNames = tempPartyList;
        _selectedStationName = tempStationList;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getSet();
  }

  List<Widget> _partyChoiceList() {
    List<Widget> choices = [];

    _partyNames.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          disabledColor: Theme.of(context).colorScheme.secondary,
          selectedColor: Theme.of(context).colorScheme.primary,
          labelStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          label: Text(item.name),
          selected: _selectedPartyNames.any((element) => element.id == item.id),
          onSelected: (selected) {
            setState(() {
              _selectedPartyNames.any((element) => element.id == item.id)
                  ? _selectedPartyNames
                      .removeWhere((element) => element.id == item.id)
                  : _selectedPartyNames.add(item);
            });
          },
        ),
      ));
    });
    return choices;
  }

  List<Widget> _locationChoiceList() {
    List<Widget> choices = [];
    _stationNames.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          disabledColor: Theme.of(context).colorScheme.secondary,
          selectedColor: Theme.of(context).colorScheme.primary,
          labelStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          label: Text(item.name),
          selected:
              _selectedStationName.any((element) => element.id == item.id),
          onSelected: (selected) {
            setState(() {
              _selectedStationName.any((element) => element.id == item.id)
                  ? _selectedStationName
                      .removeWhere((element) => element.id == item.id)
                  : _selectedStationName.add(item);
            });
          },
        ),
      ));
    });
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    final received =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    if (received['data'] != "" && initCount == 0) {
      lock(received['data']);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New User"),
      ),
      body: _isWholeLoading
          ? LoadingListPage()
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: _nameController,
                        onSaved: (value) {
                          user['name'] = value.toString();
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Full Name',
                            hintText: 'Enter name as Virat Kohli'),
                        validator: MultiValidator(
                          [
                            RequiredValidator(errorText: "* Required"),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: _emailController,
                        onSaved: (value) {
                          user['email'] = value.toString().trim();
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Email',
                            hintText: 'Enter valid email id as abc@gmail.com'),
                        validator: MultiValidator(
                          [
                            RequiredValidator(errorText: "* Required"),
                            EmailValidator(errorText: "Enter valid email id"),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: _mobileController,
                        onSaved: (value) {
                          user['mobile'] = value.toString();
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Mobile No.',
                            hintText: 'Enter mobile no. as 1023456789'),
                        keyboardType: TextInputType.phone,
                        validator: MultiValidator(
                          [
                            RequiredValidator(errorText: "* Required"),
                            MinLengthValidator(10,
                                errorText:
                                    'Mobile no. must be at least 10 digits long'),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                          enabled: !_isEdit,
                          controller: _passwordController,
                          onSaved: (value) {
                            user['password'] = value.toString();
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Password',
                              hintText: 'Enter secure password'),
                          validator: MultiValidator([
                            RequiredValidator(errorText: "* Required"),
                            MinLengthValidator(6,
                                errorText:
                                    "Password should be at least 6 characters"),
                            MaxLengthValidator(15,
                                errorText:
                                    "Password should not be greater than 15 characters")
                          ])
                          //validatePassword,        //Function to check validation
                          ),
                      SizedBox(
                        height: 8,
                      ),
                      // here
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text(
                              "Select Branch",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(20),
                            child: DropdownButton(
                              value: _selectedBranch,
                              items: _branchItems.map((Branch item) {
                                return DropdownMenuItem(
                                  child: Text(item.name),
                                  value: item.id,
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedBranch = value.toString();
                                });
                              },
                              hint: Text("Select Branch"),
                              elevation: 8,
                              icon: Icon(Icons.arrow_drop_down_circle),
                              iconEnabledColor:
                                  Theme.of(context).colorScheme.secondary,
                              // isExpanded: true,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text(
                              "Select Role",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(20),
                            child: DropdownButton(
                              value: _value,
                              items: items.map((int item) {
                                return DropdownMenuItem<int>(
                                  child: Text(typeAccount(item)),
                                  value: item,
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedStationName = [];
                                  _selectedPartyNames = [];
                                  if (value == 2) {
                                    _isSupervisor = true;
                                  } else {
                                    _isSupervisor = false;
                                  }
                                  _value = int.parse(value.toString());
                                });
                              },
                              hint: Text("Select User Role"),
                              elevation: 8,
                              icon: Icon(Icons.arrow_drop_down_circle),
                              iconEnabledColor:
                                  Theme.of(context).colorScheme.secondary,
                              // isExpanded: true,
                            ),
                          ),
                        ],
                      ),
                      _isSupervisor
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Text(
                                        "Select Parties",
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Wrap(
                                      children: _partyChoiceList(),
                                    )
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Text(
                                        "Select From Stations",
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Wrap(
                                      children: _locationChoiceList(),
                                    )
                                  ],
                                )
                              ],
                            )
                          : SizedBox(
                              width: 0,
                            ),
                      _isEdit
                          ? ElevatedButton(
                              onPressed: () => handleSubmit(isUpdate: true),
                              child: _isLoading
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text("Update User"),
                            )
                          : ElevatedButton(
                              onPressed: handleSubmit,
                              child: _isLoading
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text("Add New User"),
                            )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
