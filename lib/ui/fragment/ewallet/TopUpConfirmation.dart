import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kmob/common/functions/format.dart';
import 'package:kmob/common/functions/showDialogSingleButton.dart';
import 'package:kmob/common/platform/platformScaffold.dart';
import 'package:kmob/common/widgets/MyAppBar.dart';
import 'package:kmob/model/profile_model.dart';
import 'package:kmob/ui/fragment/ewallet/TopUpSuccess.dart';
import 'package:kmob/utils/constant.dart';
import 'package:http/http.dart' as http;
import 'package:progress_hud/progress_hud.dart';

class TopUpConfirmation extends StatefulWidget {
  final String input_nomor_hp;
  final String keyTransaction;
  final String input_nak;
  final String input_amount;
  final String adminfeemu;
  final String inquiry_private_48;
  final String inquiry_private_59;
  final String inquiry_private_63;
  final String inquiry_private_61;
  final String inquiry_dest_account;
  final String inquiry_fee_account;
  final String location_name;
  final ProfileModel profile;

  const TopUpConfirmation(
      {Key key,
      this.profile,
      this.keyTransaction,
      this.input_nomor_hp,
      this.input_nak,
      this.input_amount,
      this.inquiry_private_48,
      this.inquiry_private_59,
      this.inquiry_private_63,
      this.inquiry_dest_account,
      this.inquiry_fee_account,
      this.location_name,
      this.inquiry_private_61,
      this.adminfeemu})
      : super(key: key);
  @override
  _TopUpConfirmationState createState() => _TopUpConfirmationState();
}

class _TopUpConfirmationState extends State<TopUpConfirmation> {
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

  @override
  Widget build(BuildContext context) {
    _context = context;
    maxWidth = MediaQuery.of(context).size.width;
    maxHeight = MediaQuery.of(context).size.height >= 775.0
        ? MediaQuery.of(context).size.height
        : 775.0;
    return SafeArea(
      child: PlatformScaffold(
        appBar: appBarDetail(context, "Top Up Ewallet"),
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
                                  "Informasi Topup",
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontFamily: "NeoSansBold"),
                                ),
                              ],
                            ),
                            IconButton(
                              iconSize: 80.0,
                              icon: new Icon(
                                FontAwesomeIcons.moneyBillWave,
                                color: ColorPalette.warnaCorporate,
                              ),
                              onPressed: () {},
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  widget.inquiry_private_61
                                      .replaceAll(new RegExp(r"\s+"), "")
                                      .replaceAll("|", "\n"),
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontFamily: "NeoSansBold"),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              "Nominal :" +
                                  formatCurrency(
                                      double.parse(widget.input_amount)),
                              style: TextStyle(
                                  fontSize: 14.0, fontFamily: "NeoSansBold"),
                            ),
                            Text(
                              "( Termasuk Biaya Top Up : " +
                                  formatCurrency(
                                      double.parse(widget.adminfeemu)) +
                                  ")",
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
                      child: Container(
                        width: maxWidth,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                                10.0, 10.0, 40.0, 8.0),
                            child: _buildForm(),
                          ),
                          elevation: 2.0,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
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
        processtopup();

        // amountFix = double.parse(double.parse(amount).toStringAsFixed(0));
        // inquiry();
      }
    }

    return SingleChildScrollView(
        child: Column(children: <Widget>[
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

  Map<String, String> get headers => {
        'x-key': "\$^DR&MYUTIL*EIU&Juk98onu98OI&KU(*OIU)d",
        'Content-Type': 'application/json',
        'app-id': "8A53A5C5-8B3D-4624-ACFA-C14945EC4F88"
      };
  String tokens;
  Future<void> processtopup() async {
    dismissProgressHUD();
    // Map<String, String> body = {
    //   'hp': hp,
    // };

    Map<String, String> body = {
      'input_nomor_hp': widget.input_nomor_hp,
      'input_nak': widget.input_nak,
      'input_amount': widget.input_amount,
      'inquiry_private_48': widget.inquiry_private_48,
      'inquiry_private_59': widget.inquiry_private_59,
      'inquiry_private_63': widget.inquiry_private_63,
      'inquiry_dest_account': widget.inquiry_dest_account,
      'inquiry_fee_account': widget.inquiry_fee_account,
      'key_transaction': widget.keyTransaction,
      'location_name': 'GRESIK'
    };
    final response = await http
        .post(Uri.parse(APIConstant.url + "topup_jurnal_validation"),
            headers: headers, body: json.encode(body))
        .timeout(const Duration(seconds: 60), onTimeout: () {
      showDialogSingleButtonWithAction(
          _context,
          "Proses confirmation topup ewallet gagal",
          "Timeout",
          "OK",
          "/HomeScreen");
      dismissProgressHUD();
    });

    if (response.statusCode == 200) {
      dismissProgressHUD();
      final rv = json.decode(response.body);
      if (rv["code"] != null) {
        if (rv["code"] == 200) {
          final rvdata = rv["response_data"];
          String response_proses_name = rv["response_proses_name"];
          if (response_proses_name == "trx_biller_payment") {
            String ref = rvdata["RETRIEVAL_REFERENCE_NUMBER"] == null
                ? ""
                : rvdata["RETRIEVAL_REFERENCE_NUMBER"];
            //testing by pass
            Navigator.push(
                _context,
                MaterialPageRoute(
                    builder: (context) => TopUpSuccess(
                          reference: ref,
                          nak: widget.input_nak,
                          nama: widget.profile.ewalletName,
                          no_hp: widget.input_nomor_hp,
                          amount: widget.input_amount,
                        )));
          } else {
            showDialogSingleButton(
                context, "Error", rv["response_message"], "OK");
          }
        } else {
          if (rv["msg"] != null) {
            showDialogSingleButton(context, "Error", rv["msg"], "OK");
          } else if (rv["response_proses_name"] != null) {
            showDialogSingleButton(
                context, "Error", rv["response_message"], "OK");
          }
        }
      } else if (response.statusCode == 401) {
        dismissProgressHUD();
        Navigator.of(context).pushReplacementNamed('/LoginScreen');
      } else {
        if (response.reasonPhrase != null) {
          showDialogSingleButton(context, "Error", response.reasonPhrase, "OK");
        }
        dismissProgressHUD();
      }
    }
  }
}
