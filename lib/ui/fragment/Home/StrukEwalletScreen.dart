import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kmob/common/functions/format.dart';
import 'package:kmob/common/platform/platformScaffold.dart';
import 'package:kmob/common/widgets/MyAppBar.dart';
import 'package:kmob/utils/constant.dart';
import 'package:progress_hud/progress_hud.dart';

class StrukEwalletScreen extends StatefulWidget {
  final String username;
  final String accountName;
  final String amount;
  final String note;
  final String reference;
  final String noreferensiTransaksi;
  final String tanggalTransaksi;

  const StrukEwalletScreen(
      {Key key,
      this.username,
      this.accountName,
      this.amount,
      this.note,
      this.reference,
      this.noreferensiTransaksi,
      this.tanggalTransaksi})
      : super(key: key);
  @override
  _StrukEwalletScreenState createState() => _StrukEwalletScreenState();
}

class _StrukEwalletScreenState extends State<StrukEwalletScreen> {
  BuildContext _context;
  double maxWidth = 0;
  bool _loading = false;

  double maxHeight = 0;

  Future<bool> _onWillPop() {
    return Navigator.of(context).pushReplacementNamed('/HomeScreen');
  }

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateTime dt = DateTime.parse(widget.tanggalTransaksi);
    // DateTime dt = DateTime.parse(widget.tanggalTransaksi.substring(0, 8) +
    //     'T' +
    //     widget.tanggalTransaksi.substring(8));
    _context = context;
    maxWidth = MediaQuery.of(context).size.width;
    maxHeight = MediaQuery.of(context).size.height >= 775.0
        ? MediaQuery.of(context).size.height
        : 775.0;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: PlatformScaffold(
          appBar: appBarDetail(context, "Struk Transaksi"),
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "e-Wallet K3PG",
                                    style: new TextStyle(
                                        fontFamily: "NeoSansBold",
                                        fontSize: 25.0),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Scan to Pay : BERHASIL",
                                    style: new TextStyle(
                                        fontFamily: "NeoSans", fontSize: 15.0),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Reference : " +
                                        widget.noreferensiTransaksi,
                                    style: new TextStyle(
                                        fontFamily: "NeoSans", fontSize: 15.0),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Nomor Akun : " + widget.username,
                                    style: new TextStyle(
                                        fontFamily: "NeoSans", fontSize: 15.0),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Nama Akun : " + widget.accountName,
                                    style: new TextStyle(
                                        fontFamily: "NeoSans", fontSize: 15.0),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Ref. No : " + widget.reference,
                                    style: new TextStyle(
                                        fontFamily: "NeoSans", fontSize: 15.0),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(16, 8, 8, 16),
                                height: 60,
                                decoration: BoxDecoration(
                                    // borderRadius: BorderRadius.all(Radius.circular(10)),
                                    shape: BoxShape.rectangle,
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.black, width: 3.0),
                                        top: BorderSide(
                                            color: Colors.black, width: 3.0))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "BUKTI PEMBAYARAN",
                                      style: new TextStyle(
                                          fontFamily: "NeoSans",
                                          fontSize: 20.0),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Note : ",
                                    style: new TextStyle(
                                        fontFamily: "NeoSansBold",
                                        fontSize: 18.0),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      widget.note,
                                      style: new TextStyle(
                                          fontFamily: "NeoSans",
                                          fontSize: 18.0),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Total :" +
                                        formatCurrency(
                                            double.parse(widget.amount)),
                                    style: new TextStyle(
                                        fontFamily: "NeoSans", fontSize: 25.0),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.center,
                              //   children: <Widget>[
                              //     Text(
                              //       widget.tanggalTransaksi,
                              //       style: new TextStyle(
                              //           fontFamily: "NeoSans", fontSize: 18.0),
                              //     ),
                              //   ],
                              // ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "" +
                                        formatDate(dateFormat.format(dt), true),
                                    style: new TextStyle(
                                        fontFamily: "NeoSans", fontSize: 12.0),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "K3PG Mobile",
                                    style: new TextStyle(
                                        fontFamily: "NeoSans", fontSize: 18.0),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              MaterialButton(
                                  color: ColorPalette.warnaCorporate,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 42.0),
                                    child: Text(
                                      "Selesai",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15.0,
                                          fontFamily: "WorkSansBold"),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.popUntil(_context,
                                        ModalRoute.withName('/HomeScreen'));
                                  })
                            ],
                          ),
                        ),
                      ),
                    ),
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
      ),
    );
  }
}
