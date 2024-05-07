import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kmob/common/platform/platformScaffold.dart';
import 'package:kmob/common/widgets/MyAppBar.dart';
import 'package:kmob/model/bank_model.dart';
import 'package:kmob/ui/fragment/Setoran/UploadSetoranScreen.dart';
import 'package:kmob/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SetoranSS2Screen extends StatefulWidget {
  @override
  _SetoranSS2ScreenState createState() => _SetoranSS2ScreenState();
}

class _SetoranSS2ScreenState extends State<SetoranSS2Screen> {
  // start region variable

  //  _formKey and _autoValidate
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //value form
  String _rekening;
  String _nama;
  String _jangka;
  double _nominal;
  //list bank dari server
  List<BankModel> banks = [];
  BankModel _bank;
  //url bank
  String url = "" + APIConstant.urlBase + "" + APIConstant.serverApi + "bank";
  Map<String, String> get headers => {
        'Authorization': 'Bearer $tokens',
        'Content-Type': 'application/json',
      };
  //ui
  double maxWidth = 0;
  double maxHeight = 0;
  // end region variable

  @override
  void initState() {
    super.initState();
    _getBank();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // start region data bank
  //getdata area
  Future<void> _getBank() async {
    final prefs = await SharedPreferences.getInstance();
    tokens = prefs.getString('LastToken') ?? '';

    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      var rest = json.decode(response.body) as List;
      banks = rest.map<BankModel>((json) => BankModel.fromJson(json)).toList();
      setState(() {
        banks = banks;
      });
    } else if (response.statusCode == 401) {}
  }

  // end region data bank
  //main build method
  Widget build(BuildContext context) {
    maxWidth = MediaQuery.of(context).size.width;
    maxHeight = MediaQuery.of(context).size.height >= 775.0
        ? MediaQuery.of(context).size.height
        : 775.0;
    return SafeArea(
      child: PlatformScaffold(
        appBar: appBarDetail(context, "Setoran Simpanan Sukarela 2"),
        backgroundColor: Colors.grey[300],
        body: Container(
          width: maxWidth,
          height: maxHeight,
          margin: EdgeInsets.all(5.0),
          color: Colors.grey[200],
          child: new Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.always,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 10.0, 40.0, 8.0),
                  child: _buildForm(),
                ),
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              )),
        ),
      ),
    );
  }

  Widget _buildForm() {
    void _validateInputs() {
      if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
        _formKey.currentState.save();
        //navigate
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UploadSetoranScreen(
                  bank: _bank,
                  rekening: _rekening,
                  nominal: _nominal,
                  nama: _nama,
                  jangka: _jangka,
                  simpanan: "Sukarela 2")),
        );
      } else {
//    If all data are not valid then start auto validation.
        setState(() {});
      }
    }

//     String validateName(String value) {
//       if (value.length < 3)
//         return 'Name must be more than 2 charater';
//       else
//         return null;
//     }

//     String validateMobile(String value) {
// // Indian Mobile number are of 10 digit only
//       if (value.length != 10)
//         return 'Mobile Number must be of 10 digit';
//       else
//         return null;
//     }

//     String validateEmail(String value) {
//       Pattern pattern =
//           r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
//       RegExp regex = new RegExp(pattern);
//       if (!regex.hasMatch(value))
//         return 'Enter Valid Email';
//       else
//         return null;
//     }

    return Column(
      children: <Widget>[
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: "Jangka Waktu : ",
            icon: Icon(FontAwesomeIcons.store, color: Colors.blue),
          ),
          validator: (String arg) {
            if (arg == null)
              return 'Harus diisi';
            else
              return null;
          },
          onSaved: (String newValue) {
            setState(() {
              _jangka = newValue;
            });
          },
          value: _jangka,
          onChanged: (String newValue) {
            setState(() {
              _jangka = newValue;
            });
          },
          items: ["3", "6", "12"].map((label) {
            return new DropdownMenuItem<String>(
              value: label,
              child: new SizedBox(
                width: 200.0,
                child: new Text(
                  label + " bulan",
                  style: new TextStyle(color: Colors.black),
                ),
              ),
            );
          }).toList(),
        ),
        DropdownButtonFormField<BankModel>(
          decoration: const InputDecoration(
            labelText: "Bank Pengirim : ",
            icon: Icon(FontAwesomeIcons.store, color: Colors.blue),
          ),
          validator: (BankModel arg) {
            if (arg == null)
              return 'Harus diisi';
            else
              return null;
          },
          onSaved: (BankModel newValue) {
            setState(() {
              _bank = newValue;
            });
          },
          value: _bank,
          onChanged: (BankModel newValue) {
            setState(() {
              _bank = newValue;
            });
          },
          items: banks.map((BankModel bank) {
            return new DropdownMenuItem<BankModel>(
              value: bank,
              child: new SizedBox(
                width: 200.0,
                child: new Text(
                  bank.nama,
                  style: new TextStyle(color: Colors.black),
                ),
              ),
            );
          }).toList(),
        ),
        new TextFormField(
          decoration: const InputDecoration(
            labelText: "No Rekening : ",
            icon: Icon(FontAwesomeIcons.userTag, color: Colors.blue),
          ),
          keyboardType: TextInputType.number,
          validator: (String arg) {
            if (arg.length < 1)
              return 'Harus diisi';
            else
              return null;
          },
          onSaved: (String val) {
            _rekening = val;
          },
        ),
        new TextFormField(
          decoration: const InputDecoration(
            labelText: "Nama Rekening : ",
            icon: Icon(FontAwesomeIcons.userTag, color: Colors.blue),
          ),
          keyboardType: TextInputType.text,
          validator: (String arg) {
            if (arg.length < 1)
              return 'Harus diisi';
            else
              return null;
          },
          onSaved: (String val) {
            _nama = val;
          },
        ),
        new TextFormField(
          decoration: const InputDecoration(
            labelText: "Nominal : ",
            icon: Icon(FontAwesomeIcons.moneyBillAlt, color: Colors.blue),
          ),
          keyboardType: TextInputType.number,
          validator: (String arg) {
            if (arg.length < 1)
              return 'Harus diisi';
            else
              return null;
          },
          onSaved: (String val) {
            _nominal = double.parse(val);
          },
        ),
        new SizedBox(
          height: 10.0,
        ),
        ElevatedButton(
          onPressed: _validateInputs,
          child: new Text('Lanjut'),
        )
      ],
    );
  }
}
