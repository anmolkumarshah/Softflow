import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:provider/provider.dart';
import 'package:softflow_app/Helpers/AutocompleteDropdown.dart';
import 'package:softflow_app/Helpers/Snakebar.dart';
import 'package:softflow_app/Helpers/TextFieldHelper.dart';
import 'package:softflow_app/Models/do_model.dart';
import 'package:softflow_app/Models/partyName_model.dart';
import 'package:softflow_app/Models/truck_model.dart';
import 'package:softflow_app/Models/user_model.dart';
import 'package:softflow_app/Providers/main_provider.dart';
import 'package:softflow_app/Screens/TrafficMaster/traffic_master_do_screen.dart';

// ignore: must_be_immutable
class SplitTruck extends StatefulWidget {
  DO? receivedDo;
  double? actualWt;
  double? splitableWt;
  List<Split> list = [];
  bool? loading = false;
  SplitTruck({Key? key, this.receivedDo}) {
    this.receivedDo = receivedDo;
    this.actualWt = receivedDo!.Wt;
    this.splitableWt = this.actualWt;
  }
  @override
  State<SplitTruck> createState() => _SplitTruckState();
}

class _SplitTruckState extends State<SplitTruck> {
  @override
  Widget build(BuildContext context) {
    final User currentUser =
        Provider.of<MainProvider>(context, listen: false).mainUser;

    void changeSplitWt(double wt) {
      if (wt > widget.splitableWt!)
        throw "Split Quantity Cannot Be More Than ${widget.splitableWt.toString()}";
      widget.splitableWt = (widget.splitableWt! - wt);
      setState(() {});
    }

    void addSplit(List<Split> list) {
      widget.list = list;
      setState(() {});
    }

    Future assignUId(List<DO> splitedDO) async {
      print("assign - start");
      for (DO item in splitedDO) {
        await item.getSetUid();
      }
      print("assign - end");
    }

    Future saveSplit(List<DO> splitedDO) async {
      print("save - start");
      for (DO item in splitedDO) {
        await item.save();
      }
      print("save - end");
    }

    handleSplitAdd() async {
      if (widget.list.length < 1) {
        showSnakeBar(context, "Atleast One Split Must Be Done");
        return;
      }
      widget.loading = true;
      setState(() {});
      try {
        List<DO> splitedDO = widget.list.map((e) {
          DO partDO = widget.receivedDo!.clone(new DO());
          partDO.Wt = e.qty!;
          partDO.truckid = e.truck!.uid;
          partDO.broker = e.broker!.id;
          return partDO;
        }).toList();
        await assignUId(splitedDO);
        await saveSplit(splitedDO);
        await widget.receivedDo!.update(q: '''
          update domast
          set
          Wt = ${widget.splitableWt!}
          where uid = '${widget.receivedDo!.uid}'
        ''');
        showSnakeBar(context, "DO Splited Successfully");
        Navigator.popUntil(
            context, ModalRoute.withName('/traffic_master_do_screen'));
      } catch (e) {
        showSnakeBar(context, e.toString());
        widget.loading = false;
        setState(() {});
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Truck - ${widget.receivedDo!.do_no}"),
        actions: [
          IconButton(onPressed: handleSplitAdd, icon: Icon(Icons.save))
        ],
      ),
      body: widget.loading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text("Actual Weight"),
                        trailing: Text("${widget.actualWt}"),
                      ),
                      ListTile(
                        title: Text("Splitable Weight Left"),
                        trailing: Text("${widget.splitableWt}"),
                      ),
                    ],
                  ),
                  elevation: 8,
                  shadowColor: Colors.green,
                  margin: EdgeInsets.all(20),
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.green, width: 1)),
                ),
                Expanded(
                  child: OpenModel(
                    considerUser: currentUser,
                    context: context,
                    handleSplit: changeSplitWt,
                    handleAdd: addSplit,
                  ),
                  flex: 2,
                ),
              ],
            ),
    );
  }
}

class OpenModel extends StatefulWidget {
  final BuildContext? context;
  final User? considerUser;
  final Function? handleSplit;
  final Function? handleAdd;
  static const int count = 0;
  const OpenModel({
    Key? key,
    this.context,
    this.considerUser,
    this.handleSplit,
    this.handleAdd,
  }) : super(key: key);

  @override
  State<OpenModel> createState() => _OpenModelState();
}

class Split {
  final PartyName? broker;
  final Truck? truck;
  final double? qty;
  Split({this.broker, this.qty, this.truck});
}

class _OpenModelState extends State<OpenModel> {
  AsyncMemoizer? _memoizer;
  List<PartyName> _brokerItems = [];
  List<Truck> _truckItems = [];
  PartyName? _selectedBroker = new PartyName(name: '-1', id: '-1');
  Truck? _selectedTruck = new Truck(panNo: '-1', truckNo: '-1', uid: '-1');
  TextEditingController truckController = TextEditingController(text: "");
  TextEditingController brokerController = TextEditingController(text: "");
  TextEditingController _splitQty = TextEditingController(text: "0");
  List<Split> list = [];

