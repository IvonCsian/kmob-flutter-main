import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kmob/common/functions/format.dart';
import 'package:kmob/common/functions/showDialogSingleButton.dart';
import 'package:kmob/common/platform/platformScaffold.dart';
import 'package:kmob/common/widgets/MyAppBar.dart';
import 'package:kmob/model/profile_model.dart';
import 'package:kmob/utils/constant.dart';
import 'package:http/http.dart' as http;

import 'package:progress_hud/progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'PointDetail.dart';

class PointRedeem extends StatefulWidget {
  final ProfileModel profile;

  const PointRedeem({Key key, this.profile}) : super(key: key);
  @override
  _PointRedeemState createState() => _PointRedeemState();
}

class _PointRedeemState extends State<PointRedeem> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  double maxWidth = 0;
  double maxHeight = 0;
  String nominal;
  String saldo = "";
  double saldoV = 0;
  double adminfee = 0;
  BuildContext _context;

  bool _loading = false;
  void dismissProgressHUD() {
    setState(() {
      _loading = !_loading;
    });
  }

  @override
  void initState() {
    super.initState();
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
        appBar: appBarDetail(context, "Redeem Point K3PG"),
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

  Map<String, String> get headers => {
        'Authorization': 'Bearer $tokens',
        'Content-Type': 'application/json',
      };

  String tokens;
  String url = "" +
      APIConstant.urlBase +
      "" +
      APIConstant.serverApi +
      "Transaksi/redeem";
  processtopup() async {
    dismissProgressHUD();
    Map<String, String> body = {
      'pointredeem': nominal,
    };
    final prefs = await SharedPreferences.getInstance();
    tokens = prefs.getString('LastToken') ?? '';
    final response = await http
        .post(Uri.parse(url), headers: headers, body: json.encode(body))
        .timeout(const Duration(seconds: 60), onTimeout: () {
      showDialogSingleButtonWithAction(
          _context, "Proses redeem gagal", "Timeout", "OK", "/HomeScreen");
      dismissProgressHUD();
    });

    if (response.statusCode == 200) {
      dismissProgressHUD();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => PointDetail(
                    profile: widget.profile,
                  )),
          ModalRoute.withName("/HomeScreen"));
    } else if (response.statusCode == 401) {
      dismissProgressHUD();
      Navigator.of(context).pushReplacementNamed('/LoginScreen');
    } else {
      dismissProgressHUD();
      showDialogSingleButtonWithAction(
          _context, "Proses redeem gagal", "Timeout", "OK", "/HomeScreen");
    }
  }

  _buildForm() {
    void _validateInputs() {
      _formKey.currentState.save();
      if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
        double nominalD = double.parse(nominal);
        if (nominalD > widget.profile.yourpoint) {
          showDialogSingleButton(
              _context,
              "Peringatan",
              'Nominal maksimal yang bisa diredeem : ' +
                  formatCurrency(widget.profile.yourpoint),
              "OK");
        } else {
          processtopup();
        }
      } else {
        setState(() {
          // _autoValidate = true;
        });
      }
    }

    return SingleChildScrollView(
        child: Column(children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          new Text(
            "Point Anda " + formatCurrency(widget.profile.yourpoint),
            style: new TextStyle(fontFamily: "WorkSans", fontSize: 15.0),
          ),
        ],
      ),
      SizedBox(
        height: 10.0,
      ),
      new TextFormField(
        decoration: const InputDecoration(
          labelText: "Nominal Redeem : ",
          icon: Icon(FontAwesomeIcons.moneyBillWave, color: Colors.black),
        ),
        keyboardType: TextInputType.number,
        validator: (String arg) {
          if (arg.length < 1)
            return 'Harus diisi';
          else if (double.parse(arg) < 25000)
            return 'Minimal redeem Rp.25.000';
          else if (arg.length > 20)
            return 'Nominal terlalu panjang';
          else
            return null;
        },
        onSaved: (String val) {
          nominal = val;
        },
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
              "Redeem ke Voucher",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                  fontFamily: "WorkSansBold"),
            ),
          ),
          onPressed: _validateInputs)
    ]));
  }
}
