import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kmob/common/functions/format.dart';
import 'package:kmob/common/functions/showDialogSingleButton.dart';
import 'package:kmob/common/platform/platformScaffold.dart';
import 'package:kmob/common/widgets/MyAppBar.dart';
import 'package:kmob/model/profile_model.dart';
import 'package:kmob/ui/fragment/Administrasi/OTPFragment.dart';
import 'package:kmob/utils/constant.dart';
import 'package:progress_hud/progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PinEwallet extends StatefulWidget {
  final ProfileModel profile;
  const PinEwallet({Key key, this.profile}) : super(key: key);
  @override
  _PinEwalletState createState() => _PinEwalletState();
}

class _PinEwalletState extends State<PinEwallet> {
  double maxWidth = 0;
  double maxHeight = 0;
  String _newPassword = "";
  String _newPassword2 = "";
  String tanggalString = "*belum dipilih";
  DateTime dates;
  String tanggal;
  String tempatlahir;
  String hp;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String url = APIConstant.url + "registercust";

  BuildContext _context;
  bool _loading = false;
  void dismissProgressHUD() {
    setState(() {
      _loading = !_loading;
    });
  }

  //main build method
  Widget build(BuildContext context) {
    _context = context;
    maxWidth = MediaQuery.of(context).size.width;
    maxHeight = MediaQuery.of(context).size.height >= 775.0
        ? MediaQuery.of(context).size.height
        : 775.0;
    return SafeArea(
      child: PlatformScaffold(
        appBar: appBarDetail(context, "PIN E-Wallet"),
        backgroundColor: Colors.grey[300],
        body: Stack(
          children: <Widget>[
            Container(
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
            if (_loading)
              new ProgressHUD(
                backgroundColor: Colors.black12,
                color: Colors.white,
                containerColor: Colors.blue,
                borderRadius: 5.0,
                text: 'Mohon Tunggu...',
              ),
          ],
        ),
      ),
    );
  }

  _buildForm() {
    void _validateInputs() {
      _formKey.currentState.save();
      if (_formKey.currentState.validate() &&
          !(["", null, false, 0].contains(tanggal))) {
//    If all data are correct then save data to out variables

        if (_newPassword2 != _newPassword) {
          showDialogSingleButton(
              _context, "Peringatan", 'PIN baru tidak sama', "OK");
        } else {
          if (_newPassword.length == 6) {
            _updatePassword(widget.profile.nak, _newPassword);
          } else {
            showDialogSingleButton(_context, "Peringatan",
                'Kata sandi terlalu pendek. 6 digit angka PIN', "OK");
          }
        }
      } else {
        //    If all data are not valid then start auto validation.
        if ((["", null, false, 0].contains(tanggal))) {
          showDialog(
            context: context,
            builder: (context) => new AlertDialog(
              title: new Text('Validasi'),
              content: new Text('Mohon isi tanggal Lahir'),
              actions: <Widget>[
                new TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: new Text('Ok'),
                ),
              ],
            ),
          );
        }
        setState(() {});
      }
    }

    return SingleChildScrollView(
        child: Column(children: <Widget>[
      new TextFormField(
        decoration: const InputDecoration(
          labelText: "6 digit angka PIN : ",
          icon: Icon(FontAwesomeIcons.lock, color: Colors.black),
        ),
        keyboardType: TextInputType.number,
        maxLength: 6,
        obscureText: true,
        validator: (String arg) {
          if (arg.length < 1)
            return 'Harus diisi';
          else if (arg.length != 6)
            return 'Pin terdiri dari 6 angka';
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
          labelText: "Ketik ulang PIN : ",
          icon: Icon(FontAwesomeIcons.lock, color: Colors.black),
        ),
        keyboardType: TextInputType.number,
        maxLength: 6,
        obscureText: true,
        validator: (String arg) {
          if (arg.length < 1)
            return 'Harus diisi';
          else if (arg.length != 6)
            return 'Pin terdiri dari 6 angka';
          else if (arg.length > 25)
            return 'Kata sandi terlalu panjang';
          else
            return null;
        },
        onSaved: (String val) {
          _newPassword2 = val;
        },
      ),
      SizedBox(
        height: 10.0,
      ),
      new Text(
        "PIN akan digunakan untuk menverifikasi semua transaksi ewallet. Harap ingat baik baik dan jaga kerahasiaan PIN anda.",
        style: new TextStyle(fontFamily: "WorkSans", fontSize: 10.0),
      ),
      SizedBox(
        height: 10.0,
      ),
      new TextFormField(
        decoration: const InputDecoration(
          labelText: "No Handphone : ",
          icon: Icon(FontAwesomeIcons.phoneSquare, color: Colors.black),
        ),
        keyboardType: TextInputType.number,
        validator: (String arg) {
          if (arg.length < 1)
            return 'Harus diisi';
          else if (arg.length < 1)
            return 'Tidak Valid';
          else if (arg.length > 20)
            return 'No Hp terlalu panjang';
          else
            return null;
        },
        onSaved: (String val) {
          hp = val;
        },
      ),
      SizedBox(
        height: 10.0,
      ),
      new TextFormField(
        decoration: const InputDecoration(
          labelText: "Tempat Lahir : ",
          icon: Icon(FontAwesomeIcons.city, color: Colors.black),
        ),
        keyboardType: TextInputType.text,
        validator: (String arg) {
          if (arg.length < 1)
            return 'Harus diisi';
          else if (arg.length < 1)
            return 'Tidak Valid';
          else if (arg.length > 50)
            return 'Nama Kota terlalu panjang';
          else
            return null;
        },
        onSaved: (String val) {
          tempatlahir = val;
        },
      ),
      SizedBox(
        height: 10.0,
      ),
      Row(
        children: <Widget>[
          Icon(FontAwesomeIcons.calendar, color: Colors.black),
          SizedBox(
            width: 10.0,
          ),
          Text("Tanggal Lahir : "),
          Text("$tanggalString "),
          SizedBox(
            width: 50,
            child: new MaterialButton(
              color: ColorPalette.warnaCorporate,
              onPressed: () {
                {
                  DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      minTime: new DateTime(1945, 8, 17),
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
      SizedBox(
        height: 10.0,
      ),
      MaterialButton(
          color: ColorPalette.warnaCorporate,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
            child: Text(
              "LANJUTKAN PROSES AKTIVASI",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                  fontFamily: "WorkSansBold"),
            ),
          ),
          onPressed: _validateInputs)
    ]));
  }

  Map<String, String> get headers => {
        'x-key': "\$^DR&MYUTIL*EIU&Juk98onu98OI&KU(*OIU)d",
        'Content-Type': 'application/json',
        'app-id': "8A53A5C5-8B3D-4624-ACFA-C14945EC4F88"
      };
  String tokens;
  Map<String, String> get headersKmobile => {
        'Authorization': 'Bearer $tokens',
        'Content-Type': 'application/json',
      };
  Future _updatePassword(String nak, String newPassword) async {
    dismissProgressHUD();
    // Map<String, String> body = {
    //   'hp': hp,
    // };

    Map<String, String> body = {'nohp': hp, 'nak': widget.profile.nak};
    final prefs = await SharedPreferences.getInstance();
    tokens = prefs.getString('LastToken') ?? '';
    // final response = await http.post(APIConstant.urlBase + "" + APIConstant.serverApi + "/Otp/insert",
    //     headers: headersKmobile,
    //     body: json.encode(body));

    final response = await http.post(Uri.parse(APIConstant.url + "smsotp"),
        headers: headers, body: json.encode(body));

    if (response.statusCode == 200) {
      dismissProgressHUD();
      Navigator.push(
          _context,
          MaterialPageRoute(
              builder: (context) => OTPFragment(
                  profile: widget.profile,
                  tempatlahir: tempatlahir,
                  tanggal: tanggal,
                  password: newPassword,
                  hp: hp)));
    } else if (response.statusCode == 401) {
      dismissProgressHUD();
      Navigator.of(context).pushReplacementNamed('/LoginScreen');
    } else {
      dismissProgressHUD();
    }

    // Map<String, String> body = {
    //   'firstName': widget.profile.nmAng,
    //   'lastName': widget.profile.nmAng,
    //   'placeOfBirth': tempatlahir,
    //   'dateOfBirth': tanggal,
    //   'password': newPassword,
    //   'msisdn': widget.profile.hp,
    //   'email': widget.profile.email,
    //   'productName': "ANCOL",
    //   'nak': widget.profile.nak,
    // };
    // final response =
    //     await http.post(Uri.parse(url), body: json.encode(body), headers: headers);
    // if (response.statusCode == 200) {
    //   final body = json.decode(response.body);
    //   if (body['body']['RegisterNonCustomerJomiResponse'] == null) {
    //     showDialogSingleButton(context, "Proses Aktivasi E-Wallet gagal",
    //         body['body']['Fault']['faultstring']['_text'], "OK");
    //   } else {
    //     showDialogSingleButton(
    //         context,
    //         "Proses Aktivasi E-Wallet berhasil dilakukan",
    //         "Terima kasih",
    //         "OK");
    //     Timer(Duration(seconds: 2), () {
    //       Navigator.of(context).pushReplacementNamed('/HomeScreen');
    //     });
    //   }
    // } else {
    //   final body = json.decode(response.body);
    //   showDialogSingleButton(
    //       context, "Aktivasi gagal", body["msg"].toString(), "OK");
    // }
  }
}
