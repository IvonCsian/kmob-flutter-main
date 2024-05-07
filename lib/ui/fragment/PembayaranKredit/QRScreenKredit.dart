import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kmob/common/functions/format.dart';
import 'package:kmob/model/token_kredit_model.dart';
import 'package:kmob/utils/constant.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class QRScreenKredit extends StatefulWidget {
  @override
  _QRScreenKreditState createState() => _QRScreenKreditState();
}

class _QRScreenKreditState extends State<QRScreenKredit> {
  bool _qrshow = false;
  String tokens;
  String url =
      "" + APIConstant.urlBase + "" + APIConstant.serverApi + "/Kredit/active";
  TokenKreditModel tokenKredit;
  String qrcode = "";
  String nominal = "";
  String namatoko = "";
  String cicilan = "";
  String expired = "";
  String pressed = "";

  void dismissQR() {
    setState(() {
      _qrshow = !_qrshow;
    });
  }

  Map<String, String> get headers => {
        'Authorization': 'Bearer $tokens',
        'Content-Type': 'application/json',
      };

  void checkTokenKredit() async {
    final prefs = await SharedPreferences.getInstance();
    tokens = prefs.getString('LastToken') ?? '';
    var response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      _qrshow = true;
      tokenKredit = new TokenKreditModel.fromJson(json.decode(response.body));
      qrcode = tokenKredit.token;
      nominal = formatCurrency(tokenKredit.nominal);
      namatoko = tokenKredit.updatedby;
      cicilan = tokenKredit.cicilan;
      expired = formatDate(tokenKredit.expired, true);
      setState(() {});
    } else {
      _qrshow = false;
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _qrshow
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  child: Container(
                    decoration: BoxDecoration(
                        color: ColorPalette.warnaCorporate,
                        borderRadius:
                            new BorderRadius.all(new Radius.circular(20.0))),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    // color: Color(0xFF015FFF),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 30.0,
                        ),
                        Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("QR CODE Kredit K3PG",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                        fontFamily: "NeoSansBold")),
                              ],
                            ),
                            SizedBox(height: 30.0),
                            Text("$qrcode",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontFamily: "NeoSansBold")),
                            QrImage(
                              data: qrcode,
                              backgroundColor: Colors.white,
                              version: QrVersions.auto,
                              size: 200.0,
                            ),
                            SizedBox(height: 15.0),
                            Text(
                              "Terlampir token anda untuk transaksi kredit $nominal cicilan $cicilan x di Toko $namatoko. Berlaku sampai $expired. Hati hati jangan infokan Token ke sembarang pihak.",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontFamily: "NeoSansBold",
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius:
                              new BorderRadius.all(new Radius.circular(20.0))),
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      // color: Color(0xFF015FFF),
                      child: Text(
                        "Tidak ada transaksi yang sedang anda lakukan",
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontFamily: "NeoSansBold",
                          overflow: TextOverflow.ellipsis,
                        ),
                      )),
                ),
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: ElevatedButton(
              onPressed: () {
                checkTokenKredit();
              },
              child: Text('Generate QR Code'),
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );

    /* return Container(
        height: 500.0,
        child: Column(
          children: <Widget>[
            new GestureDetector(
              onTap: () {
                checkTokenKredit();
              },
              child: new Card(
                  margin: EdgeInsets.all(10.0),
                  elevation: 1.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50.0))),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: ColorPalette.warnaCorporate,
                        borderRadius:
                            new BorderRadius.all(new Radius.circular(20.0))),
                    padding: EdgeInsets.all(5.0),
                    child: Center(
                      child: new Text('Generate QR Code',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontFamily: "NeoSansBold")),
                    ),
                  )),
            ),
            Card(
              margin: EdgeInsets.all(10.0),
              elevation: 1.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50.0))),
              child: _qrshow
                  ? Container(
                      decoration: BoxDecoration(
                          color: ColorPalette.warnaCorporate,
                          borderRadius:
                              new BorderRadius.all(new Radius.circular(20.0))),
                      padding: EdgeInsets.all(5.0),
                      // color: Color(0xFF015FFF),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 30.0,
                          ),
                          Container(
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text("QR CODE Kredit K3PG",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0,
                                            fontFamily: "NeoSansBold")),
                                  ],
                                ),
                                SizedBox(height: 20.0),
                                SizedBox(height: 10.0),
                                Text("$qrcode",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                        fontFamily: "NeoSansBold")),
                                QrImage(
                                  data: qrcode,
                                  backgroundColor: Colors.white,
                                  version: QrVersions.auto,
                                  size: 200.0,
                                ),
                                SizedBox(height: 15.0),
                                Text(
                                    "Terlampir token anda untuk transaksi kredit $nominal cicilan $cicilan x di Toko $namatoko. Berlaku sampai $expired. Hati hati jangan infokan Token ke sembarang pihak.",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                        fontFamily: "NeoSansBold")),
                              ],
                            ),
                          )
                        ],
                      ))
                  : Container(
                      decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius:
                              new BorderRadius.all(new Radius.circular(20.0))),
                      padding: EdgeInsets.all(5.0),
                      // color: Color(0xFF015FFF),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                    "Tidak ada transaksi yang sedang anda lakukan",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                        fontFamily: "NeoSansBold")),
                              ],
                            ),
                          )
                        ],
                      )),
            ),
          ],
        )); */
  }
}
