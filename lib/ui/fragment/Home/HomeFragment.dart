import 'dart:async';
import 'dart:convert';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kmob/common/functions/format.dart';
import 'package:kmob/common/functions/future.dart';
import 'package:kmob/common/functions/showDialogSingleButton.dart';
import 'package:kmob/model/ewallet_model.dart';
import 'package:kmob/model/home_model.dart';
import 'package:kmob/model/profile_model.dart';
import 'package:kmob/ui/fragment/Home/EwalletDetail.dart';
import 'package:kmob/ui/fragment/Home/W_Promo.dart';
import 'package:kmob/ui/fragment/Home/W_Summary.dart';
import 'package:kmob/ui/fragment/ewallet/TopUpInquiry.dart';
import 'package:kmob/utils/constant.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/keyboard.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'ConfirmTransactionWalletScreen.dart';
import 'MerchantScreen.dart';
import 'package:loading/loading.dart';

typedef MenuCallback = void Function(String menu);

class HomeFragment extends StatefulWidget {
  const HomeFragment({this.onMenuSelect});
  final MenuCallback onMenuSelect;

  @override
  _HomeFragmentState createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();
  bool isAuthenticated = false;
  final pinController = TextEditingController();
  double saldo = 0;
  String token;
  String barcode = "";
  String pin = "";
  bool saldoAda = false;
  bool checkingProgress = false;
  BuildContext _context;

  List<K3PGService> _k3pgServiceList = [
    new K3PGService(
        image: FontAwesomeIcons.moneyBill,
        color: ColorPalette.menuRide,
        mode: "simpanan",
        title: "SIMPANAN"),
    new K3PGService(
        image: FontAwesomeIcons.moneyCheck,
        color: ColorPalette.menuCar,
        mode: "pinjaman",
        title: "PINJAMAN"),
    new K3PGService(
        image: FontAwesomeIcons.funnelDollar,
        color: ColorPalette.menuBluebird,
        mode: "ratesimpanan",
        title: "RATE SIMPANAN"),
    new K3PGService(
        image: FontAwesomeIcons.calculator,
        color: ColorPalette.menuFood,
        mode: "ratepinjaman",
        title: "RATE PINJAMAN"),
    new K3PGService(
        image: FontAwesomeIcons.tags,
        color: ColorPalette.menuSend,
        mode: "promosi",
        title: "PROMOSI"),
    new K3PGService(
        image: FontAwesomeIcons.cogs,
        color: Colors.black,
        mode: "administrasi",
        title: "ADMINISTRASI"),
    new K3PGService(
        image: FontAwesomeIcons.creditCard,
        color: Colors.pink,
        mode: "produkjasa",
        title: "PEMBAYARAN KREDIT"),
    new K3PGService(
        image: FontAwesomeIcons.book,
        color: Colors.orange[500],
        mode: "bantuan",
        title: "BANTUAN")
  ];

  ProfileModel profile;
  bool isData = false;
  String ewalletId = "";
  Map<String, String> get headersWallet => {
        'x-key': "\$^DR&MYUTIL*EIU&Juk98onu98OI&KU(*OIU)d",
        'Content-Type': 'application/json',
        'app-id': "8A53A5C5-8B3D-4624-ACFA-C14945EC4F88"
      };

