import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:softflow_app/Helpers/Snakebar.dart';
import 'package:softflow_app/Helpers/TextFieldHelper.dart';
import 'package:softflow_app/Helpers/dropDownContainer.dart';
import 'package:softflow_app/Models/balCdModel.dart';
import 'package:softflow_app/Models/partyName_model.dart';
import 'package:softflow_app/Providers/main_provider.dart';

class PartyInputScreen extends StatefulWidget {
  @override
  State<PartyInputScreen> createState() => _PartyInputScreenState();
  static const routeName = '/party-input-screen';
}

class _PartyInputScreenState extends State<PartyInputScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int initCount = 0;
  TextEditingController _partyName = TextEditingController(text: "");
  TextEditingController _placeName = TextEditingController(text: "");
  TextEditingController _mobile = TextEditingController(text: "");
  TextEditingController _pan = TextEditingController(text: "");
  TextEditingController _gst = TextEditingController(text: "");
  List<BalCd> _balCdList = [];
  late BalCd? _selectedBalCd;
  bool _isWhole = false;
  bool _isSaving = false;
  bool enable = true;

  init() async {
    setState(() {
      _isWhole = true;
    });
    final result = await BalCd.getBalCd();
    if (result['message'] == 'success') {
      setState(() {
        _balCdList = result['data'];
        _selectedBalCd = _balCdList[0];
        _isWhole = false;
      });
    } else {
      showSnakeBar(context, result['message']);
    }
  }

  handleSave() async {
    setState(() {
      _isSaving = true;
    });
    _formKey.currentState!.save();
    final currentUser =
        Provider.of<MainProvider>(context, listen: false).mainUser;
    final resultId = await PartyName.getUid();
    if (_formKey.currentState!.validate()) {
      PartyName party = new PartyName(
        name: _partyName.value.text,
        place: _placeName.value.text,
        mobile: _mobile.value.text,
        bal_cd: _selectedBalCd!.bal_cd,
        id: resultId,
        party_cd: resultId,
        multi_pcd: resultId,
        it_no: _pan.value.text,
        gsttin: _gst.value.text,
      );
      final result = await party.save(currentUser.co);
      if (result['message'] == 'success') {
        showSnakeBar(context, result['message']);
        setState(() {
          _isSaving = false;
        });
        Navigator.of(context).pop(context);
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
  void didChangeDependencies() {
    print("did change");
    super.didChangeDependencies();
  }

  @override
  void initState() {
    print("first");
    super.initState();
    init();
  }

  lock(PartyName party) async {
    setState(() {
      _isWhole = true;
      initCount = initCount + 1;
    });
    await init();
    _partyName = TextEditingController(text: party.name);
    _placeName = TextEditingController(text: party.place);
    _mobile = TextEditingController(text: party.mobile);
    _pan = TextEditingController(text: party.it_no);
    _gst = TextEditingController(text: party.gsttin);
    BalCd temp =
        _balCdList.firstWhere((element) => element.bal_cd == party.bal_cd);
    print(temp.bal_cd);
    setState(() {
      _selectedBalCd = temp;
      _isWhole = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final received =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    if (received['data'] != "" && initCount < 2) {
      setState(() {
        enable = received['enable'];
      });
      lock(received['data']);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("New Party"),
      ),
      body: _isWhole
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFieldHelper(
                        _partyName,
                        "Party Name",
                        TextInputType.name,
                        enable: enable,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFieldHelper(
                        _placeName,
                        "Place Name",
                        TextInputType.name,
                        enable: enable,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFieldHelper(
                        _mobile,
                        "Mobile Number",
                        TextInputType.phone,
                        enable: enable,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFieldHelper(
                        _pan,
                        "PAN Number",
                        TextInputType.name,
                        enable: enable,
                        noValidate: true,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFieldHelper(
                        _gst,
                        "GSTIN Number",
                        TextInputType.name,
                        enable: enable,
                        noValidate: true,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      StyleContainer(
                        icon: Icons.category,
                        name: "Schedule",
                        child: DropdownButton<BalCd>(
                          value: _selectedBalCd,
                          icon: Icon(Icons.arrow_drop_down_circle),
                          items: _balCdList.map(buildBalCdItem).toList(),
                          onChanged: enable
                              ? (value) => setState(() {
                                    _selectedBalCd = value;
                                  })
                              : null,
                        ),
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
                                  child: Text("Save Party"),
                                  onPressed: handleSave,
                                )
                              : SizedBox(
                                  height: 0,
                                ),
                    ],
                  ),
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
}
