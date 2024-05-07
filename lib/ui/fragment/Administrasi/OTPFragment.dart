import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kmob/common/functions/showDialogSingleButton.dart';
import 'package:kmob/common/platform/platformScaffold.dart';
import 'package:kmob/common/widgets/MyAppBar.dart';
import 'package:kmob/model/profile_model.dart';
import 'package:kmob/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sms_otp_auto_verify/sms_otp_auto_verify.dart';

class OTPFragment extends StatefulWidget {
  final ProfileModel profile;
  final String tempatlahir;
  final String tanggal;
  final String password;
  final String hp;
  final String hpexist;

  final String ewalletId;
  final String ewalletName;
  final String ewalletUsername;
  final String ewalletMsisdn;
  final String ewalletEmail;
  const OTPFragment({
    Key key,
    this.profile,
    this.tempatlahir,
    this.tanggal,
    this.password,
    this.hp,
    this.hpexist,
    this.ewalletId,
    this.ewalletName,
    this.ewalletUsername,
    this.ewalletMsisdn,
    this.ewalletEmail,
  }) : super(key: key);
  @override
  _OTPFragmentState createState() => _OTPFragmentState();
}

class _OTPFragmentState extends State<OTPFragment> {
  TextEditingController controller1 = new TextEditingController();
  TextEditingController controller2 = new TextEditingController();
  TextEditingController controller3 = new TextEditingController();
  TextEditingController controller4 = new TextEditingController();
  TextEditingController controller5 = new TextEditingController();
  TextEditingController controller6 = new TextEditingController();

  TextEditingController currController = new TextEditingController();
  BuildContext _context;
  int _otpCodeLength = 6;
  bool _isLoadingButton = false;
  bool _enableButton = false;
  String _otpCode = "";
  @override
  void dispose() {
    super.dispose();
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    controller4.dispose();
    controller5.dispose();
    controller6.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getSignatureCode();
    currController = controller1;
  }

  /// get signature code
  _getSignatureCode() async {
    String signature = await SmsVerification.getAppSignature();
    // String signature = await SmsRetrieved.getAppSignature();
    print("signature $signature");
  }

  _onSubmitOtp() {
    setState(() {
      _isLoadingButton = !_isLoadingButton;
      _verifyOtpCode();
    });
  }

  _onOtpCallBack(String otpCode, bool isAutofill) {
    setState(() {
      this._otpCode = otpCode;
      if (otpCode.length == _otpCodeLength && isAutofill) {
        _enableButton = false;
        _isLoadingButton = true;
        _verifyOtpCode();
      } else if (otpCode.length == _otpCodeLength && !isAutofill) {
        _enableButton = true;
        _isLoadingButton = false;
      } else {
        _enableButton = false;
      }
    });
  }

  String tokens;
  String urlRegister = APIConstant.url + "registercust";

  Map<String, String> get headersKmobile => {
        'Authorization': 'Bearer $tokens',
        'Content-Type': 'application/json',
      };

