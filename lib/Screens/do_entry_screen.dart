import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:softflow_app/Helpers/Snakebar.dart';
import 'package:softflow_app/Models/do_model.dart';
import 'package:softflow_app/Models/partyName_model.dart';
import 'package:softflow_app/Models/product_model.dart';
import 'package:softflow_app/Models/station_model.dart';
import 'package:softflow_app/Models/truck_model.dart';
import 'package:softflow_app/Models/user_model.dart';
import 'package:softflow_app/Providers/main_provider.dart';
import 'package:intl/intl.dart';
import '../Helpers/AutocompleteDropdown.dart';

class DoEntryScreen extends StatefulWidget {
  static const routeName = "/do_entry_screen";

  @override
  _DoEntryScreenState createState() => _DoEntryScreenState();
}

class _DoEntryScreenState extends State<DoEntryScreen> {
  late User considerUser;
  PartyName _selectedParty = new PartyName(id: '-1', name: '-1');
  PartyName _selectedBroker = new PartyName(id: '-1', name: '-1');
  PartyName _selectedConsignee = new PartyName(id: '-1', name: '-1');
  PartyName _selectedConsecd = new PartyName(id: '-1', name: '-1');
  Station _stationFrom = new Station(id: '-1', name: '-1');
  Station _stationTo = new Station(id: '-1', name: '-1');
  Truck _selectedTruck = new Truck(panNo: '-1', truckNo: '-1', uid: '-1');
  Product _selectedProduct = new Product(id: '-1', name: '-1');
  late DateTime _selectedDate = DateTime.now();
  final _doController = TextEditingController();
  final _qtyController = TextEditingController();

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(3025),
    );
    if (picked != null)
      setState(() {
        _selectedDate = picked;
      });
  }

  // ------------------------------------------------------

  partySuggestion(pattern) async {
    final result = await considerUser.getPartyName(
        considerUser.co, considerUser.yr, pattern, 'A5');
    if (result['message'] == 'success') {
      return (result['data'] as List<PartyName>);
    } else {
      showSnakeBar(context, result['message']);
    }
    return ['Not Found Anything'];
  }

  String partyText(suggestion) {
    return (suggestion as PartyName).showName();
  }

  partyState(suggestion) {
    setState(() {
      _selectedParty = suggestion as PartyName;
    });
  }

  consigneeState(suggestion) {
    setState(() {
      _selectedConsignee = suggestion as PartyName;
    });
  }

  consecdState(suggestion) {
    setState(() {
      _selectedConsecd = suggestion as PartyName;
    });
  }

  additionalPartyOnPressCallback() =>
      {
        setState(() {
          _selectedParty = new PartyName(id: '-1', name: '-1');
        })
      };

  additionalConsigneeOnPressCallback() =>
      {
        setState(() {
          _selectedConsignee = new PartyName(id: '-1', name: '-1');
        })
      };

  additionalConsecdOnPressCallback() =>
      {
        setState(() {
          _selectedConsecd = new PartyName(id: '-1', name: '-1');
        })
      };

  // ------------------------------------------------------------

  // ------------------------------------------------------

  brokerPartySuggestion(pattern) async {
    final result = await considerUser.getPartyName(
        considerUser.co, considerUser.yr, pattern, 'L5');
    if (result['message'] == 'success') {
      return (result['data'] as List<PartyName>);
    } else {
      showSnakeBar(context, result['message']);
    }
    return ['Not Found Anything'];
  }

  String brokerPartyText(suggestion) {
    return (suggestion as PartyName).showName();
  }

  brokerPartyState(suggestion) {
    setState(() {
      _selectedBroker = suggestion as PartyName;
    });
  }

  additionalBrokerPartyOnPressCallback() =>
      {
        setState(() {
          _selectedBroker = new PartyName(id: '-1', name: '-1');
        })
      };

  // ------------------------------------------------------------

  // ------------------------------------------------------

  fromStationSuggestion(pattern) async {
    final result = await considerUser.getStations(pattern);
    if (result['message'] == 'success') {
      return (result['data'] as List<Station>);
    } else {
      showSnakeBar(context, result['message']);
    }
    return ['Not Found Anything'];
  }

  String fromStationText(suggestion) {
    return (suggestion as Station).showName();
  }

  fromStationState(suggestion) {
    print(suggestion.name);
    setState(() {
      _stationFrom = suggestion as Station;
    });
  }

  additionalFromStationOnPressCallback() =>
      {
        setState(() {
          _stationFrom = new Station(id: '-1', name: '-1');
        })
      };

  // ------------------------------------------------------------

  // ------------------------------------------------------

  toStationSuggestion(pattern) async {
    final result = await considerUser.getStations(pattern);
    if (result['message'] == 'success') {
      return (result['data'] as List<Station>);
    } else {
      showSnakeBar(context, result['message']);
    }
    return ['Not Found Anything'];
  }

  String toStationText(suggestion) {
    return (suggestion as Station).showName();
  }

  toStationState(suggestion) {
    setState(() {
      _stationTo = suggestion as Station;
    });
  }

  additionalToStationOnPressCallback() =>
      {
        setState(() {
          _stationTo = new Station(id: '-1', name: '-1');
        })
      };

  // ------------------------------------------------------------

  // ------------------------------------------------------

  truckSuggestion(pattern) async {
    final result = await considerUser.getTrucks(considerUser.co, pattern);
    if (result['message'] == 'success') {
      return (result['data'] as List<Truck>);
    } else {
      showSnakeBar(context, result['message']);
    }
    return ['Not Found Anything'];
  }

  String truckText(suggestion) {
    return (suggestion as Truck).getNo();
  }

  truckState(suggestion) {
    setState(() {
      _selectedTruck = suggestion as Truck;
    });
  }

  additionalTruckOnPressCallback() =>
      {
        setState(() {
          _selectedTruck = new Truck(panNo: '-1', truckNo: '-1', uid: '-1');
        })
      };

  // ------------------------------------------------------------
  // ------------------------------------------------------

  productSuggestion(pattern) async {
    final result = await considerUser.getProducts(considerUser.co, pattern);
    if (result['message'] == 'success') {
      return (result['data'] as List<Product>);
    } else {
      showSnakeBar(context, result['message']);
    }
    return ['Not Found Anything'];
  }

  String productText(suggestion) {
    return (suggestion as Product).showName();
  }

  productState(suggestion) {
    setState(() {
      _selectedProduct = suggestion as Product;
    });
  }

  additionalProductOnPressCallback() =>
      {
        setState(() {
          _selectedProduct = new Product(id: '-1', name: '-1');
        })
      };

  // ------------------------------------------------------------

  handleSubmit() {
    if (_doController.value.text != '' &&
        _qtyController.value.text != '' &&
        _selectedParty != PartyName(name: '-1', id: '-1') &&
        _selectedConsecd != PartyName(name: '-1', id: '-1') &&
        _selectedConsignee != PartyName(name: '-1', id: '-1') &&
        _stationTo != Station(name: '-1', id: '-1') &&
        _stationFrom != Station(name: '-1', id: '-1') &&
        _selectedProduct != Product(name: '-1', id: '-1') &&
        _selectedTruck != Truck(panNo: '-1', truckNo: '-1', uid: '-1') &&
        _selectedBroker != PartyName(name: '-1', id: '-1')) {

      DO _madeDo = new DO(product: _selectedProduct,
          dateTime: _selectedDate,
          broker: _selectedBroker,
          consecd: _selectedConsecd,
          consignee: _selectedConsignee,
          doNumber: _doController.value.text,
          fromStation: _stationFrom,
          party: _selectedParty,
          quantity: _qtyController.value.text,
          toStation: _stationTo,
          truck: _selectedTruck);

      _madeDo.display();
    } else {
      showSnakeBar(context, "Please Enter all inputs");
    }
  }

  @override
  Widget build(BuildContext context) {
    considerUser = Provider
        .of<MainProvider>(context)
        .user;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("D.O. Entry"),
      ),
      body: new Container(
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Form(
            child: new ListView(
              children: [
                additionalAutoComplete(
                  text: "Party Name : ${_selectedParty.name}",
                  onPressCallback: additionalPartyOnPressCallback,
                  name: _selectedParty,
                  autoFocus: true,
                  label: "Select Party Name",
                  textCallback: partyText,
                  suggestionCallback: partySuggestion,
                  stateCallback: partyState,
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _doController,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    labelText: "D.O Number",
                    labelStyle: TextStyle(
                      fontSize: 20,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      width: 1,
                      color: Colors.grey,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // ignore: unnecessary_null_comparison
                      _selectedDate != null
                          ? FittedBox(
                        child: Text(
                          DateFormat.yMMMMd()
                              .add_jms()
                              .format(_selectedDate)
                              .toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                          : Text(
                        "Select D.O. Date",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _selectDate(context),
                        child: Text(
                          'Change date',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                additionalAutoComplete(
                  text: "From Station Name : ${_stationFrom.name}",
                  onPressCallback: additionalFromStationOnPressCallback,
                  name: _stationFrom,
                  autoFocus: false,
                  label: "Select \"From Station\" Name",
                  textCallback: fromStationText,
                  suggestionCallback: fromStationSuggestion,
                  stateCallback: fromStationState,
                ),
                SizedBox(
                  height: 10,
                ),
                additionalAutoComplete(
                  text: "To Station Name : ${_stationTo.name}",
                  onPressCallback: additionalToStationOnPressCallback,
                  name: _stationTo,
                  autoFocus: false,
                  label: "Select \"To Station\" Name",
                  textCallback: toStationText,
                  suggestionCallback: toStationSuggestion,
                  stateCallback: toStationState,
                ),
                SizedBox(
                  height: 10,
                ),
                additionalAutoComplete(
                  text: "Product : ${_selectedProduct.name}",
                  onPressCallback: additionalProductOnPressCallback,
                  name: _selectedProduct,
                  autoFocus: false,
                  label: "Select Product Name",
                  textCallback: productText,
                  suggestionCallback: productSuggestion,
                  stateCallback: productState,
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _qtyController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Qty in Mt.",
                    labelStyle: TextStyle(
                      fontSize: 20,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                additionalAutoComplete(
                  text: "Consignee : ${_selectedConsignee.name}",
                  onPressCallback: additionalConsigneeOnPressCallback,
                  name: _selectedConsignee,
                  autoFocus: false,
                  label: "Select Consignee Name",
                  textCallback: partyText,
                  suggestionCallback: partySuggestion,
                  stateCallback: consigneeState,
                ),
                SizedBox(
                  height: 10,
                ),
                additionalAutoComplete(
                  text: "Consecd  : ${_selectedConsecd.name}",
                  onPressCallback: additionalConsecdOnPressCallback,
                  name: _selectedConsecd,
                  autoFocus: false,
                  label: "Select Consecd Name",
                  textCallback: partyText,
                  suggestionCallback: partySuggestion,
                  stateCallback: consecdState,
                ),
                SizedBox(
                  height: 10,
                ),
                additionalAutoComplete(
                  text: "Broker Name : ${_selectedBroker.name}",
                  onPressCallback: additionalBrokerPartyOnPressCallback,
                  name: _selectedBroker,
                  autoFocus: false,
                  label: "Select Broker Name",
                  textCallback: brokerPartyText,
                  suggestionCallback: brokerPartySuggestion,
                  stateCallback: brokerPartyState,
                ),
                SizedBox(
                  height: 10,
                ),
                additionalAutoComplete(
                  text: "Truck Number : ${_selectedTruck.getNo()}",
                  onPressCallback: additionalTruckOnPressCallback,
                  name: _selectedTruck,
                  autoFocus: false,
                  label: "Select \"Truck\" by Number",
                  textCallback: truckText,
                  suggestionCallback: truckSuggestion,
                  stateCallback: truckState,
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: handleSubmit,
                  child: new Text("Submit"),
                ),
                SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
