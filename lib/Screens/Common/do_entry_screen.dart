import 'dart:io';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:softflow_app/Helpers/Snakebar.dart';
import 'package:softflow_app/Helpers/TextFieldHelper.dart';
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

  TextEditingController _truckWt = TextEditingController(text: "");
  TextEditingController _rate = TextEditingController(text: "");
  TextEditingController _advance = TextEditingController(text: "");
  TextEditingController _diesel = TextEditingController(text: "");

  TextEditingController _liftingDays = TextEditingController(text: "1");

  bool _isVehReached = false;
  bool _isVehLoading = false;

  handleSubmit(Map<String, dynamic> received) async {
    if (_doController.value.text != '' &&
        _qtyController.value.text != '' &&
        toMade.acc_id != '-1' &&
        // toMade.consignee != '-1' &&
        // && toMade.consecd != '-1'
        toMade.consrcd != '-1' &&
        toMade.toplc != '-1' &&
        toMade.frmplc != '-1' &&
        toMade.itemnm != '-1') {
      toMade.do_no = _doController.value.text;
      toMade.do_dt = formateDate(_selectedDate);
      toMade.frdt = formateDate(_selectedDate);
      toMade.todt = formateDate(_selectedDate);

      toMade.inddt = formateDate(_selectedDate);
      toMade.Wt = double.parse(_qtyController.value.text);
      toMade.lefdays = int.parse(_liftingDays.value.text);
      toMade.br_cd = considerUser.deptCd == '0' || considerUser.deptCd == '1'
          ? _selectedBranch
          : considerUser.deptCd;
      // if user is traffic master
      if (received['isAll']) {
        toMade.truckid = _selectedTruck.uid;
        toMade.broker = _selectedBroker.id;
      }
      setState(() {
        _isLoading = true;
      });
      await toMade.getSetUid();
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

  handleUpdate(DO oldDo, {bool byTraff = false}) async {
    toMade = oldDo;
    try {
      if (byTraff &&
          (_selectedBroker.id == '-1' || _selectedTruck.uid == '-1')) {
        throw "Select Truck And Broker";
      }
      if (_doController.value.text != '' &&
          _qtyController.value.text != '' &&
          toMade.acc_id != '-1' &&
          // toMade.consignee != '-1' &&
          // && toMade.consecd != '-1'
          toMade.consrcd != '-1' &&
          toMade.toplc != '-1' &&
          toMade.frmplc != '-1' &&
          toMade.itemnm != '-1') {
        toMade.do_no = _doController.value.text;
        toMade.do_dt = formateDate(_selectedDate);

        toMade.frdt = formateDate(_selectedDate);
        toMade.todt = formateDate(_selectedDate);

        toMade.inddt = formateDate(_selectedDate);

        toMade.truck_wt = double.parse(_truckWt.value.text);
        toMade.dies = double.parse(_diesel.value.text);
        toMade.Wt = double.parse(_qtyController.value.text);
        toMade.rt = double.parse(_rate.value.text);
        toMade.adv_typ = _selectedAdvType!;
        toMade.advperc = double.parse(_advPer.value.text);
        toMade.rate = double.parse(_ratePMT.value.text);
        toMade.adv = double.parse(_advance.value.text);
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
      showSnakeBar(context, e.toString());
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

  checkPenalty(String dt) {
    Duration diff = DateTime.now().difference(dateFormatFromDataBase(dt));
    int days = diff.inDays;
    return 1000.0 * days;
  }

// supervisor update

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
      // final consignee = (data['allPartyItems'])
      //     .firstWhere((element) => element.id == receivedDo.consecd);
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
        // consigneeController = TextEditingController(text: consignee.showName());
        consecdController = TextEditingController(text: consecd.showName());

        _advPer = TextEditingController(text: receivedDo.advperc.toString());
        _ratePMT = TextEditingController(text: receivedDo.rate.toString());

        _liftingDays =
            TextEditingController(text: receivedDo.lefdays.toString());

        _selectedAdvType = receivedDo.adv_typ;

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
                              // TextFieldHelper(
                              //   _liftingDays,
                              //   "Lifting Days",
                              //   TextInputType.number,
                              // ),
                              // SizedBox(
                              //   height: 10,
                              // ),
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
                              // additionalAutoComplete(
                              //   text: "Consignee : ${_selectedConsignee.name}",
                              //   onPressCallback:
                              //       additionalConsigneeOnPressCallback,
                              //   name: _selectedConsignee,
                              //   autoFocus: false,
                              //   label: "Select Consignee Name",
                              //   textCallback: partyText,
                              //   suggestionCallback: partySuggestion,
                              //   stateCallback: consigneeState,
                              //   controller: consigneeController,
                              //   enable: received['isTrafficMaster']
                              //       ? false
                              //       : _enable,
                              // ),
                              // SizedBox(
                              //   height: 10,
                              // ),
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
                              received['isTrafficMaster']
                                  ? onlyTraffic(
                                      received['isDetailTraffic'],
                                      received['data'],
                                      received['isAll'],
                                    )
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
                                          onPressed: () => handleUpdate(
                                              received['data'],
                                              byTraff: !received['isAll']),
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

  detailTraffic() {
    return Column(
      children: [
        TextFieldHelper(
          _truckWt,
          "Tare Weight",
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

  TextEditingController _advPer = TextEditingController(text: "");
  TextEditingController _ratePMT = TextEditingController(text: "");
  TextEditingController _manualAdv = TextEditingController(text: "0");

  int? _selectedAdvType = 3;

  void setAdvType(val) {
    setState(() {
      _selectedAdvType = val;
    });
  }

  onlyTraffic(bool received, DO? data, bool all) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FocusScope(
          onFocusChange: (value) {
            if (!value) {
              setState(() {});
            }
          },
          child: TextFieldHelper(
            _advPer,
            "Advance %",
            TextInputType.numberWithOptions(signed: false),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        TextFieldHelper(
          _ratePMT,
          "Rate Per MT",
          TextInputType.numberWithOptions(signed: false),
        ),
        SizedBox(
          height: 10,
        ),
        (_advPer.value.text == '0' || _advPer.value.text == '0.0' || all)
            ? TextFieldHelper(
                _advance,
                "Advance",
                TextInputType.numberWithOptions(signed: false),
              )
            : SizedBox(
                height: 0,
              ),
        !all
            ? ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SplitTruck(
                              receivedDo: data,
                              advPer: _advPer.value.text == ''
                                  ? '0'
                                  : _advPer.value.text,
                              manualAdv: _manualAdv.value.text,
                              ratePMT: _ratePMT.value.text,
                            )),
                  );
                },
                icon: Icon(Icons.splitscreen),
                label: Text("Split This DO"),
              )
            : SizedBox(
                height: 0,
              ),
        SizedBox(
          height: 10,
        ),
        AdvTypeList(
          selectIndex: _selectedAdvType,
          fun: !all ? setAdvType : () {},
        ),
        SizedBox(
          height: 10,
        ),
        detailTraffic(),
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
      ],
    );
  }

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  _selectDate(BuildContext context, value) async {
    final DateTime? picked = await DatePicker.showDateTimePicker(context,
        showTitleActions: true,
        minTime: DateTime(2018, 3, 5),
        maxTime: DateTime(2019, 6, 7), onChanged: (date) {
      print('change $date');
    }, onConfirm: (date) {
      print('confirm $date');
    }, currentTime: DateTime.now(), locale: LocaleType.en);

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
    setState(() {
      _selectedBroker = suggestion;
    });
  }

  additionalBrokerPartyOnPressCallback() {
    brokerController = TextEditingController(text: "");
    toMade.broker = "-1";
    brokerController = TextEditingController(text: "");
    toMade.broker = "-1";
    setState(() {
      _selectedBroker = new PartyName(id: '-1', name: '-1');
    });
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
        _selectedBroker = selectedBroker;
        _selectedTruck = suggestion;
      });
    } catch (e) {
      showSnakeBar(context, "No Broker Found For This Truck Number");
    }
  }

  additionalTruckOnPressCallback() {
    truckController = TextEditingController(text: "");
    brokerController = TextEditingController(text: "");
    toMade.truckid = "-1";
    toMade.broker = "-1";
    setState(() {
      _selectedBroker = new PartyName(id: '-1', name: '-1');
      _selectedTruck = new Truck(panNo: '-1', truckNo: '-1', uid: '-1');
    });
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

class AdvType {
  int? value;
  String? name;

  AdvType({this.value, this.name});
}

List<AdvType> advTypeList = [
  AdvType(name: "None", value: 0),
  AdvType(name: "Cash", value: 1),
  AdvType(name: "Cheque", value: 2),
  AdvType(name: "RTGS", value: 3),
];

class AdvTypeList extends StatelessWidget {
  final int? selectIndex;
  final Function? fun;
  const AdvTypeList({
    Key? key,
    this.fun,
    this.selectIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(
          width: 0,
          color: Colors.black,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Advance Type"),
          DropdownButtonHideUnderline(
              child: DropdownButton(
            value: selectIndex!,
            items: advTypeList.map((AdvType item) {
              return DropdownMenuItem<int>(
                // onTap: () => fun!(item.value),
                child: Text(
                  item.name!,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                value: item.value,
              );
            }).toList(),
            onChanged: (value) => fun!(value),
          )),
        ],
      ),
    );
  }
}