  _verifyOtpCode() {
    FocusScope.of(context).requestFocus(new FocusNode());
    Timer(Duration(milliseconds: 4000), () async {
      setState(() {
        _isLoadingButton = false;
        _enableButton = false;
      });

      Map<String, String> body = {'hp': widget.hp, 'otp': _otpCode};

      final prefs = await SharedPreferences.getInstance();
      tokens = prefs.getString('LastToken') ?? '';
      final response = await http.post(
          Uri.parse(
              APIConstant.urlBase + APIConstant.serverApi + "/Otp/verify"),
          headers: headersKmobile,
          body: json.encode(body));

      if (response.statusCode == 200) {
        if (widget.hpexist == null) {
          Map<String, String> body = {
            'firstName': widget.profile.nmAng,
            'lastName': widget.profile.nmAng,
            'placeOfBirth': widget.tempatlahir,
            'dateOfBirth': widget.tanggal,
            'password': widget.password,
            'msisdn': widget.hp,
            'email': widget.profile.email,
            'productName': "ANCOL",
            'nak': widget.profile.nak,
          };
          final response = await http.post(Uri.parse(urlRegister),
              body: json.encode(body), headers: headers);
          if (response.statusCode == 200) {
            final body = json.decode(response.body);
            if (body['body'] != null) {
              if (body['body']['RegisterNonCustomerJomiResponse'] == null) {
                showDialogSingleButton(
                    _context,
                    "Proses Aktivasi E-Wallet gagal",
                    body['body']['Fault']['faultstring']['_text'],
                    "OK");
              } else {
                showDialogSingleButton(
                    context,
                    "Proses Aktivasi E-Wallet berhasil dilakukan",
                    "Terima kasih",
                    "OK");
                Timer(Duration(seconds: 2), () {
                  Navigator.of(context).pushReplacementNamed('/HomeScreen');
                });
              }
            } else {
              final body = json.decode(response.body);
              showDialogSingleButton(
                  context, "Aktivasi gagal", body["msg"].toString(), "OK");
            }
          } else {
            final body = json.decode(response.body);
            showDialogSingleButton(
                context, "Aktivasi gagal", body["msg"].toString(), "OK");
          }
        } else {
          Map<String, String> body = {
            'ewallet_id': widget.ewalletId,
            'ewallet_name': widget.ewalletName,
            'ewallet_username': widget.ewalletUsername,
            'ewallet_msisdn': widget.ewalletMsisdn,
            'ewallet_email': widget.ewalletEmail,
          };
          final response = await http.post(
              Uri.parse("http://35.197.136.216/api/Profile/link_ewallet"),
              body: json.encode(body),
              headers: headersKmobile);
          if (response.statusCode == 200) {
            showDialogSingleButton(
                context,
                "Proses Tautan KMobile dan Akun JakOne berhasil dilakukan",
                "Terima kasih",
                "OK");
            Timer(Duration(seconds: 2), () {
              Navigator.of(context).pushReplacementNamed('/HomeScreen');
            });
          }
        }
      } else {
        showDialogSingleButton(_context, "OTP gagal", "OTP tidak sama", "OK");
      }
    });
  }

  Map<String, String> get headers => {
        'x-key': "\$^DR&MYUTIL*EIU&Juk98onu98OI&KU(*OIU)d",
        'Content-Type': 'application/json',
        'app-id': "8A53A5C5-8B3D-4624-ACFA-C14945EC4F88"
      };
  Widget _setUpButtonChild() {
    if (_isLoadingButton) {
      return Container(
        width: 19,
        height: 19,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else {
      return Text(
        "Verify",
        style: TextStyle(color: Colors.white),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return new PlatformScaffold(
      resizeToAvoidBottomPadding: false,
      appBar: appBarDetail(context, "Enter OTP"),
      backgroundColor: Color(0xFFeaeaea),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Verifying your number!",
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, top: 4.0, right: 16.0),
                    child: Text(
                      "Please type the verification code sent to",
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.normal),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 30.0, top: 2.0, right: 30.0),
                    child: Text(
                      widget.hp,
                      style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Image(
                      image: AssetImage('assets/img/otp-icon.png'),
                      height: 120.0,
                      width: 120.0,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFieldPin(
                      defaultBoxSize: 10,
                      // filled: true,
                      // filledColor: Colors.white60,
                      codeLength: _otpCodeLength,
                      // boxSize: 40,
                      // filledAfterTextChange: false,
                      textStyle: TextStyle(fontSize: 16),
                      // borderStyle: OutlineInputBorder(
                      //     borderSide: BorderSide.none,
                      //     borderRadius: BorderRadius.circular(0)),
                      onChange: (code) {
                        return _onOtpCallBack(code, false);
                      }),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      width: double.maxFinite,
                      child: MaterialButton(
                        onPressed: _enableButton ? _onSubmitOtp : null,
                        child: _setUpButtonChild(),
                        color: Colors.blue,
                        disabledColor: Colors.blue[100],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