  brokerPartySuggestion(pattern) async {
    List<PartyName> updatedBroResult = _brokerItems
        .where((element) => element.name
            .toLowerCase()
            .contains(pattern.toString().toLowerCase()))
        .toList();
    if (updatedBroResult.isNotEmpty) {
      return (updatedBroResult);
    } else {
      showSnakeBar(context, "Error Occured While Fetching Broker Names");
    }
    return ['Not Found Anything'];
  }

  String brokerPartyText(suggestion) {
    return (suggestion as PartyName).showName();
  }

  brokerPartyState(suggestion) {
    setState(() {
      _selectedBroker = (suggestion as PartyName);
    });
  }

  additionalBrokerPartyOnPressCallback() {
    setState(() {
      _selectedBroker = PartyName(name: '-1', id: '-1');
      brokerController = TextEditingController(text: "");
      _splitQty = TextEditingController(text: "");
    });
  }

  truckSuggestion(pattern) async {
    print("One");
    List<Truck> updatedResult = _truckItems
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

    if (updatedResult.isNotEmpty) {
      return (updatedResult);
    } else {
      showSnakeBar(context, "Error in Fetching Trucks");
    }
    return ['Not Found Anything'];
  }

  String truckText(suggestion) {
    return (suggestion as Truck).getNo();
  }

  truckState(suggestion) {
    print(suggestion);
    PartyName selectedBroker = new PartyName(name: '-1', id: '-1');
    try {
      selectedBroker = _brokerItems.firstWhere((element) =>
          element.name.contains((suggestion as Truck).owner.trim()));
    } catch (e) {
      showSnakeBar(context, "No Broker Found For This Truck Number");
    }
    setState(() {
      _selectedTruck = suggestion as Truck;
      _selectedBroker = selectedBroker;
    });
    // toMade.truckid = data.uid;
  }

  additionalTruckOnPressCallback() {
    setState(() {
      _selectedTruck = Truck(panNo: '-1', truckNo: '-1', uid: '-1');
      truckController = TextEditingController(text: "");
    });
  }

  Future getSet() async {
    print("getSet");
    final partyList = await PartyName.getPartyName(
        widget.considerUser!.co, widget.considerUser!.yr, "", 'A5',
        balCd2: 'L5');

    final truckList = await Truck.getTrucks(widget.considerUser!.co, '');

    setState(() {
      _brokerItems = partyList['data'];
      _truckItems = truckList['data'];
    });
  }

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

  handleAdd() {
    try {
      final double qty = double.parse(_splitQty.value.text);
      if (_selectedBroker!.id != '-1' &&
          _selectedTruck!.uid != '-1' &&
          qty != 0) {
        Split sp =
            new Split(broker: _selectedBroker, truck: _selectedTruck, qty: qty);
        widget.handleSplit!(qty);
        list.add(sp);
        widget.handleAdd!(list);
        additionalTruckOnPressCallback();
        additionalBrokerPartyOnPressCallback();
      } else {
        showSnakeBar(context, "Select Truck First");
      }
    } catch (e) {
      showSnakeBar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Chip(label: Text("Error Occured")),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              additionalAutoComplete(
                text: "Truck Number : ${_selectedTruck!.truckNo}",
                onPressCallback: additionalTruckOnPressCallback,
                name: _selectedTruck,
                autoFocus: false,
                label: "Select \"Truck\" by Number",
                textCallback: truckText,
                suggestionCallback: truckSuggestion,
                stateCallback: truckState,
                controller: truckController,
              ),
              SizedBox(
                height: 10,
              ),
              additionalAutoComplete(
                text: "Broker Name : ${_selectedBroker!.name}",
                onPressCallback: additionalBrokerPartyOnPressCallback,
                name: _selectedBroker,
                autoFocus: false,
                label: "Select Broker Name",
                textCallback: brokerPartyText,
                suggestionCallback: brokerPartySuggestion,
                stateCallback: brokerPartyState,
                controller: brokerController,
              ),
              SizedBox(
                height: 10,
              ),
              TextFieldHelper(_splitQty, "Quantity", TextInputType.number),
              SizedBox(
                height: 10,
              ),
              TextButton(onPressed: handleAdd, child: Text("Add & Split DO")),
              Divider(
                color: Colors.grey,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) => SplitWidget(
                    split: list[index],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      future: _fetchData(),
    );
  }
}

class SplitWidget extends StatelessWidget {
  final Split? split;
  const SplitWidget({
    Key? key,
    this.split,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(color: Colors.white);
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(
              "Truck : ${split!.truck!.getNo()}",
              style: style,
            ),
            subtitle: Text(
              "Broker : ${split!.broker!.name}",
              style: style,
            ),
            trailing: Text(
              "${split!.qty}",
              style: style,
            ),
          ),
        ],
      ),
      color: Theme.of(context).colorScheme.primary,
    );
  }
}
