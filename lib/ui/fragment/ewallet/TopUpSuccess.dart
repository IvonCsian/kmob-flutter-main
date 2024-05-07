import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kmob/common/functions/format.dart';
import 'package:kmob/common/platform/platformScaffold.dart';
import 'package:kmob/common/widgets/MyAppBar.dart';
import 'package:kmob/utils/constant.dart';
import 'package:progress_hud/progress_hud.dart';

class TopUpSuccess extends StatefulWidget {
  final String reference;
  final String nak;
  final String nama;
  final String no_hp;
  final String amount;

  const TopUpSuccess(
      {Key key, this.reference, this.nak, this.nama, this.amount, this.no_hp})
      : super(key: key);
  @override
  _TopUpSuccessState createState() => _TopUpSuccessState();
}

class _TopUpSuccessState extends State<TopUpSuccess> {
  BuildContext _context;
  double maxWidth = 0;
  bool _loading = false;

  double maxHeight = 0;

  Future<bool> _onWillPop() {
    Navigator.of(context).pushReplacementNamed('/HomeScreen');
  }

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    // DateTime dt = DateTime.parse("2021-03-05 15:09:20");
    DateTime dt = DateTime.parse(dateFormat.format(DateTime.now()));
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
                                    "Top Up : BERHASIL",
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
                                    "Reference : " + widget.reference,
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
                                    "Nomor Akun : " + widget.no_hp,
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
                                    "Nama Akun : " + widget.nama,
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
                                      "BUKTI TOP UP",
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
                                      "Top Up Ewallet K3PG a.n Anggota " +
                                          widget.nama +
                                          "(" +
                                          widget.no_hp +
                                          ")",
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
                                    Navigator.of(_context)
                                        .pushReplacementNamed('/HomeScreen');
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
