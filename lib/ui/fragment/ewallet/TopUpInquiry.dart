import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kmob/common/functions/format.dart';
import 'package:kmob/common/functions/showDialogSingleButton.dart';
import 'package:kmob/common/platform/platformScaffold.dart';
import 'package:kmob/common/widgets/MyAppBar.dart';
import 'package:kmob/model/profile_model.dart';
import 'package:kmob/model/source_fund_model.dart';
import 'package:kmob/ui/fragment/ewallet/TopUpConfirmation.dart';
import 'package:kmob/utils/constant.dart';
import 'package:http/http.dart' as http;

import 'package:progress_hud/progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TopUpInquiry extends StatefulWidget {
  final ProfileModel profile;

  const TopUpInquiry({Key key, this.profile}) : super(key: key);
  @override
  _TopUpInquiryState createState() => _TopUpInquiryState();
}

class _TopUpInquiryState extends State<TopUpInquiry> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  double maxWidth = 0;
  double maxHeight = 0;
  String tanggalString = "*belum dipilih";
  String nominal;
  String saldo = "";
  double saldoV = 0;
  double adminfee = 0;
  BuildContext _context;
  SourceFundModel _sourceFundModel;
  List<SourceFundModel> _sourceFundModels = [];

  bool _loading = false;
  void dismissProgressHUD() {
    setState(() {
      _loading = !_loading;
    });
  }

  @override
  void initState() {
    super.initState();
    SourceFundModel ss1 = new SourceFundModel(simpanan: "SS 1", abbrev: "SS1");
    _sourceFundModels.add(ss1);
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
        appBar: appBarDetail(context, "Sumber Dana"),
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
        'x-key': "\$^DR&MYUTIL*EIU&Juk98onu98OI&KU(*OIU)d",
        'Content-Type': 'application/json',
        'app-id': "8A53A5C5-8B3D-4624-ACFA-C14945EC4F88"
      };
  String tokens;

  processtopup() async {
    dismissProgressHUD();
    // Map<String, String> body = {
    //   'hp': hp,
    // };

    Map<String, String> body = {
      'amount': nominal,
      'nak': widget.profile.nak,
      'location_name': 'GRESIK',
      'nomorhp': widget.profile.ewalletMsisdn
    };
    final prefs = await SharedPreferences.getInstance();
    tokens = prefs.getString('LastToken') ?? '';
    // final response = await http.post(APIConstant.urlBase + "" + APIConstant.serverApi + "/Otp/insert",
    //     headers: headersKmobile,
    //     body: json.encode(body));

    final response = await http
        .post(Uri.parse(APIConstant.url + "topup_inquiry"),
            headers: headers, body: json.encode(body))
        .timeout(const Duration(seconds: 60), onTimeout: () {
      showDialogSingleButtonWithAction(
          _context,
          "Proses inquiry top up ewallet gagal",
          "Timeout",
          "OK",
          "/HomeScreen");
      dismissProgressHUD();
    });

    if (response.statusCode == 200) {
      dismissProgressHUD();
      final rv = json.decode(response.body);
      if (rv["code"] != null) {
        if (rv["code"] == 200 &&
            rv["response_proses_name"] == "trx_bill_inquiry") {
          final rvdata = rv["response_data"];
          Navigator.push(
              _context,
              MaterialPageRoute(
                  builder: (context) => TopUpConfirmation(
                        adminfeemu: rv["adminfeemu"],
                        keyTransaction: rv["key_transaction"],
                        profile: widget.profile,
                        input_nomor_hp: widget.profile.ewalletMsisdn,
                        input_nak: widget.profile.nak,
                        input_amount: double.parse(rvdata["AMOUNT"])
                            .toString()
                            .replaceAll(RegExp(r"([.]*0)(?!.*\d)"), ""),
                        inquiry_private_48: rvdata["PRIVATE_48"] != null
                            ? rvdata["PRIVATE_48"]
                            : "",
                        inquiry_private_59: rvdata["PRIVATE_59"] != null
                            ? rvdata["PRIVATE_59"]
                            : "",
                        inquiry_private_63: rvdata["PRIVATE_63"] != null
                            ? rvdata["PRIVATE_63"]
                            : "",
                        inquiry_private_61: rvdata["PRIVATE_61"] != null
                            ? rvdata["PRIVATE_61"]
                            : "",
                        inquiry_dest_account: rvdata["DEST_ACCOUNT"] != null
                            ? rvdata["DEST_ACCOUNT"]
                            : "",
                        inquiry_fee_account: rvdata["FEE_ACCOUNT"] != null
                            ? rvdata["FEE_ACCOUNT"]
                            : "",
                        location_name: "GRESIK",
                      )));
        } else {
          if (rv["msg"] != null) {
            showDialogSingleButton(context, "Error", rv["msg"], "OK");
          } else {
            showDialogSingleButton(
                context, "Error", rv["response_message"], "OK");
          }
        }
      } else {
        showDialogSingleButton(context, "Error", rv["msg"], "OK");
      }
    } else if (response.statusCode == 401) {
      dismissProgressHUD();
      Navigator.of(context).pushReplacementNamed('/LoginScreen');
    } else {
      dismissProgressHUD();
    }
  }

  _buildForm() {
    void _validateInputs() {
      _formKey.currentState.save();
      if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
        double nominalD = double.parse(nominal);
        if (nominalD < 10000) {
          showDialogSingleButton(
              _context, "Peringatan", 'Nominal minimal Rp. 10.000', "OK");
        }
        if (saldoV >= nominalD) {
          processtopup();
        } else {
          showDialogSingleButton(
              _context, "Peringatan", 'Saldo Anda tidak cukup', "OK");
        }
      } else {
        setState(() {});
      }
    }

    return SingleChildScrollView(
        child: Column(children: <Widget>[
      DropdownButtonFormField<SourceFundModel>(
        decoration: const InputDecoration(
          labelText: "Sumber Dana : ",
          icon: Icon(FontAwesomeIcons.coins, color: Colors.black),
        ),
        validator: (SourceFundModel arg) {
          if (arg == null)
            return 'Harus diisi';
          else
            return null;
        },
        onSaved: (SourceFundModel newValue) {
          setState(() {
            _sourceFundModel = newValue;
          });
        },
        value: _sourceFundModel,
        onChanged: (SourceFundModel newValue) {
          setState(() {
            _sourceFundModel = newValue;
          });
          if (newValue.abbrev == "SS1") {
            getSaldo();
          }
        },
        items: _sourceFundModels.map((SourceFundModel item) {
          return new DropdownMenuItem<SourceFundModel>(
            value: item,
            child: new SizedBox(
              width: 190.0,
              child: new Text(
                item.simpanan,
                style: new TextStyle(color: Colors.black),
              ),
            ),
          );
        }).toList(),
      ),
      SizedBox(
        height: 10.0,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          new Text(
            saldo,
            style: new TextStyle(fontFamily: "WorkSans", fontSize: 15.0),
          ),
        ],
      ),
      SizedBox(
        height: 10.0,
      ),
      new TextFormField(
        decoration: const InputDecoration(
          labelText: "Nominal Top up : ",
          icon: Icon(FontAwesomeIcons.moneyBillWave, color: Colors.black),
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
              "Lanjutkan",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                  fontFamily: "WorkSansBold"),
            ),
          ),
          onPressed: _validateInputs)
    ]));
  }

  Future<void> getSaldo() async {
    dismissProgressHUD();
    Map<String, String> body = {'nak': widget.profile.nak};

    final response = await http
        .post(Uri.parse(APIConstant.url + "ceksaldoanggota"),
            headers: headers, body: json.encode(body))
        .timeout(const Duration(seconds: 60), onTimeout: () {
      showDialogSingleButtonWithAction(
          _context,
          "Proses inquiry top up ewallet gagal",
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
          final rvdata = rv["detail_data"];
          saldo = "Saldo anda : " +
              formatCurrency(double.parse(rvdata["totalsaldo"].toString())) +
              "\n Biaya Admin : " +
              formatCurrency(double.parse(rvdata["adminfee"]));
          saldoV = double.parse(rvdata["totalsaldo"].toString());
          adminfee = double.parse(rvdata["adminfee"].toString());
          setState(() {});
        } else {
          if (rv["msg"] != null) {
            showDialogSingleButton(context, "Error", rv["msg"], "OK");
          } else {
            showDialogSingleButton(
                context, "Error", rv["response_message"], "OK");
          }
        }
      } else {
        showDialogSingleButton(context, "Error", "Contact Administrator", "OK");
      }
    } else if (response.statusCode == 401) {
      dismissProgressHUD();
      Navigator.of(context).pushReplacementNamed('/LoginScreen');
    } else {
      dismissProgressHUD();
      saldo = "Saldo anda : " + formatCurrency(0);
      saldoV = 0;
      adminfee = 0;
      setState(() {});
    }
  }
}
