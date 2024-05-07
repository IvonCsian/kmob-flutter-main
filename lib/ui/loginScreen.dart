import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kmob/common/apifunctions/requestLoginAPI.dart';
import 'package:kmob/common/functions/showDialogSingleButton.dart';
import 'package:kmob/common/functions/ui.dart';
import 'package:kmob/common/widgets/widget.dart';
import 'package:kmob/model/perusahaan_model.dart';
import 'package:kmob/style/theme.dart' as Theme;
import 'package:kmob/ui/DaftarScreen.dart';
import 'package:kmob/ui/LupaPassword.dart';
import 'package:kmob/ui/aktivasiScreen.dart';
import 'package:kmob/utils/bubble_indication_painter.dart';
import 'package:kmob/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:progress_hud/progress_hud.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  bool _loading = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<PerusahaanModel> perusahaans = [];
  PerusahaanModel _perusahaan;

  final FocusNode myFocusNodeEmailLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();

  final FocusNode noKTPFocus = FocusNode();
  final FocusNode noAnggotaFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode hpFocus = FocusNode();
  final FocusNode tokenFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  TextEditingController loginEmailController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();

  bool _obscureTextLogin = true;
  bool _obscureTextSignup = true;
  bool _obscureTextSignupConfirm = true;

  TextEditingController nikktpController = new TextEditingController();
  TextEditingController nakController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController hpController = new TextEditingController();
  TextEditingController tokenController = new TextEditingController();

  PageController _pageController;

  Color left = Colors.black;
  Color right = Colors.white;

  //new

  String _nik;
  String _nak;
  String _email;
  String _hp;
  String _token;
  String _password;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          // overscroll.disallowIndicator();
        },
        child: Stack(children: <Widget>[
          SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height >= 775.0
                  ? MediaQuery.of(context).size.height
                  : 775.0,
              color: ColorPalette.warnaCorporate,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 75.0),
                    child: Center(
                        child: new ClipRRect(
                      borderRadius: new BorderRadius.circular(50.0),
                      child: new Image.asset(
                        'assets/img/logo.jpg',
                        height: 200.0,
                        width: 200.0,
                        fit: BoxFit.fill,
                      ),
                    )),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: _buildMenuBar(context),
                  ),
                  Expanded(
                    flex: 2,
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (i) {
                        if (i == 0) {
                          setState(() {
                            right = Colors.white;
                            left = Colors.black;
                          });
                        } else if (i == 1) {
                          setState(() {
                            right = Colors.black;
                            left = Colors.white;
                          });
                        }
                      },
                      children: <Widget>[
                        new ConstrainedBox(
                          constraints: const BoxConstraints.expand(),
                          child: _buildSignIn(context),
                        ),
                        new ConstrainedBox(
                          constraints: const BoxConstraints.expand(),
                          child: _buildSignUp(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_loading)
            new ProgressHUD(
              backgroundColor: Colors.black12,
              color: Colors.white,
              containerColor: Colors.blue,
              borderRadius: 5.0,
              text: 'Loading...',
            ),
        ]),
      ),
    );
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  String lastUserId;

  @override
  void initState() {
    super.initState();
    _saveCurrentRoute("/LoginScreen");
    _getPerusahaan();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _pageController = PageController();
  }

  void dismissProgressHUD() {
    setState(() {
      _loading = !_loading;
    });
  }

  //getdata area
  Future<void> _getPerusahaan() async {
    final prefs = await SharedPreferences.getInstance();
    tokens = prefs.getString('LastToken') ?? '';
    lastUserId = prefs.getString('LastUserId') ?? '';

    String url = APIConstant.urlBase + APIConstant.serverApi + "perusahaan";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var rest = json.decode(response.body) as List;
      perusahaans = rest
          .map<PerusahaanModel>((json) => PerusahaanModel.fromJson(json))
          .toList();

      if (mounted) {
        setState(() {
          perusahaans = perusahaans;
        });
      }
    } else if (response.statusCode == 401) {}
    if (mounted) {
      setState(() {
        loginEmailController.text = lastUserId;
      });
    }
  }

  _saveCurrentRoute(String lastRoute) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('LastScreenRoute', lastRoute);
  }

  Widget _buildMenuBar(BuildContext context) {
    return Container(
      width: 300.0,
      height: 50.0,
      decoration: BoxDecoration(
        color: Color(0x552B2B2B),
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      child: CustomPaint(
        painter: TabIndicationPainter(pageController: _pageController),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: TextButton(
                style: TextButton.styleFrom(),
                // splashColor: Colors.transparent,
                // highlightColor: Colors.transparent,
                onPressed: _onSignInButtonPress,
                child: Text(
                  "Masuk",
                  style: TextStyle(
                      color: left,
                      fontSize: 16.0,
                      fontFamily: "WorkSansSemiBold"),
                ),
              ),
            ),
            //Container(height: 33.0, width: 1.0, color: Colors.white),
            Expanded(
              child: TextButton(
                // splashColor: Colors.transparent,
                // highlightColor: Colors.transparent,
                onPressed: _onSignUpButtonPress,
                child: Text(
                  "Aktivasi",
                  style: TextStyle(
                      color: right,
                      fontSize: 16.0,
                      fontFamily: "WorkSansSemiBold"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignIn(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 23.0),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            // overflow: Overflow.visible,
            children: <Widget>[
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: 300.0,
                  height: 190.0,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextFormField(
                          focusNode: myFocusNodeEmailLogin,
                          controller: loginEmailController,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          onFieldSubmitted: (term) {
                            fieldFocusChange(context, myFocusNodeEmailLogin,
                                myFocusNodePasswordLogin);
                          },
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.envelope,
                              color: Colors.black,
                              size: 22.0,
                            ),
                            hintText: "Masukkan email akun anda",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansLight", fontSize: 17.0),
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextFormField(
                          focusNode: myFocusNodePasswordLogin,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (value) {
                            myFocusNodePasswordLogin.unfocus();
                            // _calculator();
                          },
                          controller: loginPasswordController,
                          obscureText: _obscureTextLogin,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.lock,
                              size: 22.0,
                              color: Colors.black,
                            ),
                            hintText: "Password",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansLight", fontSize: 17.0),
                            suffixIcon: GestureDetector(
                              onTap: _toggleLogin,
                              child: Icon(
                                FontAwesomeIcons.eye,
                                size: 15.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 170.0),
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Theme.Colors.loginGradientStart,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                    BoxShadow(
                      color: Theme.Colors.loginGradientEnd,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                  ],
                  gradient: new LinearGradient(
                      colors: [
                        Theme.Colors.loginGradientEnd,
                        Theme.Colors.loginGradientStart
                      ],
                      begin: const FractionalOffset(0.2, 0.2),
                      end: const FractionalOffset(1.0, 1.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                child: MaterialButton(
                    highlightColor: Colors.transparent,
                    splashColor: Theme.Colors.loginGradientEnd,
                    //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 42.0),
                      child: Text(
                        "LOGIN",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.0,
                            fontFamily: "WorkSansBold"),
                      ),
                    ),
                    onPressed: () async {
                      setState(() {
                        _loading = true;
                      });
                      // showInSnackBar("Waiting for process login.....",context);
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                      if ((await requestLoginAPI(
                              context,
                              loginEmailController.text,
                              loginPasswordController.text)) ==
                          true) {
                        dismissProgressHUD();
                      } else {
                        dismissProgressHUD();
                      }
                    }),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LupaPassword()),
                  );
                },
                child: Text(
                  "Lupa Password?",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.white,
                      fontSize: 16.0,
                      fontFamily: "WorkSansMedium"),
                )),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Belum punya akun?',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                width: 10,
              ),
              tombol(
                child: Text('Daftar Anggota'),
                // backgroundColor: ColorPalette.warnaCorporate,
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => DaftarScreen()));
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSignUp(BuildContext context) {
    void _validateInputs() {
      if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
        _formKey.currentState.save();
        //navigate

        validateData(_nik, _nak, _email, _hp, _token);
      } else {
        //    If all data are not valid then start auto validation.
        setState(() {});
      }
    }

    String validateEmail(String value) {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);
      if (!regex.hasMatch(value))
        return 'Enter Valid Email';
      else
        return null;
    }

    return Container(
      padding: EdgeInsets.only(top: 20.0, bottom: 0.0, left: 20.0, right: 25.0),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.always,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 10.0, 40.0, 8.0),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  DropdownButtonFormField<PerusahaanModel>(
                    decoration: const InputDecoration(
                      labelText: "Perusahaan : ",
                      icon:
                          Icon(FontAwesomeIcons.building, color: Colors.black),
                    ),
                    validator: (PerusahaanModel arg) {
                      if (arg == null)
                        return 'Harus diisi';
                      else
                        return null;
                    },
                    onSaved: (PerusahaanModel newValue) {
                      setState(() {
                        _perusahaan = newValue;
                      });
                    },
                    value: _perusahaan,
                    onChanged: (PerusahaanModel newValue) {
                      setState(() {
                        _perusahaan = newValue;
                      });
                    },
                    items: perusahaans.map((PerusahaanModel item) {
                      return new DropdownMenuItem<PerusahaanModel>(
                        value: item,
                        child: new SizedBox(
                          width: 190.0,
                          child: new Text(
                            item.perusahaan,
                            style: new TextStyle(color: Colors.black),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  new TextFormField(
                    focusNode: noKTPFocus,
                    onFieldSubmitted: (term) {
                      fieldFocusChange(context, noKTPFocus, noAnggotaFocus);
                    },
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: "Nomor KTP (NIK) : ",
                      icon: Icon(FontAwesomeIcons.idCard, color: Colors.black),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (String arg) {
                      if (arg.length < 1)
                        return 'Harus diisi';
                      else if (arg.length > 25)
                        return 'No NIK terlalu panjang';
                      else
                        return null;
                    },
                    onSaved: (String val) {
                      _nik = val;
                    },
                  ),
                  new TextFormField(
                    focusNode: noAnggotaFocus,
                    onFieldSubmitted: (term) {
                      fieldFocusChange(context, noAnggotaFocus, emailFocus);
                    },
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: "Nomor Anggota Koperasi : ",
                      icon:
                          Icon(FontAwesomeIcons.idCardAlt, color: Colors.black),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (String arg) {
                      if (arg.length < 1)
                        return 'Harus diisi';
                      else if (arg.length > 25)
                        return 'No NIK terlalu panjang';
                      else
                        return null;
                    },
                    onSaved: (String val) {
                      _nak = val;
                    },
                  ),
                  new TextFormField(
                    focusNode: emailFocus,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (term) {
                      fieldFocusChange(context, emailFocus, hpFocus);
                    },
                    decoration: const InputDecoration(
                      labelText: "Email : ",
                      icon: Icon(Icons.email, color: Colors.black),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (String arg) {
                      return validateEmail(arg);
                    },
                    onSaved: (String val) {
                      _email = val;
                    },
                  ),
                  new TextFormField(
                    focusNode: hpFocus,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (term) {
                      fieldFocusChange(context, hpFocus, tokenFocus);
                    },
                    decoration: const InputDecoration(
                      labelText: "No HP : ",
                      icon: Icon(FontAwesomeIcons.phone, color: Colors.black),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (String arg) {
                      if (arg.length < 1)
                        return 'Harus diisi';
                      else if (arg.length > 25)
                        return 'No NIK terlalu panjang';
                      else
                        return null;
                    },
                    onSaved: (String val) {
                      _hp = val;
                    },
                  ),
                  new TextFormField(
                    focusNode: tokenFocus,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (term) {
                      fieldFocusChange(context, tokenFocus, passwordFocus);
                    },
                    decoration: const InputDecoration(
                      labelText: "Token : ",
                      icon: Icon(FontAwesomeIcons.key, color: Colors.black),
                    ),
                    keyboardType: TextInputType.text,
                    validator: (String arg) {
                      if (arg.length < 1)
                        return 'Harus diisi';
                      else if (arg.length > 25)
                        return 'No NIK terlalu panjang';
                      else
                        return null;
                    },
                    onSaved: (String val) {
                      _token = val;
                    },
                  ),
                  TextFormField(
                    focusNode: passwordFocus,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (value) {
                      passwordFocus.unfocus();
                      // _calculator();
                    },
                    obscureText: _obscureTextSignup,
                    keyboardType: TextInputType.text,
                    validator: (String arg) {
                      if (arg.length < 1)
                        return 'Harus diisi';
                      else if (arg.length > 25)
                        return 'Password terlalu panjang';
                      else
                        return null;
                    },
                    onSaved: (String val) {
                      _password = val;
                    },
                    decoration: InputDecoration(
                      labelText: "Password : ",
                      border: InputBorder.none,
                      icon: Icon(FontAwesomeIcons.key, color: Colors.black),
                      hintText: "Password",
                      hintStyle: TextStyle(
                          fontFamily: "WorkSansLight", fontSize: 17.0),
                      suffixIcon: GestureDetector(
                        onTap: _toggleSignup,
                        child: Icon(
                          FontAwesomeIcons.eye,
                          size: 15.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  new SizedBox(
                    height: 10.0,
                  ),
                  MaterialButton(
                      color: ColorPalette.warnaCorporate,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 42.0),
                        child: Text(
                          "AKTIVASI",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                              fontFamily: "WorkSansBold"),
                        ),
                      ),
                      onPressed: _validateInputs)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onSignInButtonPress() {
    _pageController.animateToPage(0,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _onSignUpButtonPress() {
    _pageController?.animateToPage(1,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }

  void _toggleSignup() {
    setState(() {
      _obscureTextSignup = !_obscureTextSignup;
    });
  }

  void _toggleSignupConfirm() {
    setState(() {
      _obscureTextSignupConfirm = !_obscureTextSignupConfirm;
    });
  }

  Future<void> validateData(
      String nik, String nak, String email, String hp, String token) async {
    final prefs = await SharedPreferences.getInstance();
    tokens = prefs.getString('LastToken') ?? '';
    String url = "" +
        APIConstant.urlBase +
        "" +
        APIConstant.serverApi +
        "Pub/activationcheck";
    Map<String, String> body = {
      'no_ang': nak,
      'token': token,
      'email': email,
      'nik': nik,
      'hp': hp,
    };
    final response = await http.post(Uri.parse(url), body: body);
    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AktivasiScreen(
                perusahaan: _perusahaan,
                nik: _nik,
                nak: _nak,
                email: _email,
                hp: _hp,
                token: _token,
                password: _password)),
      );
    } else {
      final body = json.decode(response.body);
      showDialogSingleButton(
          context, "Aktivasi gagal", body["status"].toString(), "OK");
    }
  }
}
