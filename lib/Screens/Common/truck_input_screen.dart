import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:softflow_app/Helpers/AutocompleteDropdown.dart';
import 'package:softflow_app/Helpers/Snakebar.dart';
import 'package:softflow_app/Helpers/TextFieldHelper.dart';
import 'package:softflow_app/Models/balCdModel.dart';
import 'package:softflow_app/Models/partyName_model.dart';
import 'package:softflow_app/Models/truck_model.dart';
import 'package:softflow_app/Providers/main_provider.dart';

class TruckInputScreen extends StatefulWidget {
  @override
  State<TruckInputScreen> createState() => _TruckInputScreenState();
  static const routeName = '/truck-input-screen';
}

class _TruckInputScreenState extends State<TruckInputScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _truckNo = TextEditingController(text: "");
  TextEditingController _truckNo1 = TextEditingController(text: "");
  TextEditingController _panNo = TextEditingController(text: "");
  TextEditingController _place = TextEditingController(text: "");
  TextEditingController _driver_nm = TextEditingController(text: "");
  TextEditingController _driver_mob = TextEditingController(text: "");
  TextEditingController _addr = TextEditingController(text: "");
  TextEditingController _owner = TextEditingController(text: "");

  PartyName _selectedBroker = new PartyName(id: '-1', name: '-1');
  TextEditingController brokerController = TextEditingController(text: "");

  int initCount = 0;
  bool enable = true;

  bool _isWhole = false;
  bool _isSaving = false;

  handleSave() async {
    setState(() {
      _isSaving = true;
    });
    _formKey.currentState!.save();
    final currentUser =
        Provider.of<MainProvider>(context, listen: false).mainUser;
    final resultId = await Truck.getUid();
    if (_formKey.currentState!.validate()) {
      Truck truck = new Truck(
        panNo: _panNo.value.text,
        truckNo: _truckNo.value.text,
        uid: resultId,
        truck_no1: _truckNo1.value.text,
        place: _place.value.text,
        driver_nm: _driver_nm.value.text,
        driver_mobile: _driver_mob.value.text,
        addr: _addr.value.text,
        owner: _selectedBroker.name,
      );
      final result = await truck.save(currentUser.co);
      if (result['message'] == 'success') {
        showSnakeBar(context, result['message']);
        setState(() {
          _isSaving = false;
        });
        Navigator.of(context).pop();
      } else {
        showSnakeBar(context, result['message']);
        setState(() {
          _isSaving = false;
        });
      }
    } else {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  lock(Truck truck) async {
    setState(() {
      _isWhole = true;
      initCount = initCount + 1;
    });
    _truckNo = TextEditingController(text: truck.truckNo);
    _truckNo1 = TextEditingController(text: truck.truck_no1);
    _panNo = TextEditingController(text: truck.panNo);
    _place = TextEditingController(text: truck.place);
    _driver_nm = TextEditingController(text: truck.driver_nm);
    _driver_mob = TextEditingController(text: truck.driver_mobile);
    _addr = TextEditingController(text: truck.addr);
    _owner = TextEditingController(text: truck.owner);
    final _broker = PartyName(name: truck.owner);

    setState(() {
      _isWhole = false;
      _selectedBroker = _broker;
    });
  }

  @override
  Widget build(BuildContext context) {
    final received =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    if (received['data'] != "" && initCount < 1) {
      setState(() {
        enable = received['enable'];
      });
      lock(received['data']);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("New Truck"),
      ),
      body: _isWhole
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    TextFieldHelper(
                      _truckNo,
                      "Truck Number",
                      TextInputType.visiblePassword,
                      enable: enable,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFieldHelper(
                      _truckNo1,
                      "Truck Number 1",
                      TextInputType.visiblePassword,
                      enable: enable,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    additionalAutoComplete(
                      text: "Broker Name : ${_selectedBroker.name.trim()}",
                      onPressCallback: additionalBrokerPartyOnPressCallback,
                      name: _selectedBroker,
                      autoFocus: false,
                      label: "Select Owner / Broker Name",
                      textCallback: brokerPartyText,
                      suggestionCallback: brokerPartySuggestion,
                      stateCallback: brokerPartyState,
                      controller: brokerController,
                      enable: enable,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFieldHelper(
                      _panNo,
                      "Pan Number",
                      TextInputType.visiblePassword,
                      enable: enable,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFieldHelper(
                      _place,
                      "Place Name",
                      TextInputType.name,
                      enable: enable,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFieldHelper(
                      _driver_nm,
                      "Driver Name",
                      TextInputType.name,
                      enable: enable,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFieldHelper(
                      _driver_mob,
                      "Driver Mobile Number",
                      TextInputType.phone,
                      enable: enable,
                      noValidate: true,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFieldHelper(
                      _addr,
                      "Address",
                      TextInputType.text,
                      enable: enable,
                      noValidate: true,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _isSaving
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : enable
                            ? ElevatedButton(
                                child: Text("Save Truck"),
                                onPressed: handleSave,
                              )
                            : SizedBox(
                                height: 0,
                              ),
                  ],
                ),
              ),
            ),
    );
  }

  DropdownMenuItem<BalCd> buildBalCdItem(BalCd item) => DropdownMenuItem(
        value: item,
        child: Container(
          margin: EdgeInsets.only(right: 10),
          child: Text(
            item.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );

  brokerPartySuggestion(pattern) async {
    final considerUser =
        Provider.of<MainProvider>(context, listen: false).mainUser;
    var result = await PartyName.getPartyName(
        considerUser.co, considerUser.yr, '', 'L5');
    List<PartyName> updatedResult = (result['data'] as List<PartyName>)
        .where((element) => element.name
            .toLowerCase()
            .contains(pattern.toString().toLowerCase()))
        .toList();
    if (result['message'] == 'success') {
      return (updatedResult);
    } else {
      showSnakeBar(context, result['message']);
    }
    return ['Not Found Anything'];
  }

  String brokerPartyText(suggestion) {
    return (suggestion as PartyName).showName();
  }

  brokerPartyState(suggestion) {
    final party = suggestion as PartyName;
    _panNo = TextEditingController(text: party.it_no);
    _place = TextEditingController(text: party.place);
    _addr = TextEditingController(text: party.addr);
    setState(() {
      _selectedBroker = party;
    });
  }

  additionalBrokerPartyOnPressCallback() {
    brokerController = TextEditingController(text: "");
    _panNo = TextEditingController(text: "");
    _place = TextEditingController(text: "");
    _addr = TextEditingController(text: "");
    setState(() {
      _selectedBroker = new PartyName(id: '-1', name: '-1');
    });
  }
}
