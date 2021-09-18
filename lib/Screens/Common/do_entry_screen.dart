import 'dart:io';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:softflow_app/Helpers/Snakebar.dart';
import 'package:softflow_app/Helpers/TextFieldHelper.dart';
import 'package:softflow_app/Helpers/captureImage.dart';
import 'package:softflow_app/Helpers/dateFormatfromDataBase.dart';
import 'package:softflow_app/Helpers/formatDate.dart';
import 'package:softflow_app/Helpers/shimmerLoader.dart';
import 'package:softflow_app/Models/branch_model.dart';
import 'package:softflow_app/Models/do_model.dart';
import 'package:softflow_app/Models/partyName_model.dart';
import 'package:softflow_app/Models/product_model.dart';
import 'package:softflow_app/Models/station_model.dart';
import 'package:softflow_app/Models/truck_model.dart';
import 'package:softflow_app/Models/user_model.dart';
import 'package:softflow_app/Providers/main_provider.dart';
import 'package:intl/intl.dart';
import 'package:softflow_app/Screens/TrafficMaster/splitTruck.dart';
import '../../Helpers/AutocompleteDropdown.dart';

class DoEntryScreen extends StatefulWidget {
  static const routeName = "/do_entry_screen";

  @override
  _DoEntryScreenState createState() => _DoEntryScreenState();
}

class _DoEntryScreenState extends State<DoEntryScreen> {
  DO toMade = new DO();
  int count = 0;
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

  TextEditingController _truckWt = TextEditingController(text: "");
  TextEditingController _rate = TextEditingController(text: "");
  TextEditingController _advance = TextEditingController(text: "");
  TextEditingController _diesel = TextEditingController(text: "");

  bool _isVehReached = false;
  bool _isVehLoading = false;

  handleSubmit(Map<String, dynamic> received) async {
    if (_doController.value.text != '' &&
        _qtyController.value.text != '' &&
        toMade.acc_id != '-1' &&
        toMade.consignee != '-1' &&
        toMade.consrcd != '-1' &&
        toMade.toplc != '-1' &&
        toMade.frmplc != '-1' &&
        toMade.itemnm != '-1' &&
        toMade.consecd != '-1') {
      toMade.do_no = _doController.value.text;
      toMade.do_dt = formateDate(_selectedDate);
      toMade.frdt = formateDate(_selectedDate);
      toMade.todt = formateDate(_selectedDate);

      toMade.inddt = formateDate(_selectedDate);
      toMade.Wt = double.parse(_qtyController.value.text);
      toMade.br_cd = considerUser.deptCd == '0' || considerUser.deptCd == '1'
          ? _selectedBranch
          : considerUser.deptCd;
      // is user is traffic master
      if (received['isAll']) {
        toMade.truckid = _selectedTruck.uid;
        toMade.broker = _selectedBroker.id;
      }
      setState(() {
        _isLoading = true;
      });
      await toMade.getSetUid();
      print(toMade.do_dt);
      Map<String, dynamic> result = await toMade.save();
      if (result['message'] == 'success') {
        showSnakeBar(context, "D.O saved successfully");
        Navigator.of(context).pop();
      }
      setState(() {
        _isLoading = false;
      });
    } else {
      showSnakeBar(context, "Please enter all inputs");
    }
  }

