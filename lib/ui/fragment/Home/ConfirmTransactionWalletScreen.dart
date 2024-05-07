import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kmob/common/functions/format.dart';
import 'package:kmob/common/functions/showDialogSingleButton.dart';
import 'package:kmob/common/platform/platformScaffold.dart';
import 'package:kmob/common/widgets/MyAppBar.dart';
import 'package:kmob/model/ewallet_model.dart';
import 'package:kmob/model/profile_model.dart';
import 'package:kmob/ui/fragment/Home/StrukEwalletScreen.dart';
import 'package:kmob/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:progress_hud/progress_hud.dart';

class ConfirmTransactionWalletScreen extends StatefulWidget {
  final String barcode;
  final String mode;
  final String merchantname;
  final ProfileModel profile;
  final EwalletPaymentReserved ewalletPaymentReserved;

  const ConfirmTransactionWalletScreen(
      {Key key,
      this.barcode,
      this.mode,
      this.profile,
      this.ewalletPaymentReserved,
      this.merchantname})
      : super(key: key);
  @override
  _ConfirmTransactionWalletScreenState createState() =>
      _ConfirmTransactionWalletScreenState();
}

class _ConfirmTransactionWalletScreenState
    extends State<ConfirmTransactionWalletScreen> {
  String url = APIConstant.url + "confirmtransaction";
  double maxWidth = 0;
  double maxHeight = 0;
  double amountFix = 0;
  String amount = "";
  String _newPassword = "";
  bool _loading = false;
  void dismissProgressHUD() {
    setState(() {
      _loading = !_loading;
    });
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  BuildContext _context;
  Map<String, String> get headersWallet => {
        'x-key': "\$^DR&MYUTIL*EIU&Juk98onu98OI&KU(*OIU)d",
        'Content-Type': 'application/json',
        'app-id': "8A53A5C5-8B3D-4624-ACFA-C14945EC4F88"
      };

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
                                  "Informasi Merchant & Pembayaran",
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
                              widget.merchantname,
                              style: TextStyle(
                                  fontSize: 12.0, fontFamily: "NeoSansBold"),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              formatCurrency(
                                  double.parse(
                                      widget.ewalletPaymentReserved.amountPay),
                                  0),
                              style: TextStyle(
                                  fontSize: 12.0, fontFamily: "NeoSansBold"),
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
        payNow();
      } else {
        //    If all data are not valid then start auto validation.
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
          else if (arg.length > 25)
            return 'Kata sandi terlalu panjang';
          else
            return null;
        },
        onSaved: (String val) {
          _newPassword = val;
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
              "Bayar Sekarang",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                  fontFamily: "WorkSansBold"),
            ),
          ),
          onPressed: _validateInputs)
    ]));
  }

  Future<void> payNow() async {
    dismissProgressHUD();
    try {
      Map<String, String> body = {
        'nak': widget.profile.nak,
        'username': widget.profile.ewalletUsername,
        'password': _newPassword,
        'enumChannel': "ANCOL",
        'reference': widget.ewalletPaymentReserved.reference,
        'reserved1': widget.ewalletPaymentReserved.reserved1,
        'reserved4': widget.ewalletPaymentReserved.reserved4,
        'reserved6': widget.ewalletPaymentReserved.reserved6,
        'reserved7': widget.ewalletPaymentReserved.reserved7,
        'reserved8': widget.ewalletPaymentReserved.reserved8,
        'reserved9': widget.ewalletPaymentReserved.reserved9,
        'reserved11': widget.ewalletPaymentReserved.reserved11,
        'reserved12': widget.ewalletPaymentReserved.reserved12,
        'reserved14': widget.ewalletPaymentReserved.reserved14,
        'reserved15': widget.ewalletPaymentReserved.reserved15,
        'reserved16': widget.ewalletPaymentReserved.reserved16,
        'reserved17': widget.ewalletPaymentReserved.reserved17,
        'reserved18': widget.ewalletPaymentReserved.reserved18,
        'reserved19': widget.ewalletPaymentReserved.reserved19,
        'reserved21': widget.ewalletPaymentReserved.reserved21,
        'reserved22': widget.ewalletPaymentReserved.reserved22,
      };
      final response = await http
          .post(Uri.parse(url), body: json.encode(body), headers: headersWallet)
          .timeout(const Duration(seconds: 30), onTimeout: () {
        showDialogSingleButtonWithAction(_context,
            "Proses inquiry ewallet gagal", "Timeout", "OK", "/HomeScreen");
        dismissProgressHUD();
      });
      if (response.statusCode == 200) {
        dismissProgressHUD();

        final body = json.decode(response.body);
        if (body["code"] != null) {
          switch (body["errorcode"]) {
            case "9999":
              showDialogSingleButton(_context, "Gagal",
                  body["msg"] + ". Error Code : " + body["errorcode"], "OK");
              break;
            case "2001":
              showDialogSingleButton(
                  _context,
                  "Gagal",
                  body["msg"] +
                      ". User akan terblokir ketika pin salah 3x secara beruntun. Error Code : " +
                      body["errorcode"],
                  "OK");
              break;
            case "3008":
              showDialogSingleButton(_context, "Info",
                  body["msg"] + ". Code : " + body["errorcode"], "OK");
              updateSaldo();
              break;
            default:
              showDialogSingleButton(
                  _context,
                  "Gagal",
                  body["msg"] +
                      ". User akan terblokir ketika pin salah 3x secara beruntun. Error Code : " +
                      body["errorcode"],
                  "OK");
              break;
          }
        }
        String responseCode =
            body["body"]["ConfirmScanQRISResponse"]["responseCode"]["_text"];
        String responseMessage =
            body["body"]["ConfirmScanQRISResponse"]["responseMessage"]["_text"];
        switch (responseCode) {
          case "9999":
            showDialogSingleButton(_context, "Gagal", responseMessage, "OK");
            break;
          case "6120":
            showDialogSingleButton(_context, "Gagal", responseMessage, "OK");
            break;
          case "1000":
            updateSaldo();
            final body2 =
                body["body"]["ConfirmScanQRISResponse"]["PocketGeneralPayment"];
            String _username = body2["acctFromNumber"]["_text"];
            String _accountName = body2["acctFromName"]["_text"];
            String _amount = body2["amount"]["_text"];
            String _note = body2["note"]["_text"];
            String _reference = body2["reference"]["_text"];
            String _noreferensiTransaksi = body["body"]
                ["ConfirmScanQRISResponse"]["noRefferenceTrx"]["_text"];
            String _tanggalTransaksi = body["status"]["datetime"];
            // String _tanggalTransaksi = body["body"]["ConfirmScanQRISResponse"]
            //     ["transactionDate"]["_text"];

            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => StrukEwalletScreen(
                          username: _username,
                          accountName: _accountName,
                          amount: _amount,
                          note: _note,
                          reference: _reference,
                          noreferensiTransaksi: _noreferensiTransaksi,
                          tanggalTransaksi: _tanggalTransaksi,
                        )));
            // showDialogSingleButton(_context, "Berhasil", responseMessage, "OK");

            break;
          default:
            break;
        }

        print(body);
        setState(() {});
      } else {
        try {
          final body = json.decode(response.body);
          showDialogSingleButton(_context, "Proses pembayaran ewallet gagal",
              body["msg"].toString(), "OK");
        } catch (e) {
          print(e);
          showDialogSingleButtonWithAction(
              _context,
              "Proses Konfirmasi Pembayaran ewallet gagal",
              "Server Timeout. Please contact administrator. Please check your balance.",
              "OK",
              "/HomeScreen");
        }
      }
    } catch (e) {
      print(e);
      showDialogSingleButtonWithAction(
          _context,
          "Proses Konfirmasi Pembayaran ewallet gagal",
          e.message + " . " + e.osError.message.toString(),
          "OK",
          "/HomeScreen");
      dismissProgressHUD();
    }
  }

  String tokens;
  Map<String, String> get headers => {
        'Authorization': 'Bearer $tokens',
        'Content-Type': 'application/json',
      };
  Future<void> updateSaldo() async {
    String saldo = "0";
    Map<String, String> body = {
      'password': _newPassword,
      'nak': widget.profile.nak,
      'username': widget.profile.ewalletUsername,
      'enumChannel': "ANCOL",
    };
    final response = await http
        .post(Uri.parse(APIConstant.url + "myaccount"),
            body: json.encode(body), headers: headersWallet)
        .timeout(const Duration(seconds: 30), onTimeout: () {
      showDialogSingleButtonWithAction(_context, "Proses inquiry ewallet gagal",
          "Timeout", "OK", "/HomeScreen");
      dismissProgressHUD();
    });
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      if (body["body"]["GetListPrimaryAccountResponse"] != null) {
        saldo = body["body"]["GetListPrimaryAccountResponse"]["VirtualAccount"]
            ["amount"]["_text"];
        Map<String, String> body2 = {'saldo': saldo};
        String urlUpdate = "" +
            APIConstant.urlBase +
            "" +
            APIConstant.serverApi +
            "/profile/updateSaldo";
        final prefs = await SharedPreferences.getInstance();
        tokens = prefs.getString('LastToken') ?? '';
        final response2 = await http
            .post(Uri.parse(urlUpdate),
                headers: headers, body: json.encode(body2))
            .timeout(const Duration(seconds: 30), onTimeout: () {
          showDialogSingleButtonWithAction(_context,
              "Proses inquiry ewallet gagal", "Timeout", "OK", "/HomeScreen");
          dismissProgressHUD();
        });

        if (response2.statusCode == 200) {
          Navigator.of(context).pushReplacementNamed("/HomeScreen");
        } else {
          Navigator.of(context).pushReplacementNamed("/HomeScreen");
        }
      } else {
        Navigator.of(context).pushReplacementNamed("/HomeScreen");
      }
    } else {
      Navigator.of(context).pushReplacementNamed("/HomeScreen");
    }
  }
}
