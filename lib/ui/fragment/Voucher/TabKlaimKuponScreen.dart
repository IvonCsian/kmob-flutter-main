import 'dart:convert';

import 'package:badges/badges.dart' as badge;
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kmob/common/functions/format.dart';
import 'package:kmob/common/functions/future.dart';
import 'package:kmob/common/functions/showDialogSingleButton.dart';
import 'package:kmob/model/voucher_model.dart';
import 'package:kmob/utils/constant.dart';
import 'package:progress_hud/progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TabKlaimKuponScreen extends StatefulWidget {
  @override
  _TabKlaimKuponScreenState createState() => _TabKlaimKuponScreenState();
}

class _TabKlaimKuponScreenState extends State<TabKlaimKuponScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var textController = new TextEditingController();

  bool _loading = false;
  bool _exists = false;
  CouponModel kupon;
  String barcode = "";

  //main build method
  @override
  void initState() {
    super.initState();
    _exists = false;
  }

  BuildContext _context;
  Widget build(BuildContext context) {
    _context = context;
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(5.0),
          color: Colors.grey[200],
          child: ListView(
            children: <Widget>[
              new Form(
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
              if (_exists)
                Card(
                  elevation: 2.0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 8.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 0),
                          child: new Text(
                            "Detail Kupon",
                            style: new TextStyle(
                                fontFamily: "WorkSansBold", fontSize: 14.0),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                              borderRadius: new BorderRadius.all(
                                  new Radius.circular(40.0)),
                              border: Border.all(
                                  color: ColorPalette.warnaCorporate,
                                  width: 10.0)),
                          padding: EdgeInsets.all(10.0),
                          child: new Column(
                            children: <Widget>[
                              SizedBox(
                                height: 10.0,
                              ),
                              Center(
                                child: Text(
                                  kupon.keterangan,
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontFamily: "NeoSans",
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: 16.0,
                              ),
                              Center(
                                child: Text(
                                  "Nominal :",
                                  style: TextStyle(
                                      fontSize: 20.0, fontFamily: "NeoSans"),
                                ),
                              ),
                              Center(
                                child: Text(
                                  formatCurrency(kupon.nominal),
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontFamily: "NeoSans",
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              // badge.Badge(
                              //   badgeColor: widget.param.splittable.toString() == "0"
                              //       ? Colors.blue[600]
                              //       : Colors.green[600],
                              //   shape: badge.BadgeShape.square,
                              //   borderRadius: 20,
                              //   toAnimate: false,
                              //   badgeContent: Text(
                              //       widget.param.splittable.toString() == "0"
                              //           ? "Hanya berlaku untuk sekali pakai"
                              //           : "Dapat digunakan beberapa kali.",
                              //       style: new TextStyle(
                              //           fontFamily: "WorkSansMedium",
                              //           fontSize: 15.0,
                              //           color: Colors.white)),
                              // ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Center(
                                child: Text(
                                  "Tipe Voucher : ",
                                  style: TextStyle(
                                      fontSize: 15.0, fontFamily: "NeoSans"),
                                ),
                              ),
                              Center(
                                child: Text(
                                  kupon.tipe,
                                  style: TextStyle(
                                      fontSize: 15.0, fontFamily: "NeoSans"),
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Center(
                                child: Text(
                                  "Valid Hingga : ",
                                  style: TextStyle(
                                      fontSize: 15.0, fontFamily: "NeoSans"),
                                ),
                              ),
                              Center(
                                child: Text(
                                  formatDate(kupon.validTo),
                                  style: TextStyle(
                                      fontSize: 15.0, fontFamily: "NeoSans"),
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              badge.Badge(
                                badgeColor: kupon.idStatus.toString() == "2"
                                    ? Colors.blue[600]
                                    : (kupon.idStatus.toString() == "3" ||
                                            kupon.idStatus.toString() == "4")
                                        ? Colors.yellow[600]
                                        : kupon.idStatus.toString() == "5"
                                            ? Colors.green[600]
                                            : Colors.red[600],
                                shape: badge.BadgeShape.square,
                                borderRadius: BorderRadius.circular(20),
                                toAnimate: false,
                                badgeContent: Text(
                                    kupon.voucherstatus.toString(),
                                    style: new TextStyle(
                                        fontFamily: "WorkSansMedium",
                                        fontSize: 15.0,
                                        color: Colors.white)),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              kupon.idStatus != 6
                                  ? ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  ColorPalette.green)),
                                      child: new Text(
                                        'Klaim',
                                        style:
                                            new TextStyle(color: Colors.white),
                                      ),
                                      onPressed: klaimProses)
                                  : Column(
                                      children: <Widget>[
                                        Center(
                                          child: Text(
                                            "Diredeem di " +
                                                kupon.redeemFrom +
                                                " : ",
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                fontFamily: "NeoSans"),
                                          ),
                                        ),
                                        Center(
                                          child: Text(
                                            kupon.redeemDate != ""
                                                ? formatDate(
                                                    kupon.redeemDate, true)
                                                : "",
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                fontFamily: "NeoSans"),
                                          ),
                                        ),
                                      ],
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (_loading)
          new ProgressHUD(
            backgroundColor: Colors.black12,
            color: Colors.white,
            containerColor: Colors.blue,
            borderRadius: 5.0,
            text: 'Loading data...',
          ),
      ],
    );
  }

  Map<String, String> get headers => {
        'Authorization': 'Bearer $tokens',
        'Content-Type': 'application/json',
      };

  fetchData() async {
    String inputbarcode = barcode;
    textController.text = '';

    String url =
        "" + APIConstant.urlBase + "" + APIConstant.serverApi + "/Coupon";
    Map<String, String> body = {'kode_coupon': inputbarcode};

    final prefs = await SharedPreferences.getInstance();
    tokens = prefs.getString('LastToken') ?? '';
    var response = await http.post(Uri.parse(url),
        headers: headers, body: json.encode(body));

    if (response.statusCode == 200) {
      kupon = new CouponModel.fromJson(json.decode(response.body));
      setState(() {
        textController.clear();
        _exists = true;
      });
    } else {
      showDialogSingleButton(
          _context,
          "Gagal",
          "Kupon tidak valid, silahkan periksa kembali Kode Kupon yang Anda masukkan.",
          "OK");
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
    }
  }

  klaimProses() async {
    String url = "" +
        APIConstant.urlBase +
        "" +
        APIConstant.serverApi +
        "/Coupon/redeem";
    Map<String, String> body = {'kode_coupon': barcode};

    final prefs = await SharedPreferences.getInstance();
    tokens = prefs.getString('LastToken') ?? '';
    var response = await http.post(Uri.parse(url),
        headers: headers, body: json.encode(body));

    if (response.statusCode == 200) {
      showDialogSingleButtonWithAction(
          _context, "Berhasil", response.body.toString(), "OK", '/HomeScreen');
    } else if (response.statusCode == 205) {
      showDialogSingleButton(_context, "Error", response.body.toString(), "OK");
    } else {
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
    }

    setState(() {
      _exists = true;
    });
  }

  Widget _buildForm() {
    void _validateInputs() {
      if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
        _formKey.currentState.save();
        fetchData();
      }
    }

    Future scan() async {
      try {
        var result = await BarcodeScanner.scan();

        String barcode = result.rawContent;
        setState(() {
          this.barcode = barcode;
          textController.text = barcode;
        });
      } on PlatformException catch (e) {
        if (e.code == BarcodeScanner.cameraAccessDenied) {
          setState(() {
            this.barcode = 'The user did not grant the camera permission!';
          });
        } else {
          setState(() => this.barcode = 'Unknown error: $e');
        }
      } on FormatException {
        setState(() => this.barcode =
            'null (User returned using the "back"-button before scanning anything. Result)');
      } catch (e) {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        new TextFormField(
          decoration: const InputDecoration(
            labelText: "Kode Kupon : ",
            icon: Icon(FontAwesomeIcons.userTag, color: Colors.blue),
          ),
          keyboardType: TextInputType.text,
          maxLength: 50,
          obscureText: true,
          controller: textController,
          validator: (String arg) {
            if (arg.length < 1)
              return 'Kode kupon kosong';
            else
              return null;
          },
          onSaved: (String val) {
            barcode = val;
          },
        ),
        new SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  padding: MaterialStateProperty.all(EdgeInsets.all(10)),
                ),
                // padding: EdgeInsets.all(10),
                // color: Colors.red,
                // textColor: Colors.white,
                // splashColor: Colors.blueGrey,
                onPressed: scan,
                child: Column(
                  children: <Widget>[
                    Icon(Icons.camera_alt),
                    Text('Scan Dari Kamera')
                  ],
                )),
            new SizedBox(
              width: 10.0,
            ),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(ColorPalette.warnaCorporate),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  padding: MaterialStateProperty.all(EdgeInsets.all(10)),
                ),
                // padding: EdgeInsets.all(10),
                // color: ColorPalette.warnaCorporate,
                // textColor: Colors.white,
                // splashColor: Colors.blueGrey,
                onPressed: _validateInputs,
                child: Column(
                  children: <Widget>[Icon(Icons.check), Text('Proses')],
                )),
          ],
        ),
        new SizedBox(
          height: 10.0,
        ),
      ],
    );
  }
}
