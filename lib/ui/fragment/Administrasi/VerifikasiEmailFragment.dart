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

class VerifikasiEmailFragment extends StatefulWidget {
  final String email;

  const VerifikasiEmailFragment({Key key, this.email}) : super(key: key);
  @override
  _VerifikasiEmailFragmentState createState() =>
      _VerifikasiEmailFragmentState();
}

class _VerifikasiEmailFragmentState extends State<VerifikasiEmailFragment> {
  double maxWidth = 0;
  double maxHeight = 0;
  String _otp = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String url = "" +
      APIConstant.urlBase +
      "" +
      APIConstant.serverApi +
      "profile/updateEmail";

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
        appBar: appBarDetail(context, "Verifikasi Email"),
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

        // if (_newPassword2 != _newPassword) {
        //   showDialogSingleButton(
        //       context, "Peringatan", 'Email baru tidak sama', "OK");
        // } else {
        //   showDialogSingleButton(_context, "Cek email",
        //       "Cek Email anda untuk verifikasi account dan email", "Ok");
        _updatePassword(_otp);
      } else {
        //    If all data are not valid then start auto validation.
        setState(() {});
      }
    }

    return SingleChildScrollView(
        child: Column(children: <Widget>[
      new TextFormField(
        decoration: const InputDecoration(
          labelText: "PIN OTP EMAIL : ",
          icon: Icon(FontAwesomeIcons.unlockAlt, color: Colors.black),
        ),
        keyboardType: TextInputType.text,
        validator: (String arg) {
          if (arg.length < 1)
            return 'Harus diisi';
          else if (arg.length > 40)
            return 'Email terlalu panjang';
          else
            return null;
        },
        onSaved: (String val) {
          _otp = val;
        },
      ),
      // new TextFormField(
      //   decoration: const InputDecoration(
      //     labelText: "Email baru : ",
      //     icon: Icon(FontAwesomeIcons.lock, color: Colors.black),
      //   ),
      //   keyboardType: TextInputType.text,

      //   validator: (String arg) {
      //     if (arg.length < 1)
      //       return 'Harus diisi';
      //     else if (arg.length > 40)
      //       return 'Email terlalu panjang';
      //     else
      //       return null;
      //   },
      //   onSaved: (String val) {
      //     _newPassword = val;
      //   },
      // ),
      // new TextFormField(
      //   decoration: const InputDecoration(
      //     labelText: "Tulis ulang Email baru : ",
      //     icon: Icon(FontAwesomeIcons.lock, color: Colors.black),
      //   ),
      //   keyboardType: TextInputType.text,

      //   validator: (String arg) {
      //     if (arg.length < 1)
      //       return 'Harus diisi';
      //     else if (arg.length > 40)
      //       return 'Email terlalu panjang';
      //     else
      //       return null;
      //   },
      //   onSaved: (String val) {
      //     _newPassword2 = val;
      //   },
      // ),
      MaterialButton(
          color: ColorPalette.warnaCorporate,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
            child: Text(
              "Simpan",
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

  Future _updatePassword(String __otp) async {
    final prefs = await SharedPreferences.getInstance();
    tokens = prefs.getString('LastToken') ?? '';
    Map<String, String> body = {
      'otp': __otp,
      'email': this.widget.email,
    };
    final response = await http.post(Uri.parse(url),
        body: json.encode(body), headers: headers);
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      showDialogSingleButton(_context, "Ubah/ Verifikasi Email berhasil",
          body["status"].toString(), "OK");
      Timer(Duration(seconds: 2), () {
        Navigator.pushNamedAndRemoveUntil(context, "/HomeScreen", (r) => false);
      });
    } else {
      final body = json.decode(response.body);
      showDialogSingleButton(
          _context, "Aktivasi gagal", body["status"].toString(), "OK");
    }
  }
}
