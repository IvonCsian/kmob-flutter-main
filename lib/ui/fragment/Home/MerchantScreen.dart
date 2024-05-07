import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kmob/common/functions/showDialogSingleButton.dart';
import 'package:kmob/common/platform/platformScaffold.dart';
import 'package:kmob/common/widgets/MyAppBar.dart';
import 'package:kmob/model/ewallet_model.dart';
import 'package:kmob/model/profile_model.dart';
import 'package:kmob/ui/fragment/Home/ConfirmTransactionWalletScreen.dart';
import 'package:kmob/utils/constant.dart';
import 'package:http/http.dart' as http;
import 'package:progress_hud/progress_hud.dart';

class MerchantScreen extends StatefulWidget {
  final String barcode;
  final String mode;
  final ProfileModel profile;
  const MerchantScreen({Key key, this.barcode, this.mode, this.profile})
      : super(key: key);

  @override
  _MerchantScreenState createState() => _MerchantScreenState();
}

class _MerchantScreenState extends State<MerchantScreen> {
  String url = APIConstant.url + "scantoinquiryv2";
  double maxWidth = 0;
  double maxHeight = 0;
  double amountFix = 0;
  String amount = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _loading = false;
  void dismissProgressHUD() {
    setState(() {
      _loading = !_loading;
    });
  }

