import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:softflow_app/Helpers/Snakebar.dart';
import 'package:softflow_app/Helpers/TextFieldHelper.dart';
import 'package:softflow_app/Helpers/captureImage.dart';
import 'package:softflow_app/Helpers/dateFormatfromDataBase.dart';
import 'package:softflow_app/Helpers/dateSelectorHelper.dart';
import 'package:softflow_app/Models/do_model.dart';
import 'package:softflow_app/Models/partyName_model.dart';
import 'package:softflow_app/Models/product_model.dart';
import 'package:softflow_app/Models/station_model.dart';
import 'package:softflow_app/Models/truck_model.dart';
import 'package:softflow_app/Models/url_model.dart';
import 'package:softflow_app/Models/user_model.dart';
import 'package:softflow_app/Providers/main_provider.dart';
import 'package:intl/intl.dart';
import '../../Helpers/AutocompleteDropdown.dart';

class DoEntryScreen extends StatefulWidget {
  static const routeName = "/do_entry_screen";
  static int count = 0;

  @override
  _DoEntryScreenState createState() => _DoEntryScreenState();
}

class _DoEntryScreenState extends State<DoEntryScreen> {
  bool _isLoading = false;
  bool _isLoadingWhole = false;
  late User considerUser;
  PartyName _selectedParty = new PartyName(id: '-1', name: '-1');
  PartyName _selectedBroker = new PartyName(id: '-1', name: '-1');
  PartyName _selectedConsignee = new PartyName(id: '-1', name: '-1');
  PartyName _selectedConsecd = new PartyName(id: '-1', name: '-1');
  Station _stationFrom = new Station(id: '-1', name: '-1');
  Station _stationTo = new Station(id: '-1', name: '-1');
  Truck _selectedTruck = new Truck(panNo: '-1', truckNo: '-1', uid: '-1');
  Product _selectedProduct = new Product(id: '-1', name: '-1');

  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  bool _enable = true;
  late DateTime _selectedDate = DateTime.now();
  late DateTime _inv_date = DateTime.now();
  late DateTime _valid_till = DateTime.now();
  TextEditingController partyController = TextEditingController(text: "");
  TextEditingController fromStationController = TextEditingController(text: "");
  TextEditingController toStationController = TextEditingController(text: "");
  TextEditingController productController = TextEditingController(text: "");
  TextEditingController consigneeController = TextEditingController(text: "");
  TextEditingController consecdController = TextEditingController(text: "");
  TextEditingController brokerController = TextEditingController(text: "");
  TextEditingController truckController = TextEditingController(text: "");
  TextEditingController _doController = TextEditingController(text: "");
  TextEditingController _qtyController = TextEditingController(text: "");

  //

  TextEditingController _grnNo1 = TextEditingController(text: "");
  TextEditingController _grnNo = TextEditingController(text: "");
  TextEditingController _invNo = TextEditingController(text: "");
  TextEditingController _ewayNo = TextEditingController(text: "");
  TextEditingController _ewayQrCode = TextEditingController(text: "");
  TextEditingController _consignerGst = TextEditingController(text: "");
  TextEditingController _drvName = TextEditingController(text: "");
  TextEditingController _drvMobile = TextEditingController(text: "");

