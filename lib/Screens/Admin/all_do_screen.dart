import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:softflow_app/Helpers/Snakebar.dart';
import 'package:softflow_app/Helpers/dateFormatfromDataBase.dart';
import 'package:softflow_app/Helpers/filterTypeHelper.dart';
import 'package:softflow_app/Helpers/partyWiseModel.dart';
import 'package:softflow_app/Helpers/shimmerLoader.dart';
import 'package:softflow_app/Models/user_model.dart';
import 'package:softflow_app/Providers/main_provider.dart';
import 'package:softflow_app/Screens/Common/tabulardataScreen.dart';
import 'package:softflow_app/Widgets/doItem.dart';
import '../../Models/do_model.dart';

class AllDoScreen extends StatefulWidget {
  static const routeName = '/allDoScreen';

  @override
  _AllDoScreenState createState() => _AllDoScreenState();
}

class _AllDoScreenState extends State<AllDoScreen> {
  int _selectedFilter = 1;

  List<int> filterItems = [0, 1, 2, 3, 4];

  List<DO> items = [];
  List<DO> partyWiseItems = [];
  List<DO> toShowItems = [];

  List<PartyWise>? li = [];
  PartyWise? selectedPartyWise;
  List<DropdownMenuItem<PartyWise>>? pwli;

  bool _isLoading = false;

  DateTime selectedDate = DateTime.now();

  partyFilter() {
    PartyWise? pw = selectedPartyWise;
    if (pw!.accId == -1) {
      setState(() {
        partyWiseItems = items;
      });
      filterSearch();
      return;
    }
    List<DO> temp =
        items.where((e) => e.acc_id == pw.accId.toString()).toList();
    setState(() {
      partyWiseItems = temp;
    });
    filterSearch();
  }

  getAndSet() async {
    final User currentUser =
        Provider.of<MainProvider>(context, listen: false).user;
    setState(() {
      _isLoading = true;
    });
    li = await PartyWise.fetch();
    li!.insert(0, PartyWise(accId: -1, name: "All Party Data"));
    selectedPartyWise = li![0];
    pwli = PartyWise.fetchItems(li!);
    final result = await DO.getAllDO(
      '',
      branch: currentUser.deptCd,
    );
    if (result['message'] == 'success') {
      setState(() {
        items = result['data'];
        partyWiseItems = items;
        _isLoading = false;
      });
    } else {
      showSnakeBar(context, result['message']);
      setState(() {
        _isLoading = false;
      });
    }
    handleSearch("");
  }

  handleSearch(String value) {
    List<DO> temp = partyWiseItems
        .where((element) =>
            (element.do_no.toLowerCase().contains(value.toLowerCase()) ||
                element.consignee.toLowerCase().contains(value.toLowerCase()) ||
                element.toplc.toLowerCase().contains(value.toLowerCase()) ||
                element.frmplc.toLowerCase().contains(value.toLowerCase())) &&
            (dateFormatFromDataBase(element.do_dt)
                    .isAfter(selectedDate.subtract(Duration(days: 4))) &&
                dateFormatFromDataBase(element.do_dt)
                    .isBefore(selectedDate.add(Duration(days: 1)))))
        .toList();
    setState(() {
      toShowItems = temp;
    });
    partyFilter();
  }

  filterSearch() {
    switch (_selectedFilter) {
      case 0:
        setState(() {
          toShowItems = toShowItems;
        });
        break;
      case 1:
        List<DO> temp = partyWiseItems.where((e) => e.truckid == '-1').toList();
        setState(() {
          toShowItems = temp;
        });
        break;
      case 2:
        List<DO> temp = partyWiseItems
            .where((e) =>
                e.truckid != '-1' &&
                e.broker != '-1' &&
                e.Veh_reached != '1' &&
                e.compl != 1)
            .toList();
        setState(() {
          toShowItems = temp;
        });
        break;
      case 3:
        List<DO> temp = partyWiseItems
            .where((e) => e.Veh_reached == '1' && e.compl != 1)
            .toList();
        setState(() {
          toShowItems = temp;
        });
        break;
      case 4:
        List<DO> temp = partyWiseItems.where((e) => e.compl == 1).toList();
        setState(() {
          toShowItems = temp;
        });
        break;
      default:
    }
  }

  dynamic _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
      handleSearch('');
    }
  }

  @override
  void initState() {
    super.initState();
    getAndSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("D.O. Listing"),
        actions: [
          Container(
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                value: _selectedFilter,
                items: filterItems.map((int item) {
                  return DropdownMenuItem<int>(
                    onTap: () => handleSearch(''),
                    child: Text(
                      filterType(item),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    value: item,
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedFilter = int.parse(value.toString());
                  });
                  handleSearch('');
                },
                elevation: 0,
                icon: Icon(Icons.more_vert),
                iconEnabledColor: Colors.white,
                dropdownColor: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? LoadingListPage()
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
                      labelText: 'Search DO',
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      DropdownButtonHideUnderline(
                        child: DropdownButton<PartyWise>(
                          items: pwli,
                          onChanged: (value) {
                            setState(() {
                              selectedPartyWise = value;
                            });
                            partyFilter();
                          },
                          value: selectedPartyWise,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () => _selectDate(context),
                            child: Chip(
                              label: Text(
                                "Results for Date " +
                                    DateFormat.yMMMd()
                                        .format(selectedDate)
                                        .toString(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Chip(
                            label: Text(
                              "Results : ${toShowItems.length}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => getAndSet(),
                    child: ListView.builder(
                      itemCount: toShowItems.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return DoItem(
                          receivedDO: toShowItems[index],
                          getAndSet: getAndSet,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TabularDataScreen(
                  filterDo: toShowItems,
                ),
              ));
        },
        label: Row(
          children: [
            Icon(Icons.table_chart),
            SizedBox(
              width: 5,
            ),
            Text("Report"),
          ],
        ),
        // child: ,
      ),
    );
  }
}
