import 'package:badges/badges.dart' as badge;
import 'package:flutter/material.dart';
import 'package:kmob/common/functions/format.dart';
import 'package:kmob/common/functions/future.dart';
import 'package:kmob/common/platform/platformScaffold.dart';
import 'package:kmob/common/widgets/MyAppBar.dart';
import 'package:kmob/model/voucher_model.dart';
import 'package:kmob/utils/constant.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:barcode_widget/barcode_widget.dart';

import '../../../common/functions/showDialogSingleButton.dart';

class DetailVoucherScreen extends StatefulWidget {
  final VoucherModel param;

  const DetailVoucherScreen({Key key, this.param}) : super(key: key);

  @override
  _DetailVoucherScreenState createState() => _DetailVoucherScreenState();
}

showAlertDialog(BuildContext context, String message) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("TUTUP "),
    onPressed: () {},
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("KODE VOUCHER: "),
    content: Text(message),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class _DetailVoucherScreenState extends State<DetailVoucherScreen> {
  bool _lihatvoucher = false;
  @override
  Widget build(BuildContext context) {
    var listdeposito = Container(
        padding: EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new Container(
                margin: EdgeInsets.all(10.0),
                child: FutureBuilder(
                  future: getDataVoucherLog(context, widget.param.kodeVoucher),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      int i = 0;
                      return new Column(
                          children: snapshot.data.map<Widget>((data) {
                        i = i++;
                        return rowDataVoucherLog(data, context);
                      }).toList());
                    }
                    return Center(
                      child: SizedBox(
                          width: 40.0,
                          height: 40.0,
                          child: const CircularProgressIndicator()),
                    );
                  },
                ),
              )
            ]));
    return SafeArea(
      child: PlatformScaffold(
        // appBar: new MyAppBar(_selectedDrawerIndex),
        appBar: appBarDetail(context, "Detail Voucher"),
        backgroundColor: Colors.white,
        body: Container(
          child: new ListView(
            physics: ClampingScrollPhysics(),
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(20.0)),
                    border: Border.all(
                        color: ColorPalette.warnaCorporate, width: 3.0)),
                padding: EdgeInsets.all(10.0),
                child: new Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10.0,
                    ),
                    Center(
                      child: Text(
                        widget.param.tipe,
                        style: TextStyle(
                            fontSize: 25.0,
                            fontFamily: "NeoSans",
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    new ClipRRect(
                      borderRadius: new BorderRadius.circular(8.0),
                      child: QrImage(
                        data: widget.param.kodeVoucher,
                        version: QrVersions.auto,
                        size: 250.0,
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Center(
                      child: Text(
                        "Nominal :",
                        style: TextStyle(fontSize: 20.0, fontFamily: "NeoSans"),
                      ),
                    ),
                    Center(
                      child: Text(
                        formatCurrency(widget.param.nominal),
                        style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: "NeoSans",
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Center(
                      child: Text(
                        "Terpakai :" +
                            formatCurrency(widget.param.nominalTerpakai),
                        style: TextStyle(fontSize: 15.0, fontFamily: "NeoSans"),
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Center(
                      child: Text(
                        "Sisa :" +
                            formatCurrency((widget.param.nominal -
                                widget.param.nominalTerpakai)),
                        style: TextStyle(fontSize: 15.0, fontFamily: "NeoSans"),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    badge.Badge(
                      badgeColor: widget.param.splittable.toString() == "0"
                          ? Colors.blue[600]
                          : Colors.green[600],
                      shape: badge.BadgeShape.square,
                      borderRadius: BorderRadius.circular(20),
                      toAnimate: false,
                      badgeContent: Text(
                          widget.param.splittable.toString() == "0"
                              ? "Hanya berlaku sekali pakai"
                              : "Dapat digunakan beberapa kali.",
                          style: new TextStyle(
                              fontFamily: "WorkSansMedium",
                              fontSize: 15.0,
                              color: Colors.white)),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Center(
                      child: Text(
                        "Valid Hingga : ",
                        style: TextStyle(fontSize: 15.0, fontFamily: "NeoSans"),
                      ),
                    ),
                    Center(
                      child: Text(
                        formatDate(widget.param.validTo),
                        style: TextStyle(fontSize: 15.0, fontFamily: "NeoSans"),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    badge.Badge(
                      badgeColor: widget.param.idStatus.toString() == "2"
                          ? Colors.blue[600]
                          : (widget.param.idStatus.toString() == "3" ||
                                  widget.param.idStatus.toString() == "4")
                              ? Colors.yellow[600]
                              : widget.param.idStatus.toString() == "5"
                                  ? Colors.green[600]
                                  : Colors.red[600],
                      shape: badge.BadgeShape.square,
                      borderRadius: BorderRadius.circular(20),
                      toAnimate: false,
                      badgeContent: Text(widget.param.voucherstatus.toString(),
                          style: new TextStyle(
                              fontFamily: "WorkSansMedium",
                              fontSize: 15.0,
                              color: Colors.white)),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Center(
                          child: BarcodeWidget(
                        height: 100.0,
                        barcode: Barcode.code128(),
                        drawText: false,
                        data: widget.param.kodeVoucher,
                      )),
                    ),
                    OutlinedButton(
                      child: Text(
                        'Tampilkan Kode Voucher',
                        style: TextStyle(color: Colors.grey),
                      ),
                      onPressed: () {
                        showDialogSingleButton(
                            context,
                            'KODE VOUCHER: ',
                            'Gunakan kode voucher ini jika QRCODE atau BARCODE tidak dapat terbaca oleh scanner kasir. \r\n\r\n' +
                                widget.param.kodeVoucher,
                            'TUTUP');
                      },
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                      foregroundColor: MaterialStateProperty.all(Colors.white)),
                  // color: Colors.red,
                  // textColor: Colors.white,
                  onPressed: () {},
                  child: Text('RIWAYAT TRANSAKSI :'),
                ),
                // child: new Text(
                //   "Riwayat Transaksi",

                //   style:
                //       new TextStyle(fontFamily: "WorkSansBold", fontSize: 14.0),
                // ),
              ),
              Container(
                  child: new Column(
                children: <Widget>[
                  listdeposito,
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }

  lihatVoucher() {
    setState(() {
      _lihatvoucher = !_lihatvoucher;
    });
  }
}
