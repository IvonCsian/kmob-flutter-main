import 'dart:convert';

import 'package:badges/badges.dart' as badge;
import 'package:flutter/material.dart';
import 'package:kmob/common/functions/showDialogSingleButton.dart';
import 'package:kmob/common/platform/platformScaffold.dart';
import 'package:kmob/common/widgets/MyAppBar.dart';
import 'package:kmob/model/perusahaan_model.dart';
import 'package:kmob/utils/constant.dart';
import 'package:http/http.dart' as http;
import 'package:progress_hud/progress_hud.dart';

class AktivasiScreenFinish extends StatefulWidget {
  final PerusahaanModel perusahaan;
  final String nik;
  final String nak;
  final String email;
  final String hp;
  final String token;
  final String password;
  final String pathKartuAnggota;
  final String pathKTPIdCard;
  final String pathFotoDiri;

  const AktivasiScreenFinish(
      {Key key,
      this.perusahaan,
      this.nik,
      this.nak,
      this.email,
      this.hp,
      this.token,
      this.password,
      this.pathKartuAnggota,
      this.pathKTPIdCard,
      this.pathFotoDiri})
      : super(key: key);
  @override
  _AktivasiScreenFinishState createState() => _AktivasiScreenFinishState();
}

class _AktivasiScreenFinishState extends State<AktivasiScreenFinish> {
  bool _loading = false;
  bool isActivated = false;
  BuildContext _context;
  double maxWidth = 0;
  double maxHeight = 0;
  String _namaAnggota = "";
  String _nmPerusahaan = "";
  @override
  void initState() {
    super.initState();
    this.getData();

    // _progressHUD.state.dismiss();
  }

