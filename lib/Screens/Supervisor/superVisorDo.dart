import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:softflow_app/Helpers/Snakebar.dart';
import 'package:softflow_app/Helpers/TextFieldHelper.dart';
import 'package:softflow_app/Helpers/captureImage.dart';
import 'package:softflow_app/Helpers/dateFormatfromDataBase.dart';
import 'package:softflow_app/Helpers/formatDate.dart';
import 'package:softflow_app/Models/branch_model.dart';
import 'package:softflow_app/Models/do_model.dart';
import 'package:softflow_app/Models/partyName_model.dart';
import 'package:softflow_app/Models/product_model.dart';
import 'package:softflow_app/Models/station_model.dart';
import 'package:softflow_app/Models/truck_model.dart';
import 'package:softflow_app/Providers/main_provider.dart';
import 'package:async/async.dart';

// ignore: must_be_immutable
class SuperVisorDo extends StatefulWidget {
  DO? receivedDo;
  List<Branch> _branchItems = [];
  List<Truck> _truckItems = [];
  List<PartyName> _brokerItems = [];
  List<PartyName> _allPartyItems = [];
  List<Product> _productItems = [];
  List<Station> _stationItems = [];
  SuperVisorDo({Key? key, this.receivedDo}) : super(key: key);

  @override
  _SuperVisorDoState createState() => _SuperVisorDoState();
}

class _SuperVisorDoState extends State<SuperVisorDo> {
  Future getSet() async {
    var considerUser =
        Provider.of<MainProvider>(context, listen: false).mainUser;

    final branchResult = await Branch.getBranchItem(considerUser.co);

    final brokerList = await PartyName.getPartyName(
        considerUser.co, considerUser.yr, "", 'L5');

    final partyList = await PartyName.getPartyName(
        considerUser.co, considerUser.yr, "", 'A5',
        balCd2: 'L5');

    final truckList = await Truck.getTrucks(considerUser.co, '');
    final stationList = await Station.getStations('');
    final productList = await Product.getProducts(considerUser.co, '');

    widget._branchItems = branchResult['data'];
    widget._brokerItems = brokerList['data'];
    widget._truckItems = truckList['data'];
    widget._allPartyItems = partyList['data'];
    widget._stationItems = stationList['data'];
    widget._productItems = productList['data'];

    setState(() {
      _actualWt =
          TextEditingController(text: widget.receivedDo!.actwt.toString());
      _rate = TextEditingController(text: widget.receivedDo!.rate.toString());
      _freight = TextEditingController(text: widget.receivedDo!.frt.toString());
      _diesel = TextEditingController(text: widget.receivedDo!.dies.toString());
      _advPer =
          TextEditingController(text: widget.receivedDo!.advperc.toString());
      _advAmt = TextEditingController(text: widget.receivedDo!.adv.toString());

      _grnNo1 = TextEditingController(text: widget.receivedDo!.grn_no1);
      _grnNo =
          TextEditingController(text: widget.receivedDo!.GRN_NO.toString());
      _invNo = TextEditingController(text: widget.receivedDo!.INV_no);
      _ewayNo = TextEditingController(text: widget.receivedDo!.EwayNo);
      _ewayQrCode = TextEditingController(text: widget.receivedDo!.EwayQrcode);
      _consignerGst =
          TextEditingController(text: widget.receivedDo!.Consignor_GST);
      _drvName = TextEditingController(text: widget.receivedDo!.drv_name);
      _drvMobile = TextEditingController(text: widget.receivedDo!.drv_mobile);
      _penalty = TextEditingController(
          text: widget.receivedDo!.penalty > 0
              ? widget.receivedDo!.penalty.toString()
              : checkPenalty(widget.receivedDo!.do_dt).toString());

      _selectedDate = dateFormatFromDataBase(widget.receivedDo!.do_dt);
      _inv_date = dateFormatFromDataBase(widget.receivedDo!.inv_date);
      _valid_till = dateFormatFromDataBase(widget.receivedDo!.valid_till);

      _selectedAdvType = widget.receivedDo!.adv_typ;

      _bal = TextEditingController(
          text: (double.parse(_freight.value.text) -
                  double.parse(_advAmt.value.text))
              .toString());
    });
  }