  BuildContext _context;
  String merchantname = "";
  Map<String, String> get headersWallet => {
        'x-key': "\$^DR&MYUTIL*EIU&Juk98onu98OI&KU(*OIU)d",
        'Content-Type': 'application/json',
        'app-id': "8A53A5C5-8B3D-4624-ACFA-C14945EC4F88"
      };
  @override
  void initState() {
    fetchMerchant();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    maxWidth = MediaQuery.of(context).size.width;
    maxHeight = MediaQuery.of(context).size.height >= 775.0
        ? MediaQuery.of(context).size.height
        : 775.0;
    return SafeArea(
      child: PlatformScaffold(
        appBar: appBarDetail(context, "Bayar Ke"),
        backgroundColor: Colors.grey[300],
        body: Stack(children: <Widget>[
          Container(
              width: maxWidth,
              height: maxHeight,
              margin: EdgeInsets.all(5.0),
              color: Colors.grey[200],
              child: Column(
                children: <Widget>[
                  Container(
                    width: maxWidth,
                    color: Colors.grey[200],
                    child: Card(
                      elevation: 5.0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 8.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Informasi Merchant",
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontFamily: "NeoSansBold"),
                                ),
                              ],
                            ),
                            IconButton(
                              iconSize: 80.0,
                              icon: new Icon(
                                Icons.store,
                                color: ColorPalette.warnaCorporate,
                              ),
                              onPressed: () {},
                            ),
                            Text(
                              merchantname,
                              style: TextStyle(
                                  fontSize: 14.0, fontFamily: "NeoSansBold"),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  new Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.always,
                      child: Card(
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(10.0, 10.0, 40.0, 8.0),
                          child: _buildForm(),
                        ),
                        elevation: 2.0,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      )),
                ],
              )),
          if (_loading)
            new ProgressHUD(
              backgroundColor: Colors.black12,
              color: Colors.white,
              containerColor: Colors.blue,
              borderRadius: 5.0,
              text: 'Mohon Tunggu...',
            ),
        ]),
      ),
    );
  }

  _buildForm() {
    void _validateInputs() {
      _formKey.currentState.save();
      if (_formKey.currentState.validate()) {
        //    If all data are not valid then start auto validation.
        setState(() {});
        amountFix = double.parse(double.parse(amount).toStringAsFixed(0));
        inquiry();
      }
    }

    return SingleChildScrollView(
        child: Column(children: <Widget>[
      new TextFormField(
        decoration: const InputDecoration(
          labelText: "Harga : ",
          icon: Icon(FontAwesomeIcons.moneyBillWave, color: Colors.black),
        ),
        keyboardType: TextInputType.numberWithOptions(decimal: false),
        validator: (String arg) {
          if (arg.length < 1)
            return 'Harus diisi';
          else if (arg.length > 25)
            return 'Harga terlalu besar';
          else if (arg.contains(".") || arg.contains("-"))
            return "Harga tidak boleh desimal";
          else
            return null;
        },
        onSaved: (String val) {
          amount = val;
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
              "Lanjutkan",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                  fontFamily: "WorkSansBold"),
            ),
          ),
          onPressed: _validateInputs)
    ]));
  }

  Future<void> fetchMerchant() async {
    dismissProgressHUD();
    try {
      Map<String, String> body = {
        'nak': widget.profile.nak,
        'username': widget.profile.ewalletUsername,
        'acctFromNumber': widget.profile.ewalletMsisdn,
        'amount': "0",
        'tips': "0",
        'enumChannel': "ANCOL",
        "fullStringQR": widget.barcode
      };
      final response = await http
          .post(Uri.parse(url), body: json.encode(body), headers: headersWallet)
          .timeout(const Duration(seconds: 30), onTimeout: () {
        showDialogSingleButtonWithAction(_context,
            "Proses inquiry ewallet gagal", "Timeout", "OK", "/HomeScreen");
        dismissProgressHUD();
      });
      if (response.statusCode == 200) {
        final body = json.decode(response.body);

        if (body["body"] != null) {
          if (body["body"]["CreateScanQRISResponse"] != null) {
            // merchantname = body["body"]["CreateScanQRISResponse"]
            //     ["PaymentReserved"]["reserved11"]["_text"];
            merchantname = body["merchantName"];
            setState(() {});
          } else {
            showDialogSingleButtonWithAction(
                _context,
                "Proses inquiry ewallet gagal",
                "QR Code tidak dikenali",
                "OK",
                "/HomeScreen");
          }
        } else {
          showDialogSingleButtonWithAction(_context,
              "Proses inquiry ewallet gagal", body["msg"], "OK", "/HomeScreen");
        }

        dismissProgressHUD();
      } else {
        dismissProgressHUD();
        String ermsg = "";
        if (response.body != "") {
          try {
            final body = json.decode(response.body);
            ermsg = body["msg"].toString() == ""
                ? "QRCode yang anda gunakan tidak valid"
                : "";
          } on FormatException {
            ermsg = "QR Code is not valid format.504";
          }
        } else {
          ermsg = "QRCode yang anda gunakan tidak valid";
        }
        showDialogSingleButtonWithAction(_context,
            "Proses inquiry ewallet gagal", ermsg, "OK", "/HomeScreen");
      }
    } catch (e) {
      print(e);
      showDialogSingleButtonWithAction(
          _context,
          "Proses inquiry ewallet gagal",
          e.message + " . " + e.osError.message.toString(),
          "OK",
          "/HomeScreen");
      dismissProgressHUD();
    }
  }

  Future inquiry() async {
    dismissProgressHUD();
    Map<String, String> body = {
      'nak': widget.profile.nak,
      'username': widget.profile.ewalletUsername,
      'acctFromNumber': widget.profile.ewalletMsisdn,
      'amount': amount,
      'tips': "0",
      'enumChannel': "ANCOL",
      "fullStringQR": widget.barcode
    };
    final response = await http
        .post(Uri.parse(url), body: json.encode(body), headers: headersWallet)
        .timeout(const Duration(seconds: 30), onTimeout: () {
      showDialogSingleButtonWithAction(_context, "Proses inquiry ewallet gagal",
          "Timeout", "OK", "/HomeScreen");
      dismissProgressHUD();
    });
    ;
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      EwalletPaymentReserved ewalletPaymentReserved =
          new EwalletPaymentReserved(
        reference: body["body"]["CreateScanQRISResponse"]
            ["PocketGeneralPayment"]["reference"]["_text"],
        reserved1: body["body"]["CreateScanQRISResponse"]["PaymentReserved"]
            ["reserved1"]["_text"],
        reserved4: body["body"]["CreateScanQRISResponse"]["PaymentReserved"]
            ["reserved4"]["_text"],
        reserved6: body["body"]["CreateScanQRISResponse"]["PaymentReserved"]
            ["reserved6"]["_text"],
        reserved7: body["body"]["CreateScanQRISResponse"]["PaymentReserved"]
            ["reserved7"]["_text"],
        reserved8: body["body"]["CreateScanQRISResponse"]["PaymentReserved"]
            ["reserved8"]["_text"],
        reserved9: body["body"]["CreateScanQRISResponse"]["PaymentReserved"]
            ["reserved9"]["_text"],
        reserved11: body["body"]["CreateScanQRISResponse"]["PaymentReserved"]
            ["reserved11"]["_text"],
        reserved12: body["body"]["CreateScanQRISResponse"]["PaymentReserved"]
            ["reserved12"]["_text"],
        reserved14: body["body"]["CreateScanQRISResponse"]["PaymentReserved"]
            ["reserved14"]["_text"],
        reserved15: body["body"]["CreateScanQRISResponse"]["PaymentReserved"]
            ["reserved15"]["_text"],
        reserved16: body["body"]["CreateScanQRISResponse"]["PaymentReserved"]
            ["reserved16"]["_text"],
        reserved17: body["body"]["CreateScanQRISResponse"]["PaymentReserved"]
            ["reserved17"]["_text"],
        reserved18: body["body"]["CreateScanQRISResponse"]["PaymentReserved"]
            ["reserved18"]["_text"],
        reserved19: body["body"]["CreateScanQRISResponse"]["PaymentReserved"]
            ["reserved19"]["_text"],
        reserved21: body["body"]["CreateScanQRISResponse"]["PaymentReserved"]
            ["reserved21"]["_text"],
        reserved22: body["body"]["CreateScanQRISResponse"]["PaymentReserved"]
            ["reserved22"]["_text"],
        amountPay: body["body"]["CreateScanQRISResponse"]
            ["TransactionFeeDetail"]["amountPay"]["_text"],
      );
      dismissProgressHUD();

      Navigator.push(
        _context,
        MaterialPageRoute(
            builder: (context) => ConfirmTransactionWalletScreen(
                  barcode: widget.barcode,
                  mode: "statis",
                  profile: widget.profile,
                  ewalletPaymentReserved: ewalletPaymentReserved,
                  merchantname: merchantname,
                )),
      );
    } else {
      dismissProgressHUD();
      final body = json.decode(response.body);
      showDialogSingleButton(_context, "Proses inquiry2 ewallet gagal",
          body["msg"].toString(), "OK");
    }
  }
}