  handleUpdate(DO oldDo) async {
    toMade = oldDo;
    try {
      if (_doController.value.text != '' &&
          _qtyController.value.text != '' &&
          toMade.acc_id != '-1' &&
          toMade.consignee != '-1' &&
          toMade.consrcd != '-1' &&
          toMade.toplc != '-1' &&
          toMade.frmplc != '-1' &&
          toMade.itemnm != '-1' &&
          toMade.consecd != '-1') {
        toMade.do_no = _doController.value.text;
        toMade.do_dt = formateDate(_selectedDate);
        // oldDo.acc_id = _selectedParty.getId();
        // oldDo.consignee = _selectedConsignee.showName();
        // oldDo.frmplc = _stationFrom.showName();
        // oldDo.toplc = _stationTo.showName();
        toMade.frdt = formateDate(_selectedDate);
        toMade.todt = formateDate(_selectedDate);
        // oldDo.itemnm = _selectedProduct.showName();
        // oldDo.consrcd = _selectedConsecd.getId();
        // oldDo.consecd = _selectedConsignee.getId();
        toMade.inddt = formateDate(_selectedDate);
        // oldDo.broker = _selectedBroker.getId().toString();
        // oldDo.truckid = _selectedTruck.getId().toString();
        toMade.adv = double.parse(_advance.value.text);
        toMade.truck_wt = double.parse(_truckWt.value.text);
        toMade.dies = double.parse(_diesel.value.text);
        toMade.Wt = double.parse(_qtyController.value.text);
        toMade.rt = double.parse(_rate.value.text);
        setState(() {
          _isLoading = true;
        });
        Map<String, dynamic> result = await toMade.update();
        if (result['message'] == 'success') {
          showSnakeBar(context, "D.O Updated successfully");
          Navigator.of(context).pop();
        }
        setState(() {
          _isLoading = false;
        });
      } else {
        showSnakeBar(context, "Maybe you left Broker and Truck as Not Set");
      }
    } catch (e) {
      showSnakeBar(context, "e");
    }
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
    oldDo.grn_no1 = _grnNo1.value.text;
    oldDo.GRN_NO = int.parse(_grnNo.value.text);
    oldDo.INV_no = _invNo.value.text;
    oldDo.EwayNo = _ewayNo.value.text;
    oldDo.EwayQrcode = _ewayQrCode.value.text;
    oldDo.Consignor_GST = _consignerGst.value.text;
    oldDo.drv_name = _drvName.value.text;
    oldDo.drv_mobile = _drvMobile.value.text;
    oldDo.inv_date = _inv_date.toIso8601String().split('T')[0];
    oldDo.valid_till = _valid_till.toIso8601String().split('T')[0];
    setState(() {
      _isLoading = true;
    });
    Map<String, dynamic> result = await oldDo.updateBySupervisor();
    if (result['message'] == 'success') {
      showSnakeBar(context, "D.O Updated successfully");
      Navigator.of(context).pop();
    } else {
      showSnakeBar(context, "Error in Supervisor Update");
    }
    setState(() {
      _isLoading = false;
    });
  }

  List<Branch> _branchItems = [];
  List<Truck> _truckItems = [];
  List<PartyName> _brokerItems = [];
  List<PartyName> _allPartyItems = [];
  String _selectedBranch = '1';

  Future<Map<String, List<dynamic>>> getSet() async {
    final branchResult = await Branch.getBranchItem(considerUser.co);
    final brokerList = await PartyName.getPartyName(
        considerUser.co, considerUser.yr, "", 'L5');
    final partyList = await PartyName.getPartyName(
        considerUser.co, considerUser.yr, "", 'A5',
        balCd2: 'L5');

    final truckList = await Truck.getTrucks(considerUser.co, '');

    _branchItems = branchResult['data'];
    _brokerItems = brokerList['data'];
    _truckItems = truckList['data'];
    _allPartyItems = partyList['data'];

    return {
      'branchItems': _branchItems,
      'brokerItems': _brokerItems,
      'truckItems': _truckItems,
      'allPartyItems': _allPartyItems,
    };
  }

