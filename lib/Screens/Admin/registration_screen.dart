import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:provider/provider.dart';
import 'package:softflow_app/Helpers/Snakebar.dart';
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

  final _items = _partyNames
      .map((party) => MultiSelectItem<PartyName>(party, party.name))
      .toList();

  final _fromStationItems = _stationNames
      .map((station) => MultiSelectItem<Station>(station, station.name))
      .toList();

  List<PartyName> _selectedPartyNames = [];
  List<Station> _selectedStationName = [];

  TextEditingController _nameController =  TextEditingController(text: "");
  TextEditingController _emailController =  TextEditingController(text: "");
  TextEditingController _mobileController =  TextEditingController(text: "");
  TextEditingController _passwordController =  TextEditingController(text: "");

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int _value = 0;
  List<int> items = [0, 1, 2, 3];
  List<Branch> _branchItems = [];
  String _selectedBranch = '1';
  bool _isLoading = false;
  bool _isWholeLoading = false;
  bool _isSupervisor = false;

  // USER IS NOT A CLASS / OBJECT HERE BUT JUST A MAP OF VALUES
  final user = {
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
    "branch" : "",
  };

  typeAccount(value) {
    switch (value) {
      case 0:
        return "Admin";
      case 1:
        return "Traffic Master";
      case 2:
        return "Supervisor";
      case 3:
        return "User Account";
    }
  }

  handleSubmit() async {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      switch (_value) {
        case 2:
          {
            _formKey.currentState!.save();
            if (_selectedStationName.length < 0 ||
                _selectedStationName.length > 3 ||
                _selectedStationName.length < 3 ||
                _selectedPartyNames.length < 0 ||
                _selectedPartyNames.length > 3 ||
                _selectedPartyNames.length < 3) {
              showSnakeBar(context,
                  "Please select 3 party and 3 stations name for Supervisor role");
              setState(() {
                _isLoading = false;
              });
              // check for proper 3 selection
              break;
            }

            // for case of supervisor
            user['type'] = _value;
            user['branch'] = _selectedBranch;
            user['acc_id'] = _selectedPartyNames[0].getId();
            user['acc_id1'] = _selectedPartyNames[1].getId();
            user['acc_id2'] = _selectedPartyNames[2].getId();

            user['station'] = _selectedStationName[0].id;
            user['station1'] = _selectedStationName[1].id;
            user['station2'] = _selectedStationName[2].id;

            final result = await User.addNewUser(user);
            if (result['message'] == 'success') {
              showSnakeBar(context, "New User added successfully");
              setState(() {
                _isLoading = false;
              });
            } else {
              showSnakeBar(context, "Error in adding new user");
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
            final result = await User.addNewUser(user);
            if (result['message'] == 'success') {
              showSnakeBar(context, "New User added successfully");
              setState(() {
                _isLoading = false;
              });
            } else {
              showSnakeBar(context, "Error in adding new user");
              setState(() {
                _isLoading = false;
              });
            }
          }
      }
    } else {
      showSnakeBar(context, "Error in adding new user");
      setState(() {
        _isLoading = false;
      });
    }
  }

  getSet() async {
    setState(() {
      _isWholeLoading = true;
    });
    final currentUser = Provider.of<MainProvider>(context).user;
    final branchResult = await Branch.getBranchItem(currentUser.co);
    final result = await currentUser.getPartyName(
        currentUser.co, currentUser.yr, '', 'A5');
    final result2 = await currentUser.getStations("");
    setState(() {
      _branchItems = branchResult['data'];
      _partyNames = result['data'] as List<PartyName>;
      _stationNames = result2['data'] as List<Station>;
      _isWholeLoading = false;
    });
  }

  @override
  void didChangeDependencies() {
    getSet();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registration"),
      ),
      body: _isWholeLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
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
                            child: Text("Select Branch",style: TextStyle(
                              fontSize: 18,
                            ),),
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
                              iconEnabledColor: Theme.of(context).accentColor,
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
                            child: Text("Select Role",style: TextStyle(
                              fontSize: 18,
                            ),),
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
                              iconEnabledColor: Theme.of(context).accentColor,
                              // isExpanded: true,
                            ),
                          ),
                        ],
                      ),
                      _isSupervisor
                          ? Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      MultiSelectBottomSheetField(
                                        initialChildSize: 0.4,
                                        listType: MultiSelectListType.LIST,
                                        searchable: true,
                                        buttonText: Text("Select 3 Parties"),
                                        title: Text("Party Names"),
                                        items: _items,
                                        onConfirm: (values) {
                                          values.forEach((element) {
                                            _selectedPartyNames
                                                .add(element as PartyName);
                                          });
                                        },
                                        chipDisplay: MultiSelectChipDisplay(
                                          textStyle:
                                              TextStyle(color: Colors.black),
                                          onTap: (value) {
                                            setState(() {
                                              _selectedPartyNames.remove(value);
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      MultiSelectBottomSheetField(
                                        initialChildSize: 0.4,
                                        listType: MultiSelectListType.LIST,
                                        searchable: true,
                                        buttonText: Text("Select 3 Stations"),
                                        title: Text("Stations Names"),
                                        items: _fromStationItems,
                                        onConfirm: (values) {
                                          if (values.length > 0) {
                                            List<Station> temp = [];
                                            values.forEach((element) {
                                              temp.add(element as Station);
                                            });
                                            setState(() {
                                              _selectedStationName = temp;
                                            });
                                          }
                                        },
                                        chipDisplay: MultiSelectChipDisplay(
                                          textStyle:
                                              TextStyle(color: Colors.black),
                                          onTap: (value) {
                                            print((value as Station).id);
                                            setState(() {
                                              _selectedPartyNames.remove(
                                                  (value as Station).id);
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )
                          : SizedBox(
                              width: 0,
                            ),
                      ElevatedButton(
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