  fetchJson() async {
    final prefs = await SharedPreferences.getInstance();
    tokens = prefs.getString('LastToken') ?? '';

    var response = await executeRequest(
      url,
      // headers: headers,
    );

    if (response.statusCode == 200) {
      profile = new ProfileModel.fromJson(json.decode(response.body));
      ewalletId = profile.ewalletId;
      isData = true;
      setState(() {});
      Map<String, String> body = {
        'msisdn': profile.ewalletMsisdn,
        'nak': profile.nak,
        'enumChannel': "ANCOL",
      };
      final response2 = await http.post(
          Uri.parse(APIConstant.url + "channelinfo"),
          body: json.encode(body),
          headers: headersWallet);
      if (response2.statusCode == 200) {
        final body = json.decode(response2.body);
        if (body["body"]["GetAccountInformationOtherChannelResponse"] != null) {
          saldo = double.parse(body["body"]
                  ["GetAccountInformationOtherChannelResponse"]
              ["AccountInformation"]["availableBalance"]["_text"]);
        }
        saldoAda = true;
      }

      if (mounted) {
        setState(() {});
      }
    } else {
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();

    // fetchJson();
  }

  @override
  void dispose() {
    _verificationNotifier.close();
    super.dispose();
  }

  String tokens;
  String url = APIConstant.urlBase + APIConstant.serverApi + "/profile";

  Map<String, String> get headers => {
        'Authorization': 'Bearer $tokens',
        'Content-Type': 'application/json',
      };

  _openPopup(context) {
    Alert(
        context: context,
        title: "Masukkan PIN eWallet",
        content: Column(
          children: <Widget>[
            new TextField(
              decoration: const InputDecoration(
                labelText: "Masukkan 6 digit PIN : ",
                icon: Icon(FontAwesomeIcons.lock, color: Colors.black),
              ),
              keyboardType: TextInputType.number,
              maxLength: 6,
              obscureText: true,
              controller: pinController,
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () {
              if (pinController.text != "") {
                if (!checkingProgress) checkpin();
              } else {
                showDialogSingleButton(
                    _context, "Warning", "Form tidak lengkap", "OK");
              }
            },
            child: Text(
              "LOGIN",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  checkpin() async {
    checkingProgress = true;
    bool isValid = false;
    pin = pinController.text;
    pinController.text = "";
    Map<String, String> body = {
      'password': pin,
      'nak': profile.nak,
      'username': profile.ewalletUsername,
      'enumChannel': "ANCOL",
    };
    final response = await http.post(Uri.parse(APIConstant.url + "myaccount"),
        body: json.encode(body), headers: headersWallet);
    if (response.statusCode == 200) {
      checkingProgress = false;
      final body = json.decode(response.body);
      if (body["code"] != null && body["code"] != "200") {
        checkingProgress = false;
        final body = json.decode(response.body);
        String message = body["msg"];
        showDialogSingleButton(
            _context, "Warning", message + ". Please try again later.", "OK");
      }
      if (body["body"]["GetListPrimaryAccountResponse"] != null) {
        _verificationNotifier.add(isValid);
        isValid = true;
        if (isValid) {
          Navigator.pushAndRemoveUntil(
              _context,
              MaterialPageRoute(
                  builder: (context) =>
                      EwalletDetail(profile: profile, password: pin)),
              ModalRoute.withName("/HomeScreen"));
        }
      } else {
        checkingProgress = false;
        final body = json.decode(response.body);
        String message = body["body"]["Fault"]["faultstring"]["_text"];
        showDialogSingleButton(
            _context, "Warning", message + ". Please try again later.", "OK");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Container(
        child: new ListView(
      physics: ClampingScrollPhysics(),
      children: <Widget>[
        new Container(
            // padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
            color: Colors.white,
            child: new Column(
              children: <Widget>[
                HomeSummary(),
                isData
                    ? ewalletId != ""
                        ? ewalletMenu()
                        : ewalletMenuDisable()
                    : SizedBox(
                        height: 10.0,
                      ),
                APIConstant.mode == "PROD"
                    ? menu()
                    : SizedBox(
                        height: 10,
                      ),
                HomePromo(),
              ],
            )),
      ],
    ));
  }

  Widget ewalletMenuDisable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: new Text(
                "E-WALLET",
                style:
                    new TextStyle(fontFamily: "WorkSansBold", fontSize: 14.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: new Text(
                "powered by ",
                style: new TextStyle(fontFamily: "WorkSans", fontSize: 10.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: new Text(
                "JakOne",
                style:
                    new TextStyle(fontFamily: "WorkSansBold", fontSize: 10.0),
              ),
            ),
          ],
        ),
        InkWell(
          onTap: () {
            widget.onMenuSelect("administrasi");
          },
          child: Container(
            decoration: new BoxDecoration(
                color: Colors.grey,
                borderRadius: new BorderRadius.all(new Radius.circular(20.0))),
            height: 70.0,
            padding: EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 0),
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text("Uang Elektronik belum aktif",
                              style: new TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.white,
                                  fontFamily: "WorkSansBold")),
                        ],
                      ),
                      SizedBox(
                        width: 15.0,
                      ),
                      Row(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              new Container(
                                child: new Icon(
                                  FontAwesomeIcons.wallet,
                                  color: Colors.white,
                                  size: 18.0,
                                ),
                              ),
                              new Padding(
                                padding: EdgeInsets.only(top: 6.0),
                              ),
                              Center(
                                child: new Text(
                                  "AKTIFKAN",
                                  style: new TextStyle(
                                      fontSize: 10.0,
                                      color: Colors.white,
                                      fontFamily: "WorkSansBold"),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  _showLockScreen(BuildContext context,
      {bool opaque,
      CircleUIConfig circleUIConfig,
      KeyboardUIConfig keyboardUIConfig,
      Widget cancelButton,
      List<String> digits}) {
    Navigator.push(
        context,
        PageRouteBuilder(
          opaque: opaque,
          pageBuilder: (context, animation, secondaryAnimation) =>
              PasscodeScreen(
            title: Text(
              'Enter App Passcode',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 28),
            ),
            circleUIConfig: circleUIConfig,
            keyboardUIConfig: keyboardUIConfig,
            passwordEnteredCallback: _onPasscodeEntered,
            cancelButton: cancelButton,
            deleteButton: Text(
              'Delete',
              style: const TextStyle(fontSize: 16, color: Colors.white),
              semanticsLabel: 'Delete',
            ),
            shouldTriggerVerification: _verificationNotifier.stream,
            backgroundColor: Colors.black.withOpacity(0.8),
            cancelCallback: _onPasscodeCancelled,
            digits: digits,
          ),
        ));
  }

  _onPasscodeCancelled() {
    Navigator.maybePop(context);
  }

  void dismissProgressHUD() {
    setState(() {
      _loading = !_loading;
    });
  }

  bool _loading = false;
  _onPasscodeEntered(String enteredPasscode) async {
    dismissProgressHUD();
    bool isValid = false;
    Map<String, String> body = {
      'password': enteredPasscode,
      'nak': profile.nak,
      'username': profile.ewalletUsername,
      'enumChannel': "ANCOL",
    };
    final response = await http.post(Uri.parse(APIConstant.url + "myaccount"),
        body: json.encode(body), headers: headersWallet);
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      if (body["body"]["GetListPrimaryAccountResponse"] != null) {
        _verificationNotifier.add(isValid);
        isValid = true;
        if (isValid) {
          Navigator.pushAndRemoveUntil(
              _context,
              MaterialPageRoute(
                  builder: (context) => EwalletDetail(
                      profile: profile, password: enteredPasscode)),
              ModalRoute.withName("/HomeScreen"));

          setState(() {
            this.isAuthenticated = isValid;
          });
        }
      } else {
        dismissProgressHUD();
        final body = json.decode(response.body);
        String message = body["body"]["Fault"]["faultstring"]["_text"];
        showDialogSingleButton(
            _context, "Warning", message + ". Please try again later.", "OK");
      }
    }
  }

  Widget ewalletMenu() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: new Text(
            "E-WALLET powered by JakOne",
            style: new TextStyle(fontFamily: "WorkSansBold", fontSize: 14.0),
          ),
        ),
        Container(
          decoration: new BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [const Color(0xff3164bd), const Color(0xff295cb5)],
              ),
              borderRadius: new BorderRadius.all(new Radius.circular(20.0))),
          height: 70.0,
          padding: EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 0),
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text("Saldo anda saat ini : ",
                            style: new TextStyle(
                                fontSize: 13.0,
                                color: Colors.white,
                                fontFamily: "WorkSansBold")),
                        new Padding(
                          padding: EdgeInsets.only(top: 6.0),
                        ),
                        saldoAda
                            ? Text(formatCurrency(saldo),
                                style: new TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.white,
                                    fontFamily: "WorkSansBold"))
                            : Loading(
                                indicator: BallPulseIndicator(),
                                size: 20.0,
                                color: Colors.white),
                      ],
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Row(
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            scan();
                          },
                          child: Column(
                            children: <Widget>[
                              new Container(
                                child: new Icon(
                                  FontAwesomeIcons.camera,
                                  color: Colors.white,
                                  size: 18.0,
                                ),
                              ),
                              new Padding(
                                padding: EdgeInsets.only(top: 6.0),
                              ),
                              Center(
                                child: new Text(
                                  "Scan QR",
                                  style: new TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.white,
                                      fontFamily: "WorkSansBold"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                                _context,
                                MaterialPageRoute(
                                    builder: (context) => TopUpInquiry(
                                          profile: profile,
                                        )),
                                ModalRoute.withName("/HomeScreen"));
                          },
                          child: Column(
                            children: <Widget>[
                              new Container(
                                child: new Icon(
                                  FontAwesomeIcons.moneyBill,
                                  color: Colors.white,
                                  size: 18.0,
                                ),
                              ),
                              new Padding(
                                padding: EdgeInsets.only(top: 6.0),
                              ),
                              Center(
                                child: new Text(
                                  "Top Up",
                                  style: new TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.white,
                                      fontFamily: "WorkSansBold"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        InkWell(
                          onTap: () {
                            _openPopup(_context);
                            // _showLockScreen(
                            //   context,
                            //   opaque: false,
                            //   cancelButton: Text(
                            //     'Cancel',
                            //     style: const TextStyle(
                            //         fontSize: 16, color: Colors.white),
                            //     semanticsLabel: 'Cancel',
                            //   ),
                            // );
                          },
                          child: Column(
                            children: <Widget>[
                              new Container(
                                child: new Icon(
                                  FontAwesomeIcons.ellipsisV,
                                  color: Colors.white,
                                  size: 18.0,
                                ),
                              ),
                              new Padding(
                                padding: EdgeInsets.only(top: 7.0),
                              ),
                              Center(
                                child: new Text(
                                  "More",
                                  style: new TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.white,
                                      fontFamily: "WorkSansBold"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Future scan() async {
    try {
      var result = await BarcodeScanner.scan();

      String barcode = result.rawContent;

      // var result = await BarcodeScanner.scan();

      // String barcode = result.rawContent;

      String barrcode = barcode;
      //tag and cut
      barrcode = barrcode.substring(2, barrcode.length);
      //digit and cut
      int length = int.parse(barrcode.substring(0, 2));
      barrcode = barrcode.substring(2, barrcode.length);
      //after length and cut
      barrcode = barrcode.substring(length, barrcode.length);

      //dinamis or statis start
      barrcode = barrcode.substring(2, barrcode.length);
      //digit and cut
      int length2 = int.parse(barrcode.substring(0, 2));
      barrcode = barrcode.substring(2, barrcode.length);
      //after length and cut
      String afterlength2 = barrcode.substring(0, length2);
      barrcode = barrcode.substring(length2, barrcode.length);

      // Navigator.pushAndRemoveUntil(
      //     _context,
      //     MaterialPageRoute(builder: (context) => PanduanTopUp()),
      //     ModalRoute.withName("/HomeScreen"));
      String mode = "";
      String merchantname;
      switch (afterlength2) {
        case "11":
          mode = "statis";
          Navigator.push(
            _context,
            MaterialPageRoute(
                builder: (context) => MerchantScreen(
                    barcode: barcode, mode: mode, profile: profile)),
          );
          break;
        case "12":
          mode = "dinamis";
          try {
            Map<String, String> body = {
              'nak': profile.nak,
              'username': profile.ewalletUsername,
              'acctFromNumber': profile.ewalletMsisdn,
              'amount': "0",
              'tips': "0",
              'enumChannel': "ANCOL",
              "fullStringQR": barcode
            };
            final response = await http
                .post(Uri.parse(APIConstant.url + "scantoinquiryv2"),
                    body: json.encode(body), headers: headersWallet)
                .timeout(const Duration(seconds: 30), onTimeout: () {
              showDialogSingleButtonWithAction(
                  _context,
                  "Proses inquiry ewallet gagal",
                  "Timeout",
                  "OK",
                  "/HomeScreen");
            });
            if (response.statusCode == 200) {
              final body = json.decode(response.body);
              if (body["body"] != null) {
                if (body["body"]["CreateScanQRISResponse"] != null) {
                  merchantname = body["merchantName"];
                  EwalletPaymentReserved ewalletPaymentReserved =
                      new EwalletPaymentReserved(
                    reference: body["body"]["CreateScanQRISResponse"]
                        ["PocketGeneralPayment"]["reference"]["_text"],
                    reserved1: body["body"]["CreateScanQRISResponse"]
                        ["PaymentReserved"]["reserved1"]["_text"],
                    reserved4: body["body"]["CreateScanQRISResponse"]
                        ["PaymentReserved"]["reserved4"]["_text"],
                    reserved6: body["body"]["CreateScanQRISResponse"]
                        ["PaymentReserved"]["reserved6"]["_text"],
                    reserved7: body["body"]["CreateScanQRISResponse"]
                        ["PaymentReserved"]["reserved7"]["_text"],
                    reserved8: body["body"]["CreateScanQRISResponse"]
                        ["PaymentReserved"]["reserved8"]["_text"],
                    reserved9: body["body"]["CreateScanQRISResponse"]
                        ["PaymentReserved"]["reserved9"]["_text"],
                    reserved11: body["body"]["CreateScanQRISResponse"]
                        ["PaymentReserved"]["reserved11"]["_text"],
                    reserved12: body["body"]["CreateScanQRISResponse"]
                        ["PaymentReserved"]["reserved12"]["_text"],
                    reserved14: body["body"]["CreateScanQRISResponse"]
                        ["PaymentReserved"]["reserved14"]["_text"],
                    reserved15: body["body"]["CreateScanQRISResponse"]
                        ["PaymentReserved"]["reserved15"]["_text"],
                    reserved16: body["body"]["CreateScanQRISResponse"]
                        ["PaymentReserved"]["reserved16"]["_text"],
                    reserved17: body["body"]["CreateScanQRISResponse"]
                        ["PaymentReserved"]["reserved17"]["_text"],
                    reserved18: body["body"]["CreateScanQRISResponse"]
                        ["PaymentReserved"]["reserved18"]["_text"],
                    reserved19: body["body"]["CreateScanQRISResponse"]
                        ["PaymentReserved"]["reserved19"]["_text"],
                    reserved21: body["body"]["CreateScanQRISResponse"]
                        ["PaymentReserved"]["reserved21"]["_text"],
                    reserved22: body["body"]["CreateScanQRISResponse"]
                        ["PaymentReserved"]["reserved22"]["_text"],
                    amountPay: body["body"]["CreateScanQRISResponse"]
                        ["TransactionFeeDetail"]["amountPay"]["_text"],
                  );

                  Navigator.push(
                    _context,
                    MaterialPageRoute(
                        builder: (context) => ConfirmTransactionWalletScreen(
                              barcode: barcode,
                              mode: "dinamis",
                              profile: profile,
                              ewalletPaymentReserved: ewalletPaymentReserved,
                              merchantname: merchantname,
                            )),
                  );
                } else {
                  showDialogSingleButtonWithAction(
                      _context,
                      "QR Code tidak valid",
                      body["msg"].toString(),
                      "Kembali",
                      "/HomeScreen");
                }
              } else {
                showDialogSingleButtonWithAction(
                    _context,
                    "Proses inquiry ewallet gagal",
                    body["msg"],
                    "OK",
                    "/HomeScreen");
                // showDialogSingleButtonWithAction(_context, "QR Code tidak valid",
                //     body["msg"].toString(), "Kembali", "/HomeScreen");
              }
            } else if (response.statusCode == 500) {
              showDialogSingleButton(
                  _context,
                  "Proses inquiry QR dinamis ewallet gagal",
                  "Qr Code tidak valid",
                  "OK");
            } else {
              final body = json.decode(response.body);
              showDialogSingleButton(_context, "Proses inquiry2 ewallet gagal",
                  body["msg"].toString(), "OK");
            }
          } catch (e) {
            print(e);
            showDialogSingleButtonWithAction(
                _context,
                "Proses inquiry ewallet gagal",
                e.message + " . " + e.osError.message.toString(),
                "OK",
                "/HomeScreen");
          }
          break;
        default:
      }
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          // this.barcode = 'The user did not grant the camera permission!';
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

  Widget menu() {
    return Container(
      padding: EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          new Text(
            "MENU",
            style: new TextStyle(fontFamily: "WorkSansBold", fontSize: 14.0),
          ),
          new SizedBox(
              width: double.infinity,
              height: 200.0,
              child: new Container(
                  child: GridView.builder(
                      physics: ClampingScrollPhysics(),
                      itemCount: _k3pgServiceList.length,
                      gridDelegate:
                          new SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4),
                      itemBuilder: (context, position) {
                        return _rowMenuService(
                            _k3pgServiceList[position], position);
                      }))),
        ],
      ),
    );
  }

  Widget _rowMenuService(K3PGService gojekService, int position) {
    return new Container(
      child: InkWell(
        onTap: () {
          widget.onMenuSelect(gojekService.mode);
        },
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
              decoration: new BoxDecoration(
                  border: Border.all(color: ColorPalette.grey200, width: 1.0),
                  borderRadius:
                      new BorderRadius.all(new Radius.circular(10.0))),
              padding: EdgeInsets.all(6.0),
              child: new Icon(
                gojekService.image,
                color: gojekService.color,
                size: 28.0,
              ),
            ),
            new Padding(
              padding: EdgeInsets.only(top: 6.0),
            ),
            Center(
              child: new Text(
                gojekService.title,
                style: new TextStyle(fontSize: 9.0, fontFamily: "WorkSansBold"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
