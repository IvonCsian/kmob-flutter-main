import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kmob/common/functions/format.dart';
import 'package:kmob/model/profile_model.dart';
import 'package:kmob/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:progress_hud/progress_hud.dart';

class EntrySPBUScreen extends StatefulWidget {
  @override
  _EntrySPBUScreenState createState() => _EntrySPBUScreenState();
}

class _EntrySPBUScreenState extends State<EntrySPBUScreen> {
  //  _formKey and _autoValidate
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  double maxWidth = 0;
  double maxHeight = 0;
  //value form
  String noNota;
  String tanggal;
  String tanggalString = "*belum dipilih";
  double nominal;
  double maxSpbu;
  DateTime dates;
  String tokens;
  bool _loading = false;

  String urlProfile = APIConstant.urlBase + APIConstant.serverApi + "/profile";
  Map<String, String> get headers => {
        'Authorization': 'Bearer $tokens',
        'Content-Type': 'application/json',
      };
  ProfileModel profile;

  @override
  void initState() {
    super.initState();
    this.getData();
  }

  void toggleProgressHUD() {
    setState(() {
      _loading = !_loading;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getData() async {
    toggleProgressHUD();
    final prefs = await SharedPreferences.getInstance();
    tokens = prefs.getString('LastToken') ?? '';
    final response = await http.get(Uri.parse(urlProfile), headers: headers);
    if (response.statusCode == 200) {
      toggleProgressHUD();
      // If the call to the server was successful, parse the JSON.
      profile = new ProfileModel.fromJson(json.decode(response.body));
      setState(() {
        maxSpbu = profile.maxSpbu;
      });
    } else {
      toggleProgressHUD();
      print('Something went wrosdng. \nResponse Code : ${response.statusCode}');
    }
  }

  //main build method
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(5.0),
          color: Colors.grey[200],
          child: new Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.always,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 8.0),
                  child: _buildForm(),
                ),
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              )),
        ),
        if (_loading)
          new ProgressHUD(
            backgroundColor: Colors.black12,
            color: Colors.white,
            containerColor: Colors.blue,
            borderRadius: 5.0,
            text: 'Loading data...',
          ),
      ],
    );
  }

  Widget _buildForm() {
    // void _validateInputs() {
    //   if (_formKey.currentState.validate() &&
    //       !(["", null, false, 0].contains(tanggal))) {
    //     _formKey.currentState.save();

    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) => UploadSPBUScren(
    //               noNota: noNota, tanggal: tanggal, nominal: nominal)),
    //     );
    //   } else {
    //     if ((["", null, false, 0].contains(tanggal))) {
    //       showDialog(
    //         context: context,
    //         builder: (context) => new AlertDialog(
    //           title: new Text('Validasi'),
    //           content: new Text('Mohon isi tanggal Transaksi'),
    //           actions: <Widget>[
    //             new TextButton(
    //               onPressed: () => Navigator.of(context).pop(false),
    //               child: new Text('Ok'),
    //             ),
    //           ],
    //         ),
    //       );
    //     }

    //     setState(() {});
    //   }
    // }

    return ListView(
      children: <Widget>[
        new TextFormField(
          decoration: const InputDecoration(
            labelText: "No Nota SPBU : ",
            icon: Icon(FontAwesomeIcons.userTag, color: Colors.blue),
          ),
          keyboardType: TextInputType.text,
          validator: (String arg) {
            if (arg.length < 1)
              return 'Harus diisi';
            else if (arg.length > 20)
              return 'No Nota SPBU terlalu panjang';
            else
              return null;
          },
          onSaved: (String val) {
            noNota = val;
          },
        ),
        Row(
          children: <Widget>[
            Icon(FontAwesomeIcons.calendar, color: Colors.blue),
            SizedBox(
              width: 10.0,
            ),
            Text("Tanggal Transaksi : "),
            Text("$tanggalString "),
            SizedBox(
              width: 50,
              child: new MaterialButton(
                color: Colors.blue,
                onPressed: () {
                  {
                    DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        maxTime: DateTime.now(), onConfirm: (date) {
                      dates = date;
                      tanggalString = formatDate(date.toString());
                      setState(() {
                        // new DateFormat("dd MMMMM yyyy").format(date).toString();
                      });
                      tanggal =
                          new DateFormat("yyyy-MM-dd").format(dates).toString();
                    }, currentTime: DateTime.now(), locale: LocaleType.id);
                  }
                },
                child: new Icon(FontAwesomeIcons.caretSquareDown,
                    color: Colors.white),
              ),
            )
          ],
        ),
        new TextFormField(
          decoration: const InputDecoration(
            labelText: "Nominal Transaksi : ",
            icon: Icon(FontAwesomeIcons.moneyBillAlt, color: Colors.blue),
          ),
          keyboardType: TextInputType.number,
          validator: (String arg) {
            if (arg.length < 1)
              return 'Harus diisi';
            else {
              if (double.parse(arg) <= maxSpbu) {
                return null;
              } else {
                return 'Nominal nota spbu melebihi batas maksimal';
              }
            }
          },
          onSaved: (String val) {
            nominal = double.parse(val);
          },
        ),
        new SizedBox(
          height: 10.0,
        ),
        ElevatedButton(
          onPressed: () {},
          child: new Text('Lanjut'),
        )
      ],
    );
  }
}
