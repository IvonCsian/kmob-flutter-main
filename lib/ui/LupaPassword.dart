import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kmob/common/functions/showDialogSingleButton.dart';
import 'package:kmob/ui/PasswordBaru.dart';
import 'package:kmob/utils/constant.dart';
import 'package:http/http.dart' as http;

class LupaPassword extends StatefulWidget {
  @override
  _LupaPasswordState createState() => _LupaPasswordState();
}

class _LupaPasswordState extends State<LupaPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _email;
  String _nak;

  BuildContext _context;
  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  Future<void> validateData(
    String email,
    String nak,
  ) async {
    String url = "" +
        APIConstant.urlBase +
        "" +
        APIConstant.serverApi +
        "Pub/forgotpassword";
    Map<String, String> body = {
      'no_ang': nak,
      'email': email,
    };
    final response = await http.post(Uri.parse(url), body: body);
    if (response.statusCode == 200) {
      showDialogSingleButton(
          context,
          "Recovery Password berhasil",
          "Silahkan Cek email anda untuk mendapatkan kode token yang akan dipakai di halaman selanjutnya",
          "OK");

      Timer(Duration(seconds: 5), () {
        Navigator.push(
          _context,
          MaterialPageRoute(builder: (context) => PasswordBaru(email: email)),
        );
      });
    } else {
      final body = json.decode(response.body);
      showDialogSingleButton(
          context, "Aktivasi gagal", body["status"].toString(), "OK");
    }
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    void _validateInputs() {
      if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
        _formKey.currentState.save();
        //navigate

        validateData(_email, _nak);
      } else {
        //    If all data are not valid then start auto validation.
        setState(() {});
      }
    }

    return Scaffold(
        body: Stack(children: <Widget>[
      SingleChildScrollView(
          child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height >= 775.0
            ? MediaQuery.of(context).size.height
            : 775.0,
        color: ColorPalette.warnaCorporate,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 75.0),
              child: Center(
                  child: new ClipRRect(
                borderRadius: new BorderRadius.circular(50.0),
                child: new Image.asset(
                  'assets/img/logo.jpg',
                  height: 200.0,
                  width: 200.0,
                  fit: BoxFit.fill,
                ),
              )),
            ),
            Container(
                padding: EdgeInsets.only(
                    top: 20.0, bottom: 0.0, left: 20.0, right: 25.0),
                child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.always,
                    child: Card(
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                                20.0, 10.0, 40.0, 8.0),
                            child: SingleChildScrollView(
                                child: Column(children: <Widget>[
                              new TextFormField(
                                textInputAction: TextInputAction.done,
                                decoration: const InputDecoration(
                                  labelText: "Email anda yg terdaftar : ",
                                  icon: Icon(FontAwesomeIcons.idCard,
                                      color: Colors.black),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (String arg) {
                                  return validateEmail(arg);
                                },
                                onSaved: (String val) {
                                  _email = val;
                                },
                              ),
                              new TextFormField(
                                decoration: const InputDecoration(
                                  labelText: "Nomor Anggota Koperasi : ",
                                  icon: Icon(FontAwesomeIcons.idCardAlt,
                                      color: Colors.black),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (String arg) {
                                  if (arg.length < 1)
                                    return 'Harus diisi';
                                  else if (arg.length > 25)
                                    return 'No NIK terlalu panjang';
                                  else
                                    return null;
                                },
                                onSaved: (String val) {
                                  _nak = val;
                                },
                              ),
                              MaterialButton(
                                  color: ColorPalette.warnaCorporate,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 42.0),
                                    child: Text(
                                      "SUBMIT",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15.0,
                                          fontFamily: "WorkSansBold"),
                                    ),
                                  ),
                                  onPressed: _validateInputs)
                            ]))))))
          ],
        ),
      ))
    ]));
  }
}
