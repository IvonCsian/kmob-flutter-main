import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:kmob/common/functions/future.dart';
import 'package:kmob/common/functions/getToken.dart';
import 'package:kmob/common/functions/showDialogSingleButton.dart';
import 'package:kmob/common/platform/platformScaffold.dart';
import 'package:kmob/model/loginModel.dart';
import 'package:kmob/model/profile_model.dart';
import 'package:kmob/utils/constant.dart';
// import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final int splashDuration = 3;
  var token;
  AppUpdateInfo _updateInfo;
  BuildContext _context;

  startTime() async {
    return Timer(Duration(seconds: splashDuration), () {
      InAppUpdate.checkForUpdate().then((info) {
        if (info?.updateAvailability == UpdateAvailability.updateAvailable)
          InAppUpdate.performImmediateUpdate().catchError((e) => _showError(e));

        getToken().then((dynamic res) {
          token = res;
          if (["", null, false, 0].contains(token)) {
            SystemChannels.textInput.invokeMethod('TextInput.hide');
            Navigator.of(context).pushReplacementNamed('/LoginScreen');
          } else {
            fetchJson(token);
            // Navigator.of(context).pushReplacementNamed('/HomeScreen');
          }
        });
        setState(() {
          _updateInfo = info;
        });
      }).catchError((e) => _showError(e));
    });
  }

  startTime2() async {
    return Timer(Duration(seconds: splashDuration), () {
      getToken().then((dynamic res) {
        token = res;
        if (["", null, false, 0].contains(token)) {
          SystemChannels.textInput.invokeMethod('TextInput.hide');
          Navigator.of(context).pushReplacementNamed('/LoginScreen');
        } else {
          fetchJson(token);
          // Navigator.of(context).pushReplacementNamed('/HomeScreen');
        }
      });
    });
  }

  String url =
      APIConstant.urlBase + APIConstant.serverApi + "profile/isValidToken";

  Map<String, String> get headers => {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

  ProfileModel profile;

  fetchJson(String token) async {
    // debugPrint(url);
    // debugPrint(headers.toString());

    var response = await executeRequest(url);
    // http.get(
    //   url,
    //   headers: headers,
    // );

    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      var user = new LoginModel.fromJson(responseJson);
      if (user.kasir) {
        Navigator.of(context).pushReplacementNamed('/KasirScreen');
      } else {
        Navigator.of(context).pushReplacementNamed('/HomeScreen');
      }
    } else {
      Navigator.of(context).pushReplacementNamed('/LoginScreen');
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
    }
    // setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // checkForUpdate();
    // startTime();
    startTime2();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        _updateInfo = info;
      });
      if (_updateInfo?.updateAvailability == UpdateAvailability.updateAvailable)
        InAppUpdate.performImmediateUpdate().catchError((e) => _showError(e));
    }).catchError((e) => _showError(e));
  }

  void _showError(dynamic exception) {
    showDialogSingleButton(_context, 'Error: ', exception.toString(), 'TUTUP');
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    var drawer = Drawer();

    return PlatformScaffold(
        drawer: drawer,
        body: Container(
            decoration: BoxDecoration(color: ColorPalette.warnaCorporate),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                      decoration:
                          BoxDecoration(color: ColorPalette.warnaCorporate),
                      alignment: FractionalOffset(0.5, 0.3),
                      child: Center(
                          child: new ClipRRect(
                        borderRadius: new BorderRadius.circular(50.0),
                        child: new Image.asset(
                          'assets/img/logo.jpg',
                          height: 200.0,
                          width: 200.0,
                          fit: BoxFit.fill,
                        ),
                      )
                          // ClipRect(
                          //   child: Container(
                          //     child: new Image.asset(
                          //       'assets/img/logo.jpg',
                          //       fit: BoxFit.cover,
                          //       height: 180,
                          //     ),
                          //   ),
                          // ),
                          )),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 30.0),
                  child: Text(
                    "© Copyright \n KOPERASI KARYAWAN KELUARGA BESAR PETROKIMIA GRESIK (K3PG) \n@ 2019",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            )));
  }
}