  lock(DO receivedDo, data, {enable = false}) async {
    toMade = receivedDo;
    try {
      final party = (data['allPartyItems'])
          .firstWhere((element) => element.id == receivedDo.acc_id);
      final consignee = (data['allPartyItems'])
          .firstWhere((element) => element.id == receivedDo.consecd);
      final consecd = (data['allPartyItems'])
          .firstWhere((element) => element.id == receivedDo.consrcd);

      var broker;
      var truck;
      try {
        broker = (data['brokerItems'])
            .firstWhere((element) => element.id == receivedDo.broker);
      } catch (e) {
        print("Broker " + e.toString());
      }

      try {
        truck = (data['truckItems'])
            .firstWhere((element) => element.uid == receivedDo.truckid);
      } catch (e) {
        print("Truck " + e.toString());
      }

      setState(() {
        _isVehReached = int.parse(receivedDo.Veh_reached) < 1 ? false : true;
        _enable = enable;
        _selectedBranch = receivedDo.br_cd == '0' ? '1' : receivedDo.br_cd;
        _selectedDate = dateFormatFromDataBase(receivedDo.do_dt);
        _inv_date = dateFormatFromDataBase(receivedDo.inv_date);
        _valid_till = dateFormatFromDataBase(receivedDo.valid_till);
        partyController = TextEditingController(text: party.showName());
        fromStationController = TextEditingController(text: receivedDo.frmplc);
        toStationController = TextEditingController(text: receivedDo.toplc);
        productController = TextEditingController(text: receivedDo.itemnm);
        consigneeController = TextEditingController(text: consignee.showName());
        consecdController = TextEditingController(text: consecd.showName());

        _selectedBroker =
            broker != null ? broker : PartyName(name: "NOT SET", id: '-1');
        _selectedTruck = truck != null
            ? truck
            : Truck(
                panNo: "",
                truckNo: "NOT SET",
                uid: "-1",
              );
        brokerController = TextEditingController(
            text: broker != null ? broker.showName() : "Not Set");
        truckController = TextEditingController(
            text: truck != null ? truck.truckNo : "Not Set");
        _doController = TextEditingController(text: receivedDo.do_no);
        _qtyController = TextEditingController(text: receivedDo.Wt.toString());
        _rate = TextEditingController(text: receivedDo.rt.toString());

        _advance = TextEditingController(text: receivedDo.adv.toString());
        _diesel = TextEditingController(text: receivedDo.dies.toString());
        _truckWt = TextEditingController(text: receivedDo.truck_wt.toString());

        _grnNo1 = TextEditingController(text: receivedDo.grn_no1);
        _grnNo = TextEditingController(text: receivedDo.GRN_NO.toString());
        _invNo = TextEditingController(text: receivedDo.INV_no);
        _ewayNo = TextEditingController(text: receivedDo.EwayNo);
        _ewayQrCode = TextEditingController(text: receivedDo.EwayQrcode);
        _consignerGst = TextEditingController(text: receivedDo.Consignor_GST);
        _drvName = TextEditingController(text: receivedDo.drv_name);
        _drvMobile = TextEditingController(text: receivedDo.drv_mobile);
        //  -----------------------------------
        // _selectedParty = new PartyName(id: party.id, name: party.name);
        // _stationFrom = new Station(id: '010', name: receivedDo.frmplc);
        // _stationTo = new Station(id: '010', name: receivedDo.toplc);
        // _selectedProduct = new Product(name: receivedDo.itemnm, id: '010');
        // _selectedConsignee =
        //     new PartyName(id: consignee.id, name: consignee.name);
        // _selectedConsecd = new PartyName(id: consecd.id, name: consecd.name);

        count = count + 1;
      });
    } catch (e) {
      print(e);
    }
  }

  AsyncMemoizer? _memoizer;
  _fetchData() async {
    return this._memoizer!.runOnce(() async {
      return getSet();
    });
  }

  @override
  void initState() {
    super.initState();
    _memoizer = AsyncMemoizer();
  }