  checkPenalty(String dt) {
    Duration diff = DateTime.now().difference(dateFormatFromDataBase(dt));
    int days = diff.inDays;
    var p = 1000.0 * days;
    return p;
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

  TextEditingController _actualWt = TextEditingController(text: "");
  TextEditingController _rate = TextEditingController(text: "");
  TextEditingController _freight = TextEditingController(text: "");
  TextEditingController _diesel = TextEditingController(text: "");
  TextEditingController _advPer = TextEditingController(text: "");
  TextEditingController _advAmt = TextEditingController(text: "");

  TextEditingController _bal = TextEditingController(text: "");

  TextEditingController _grnNo1 = TextEditingController(text: "");
  TextEditingController _grnNo = TextEditingController(text: "");
  TextEditingController _invNo = TextEditingController(text: "");
  TextEditingController _ewayNo = TextEditingController(text: "");
  TextEditingController _ewayQrCode = TextEditingController(text: "");
  TextEditingController _consignerGst = TextEditingController(text: "");
  TextEditingController _drvName = TextEditingController(text: "");
  TextEditingController _drvMobile = TextEditingController(text: "");
  TextEditingController _penalty = TextEditingController(text: "");

  int? _selectedAdvType = 0;
  bool? show = false;
  void setAdvType(val) {
    setState(() {
      _selectedAdvType = val;
    });
  }

  late DateTime _inv_date = DateTime.now();
  late DateTime _valid_till = DateTime.now();
  late DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  handleDispatchedVehicle(bool value, receivedDo) async {
    final cu = Provider.of<MainProvider>(context, listen: false).mainUser;
    setState(() {
      _isLoading = true;
    });
    switch (value) {
      case true:
        await (receivedDo as DO).dispatchVehicle(1, cu.id);
        break;
      case false:
        await (receivedDo as DO).dispatchVehicle(0, 0);
        break;
    }

    Navigator.pop(context);

    setState(() {
      // _isVehDispatched = value;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receivedDo!.do_no),
      ),
      body: FutureBuilder(
        future: _fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            children: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      show = !show!;
                    });
                  },
                  child: Text(show == true ? "Hide" : "Show All")),
              show == true
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Item(
                          label: "Branch",
                          data: widget._branchItems
                              .firstWhere((element) =>
                                  element.id == (widget.receivedDo)!.br_cd)
                              .name,
                        ),
                        Item(
                          label: "Party Name",
                          data: widget._allPartyItems
                              .firstWhere((element) =>
                                  element.id == (widget.receivedDo)!.acc_id)
                              .name,
                        ),
                        Item(
                          label: "D.O. Number",
                          data: widget.receivedDo!.do_no,
                        ),
                        Item(
                          label: "D.O. date",
                          data: formateDate(
                              dateFormatFromDataBase(widget.receivedDo!.do_dt)),
                        ),
                        Item(
                          label: "From Station",
                          data: widget._stationItems
                              .firstWhere((element) =>
                                  element.name == (widget.receivedDo)!.frmplc)
                              .name,
                        ),
                        Item(
                          label: "To Station",
                          data: widget._stationItems
                              .firstWhere((element) =>
                                  element.name == (widget.receivedDo)!.toplc)
                              .name,
                        ),
                        Item(
                          label: "Product Name",
                          data: widget._productItems
                              .firstWhere((element) =>
                                  element.name == (widget.receivedDo)!.itemnm)
                              .name,
                        ),
                        // Item(
                        //   label: "Consignee Name",
                        //   data: widget._allPartyItems
                        //       .firstWhere((element) =>
                        //           element.id == (widget.receivedDo)!.consecd)
                        //       .name,
                        // ),
                        Item(
                          label: "Consigner Name",
                          data: widget._allPartyItems
                              .firstWhere((element) =>
                                  element.id == (widget.receivedDo)!.consrcd)
                              .name,
                        ),
                        Item(
                          label: "Broker Name",
                          data: widget._brokerItems
                              .firstWhere((element) =>
                                  element.id == (widget.receivedDo)!.broker)
                              .name,
                        ),
                        Item(
                          label: "Truck No.",
                          data: widget._truckItems
                              .firstWhere((element) =>
                                  element.uid == (widget.receivedDo)!.truckid)
                              .truckNo,
                        ),
                      ],
                    )
                  : SizedBox(
                      height: 0,
                    ),
              Divider(
                color: Colors.black,
              ),
              Item(
                label: "Net Weight",
                data: widget.receivedDo!.Wt.toString(),
              ),
              Item(
                label: "Tare Weight",
                data: widget.receivedDo!.truck_wt.toString(),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    // act wt
                    FocusScope(
                      onFocusChange: (value) {
                        if (!value) {
                          double advPer = double.parse(_advPer.value.text);
                          double frt = double.parse(_actualWt.value.text) *
                              double.parse(_rate.value.text);
                          double? adv = double.parse(_advAmt.value.text);
                          double? bal;
                          print(advPer);
                          if (advPer != 0) {
                            var temp = frt - double.parse(_diesel.value.text);
                            adv = (advPer / 100) * temp;
                          }
                          bal = frt - adv;
                          setState(() {
                            _freight =
                                TextEditingController(text: frt.toString());
                            _advAmt =
                                TextEditingController(text: adv.toString());
                            _bal = TextEditingController(text: bal.toString());
                          });
                        }
                      },
                      child: TextFieldHelper(
                        _actualWt,
                        "Actual Weight",
                        TextInputType.number,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FocusScope(
                      onFocusChange: (value) {
                        if (!value) {
                          double advPer = double.parse(_advPer.value.text);
                          double frt = double.parse(_actualWt.value.text) *
                              double.parse(_rate.value.text);
                          double? adv;
                          double? bal;
                          if (advPer != 0) {
                            var temp = frt - double.parse(_diesel.value.text);
                            adv = (advPer / 100) * temp;
                            bal = frt - adv;
                          }
                          setState(() {
                            _rate = TextEditingController(
                                text: _rate.value.text.toString());
                            _freight =
                                TextEditingController(text: frt.toString());
                            _advAmt =
                                TextEditingController(text: adv.toString());
                            _bal = TextEditingController(text: bal.toString());
                          });
                        }
                      },
                      child: TextFieldHelper(
                        _rate,
                        "Rate",
                        TextInputType.number,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FocusScope(
                      onFocusChange: (value) {
                        if (!value) {
                          double advPer = double.parse(_advPer.value.text);
                          double frt = double.parse(_actualWt.value.text) *
                              double.parse(_rate.value.text);
                          double? adv;
                          double? bal;
                          if (advPer != 0) {
                            var temp = frt - double.parse(_diesel.value.text);
                            adv = (advPer / 100) * temp;
                            bal = frt - adv;
                          }
                          setState(() {
                            _freight =
                                TextEditingController(text: frt.toString());
                            _advAmt =
                                TextEditingController(text: adv.toString());
                            _bal = TextEditingController(text: bal.toString());
                          });
                        }
                      },
                      child: TextFieldHelper(
                        _advPer,
                        "Advance %",
                        TextInputType.number,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    AdvTypeList(
                      selectIndex: _selectedAdvType,
                      fun: (s) {},
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFieldHelper(
                      _advAmt,
                      "Advance Amount",
                      TextInputType.number,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFieldHelper(
                      _diesel,
                      "Diesel",
                      TextInputType.number,
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    FocusScope(
                      onFocusChange: (value) {
                        if (!value) {
                          setState(() {
                            _freight = TextEditingController(
                                text: _freight.value.text.toString());
                          });
                        }
                      },
                      child: TextFieldHelper(
                        _freight,
                        "Freight",
                        TextInputType.number,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    TextFieldHelper(
                      _bal,
                      "Balance",
                      TextInputType.number,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      leading: Text(
                        "Penalty",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      trailing: Text(
                        "${_penalty.value.text.toString()}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      tileColor: Colors.red,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      color: Colors.black,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFieldHelper(
                      _grnNo1,
                      "GRN NO1",
                      TextInputType.text,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFieldHelper(
                      _grnNo,
                      "GRN NO",
                      TextInputType.number,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFieldHelper(
                      _invNo,
                      "INV No",
                      TextInputType.number,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFieldHelper(
                      _ewayNo,
                      "Eway No",
                      TextInputType.number,
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
                    Divider(
                      color: Colors.black,
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
                          TextButton(
                            onPressed: () => _selectDate(context, 'inv_date'),
                            child: Text(
                              'Select Inv. Date',
                              style: TextStyle(
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
                          TextButton(
                            onPressed: () => _selectDate(context, 'valid_till'),
                            child: Text(
                              'Valid Till',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // only when vehicle reached is tick

                    Column(
                      children: [
                        CaptureImage(),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  handleDispatchedVehicle(
                                      true, widget.receivedDo);
                                },
                                child: Text("Done")),
                            SizedBox(
                              width: 20,
                            ),
                            ElevatedButton(
                              onPressed: () =>
                                  handleUpdateFile(widget.receivedDo!),
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
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
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

    oldDo.frt = double.parse(_freight.value.text);
    oldDo.adv = double.parse(_advAmt.value.text);
    oldDo.actwt = double.parse(_actualWt.value.text);
    oldDo.rt = double.parse(_rate.value.text);
    oldDo.rate = double.parse(_rate.value.text);
    oldDo.advperc = double.parse(_advPer.value.text);
    oldDo.dies = double.parse(_diesel.value.text);
    oldDo.penalty = double.parse(_penalty.value.text);
    setState(() {
      _isLoading = true;
    });
    Map<String, dynamic> result = await oldDo.updateBySupervisor();
    if (result['message'] == 'success') {
      showSnakeBar(context, "D.O Updated successfully");
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      showSnakeBar(context, "Error in Supervisor Update");
    }
    setState(() {
      _isLoading = false;
    });
  }
}

class Item extends StatelessWidget {
  const Item({
    Key? key,
    required this.label,
    required this.data,
  }) : super(key: key);

  final String label;
  final String data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Chip(
            label: Text(
              data,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
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
