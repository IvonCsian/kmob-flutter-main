import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kmob/common/functions/showDialogSingleButton.dart';
import 'package:kmob/common/platform/platformScaffold.dart';
import 'package:kmob/common/widgets/MyAppBar.dart';
import 'package:kmob/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class GantiPasswordFragment extends StatefulWidget {
  @override
  _GantiPasswordFragmentState createState() => _GantiPasswordFragmentState();
}

class _GantiPasswordFragmentState extends State<GantiPasswordFragment> {
  double maxWidth = 0;
  double maxHeight = 0;
  String _currentPassword = "";
  String _newPassword = "";
  String _newPassword2 = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String url = "" +
      APIConstant.urlBase +
      "" +
      APIConstant.serverApi +
      "profile/changepassword";

  BuildContext _context;

  //main build method
  Widget build(BuildContext context) {
    _context = context;
    maxWidth = MediaQuery.of(context).size.width;
    maxHeight = MediaQuery.of(context).size.height >= 775.0
        ? MediaQuery.of(context).size.height
        : 775.0;
    return SafeArea(
      child: PlatformScaffold(
        appBar: appBarDetail(context, "Ubah Kata Sandi"),
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

  _buildForm() {
    void _validateInputs() {
      _formKey.currentState.save();
      if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables

        if (_newPassword2 != _newPassword) {
          showDialogSingleButton(
              context, "Peringatan", 'Kata sandi baru tidak sama', "OK");
        } else {
          if (_newPassword.length < 6) {
            showDialogSingleButton(_context, "Peringatan",
                'Kata sandi terlalu pendek. Minimal 6 karakter', "OK");
          } else {
            _updatePassword(_currentPassword, _newPassword);
          }
        }
      } else {
        //    If all data are not valid then start auto validation.
        setState(() {});
      }
    }

    return SingleChildScrollView(
        child: Column(children: <Widget>[
      new TextFormField(
        decoration: const InputDecoration(
          labelText: "Kata sandi sekarang : ",
          icon: Icon(FontAwesomeIcons.unlockAlt, color: Colors.black),
        ),
        keyboardType: TextInputType.text,
        obscureText: true,
        validator: (String arg) {
          if (arg.length < 1)
            return 'Harus diisi';
          else if (arg.length > 25)
            return 'Kata sandi terlalu panjang';
          else
            return null;
        },
        onSaved: (String val) {
          _currentPassword = val;
        },
      ),
      new TextFormField(
        decoration: const InputDecoration(
          labelText: "Kata sandi baru : ",
          icon: Icon(FontAwesomeIcons.lock, color: Colors.black),
        ),
        keyboardType: TextInputType.text,
        obscureText: true,
        validator: (String arg) {
          if (arg.length < 1)
            return 'Harus diisi';
          else if (arg.length > 25)
            return 'Kata sandi terlalu panjang';
          else
            return null;
        },
        onSaved: (String val) {
          _newPassword = val;
        },
      ),
      new TextFormField(
        decoration: const InputDecoration(
          labelText: "Tulis ulang kata sandi baru : ",
          icon: Icon(FontAwesomeIcons.lock, color: Colors.black),
        ),
        keyboardType: TextInputType.text,
        obscureText: true,
        validator: (String arg) {
          if (arg.length < 1)
            return 'Harus diisi';
          else if (arg.length > 25)
            return 'Kata sandi terlalu panjang';
          else
            return null;
        },
        onSaved: (String val) {
          _newPassword2 = val;
        },
      ),
      MaterialButton(
          color: ColorPalette.warnaCorporate,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
            child: Text(
              "Simpan Perubahan",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                  fontFamily: "WorkSansBold"),
            ),
          ),
          onPressed: _validateInputs)
    ]));
  }

  Map<String, String> get headers => {
        'Authorization': 'Bearer $tokens',
        'Content-Type': 'application/json',
      };
  String tokens;

  Future _updatePassword(String currentPassword, String newPassword) async {
    final prefs = await SharedPreferences.getInstance();
    tokens = prefs.getString('LastToken') ?? '';
    Map<String, String> body = {
      'password': _currentPassword,
      'passwordbaru': _newPassword2,
    };
    final response = await http.post(Uri.parse(url),
        body: json.encode(body), headers: headers);
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      showDialogSingleButton(
          context, "Ubah Kata Sandi berhasil", body["status"].toString(), "OK");
      Timer(Duration(seconds: 2), () {
        Navigator.popUntil(_context, ModalRoute.withName('/HomeScreen'));
      });
    } else {
      final body = json.decode(response.body);
      showDialogSingleButton(
          context, "Aktivasi gagal", body["status"].toString(), "OK");
    }
  }
}