  void dismissProgressHUD() {
    setState(() {
      _loading = !_loading;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  String urlProfile = "" +
      APIConstant.urlBase +
      "" +
      APIConstant.serverApi +
      "Pub/checkprofile";

  Future<void> getData() async {
    Map<String, String> body = {
      'no_ang': widget.nak,
      'token': widget.token,
    };
    final response = await http.post(Uri.parse(urlProfile), body: body);
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON.
      final body = json.decode(response.body);
      setState(() {
        _namaAnggota = body["nm_ang"].toString();
        _nmPerusahaan = body["nm_prsh"].toString();
      });
    } else {
      print('Something went wrosdng. \nResponse Code : ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    maxWidth = MediaQuery.of(context).size.width;
    maxHeight = MediaQuery.of(context).size.height >= 775.0
        ? MediaQuery.of(context).size.height
        : 775.0;
    return SafeArea(
      child: PlatformScaffold(
          // appBar: new MyAppBar(_selectedDrawerIndex),
          appBar: appBarDetail(context, "Lengkapi berkas aktivasi K3PG Mobile"),
          backgroundColor: Colors.grey[300],
          body: new Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    _info(),
                    if (!isActivated) _summaryArea(),
                    if (!isActivated) _submitArea(),
                    if (isActivated) _toLoginArea(),
                  ],
                ),
              ),
              if (_loading)
                new ProgressHUD(
                  backgroundColor: Colors.black12,
                  color: Colors.white,
                  containerColor: Colors.blue,
                  borderRadius: 5.0,
                  text: 'Uploading...',
                ),
            ],
          )),
    );
  }

  _activationProcess() async {
    setState(() {
      _loading = true;
    });
    String url = "" +
        APIConstant.urlBase +
        "" +
        APIConstant.serverApi +
        "Pub/registerAccount";

    Map<String, String> body = {
      'nik': widget.nik,
      'no_ang': widget.nak,
      'email': widget.email,
      'hp': widget.hp,
      'password': widget.password,
      'perusahaan': widget.perusahaan.perusahaan,
      'pathKartuAnggota': widget.pathKartuAnggota,
      'pathKTPIdCard': widget.pathKTPIdCard,
      'pathFotoDiri': widget.pathFotoDiri,
    };
    final response = await http.post(Uri.parse(url), body: body);
    if (response.statusCode == 200) {
      setState(() {
        _loading = false;
        isActivated = true;
      });
      final body = json.decode(response.body);
      showDialogSingleButton(
          _context, "Aktivasi berhasil", body["status"].toString(), "OK");
    } else {
      setState(() {
        _loading = false;
        isActivated = false;
      });

      final body = json.decode(response.body);
      showDialogSingleButton(
          _context, "Aktivasi gagal", body["status"].toString(), "OK");
    }
  }

  Widget _summaryArea() {
    return Container(
      width: maxWidth,
      height: 700,
      color: Colors.grey[200],
      child: Card(
        elevation: 5.0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 8.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Berkas anda",
                    style: TextStyle(fontSize: 14.0, fontFamily: "NeoSansBold"),
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("1. Kartu Anggota : "),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(
                    height: 192.0,
                    fit: BoxFit.cover,
                    image: NetworkImage(widget.pathKartuAnggota),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("2. KTP dan ID Karyawan : "),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(
                    height: 192.0,
                    fit: BoxFit.cover,
                    image: NetworkImage(widget.pathKTPIdCard),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("3. Foto Diri : "),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(
                    height: 192.0,
                    fit: BoxFit.cover,
                    image: NetworkImage(widget.pathFotoDiri),
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _info() {
    return Container(
      width: maxWidth,
      height: 240,
      color: Colors.grey[200],
      child: Card(
        elevation: 5.0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 8.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Petunjuk dan Informasi",
                    style: TextStyle(fontSize: 14.0, fontFamily: "NeoSansBold"),
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[Text("Hai : "), Text(_namaAnggota)],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Nama Perusahaan : "),
                  Text(_nmPerusahaan)
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                "Terima kasih telah melengkapi berkas verifikasi. Silahkan pastikan file anda benar dan klik aktifkan akun saya untuk menyelesaikan aktivasi akun K3PG Mobile.",
                textAlign: TextAlign.justify,
              ),
              SizedBox(
                height: 5.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "1. Foto Kartu / Bukti Potong / Buku Anggota ",
                    textAlign: TextAlign.left,
                  ),
                  badge.Badge(
                    badgeColor: Colors.green[700],
                    shape: badge.BadgeShape.square,
                    borderRadius: BorderRadius.circular(20),
                    toAnimate: false,
                    badgeContent: Text("sudah diupload",
                        style: new TextStyle(
                            fontFamily: "WorkSansMedium",
                            fontSize: 10.0,
                            color: Colors.white)),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "2. Foto KTP dan ID Karyawan ",
                    textAlign: TextAlign.left,
                  ),
                  badge.Badge(
                    badgeColor: Colors.green[700],
                    shape: badge.BadgeShape.square,
                    borderRadius: BorderRadius.circular(20),
                    toAnimate: false,
                    badgeContent: Text("sudah diupload",
                        style: new TextStyle(
                            fontFamily: "WorkSansMedium",
                            fontSize: 10.0,
                            color: Colors.white)),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("3. Foto Diri", textAlign: TextAlign.left),
                  badge.Badge(
                    badgeColor: Colors.green[700],
                    shape: badge.BadgeShape.square,
                    borderRadius: BorderRadius.circular(20),
                    toAnimate: false,
                    badgeContent: Text("sudah diupload",
                        style: new TextStyle(
                            fontFamily: "WorkSansMedium",
                            fontSize: 10.0,
                            color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _submitArea() {
    return Container(
      width: maxWidth,
      height: 50.0,
      margin: new EdgeInsets.only(bottom: 10.0),
      color: Colors.grey[200],
      child: Card(
        elevation: 5.0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: SizedBox.expand(
          child: ElevatedButton(
            child: new Text("Aktifkan Akun K3PG saya",
                style: new TextStyle(
                  color: Colors.white,
                )),

            // colorBrightness: Brightness.dark,
            onPressed: () {
              _activationProcess();
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(ColorPalette.warnaCorporate),
            ),
            // color: ColorPalette.warnaCorporate,
          ),
        ),
      ),
    );
  }

  _toLoginArea() {
    return Container(
      width: maxWidth,
      height: 50.0,
      margin: new EdgeInsets.only(bottom: 10.0),
      color: Colors.grey[200],
      child: Card(
        elevation: 5.0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: SizedBox.expand(
          child: ElevatedButton(
            child: new Text("Login akun saya",
                style: new TextStyle(
                  color: Colors.white,
                )),
            // colorBrightness: Brightness.dark,
            onPressed: () {
              Navigator.popUntil(_context, ModalRoute.withName('/LoginScreen'));
            },
            // color: ColorPalette.warnaCorporate,
          ),
        ),
      ),
    );
  }
}
