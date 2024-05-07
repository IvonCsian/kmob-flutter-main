import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kmob/common/platform/platformScaffold.dart';
import 'package:kmob/common/widgets/MyAppBar.dart';
import 'package:kmob/model/profile_model.dart';
import 'package:kmob/ui/fragment/Administrasi/OTPFragment.dart';
import 'package:kmob/utils/constant.dart';
import 'package:progress_hud/progress_hud.dart';
import 'package:http/http.dart' as http;

class LinkExistFragment extends StatefulWidget {
  final ProfileModel profile;

  const LinkExistFragment({Key key, this.profile}) : super(key: key);
  @override
  _LinkExistFragmentState createState() => _LinkExistFragmentState();
}

class _LinkExistFragmentState extends State<LinkExistFragment> {
  double maxWidth = 0;
  double maxHeight = 0;
  String hp;
  bool isExist = false;
  String nama = "";
  String ewalletId;
  String ewalletName;
  String ewalletUsername;
  String ewalletMsisdn;
  String ewalletEmail;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String url = APIConstant.url + "registercust";

  BuildContext _context;
  bool _loading = false;
  void dismissProgressHUD() {
    setState(() {
      _loading = !_loading;
    });
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
        appBar: appBarDetail(context, "Link Account JakOne"),
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

  _buildForm() {
    void _validateInputs() {
      _formKey.currentState.save();
      if (_formKey.currentState.validate()) {
        detailUser();
      } else {
        setState(() {});
      }
    }

    return SingleChildScrollView(
        child: Column(children: <Widget>[
      new TextFormField(
        decoration: const InputDecoration(
          labelText: "No Hp yang telah terdaftar : ",
          icon: Icon(FontAwesomeIcons.lock, color: Colors.black),
        ),
        keyboardType: TextInputType.number,
        maxLength: 15,
        validator: (String arg) {
          if (arg.length < 1)
            return 'Harus diisi';
          else if (arg.length > 25)
            return 'Kata sandi terlalu panjang';
          else
            return null;
        },
        onSaved: (String val) {
          hp = val;
        },
      ),
      SizedBox(
        height: 10.0,
      ),
      new Text(
        "Sistem akan mengirim sms OTP ke no hp anda. Pastikan no hp yang anda masukkan valid dan pulsa anda cukup untuk menerima SMS dari Bank DKI. Sistem akan terblokir setelah 3x kesalahan percobaan",
        style: new TextStyle(fontFamily: "WorkSans", fontSize: 10.0),
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
              "CEK NO HP",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                  fontFamily: "WorkSansBold"),
            ),
          ),
          onPressed: _validateInputs),
      SizedBox(
        height: 10.0,
      ),
      isExist
          ? Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent, width: 3),
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(15.0),
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Nama : "),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(nama),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                          color: ColorPalette.warnaCorporate,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 42.0),
                            child: Text(
                              "KIRIM OTP",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  fontFamily: "WorkSansBold"),
                            ),
                          ),
                          onPressed: _kirimotp),
                    ],
                  ),
                ],
              ),
            )
          : SizedBox(
              height: 10.0,
            ),
    ]));
  }

  Map<String, String> get headersWallet => {
        'x-key': "\$^DR&MYUTIL*EIU&Juk98onu98OI&KU(*OIU)d",
        'Content-Type': 'application/json',
        'app-id': "8A53A5C5-8B3D-4624-ACFA-C14945EC4F88"
      };
  Future<void> detailUser() async {
    dismissProgressHUD();
    Map<String, String> body = {
      'msisdn': hp,
      'nak': widget.profile.nak,
      'enumChannel': "ANCOL",
    };
    final response2 = await http.post(
        Uri.parse(APIConstant.url + "channelinfo"),
        body: json.encode(body),
        headers: headersWallet);
    if (response2.statusCode == 200) {
      final body = json.decode(response2.body);
      if (body["body"]["GetAccountInformationOtherChannelResponse"] != null) {
        isExist = true;
        String firstName = body["body"]
            ["GetAccountInformationOtherChannelResponse"]["firstName"]["_text"];
        String lastname = body["body"]
            ["GetAccountInformationOtherChannelResponse"]["lastName"]["_text"];
        nama = firstName == lastname ? firstName : firstName + " " + lastname;
        nama = nama.toUpperCase();
        ewalletId = body["body"]["GetAccountInformationOtherChannelResponse"]
            ["id"]["_text"];
        ewalletName = nama;
        ewalletUsername = body["body"]
            ["GetAccountInformationOtherChannelResponse"]["username"]["_text"];
        ewalletMsisdn = body["body"]
            ["GetAccountInformationOtherChannelResponse"]["msisdn"]["_text"];
        ewalletEmail = body["body"]["GetAccountInformationOtherChannelResponse"]
            ["email"]["_text"];
      }
    }
    dismissProgressHUD();
    setState(() {});
  }

  Future<void> _kirimotp() async {
    dismissProgressHUD();
    Map<String, String> body = {'nohp': hp, 'nak': widget.profile.nak};
    final response = await http.post(Uri.parse(APIConstant.url + "smsotp"),
        headers: headersWallet, body: json.encode(body));

    if (response.statusCode == 200) {
      dismissProgressHUD();
      Navigator.push(
          _context,
          MaterialPageRoute(
              builder: (context) => OTPFragment(
                    hpexist: "exist",
                    profile: widget.profile,
                    hp: hp,
                    ewalletId: ewalletId,
                    ewalletName: ewalletName,
                    ewalletUsername: ewalletUsername,
                    ewalletMsisdn: ewalletMsisdn,
                    ewalletEmail: ewalletEmail,
                  )));
    } else if (response.statusCode == 401) {
      dismissProgressHUD();
      Navigator.of(context).pushReplacementNamed('/LoginScreen');
    } else {
      dismissProgressHUD();
    }
  }
}