  bool _isVehReached = false;
  bool _isVehLoading = false;

  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  _selectDate(BuildContext context, value) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(3025),
    );

    switch (value) {
      case 'do_dt':
        if (picked != null)
          setState(() {
            _selectedDate = picked;
          });
        break;
      case 'valid_till':
        if (picked != null)
          setState(() {
            _valid_till = picked;
          });
        break;
      case 'inv_date':
        if (picked != null)
          setState(() {
            _inv_date = picked;
          });
        break;
    }
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

  additionalPartyOnPressCallback() => {
        setState(() {
          _selectedParty = new PartyName(id: '-1', name: '-1');
        })
      };

  additionalConsigneeOnPressCallback() => {
        setState(() {
          _selectedConsignee = new PartyName(id: '-1', name: '-1');
        })
      };

  additionalConsecdOnPressCallback() => {
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

  additionalBrokerPartyOnPressCallback() => {
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

  additionalFromStationOnPressCallback() => {
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

  additionalToStationOnPressCallback() => {
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

  additionalTruckOnPressCallback() => {
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

  additionalProductOnPressCallback() => {
        setState(() {
          _selectedProduct = new Product(id: '-1', name: '-1');
        })
      };

  // ------------------------------------------------------------

  handleSubmit(Map<String, dynamic> received) async {
    if (_doController.value.text != '' &&
        _qtyController.value.text != '' &&
        _selectedParty.name != '-1' &&
        _selectedParty.id != '-1' &&
        _selectedConsecd.name != '-1' &&
        _selectedConsecd.id != '-1' &&
        _selectedConsignee.name != '-1' &&
        _selectedConsignee.id != '-1' &&
        _stationTo.name != '-1' &&
        _stationTo.id != '-1' &&
        _stationFrom.name != '-1' &&
        _stationFrom.id != '-1' &&
        _selectedProduct.name != '-1' &&
        _selectedProduct.id != '-1') {
      DO _madeDo = new DO(
        do_no: _doController.value.text,
        do_dt: _selectedDate.toString().split(" ")[0],
        acc_id: _selectedParty.getId(),
        consignee: _selectedConsignee.showName(),
        frmplc: _stationFrom.showName(),
        toplc: _stationTo.showName(),
        frdt: _selectedDate.toString().split(" ")[0],
        todt: _selectedDate.toString().split(" ")[0],
        itemnm: _selectedProduct.showName(),
        consrcd: _selectedConsecd.getId(),
        consecd: _selectedConsignee.getId(),
        inddt: _selectedDate.toString().split(" ")[0],
        Wt: double.parse(_qtyController.value.text),
      );
      // is user is traffic master
      if(received['isAll']){
    _madeDo.truckid = _selectedTruck.uid;
    _madeDo.broker = _selectedBroker.id;
        print(received['isAll']);
      }
      setState(() {
        _isLoading = true;
      });
      await _madeDo.getSetUid();
      Map<String, dynamic> result = await _madeDo.save();
      if (result['message'] == 'success') {
        showSnakeBar(context, "D.O saved successfully");
      }
      setState(() {
        _isLoading = false;
      });
    } else {
      showSnakeBar(context, "Please Enter all inputs");
    }
  }

  handleUpdate(DO oldDo) async {
    if (_doController.value.text != '' &&
        // TODO : add qty check
        _qtyController.value.text != '' &&
        _selectedParty.name != '-1' &&
        _selectedParty.id != '-1' &&
        _selectedConsecd.name != '-1' &&
        _selectedConsecd.id != '-1' &&
        _selectedConsignee.name != '-1' &&
        _selectedConsignee.id != '-1' &&
        _stationTo.name != '-1' &&
        _stationTo.id != '-1' &&
        _stationFrom.name != '-1' &&
        _stationFrom.id != '-1' &&
        _selectedProduct.name != '-1' &&
        _selectedProduct.id != '-1' &&
        _selectedBroker.id != '-1' &&
        _selectedTruck.getId() != '-1') {
      oldDo.do_no = _doController.value.text;
      oldDo.do_dt = _selectedDate.toString().split(" ")[0];
      oldDo.acc_id = _selectedParty.getId();
      oldDo.consignee = _selectedConsignee.showName();
      oldDo.frmplc = _stationFrom.showName();
      oldDo.toplc = _stationTo.showName();
      oldDo.frdt = _selectedDate.toString().split(" ")[0];
      oldDo.todt = _selectedDate.toString().split(" ")[0];
      oldDo.itemnm = _selectedProduct.showName();
      oldDo.consrcd = _selectedConsecd.getId();
      oldDo.consecd = _selectedConsignee.getId();
      oldDo.inddt = _selectedDate.toString().split(" ")[0];
      oldDo.broker = _selectedBroker.getId().toString();
      oldDo.truckid = _selectedTruck.getId().toString();

      setState(() {
        _isLoading = true;
      });
      Map<String, dynamic> result = await oldDo.update();
      if (result['message'] == 'success') {
        showSnakeBar(context, "D.O Updated successfully");
      }
      setState(() {
        _isLoading = false;
      });
    } else {
      showSnakeBar(context, "Please Enter all inputs");
    }
  }

  lock(receivedDo, {enable = false}) async {
    setState(() {
      _isLoadingWhole = true;
    });
    final partyList = await considerUser.getPartyName(
        considerUser.co, considerUser.yr, "", 'A5');
    final party = (partyList['data'] as List<PartyName>)
        .firstWhere((element) => element.id == receivedDo.acc_id);
    final consignee = (partyList['data'] as List<PartyName>)
        .firstWhere((element) => element.id == receivedDo.consecd);
    final consecd = (partyList['data'] as List<PartyName>)
        .firstWhere((element) => element.id == receivedDo.consrcd);
    var broker;
    if (receivedDo.broker != '-1' && receivedDo.broker != '0') {
      final brokerList = await considerUser.getPartyName(
          considerUser.co, considerUser.yr, "", 'L5');
      broker = (brokerList['data'] as List<PartyName>)
          .firstWhere((element) => element.id == receivedDo.broker);
    }
    var truck;
    if (receivedDo.truckid != '-1' && receivedDo.truckid != '0') {
      final truckList = await considerUser.getTrucks(considerUser.co, '');
      truck = (truckList['data'] as List<Truck>)
          .firstWhere((element) => element.uid == receivedDo.truckid);
    }
    setState(() {
      _isVehReached = int.parse(receivedDo.Veh_reached) < 1 ? false : true;
      _enable = enable;
      _selectedDate = dateFormatFromDataBase(receivedDo.do_dt);
      partyController = TextEditingController(text: party.showName());
      fromStationController = TextEditingController(text: receivedDo.frmplc);
      toStationController = TextEditingController(text: receivedDo.toplc);
      productController = TextEditingController(text: receivedDo.itemnm);
      consigneeController = TextEditingController(text: consignee.showName());
      consecdController = TextEditingController(text: consecd.showName());
      brokerController = TextEditingController(
          text: broker != null ? broker.showName() : "Not Set");
      truckController = TextEditingController(
          text: truck != null ? truck.truckNo : "Not Set");
      _doController = TextEditingController(text: receivedDo.do_no);
      _qtyController = TextEditingController(text: receivedDo.Wt.toString());
      //  -----------------------------------
      _selectedParty = new PartyName(id: party.id, name: party.name);
      _stationFrom = new Station(id: '010', name: receivedDo.frmplc);
      _stationTo = new Station(id: '010', name: receivedDo.toplc);
      _selectedProduct = new Product(name: receivedDo.itemnm, id: '010');
      _selectedConsignee =
          new PartyName(id: consignee.id, name: consignee.name);
      _selectedConsecd = new PartyName(id: consecd.id, name: consecd.name);
      // _selectedBroker = new PartyName(id: broker.id, name: broker.name);
      // _selectedTruck = new Truck(panNo: truck.panNo, truckNo: truck.truckNo, uid: truck.uid);
      _isLoadingWhole = false;
    });
  }

  handleVehReachedUpdate(bool value, receivedDo) async {
    setState(() {
      _isVehLoading = true;
    });
    switch (value) {
      case true:
        await (receivedDo as DO).updateIsVahReached(1, considerUser.acc_id);
        break;
      case false:
        await (receivedDo as DO).updateIsVahReached(0, 0);
        break;
    }
    setState(() {
      _isVehReached = value;
      _isVehLoading = false;
    });
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  handleUpdateFile(DO oldDo) async {
    // // Map<String, List<XFile>> files = Provider.of<MainProvider>(context, listen: false).getFile();
    // File f = await getImageFileFromAssets('images/dd.jpg');
    // final result = await User.fileUpload(considerUser.co, f);
    // showSnakeBar(context, result);
    oldDo.grn_no1 = _grnNo1.value.text;
    oldDo.GRN_NO = int.parse(_grnNo.value.text);
    oldDo.INV_no = _invNo.value.text;
    oldDo.EwayNo = _ewayNo.value.text;
    oldDo.EwayQrcode = _ewayQrCode.value.text;
    oldDo.Consignor_GST = _consignerGst.value.text;
    oldDo.drv_name = _drvName.value.text;
    oldDo.drv_mobile = _drvMobile.value.text;
    oldDo.inv_date = _inv_date.toString().split(" ")[0];
    oldDo.valid_till = _valid_till.toString().split(" ")[0];
    setState(() {
      _isLoading = true;
    });
    Map<String, dynamic> result = await oldDo.updateBySupervisor();
    if (result['message'] == 'success') {
      showSnakeBar(context, "D.O Updated successfully");
    } else {
      showSnakeBar(context, "Error in Supervisor Update");
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    DoEntryScreen.count = 0;
  }

  @override
  Widget build(BuildContext context) {
    final received =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    considerUser = Provider.of<MainProvider>(context).user;
    if (received['data'] != "" && DoEntryScreen.count == 0) {
      final receivedDo = received['data'] as DO;
      lock(receivedDo, enable: received['enable']);
      DoEntryScreen.count += 1;
    }
    return new Scaffold(
      appBar: new AppBar(
        title: received['data'] != ""
            ? new Text("D.O. - ${received['heading']}")
            : new Text("D.O. Entry"),
      ),
      body: new Container(
        child: _isLoadingWhole
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(13.0),
                child: Form(
                  child: new ListView(
                    children: [
                      additionalAutoComplete(
                        text: "Party Name : ${_selectedParty.name}",
                        onPressCallback: additionalPartyOnPressCallback,
                        name: _selectedParty,
                        autoFocus: _enable,
                        label: "Select Party Name",
                        textCallback: partyText,
                        suggestionCallback: partySuggestion,
                        stateCallback: partyState,
                        controller: partyController,
                        enable: received['data'] != ''
                            ? received['isTrafficMaster']
                                ? false
                                : true
                            : true,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFieldHelper(
                        _doController,
                        "D.O Number",
                        TextInputType.visiblePassword,
                        enable: received['isTrafficMaster'] ? false : _enable,
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
                              onPressed: _enable
                                  ? received['isTrafficMaster']
                                      ? null
                                      : () => _selectDate(context, 'do_dt')
                                  : null,
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
                        controller: fromStationController,
                        enable: received['isTrafficMaster'] ? false : _enable,
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
                        controller: toStationController,
                        enable: received['isTrafficMaster'] ? false : _enable,
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
                        controller: productController,
                        enable: received['isTrafficMaster'] ? false : _enable,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFieldHelper(
                        _qtyController,
                        "Qty in Mt.",
                        TextInputType.number,
                        enable: received['isTrafficMaster'] ? false : _enable,
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
                        controller: consigneeController,
                        enable: received['isTrafficMaster'] ? false : _enable,
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
                        controller: consecdController,
                        enable: received['isTrafficMaster'] ? false : _enable,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      received['isTrafficMaster'] || received['isAll']
                          ? additionalAutoComplete(
                              text: "Broker Name : ${_selectedBroker.name}",
                              onPressCallback:
                                  additionalBrokerPartyOnPressCallback,
                              name: _selectedBroker,
                              autoFocus: false,
                              label: "Select Broker Name",
                              textCallback: brokerPartyText,
                              suggestionCallback: brokerPartySuggestion,
                              stateCallback: brokerPartyState,
                              controller: brokerController,
                              enable: _enable,
                            )
                          : SizedBox(
                              width: 0,
                            ),
                      SizedBox(
                        height: 10,
                      ),
                      received['isTrafficMaster'] || received['isAll']
                          ? additionalAutoComplete(
                              text: "Truck Number : ${_selectedTruck.getNo()}",
                              onPressCallback: additionalTruckOnPressCallback,
                              name: _selectedTruck,
                              autoFocus: false,
                              label: "Select \"Truck\" by Number",
                              textCallback: truckText,
                              suggestionCallback: truckSuggestion,
                              stateCallback: truckState,
                              controller: truckController,
                              enable: _enable,
                            )
                          : SizedBox(
                              width: 0,
                            ),
                      received['isSupervisor']
                          ? Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                _isVehLoading
                                    ? LinearProgressIndicator()
                                    : CheckboxListTile(
                                        value: _isVehReached,
                                        title: Text("Is Vehicle Reached?"),
                                        onChanged: (value) =>
                                            handleVehReachedUpdate(
                                                value!, received['data']),
                                      ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFieldHelper(
                                  _grnNo1,
                                  "GRN NO1",
                                  TextInputType.visiblePassword,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFieldHelper(
                                  _grnNo,
                                  "GRN NO",
                                  TextInputType.visiblePassword,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFieldHelper(
                                  _invNo,
                                  "INV No",
                                  TextInputType.visiblePassword,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFieldHelper(
                                  _ewayNo,
                                  "Eway No",
                                  TextInputType.visiblePassword,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFieldHelper(
                                  _ewayQrCode,
                                  "Eway Qr code",
                                  TextInputType.visiblePassword,
                                ),
                                SizedBox(
                                  height: 10,
                                ),

                                TextFieldHelper(
                                  _consignerGst,
                                  "Consignor GST",
                                  TextInputType.visiblePassword,
                                ),
                                SizedBox(
                                  height: 10,
                                ),

                                TextFieldHelper(
                                  _drvName,
                                  "Driver Name",
                                  TextInputType.name,
                                ),
                                SizedBox(
                                  height: 10,
                                ),

                                TextFieldHelper(
                                  _drvMobile,
                                  "Driver Mobile No.",
                                  TextInputType.phone,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // ignore: unnecessary_null_comparison
                                      _inv_date != null
                                          ? FittedBox(
                                              child: Text(
                                                DateFormat.yMMMMd()
                                                    .add_jms()
                                                    .format(_inv_date)
                                                    .toString(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            )
                                          : Text(
                                              "Select Inv. Date",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 20,
                                              ),
                                            ),
                                      ElevatedButton(
                                        onPressed: () =>
                                            _selectDate(context, 'inv_date'),
                                        child: Text(
                                          'Select Inv. Date',
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // ignore: unnecessary_null_comparison
                                      _valid_till != null
                                          ? FittedBox(
                                              child: Text(
                                                DateFormat.yMMMMd()
                                                    .add_jms()
                                                    .format(_valid_till)
                                                    .toString(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            )
                                          : Text(
                                              "Valid Till",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 20,
                                              ),
                                            ),
                                      ElevatedButton(
                                        onPressed: () =>
                                            _selectDate(context, 'valid_till'),
                                        child: Text(
                                          'Valid Till',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // only when vehicle reached is tick
                                _isVehReached
                                    ? Column(
                                        children: [
                                          CaptureImage(),
                                          ElevatedButton(
                                            onPressed: () => handleUpdateFile(
                                                received['data']),
                                            child: _isLoading
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                // update by supervisor
                                                : Text("Update"),
                                          ),
                                        ],
                                      )
                                    : SizedBox(
                                        height: 0,
                                      ),
                              ],
                            )
                          : SizedBox(width: 0,),
                      SizedBox(
                        height: 10,
                      ),
                      !received['enable']
                          ? SizedBox(width: 0,)
                          : received['isTrafficMaster']
                              ? ElevatedButton(
                                  onPressed: () =>
                                      handleUpdate(received['data']),
                                  child: _isLoading
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        )
                                      : new Text("Update"),
                                )
                              : ElevatedButton(
                                  onPressed: () => handleSubmit(received),
                                  child: _isLoading
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        )
                                      : new Text("Submit"),
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