  @override
  Widget build(BuildContext context) {
    final received =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    considerUser = Provider.of<MainProvider>(context, listen: false).mainUser;

    return new Scaffold(
      appBar: new AppBar(
        title: received['data'] != ""
            ? new Text(
                "D.O. - ${received['heading']}",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              )
            : new Text("D.O. Entry"),
      ),
      body: FutureBuilder(
          future: _fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingListPage();
            }
            if (snapshot.hasData && !snapshot.hasError) {
              if (received['data'] != "" && this.count < 1) {
                final receivedDo = received['data'] as DO;
                lock(receivedDo, snapshot.data, enable: received['enable']);
              }
              return Container(
                child: _isLoadingWhole
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(13.0),
                        child: Form(
                          child: new ListView(
                            children: [
                              received['isEntry']
                                  ? (considerUser.deptCd == '0' ||
                                          considerUser.deptCd == '1'
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15),
                                              child: Text(
                                                "Select Branch",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(20),
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: DropdownButton(
                                                  value: _selectedBranch,
                                                  items: _branchItems
                                                      .map((Branch item) {
                                                    return DropdownMenuItem(
                                                      child: Text(item.name),
                                                      value: item.id,
                                                    );
                                                  }).toList(),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _selectedBranch =
                                                          value.toString();
                                                    });
                                                  },

                                                  hint: Text("Select Branch"),
                                                  elevation: 8,
                                                  icon: Icon(Icons
                                                      .arrow_drop_down_circle),
                                                  iconEnabledColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                  // isExpanded: true,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Branch",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Chip(
                                                  label: Text(
                                                _branchItems
                                                    .firstWhere((element) =>
                                                        element.id ==
                                                        considerUser.deptCd)
                                                    .name,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ))
                                            ],
                                          ),
                                        ))
                                  : (received['data'] as DO).br_cd != '0'
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Branch",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Chip(
                                                label: Text(
                                                  _branchItems
                                                      .firstWhere((element) =>
                                                          element.id ==
                                                          (received['data']
                                                                  as DO)
                                                              .br_cd)
                                                      .name,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : SizedBox(
                                          height: 0,
                                        ),
                              additionalAutoComplete(
                                text: "Party Name : ${_selectedParty.name}",
                                onPressCallback: additionalPartyOnPressCallback,
                                name: _selectedParty,
                                autoFocus: false,
                                label: "Select Party Name",
                                textCallback: partyText,
                                suggestionCallback: partySuggestionConsecd,
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
                                enable: received['isTrafficMaster']
                                    ? false
                                    : _enable,
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
                                    _selectedDate != null
                                        ? FittedBox(
                                            child: Text(
                                              DateFormat.yMMMMd()
                                                  .add_jm()
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
                                              : () =>
                                                  _selectDate(context, 'do_dt')
                                          : null,
                                      child: Text(
                                        'Change D.O. Date',
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
                                text:
                                    "From Station Name : ${_stationFrom.name}",
                                onPressCallback:
                                    additionalFromStationOnPressCallback,
                                name: _stationFrom,
                                autoFocus: false,
                                label: "Select \"From Station\" Name",
                                textCallback: fromStationText,
                                suggestionCallback: fromStationSuggestion,
                                stateCallback: fromStationState,
                                controller: fromStationController,
                                enable: received['isTrafficMaster']
                                    ? false
                                    : _enable,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              additionalAutoComplete(
                                text: "To Station Name : ${_stationTo.name}",
                                onPressCallback:
                                    additionalToStationOnPressCallback,
                                name: _stationTo,
                                autoFocus: false,
                                label: "Select \"To Station\" Name",
                                textCallback: toStationText,
                                suggestionCallback: toStationSuggestion,
                                stateCallback: toStationState,
                                controller: toStationController,
                                enable: received['isTrafficMaster']
                                    ? false
                                    : _enable,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              additionalAutoComplete(
                                text: "Product : ${_selectedProduct.name}",
                                onPressCallback:
                                    additionalProductOnPressCallback,
                                name: _selectedProduct,
                                autoFocus: false,
                                label: "Select Product Name",
                                textCallback: productText,
                                suggestionCallback: productSuggestion,
                                stateCallback: productState,
                                controller: productController,
                                enable: received['isTrafficMaster']
                                    ? false
                                    : _enable,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFieldHelper(
                                _qtyController,
                                "Qty in Mt.",
                                TextInputType.number,
                                enable: received['isTrafficMaster']
                                    ? false
                                    : _enable,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              additionalAutoComplete(
                                text: "Consignee : ${_selectedConsignee.name}",
                                onPressCallback:
                                    additionalConsigneeOnPressCallback,
                                name: _selectedConsignee,
                                autoFocus: false,
                                label: "Select Consignee Name",
                                textCallback: partyText,
                                suggestionCallback: partySuggestion,
                                stateCallback: consigneeState,
                                controller: consigneeController,
                                enable: received['isTrafficMaster']
                                    ? false
                                    : _enable,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              additionalAutoComplete(
                                text: "Consigner  : ${_selectedConsecd.name}",
                                onPressCallback:
                                    additionalConsecdOnPressCallback,
                                name: _selectedConsecd,
                                autoFocus: false,
                                label: "Select Consigner Name",
                                textCallback: partyText,
                                suggestionCallback: partySuggestionConsecd,
                                stateCallback: consecdState,
                                controller: consecdController,
                                enable: received['isTrafficMaster']
                                    ? false
                                    : _enable,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              received['isTrafficMaster'] || received['isAll']
                                  ? onlyTraffic(received['isDetailTraffic'],
                                      received['data'])
                                  : SizedBox(
                                      width: 0,
                                    ),
                              received['isSupervisor']
                                  ? onlySupervisor(received, context)
                                  : SizedBox(
                                      width: 0,
                                    ),
                              SizedBox(
                                height: 10,
                              ),
                              !received['enable']
                                  ? SizedBox(
                                      width: 0,
                                    )
                                  : received['isUpdateButton']
                                      ? ElevatedButton(
                                          onPressed: () =>
                                              handleUpdate(received['data']),
                                          child: _isLoading
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Colors.white,
                                                  ),
                                                )
                                              : new Text("Update"),
                                        )
                                      : ElevatedButton(
                                          onPressed: () =>
                                              handleSubmit(received),
                                          child: _isLoading
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child:
                                                      CircularProgressIndicator(
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
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text("Error"),
              );
            }
            return Center(
              child: Text("Error Last"),
            );
          }),
    );
  }

  Column onlySupervisor(Map<String, dynamic> received, BuildContext context) {
    return Column(
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
                    handleVehReachedUpdate(value!, received['data']),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                onPressed: () => _selectDate(context, 'inv_date'),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                onPressed: () => _selectDate(context, 'valid_till'),
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
                    onPressed: () => handleUpdateFile(received['data']),
                    child: _isLoading
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(
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
    );
  }

  detailTraffic() {
    return Column(
      children: [
        TextFieldHelper(
          _truckWt,
          "Truck Weight",
          TextInputType.number,
          enable: _enable,
          noValidate: true,
        ),
        SizedBox(
          height: 10,
        ),
        TextFieldHelper(
          _rate,
          "Rate",
          TextInputType.number,
          enable: _enable,
          noValidate: true,
        ),
        SizedBox(
          height: 10,
        ),
        TextFieldHelper(
          _advance,
          "Advance",
          TextInputType.number,
          enable: _enable,
          noValidate: true,
        ),
        SizedBox(
          height: 10,
        ),
        TextFieldHelper(
          _diesel,
          "Diesel",
          TextInputType.number,
          enable: _enable,
          noValidate: true,
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  onlyTraffic(bool received, DO? data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SplitTruck(receivedDo: data)),
            );
          },
          icon: Icon(Icons.splitscreen),
          label: Text("Split This DO"),
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
          controller: truckController,
          enable: _enable,
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
          controller: brokerController,
          enable: _enable,
        ),
        SizedBox(
          height: 10,
        ),
        received
            ? detailTraffic()
            : SizedBox(
                height: 0,
              ),
      ],
    );
  }

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
    var result = await PartyName.getPartyName(
        considerUser.co, considerUser.yr, '', 'A5',
        balCd2: 'L5');
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

  partySuggestionConsecd(pattern) async {
    final result = await PartyName.getPartyName(
        considerUser.co, considerUser.yr, '', 'A5');
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

  String partyText(suggestion) {
    return (suggestion as PartyName).showName();
  }

  partyState(suggestion) {
    toMade.acc_id = (suggestion as PartyName).id;
  }

  consigneeState(suggestion) {
    toMade.consecd = (suggestion as PartyName).id;
    // ignore: unnecessary_cast
    toMade.consignee = (suggestion as PartyName).name;
    // setState(() {
    //   _selectedConsignee = suggestion as PartyName;
    // });
  }

  consecdState(suggestion) {
    toMade.consrcd = (suggestion as PartyName).id;
    // setState(() {
    //   _selectedConsecd = suggestion as PartyName;
    // });
  }

  additionalPartyOnPressCallback() {
    partyController = TextEditingController(text: "");
    toMade.acc_id = "-1";
    // setState(() {
    //   _selectedParty = new PartyName(id: '-1', name: '-1');
    // });
  }

  additionalConsigneeOnPressCallback() {
    consigneeController = TextEditingController(text: "");
    toMade.consecd = "-1";
    // ignore: unnecessary_cast
    toMade.consignee = "-1";
    // setState(() {
    //   _selectedConsignee = new PartyName(id: '-1', name: '-1');
    // });
  }

  additionalConsecdOnPressCallback() {
    consecdController = TextEditingController(text: "");
    toMade.consrcd = '-1';
    // setState(() {
    //   _selectedConsecd = new PartyName(id: '-1', name: '-1');
    // });
  }

  // ------------------------------------------------------------

  // ------------------------------------------------------

  brokerPartySuggestion(pattern) async {
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
    toMade.broker = (suggestion as PartyName).id;
  }

  additionalBrokerPartyOnPressCallback() {
    brokerController = TextEditingController(text: "");
    toMade.broker = "-1";
  }

  // ------------------------------------------------------------

  // ------------------------------------------------------

  fromStationSuggestion(pattern) async {
    var result = await Station.getStations('');
    List<Station> updatedResult = (result['data'] as List<Station>)
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

  String fromStationText(suggestion) {
    return (suggestion as Station).showName();
  }

  fromStationState(suggestion) {
    toMade.frmplc = (suggestion as Station).name;
    // setState(() {
    //   _stationFrom = suggestion as Station;
    // });
  }

  additionalFromStationOnPressCallback() {
    fromStationController = TextEditingController(text: "");
    toMade.frmplc = "-1";
    // setState(() {
    //   _stationFrom = new Station(id: '-1', name: '-1');
    // });
  }

  // ------------------------------------------------------------

  // ------------------------------------------------------

  toStationSuggestion(pattern) async {
    var result = await Station.getStations('');
    List<Station> updatedResult = (result['data'] as List<Station>)
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

  String toStationText(suggestion) {
    return (suggestion as Station).showName();
  }

  toStationState(suggestion) {
    toMade.toplc = (suggestion as Station).name;
    // setState(() {
    //   _stationTo = suggestion as Station;
    // });
  }

  additionalToStationOnPressCallback() {
    toStationController = TextEditingController(text: "");
    toMade.toplc = "-1";
    // setState(() {
    //   _stationTo = new Station(id: '-1', name: '-1');
    // });
  }

  // ------------------------------------------------------------

  // ------------------------------------------------------

  truckSuggestion(pattern) async {
    var result = await Truck.getTrucks(considerUser.co, "");
    List<Truck> updatedResult = (result['data'] as List<Truck>)
        .where((element) =>
            element.truckNo
                .toLowerCase()
                .contains(pattern.toString().toLowerCase()) ||
            element.panNo
                .toLowerCase()
                .contains(pattern.toString().toLowerCase()) ||
            element.uid
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

  String truckText(suggestion) {
    return (suggestion as Truck).getNo();
  }

  truckState(suggestion) {
    Truck data = suggestion as Truck;
    toMade.truckid = data.uid;
    try {
      final PartyName selectedBroker = _brokerItems
          .firstWhere((element) => element.name.contains(data.owner.trim()));
      setState(() {
        toMade.broker = selectedBroker.id;
        brokerController = TextEditingController(text: selectedBroker.name);
      });
    } catch (e) {
      showSnakeBar(context, "No Broker Found For This Truck Number");
    }
  }

  additionalTruckOnPressCallback() {
    truckController = TextEditingController(text: "");
    toMade.truckid = "-1";
  }

  // ------------------------------------------------------------
  // ------------------------------------------------------

  productSuggestion(pattern) async {
    var result = await Product.getProducts(considerUser.co, '');
    List<Product> updatedResult = (result['data'] as List<Product>)
        .where((element) =>
            element.name
                .toLowerCase()
                .contains(pattern.toString().toLowerCase()) ||
            element.id.toLowerCase().contains(pattern.toString().toLowerCase()))
        .toList();
    if (result['message'] == 'success') {
      return (updatedResult);
    } else {
      showSnakeBar(context, result['message']);
    }
    return ['Not Found Anything'];
  }

  String productText(suggestion) {
    return (suggestion as Product).showName();
  }

  productState(suggestion) {
    toMade.itemnm = (suggestion as Product).name;
    // setState(() {
    //   _selectedProduct = suggestion as Product;
    // });
  }

  additionalProductOnPressCallback() {
    productController = TextEditingController(text: "");
    toMade.itemnm = '-1';
    // return setState(() {
    //   _selectedProduct = new Product(id: '-1', name: '-1');
    // });
  }

  // ------------------------------------------------------------

}
