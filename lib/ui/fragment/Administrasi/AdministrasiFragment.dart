import 'dart:convert';
import 'dart:io';

import 'package:badges/badges.dart' as badge;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kmob/common/functions/showDialogSingleButton.dart';
import 'package:kmob/model/profile_model.dart';
import 'package:kmob/ui/fragment/Administrasi/GantiPasswordFragment.dart';
import 'package:kmob/ui/fragment/Administrasi/LinkExistFragment.dart';
import 'package:kmob/ui/fragment/Administrasi/VerifikasiEmailFormFragment.dart';
import 'package:kmob/utils/constant.dart';
import 'package:progress_hud/progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'TncEwalletFragment.dart';

class AdministrasiFragment extends StatefulWidget {
  @override
  _AdministrasiFragmentState createState() => _AdministrasiFragmentState();
}

class _AdministrasiFragmentState extends State<AdministrasiFragment> {
  String token;

  String _fullName = "";
  String _foto = "";
  String _ktp = "";
  String _kartuanggota = "";
  String _status = "";
  BuildContext _context;
  String tokens;
  String url = APIConstant.urlBase + APIConstant.serverApi + "/profile";
  var url2 = APIConstant.urlBase + APIConstant.serverApi + "/profile/finance";

  bool _loading = false;

  File _imageFile;

  String _filename;

  String _nik;

  String _nak;

  String _bukti;
  void dismissProgressHUD() {
    setState(() {
      _loading = !_loading;
    });
  }

  Map<String, String> get headers => {
        'Authorization': 'Bearer $tokens',
        'Content-Type': 'application/json',
      };
  ProfileModel profile;
  bool isData = false;
  bool vEmail = false;
  bool vTelp = false;
  bool canEwallet = false;
  String ewalletId = "";

  fetchJson() async {
    final prefs = await SharedPreferences.getInstance();
    tokens = prefs.getString('LastToken') ?? '';
    var response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      profile = new ProfileModel.fromJson(json.decode(response.body));
      _fullName = profile.nmAng;
      _foto = profile.pathFoto;
      _ktp = profile.pathKtp;
      _nik = profile.ktp;
      _nak = profile.nak;
      _kartuanggota = profile.pathBuktiPotong;
      _status = profile.nmPrsh;
      vEmail = profile.emailConfirm;
      vTelp = profile.phoneConfirm;
      ewalletId = profile.ewalletId;
      if (vEmail) {
        canEwallet = true;
      }
      isData = true;
    } else {
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
    }
    var response2 = await http.get(
      Uri.parse(url2),
      headers: headers,
    );
    if (response2.statusCode == 200) {
    } else {
      print('Something went wrong. \nResponse Code : ${response2.statusCode}');
    }
    setState(() {});
  }

  @override
  void initState() {
    fetchJson();
    super.initState();
  }

  Widget _buildCoverImage(Size screenSize) {
    return Container(
      height: screenSize.height / 4,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/img/profilebg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: Container(
        width: 140.0,
        height: 140.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: new NetworkImage(_foto),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(80.0),
          border: Border.all(
            color: ColorPalette.grey,
            width: 10.0,
          ),
        ),
      ),
    );
  }

  Widget _buildFullName() {
    TextStyle _nameTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.black,
      fontSize: 28.0,
      fontWeight: FontWeight.w700,
    );

    return Text(
      _fullName,
      style: _nameTextStyle,
    );
  }

  Widget _buildStatus(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
      child: Text(
        _status,
        style: TextStyle(
          fontFamily: 'Spectral',
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget _cardShowFile() {
    return Card(
        margin: new EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
        child: InkWell(
          onTap: () {
            showModalBottomSheet<Null>(
                context: _context,
                builder: (BuildContext context) {
                  return new SingleChildScrollView(
                    child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: 10.0,
                          ),
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 3.0),
                              child: Text(
                                "Berkas anda :",
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  color: Colors.black,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              )),
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 3.0),
                              child: Text(
                                "1. KTP :",
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                ),
                              )),
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 3.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image(
                                    height: 192.0,
                                    fit: BoxFit.cover,
                                    image: new NetworkImage(_ktp),
                                  )
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 3.0),
                              child: Text(
                                "2. Kartu Anggota :",
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                ),
                              )),
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 3.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image(
                                    height: 192.0,
                                    fit: BoxFit.cover,
                                    image: new NetworkImage(_kartuanggota),
                                  )
                                ],
                              ))
                        ]),
                  );
                });
          },
          child: ListTile(
            // onTap: () => _onSelectItem(param.mode),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.0, vertical: 3.0),
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Tampilkan berkas saya",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.normal),
                  ),
                ]),
          ),
        ));
  }

  Widget _cardPassword() {
    return Card(
        margin: new EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
        child: InkWell(
          onTap: () {
            Navigator.pushAndRemoveUntil(
                _context,
                MaterialPageRoute(
                    builder: (context) => GantiPasswordFragment()),
                ModalRoute.withName("/HomeScreen"));
          },
          child: ListTile(
            // onTap: () => _onSelectItem(param.mode),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.0, vertical: 3.0),
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Ubah kata sandi",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.normal),
                  ),
                ]),
          ),
        ));
  }

  Widget _cardEmail() {
    return Card(
        margin: new EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
        child: InkWell(
          onTap: () {
            vEmail
                ? showDialogSingleButton(_context, "Verifikasi Email",
                    "Email telah diverifikasi", "OK")
                : Navigator.pushAndRemoveUntil(
                    _context,
                    MaterialPageRoute(
                        builder: (context) => VerifikasiEmailFormFragment()),
                    ModalRoute.withName("/HomeScreen"));
          },
          child: ListTile(
            // onTap: () => _onSelectItem(param.mode),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.0, vertical: 3.0),
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Verifikasi Email",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.normal),
                  ),
                  vEmail
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              FontAwesomeIcons.checkCircle,
                              color: Colors.green[900],
                            ),
                            Text(
                              "Terverifikasi",
                              style: TextStyle(color: Colors.green[900]),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              FontAwesomeIcons.windowClose,
                              color: Colors.red[900],
                            ),
                            Text(
                              "Belum diverifikasi",
                              style: TextStyle(color: Colors.red[900]),
                            ),
                          ],
                        )
                ]),
          ),
        ));
  }

  Widget _carddetailWallet() {
    return Card(
        margin: new EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
        child: InkWell(
          onTap: () {
            showModalBottomSheet<Null>(
                context: _context,
                builder: (BuildContext context) {
                  return new SingleChildScrollView(
                    child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: 10.0,
                          ),
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 3.0),
                              child: Text(
                                "Detail Ewallet",
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  color: Colors.black,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              )),
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 3.0),
                              child: Text(
                                "1. Ewallet Phone : " + profile.ewalletMsisdn,
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                ),
                              )),
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 3.0),
                              child: Text(
                                "2. Ewallet Email : " + profile.ewalletEmail,
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                ),
                              )),
                        ]),
                  );
                });
          },
          child: ListTile(
            // onTap: () => _onSelectItem(param.mode),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.0, vertical: 3.0),
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("E-Wallet telah aktif",
                      style: new TextStyle(
                          fontFamily: "WorkSansMedium",
                          fontSize: 12.0,
                          color: Colors.green[700])),
                ]),
          ),
        ));
  }

  Widget _cardSambungkan() {
    return Card(
        margin: new EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
        child: InkWell(
          onTap: () {
            canEwallet
                ? Navigator.pushAndRemoveUntil(
                    _context,
                    MaterialPageRoute(
                        builder: (context) =>
                            LinkExistFragment(profile: profile)),
                    ModalRoute.withName("/HomeScreen"))
                : print("Validasi email dan hp terlebih dahulu");
          },
          child: ListTile(
            // onTap: () => _onSelectItem(param.mode),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.0, vertical: 3.0),
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  canEwallet
                      ? Text(
                          "Sudah memliki akun JakOne Mobile? Hubungkan akun JakOne Mobile",
                          style: new TextStyle(
                              fontFamily: "WorkSansMedium",
                              fontSize: 10.0,
                              color: Colors.blue))
                      : badge.Badge(
                          badgeColor: Colors.green[600],
                          shape: badge.BadgeShape.square,
                          borderRadius: BorderRadius.circular(20),
                          toAnimate: false,
                          badgeContent: Text(
                              "Aktivasi e-wallet dapat dilakukan setelah email valid",
                              style: new TextStyle(
                                  fontFamily: "WorkSansMedium",
                                  fontSize: 11.0,
                                  color: Colors.white)),
                        ),
                ]),
          ),
        ));
  }

  Widget _cardTautkan() {
    return Card(
        margin: new EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
        child: ListTile(
          // onTap: () => _onSelectItem(param.mode),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 3.0),
          title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                canEwallet
                    ? MaterialButton(
                        color: Colors.green,
                        onPressed: () {
                          canEwallet
                              ? Navigator.pushAndRemoveUntil(
                                  _context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          TncEwallet(profile: profile)),
                                  ModalRoute.withName("/HomeScreen"))
                              : print("Validasi email dan hp terlebih dahulu");
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 42.0),
                          child: Text(
                            "AKTIFKAN E-WALLET",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                                fontFamily: "WorkSansBold"),
                          ),
                        ))
                    : badge.Badge(
                        badgeColor: Colors.green[600],
                        shape: badge.BadgeShape.square,
                        borderRadius: BorderRadius.circular(20),
                        toAnimate: false,
                        badgeContent: Text(
                            "Aktivasi e-wallet dapat dilakukan setelah email valid",
                            style: new TextStyle(
                                fontFamily: "WorkSansMedium",
                                fontSize: 11.0,
                                color: Colors.white)),
                      ),
              ]),
        ));
  }

  Future _getImage(String mode) async {
    try {
      XFile imageFile;
      ImagePicker imagePicker = ImagePicker();
      switch (mode) {
        case 'camera':
          imageFile = await imagePicker.pickImage(
              source: ImageSource.camera, maxHeight: 450.0, maxWidth: 450.0);
          break;
        case 'gallery':
          imageFile = await imagePicker.pickImage(
              source: ImageSource.gallery, maxHeight: 450.0, maxWidth: 450.0);
          break;
        default:
      }
      if (imageFile != null) {
        setState(() {
          _loading = true;
        });
        _imageFile = File(imageFile.path);
        _filename = "verifikasi_fotodiri_" + _nak + "_" + _nik;
        final StorageReference firebaseStorageRef =
            FirebaseStorage.instance.ref().child(_filename);
        final StorageUploadTask task = firebaseStorageRef.putFile(_imageFile);
        var downUrl = await (await task.onComplete).ref.getDownloadURL();
        var url = downUrl.toString();
        if (url != "") {
          _bukti = url;
          _uploadData();
          setState(() {
            _loading = false;
          });
        } else {
          setState(() {
            _loading = false;
          });
        }
      }
    } catch (e) {}
  }

  //getdata area
  Future<void> _uploadData() async {
    Map<String, String> body = {'gambar': _bukti};
    String urlUpdate =
        APIConstant.urlBase + APIConstant.serverApi + "/profile/updateFoto";
    final prefs = await SharedPreferences.getInstance();
    tokens = prefs.getString('LastToken') ?? '';
    final response = await http.post(Uri.parse(urlUpdate),
        headers: headers, body: json.encode(body));

    if (response.statusCode == 200) {
      setState(() {
        fetchJson();
        _loading = false;
      });
      var rv = json.decode(response.body);
      showDialogSingleButton(
          _context, "Aktivasi Berhasil", rv["status"].toString(), "OK");
    } else if (response.statusCode == 401) {
      // Navigator.of(context).pushReplacementNamed('/LoginScreen');
    }
  }

  Future<void> _optionsDialogBox(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new SingleChildScrollView(
                child: ListBody(
              children: <Widget>[
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    _getImage("camera");
                  },
                  leading: Container(
                    padding: EdgeInsets.only(right: 12.0),
                    decoration: new BoxDecoration(
                        border: new Border(
                            right: new BorderSide(
                                width: 1.0, color: Colors.blue))),
                    child: Icon(Icons.camera_alt, color: Colors.blue),
                  ),
                  title: new Text('Ambil Foto',
                      style: new TextStyle(fontSize: 18.0)),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    _getImage("gallery");
                  },
                  leading: Container(
                    padding: EdgeInsets.only(right: 12.0),
                    decoration: new BoxDecoration(
                        border: new Border(
                            right: new BorderSide(
                                width: 1.0, color: Colors.blue))),
                    child: Icon(Icons.image, color: Colors.blue),
                  ),
                  title: new Text('Pilih Dari Media/Gallery',
                      style: new TextStyle(fontSize: 18.0)),
                )
              ],
            )),
          );
        });
  }

  Widget _cardChangeProfilePicture() {
    return Card(
        margin: new EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
        child: InkWell(
          onTap: () {
            _optionsDialogBox(_context);
          },
          child: ListTile(
            // onTap: () => _onSelectItem(param.mode),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.0, vertical: 3.0),
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Ubah gambar profil",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.normal),
                  ),
                  new Container(
                      width: 30.0,
                      height: 30.0,
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: new NetworkImage(_foto)))),
                ]),
          ),
        ));
  }

  Widget _buildMenu() {
    return Container(
      child: Column(
        children: <Widget>[
          _cardChangeProfilePicture(),
          _cardShowFile(),
          _cardPassword(),
          _cardEmail(),
          isData
              ? ewalletId != ""
                  ? _carddetailWallet()
                  : _cardTautkan()
              : SizedBox(
                  height: 10.0,
                ),
          isData
              ? ewalletId != ""
                  ? SizedBox(
                      height: 10.0,
                    )
                  : _cardSambungkan()
              : SizedBox(
                  height: 10.0,
                )
        ],
      ),
    );
  }

  Widget _buildSeparator(Size screenSize) {
    return Container(
      width: screenSize.width / 1.6,
      height: 2.0,
      color: Colors.black54,
      margin: EdgeInsets.only(top: 4.0),
    );
  }

  Widget build(BuildContext context) {
    _context = context;
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: ColorPalette.grey,
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                _buildCoverImage(screenSize),
                SafeArea(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: screenSize.height / 10),
                      _buildProfileImage(),
                      _buildFullName(),
                      _buildStatus(context),
                      _buildSeparator(screenSize),
                      _buildMenu(),
                      // _buildStatContainer(),
                      // _buildBio(context),
                      SizedBox(height: 10.0),
                      // _buildGetInTouch(context),
                      SizedBox(height: 8.0),
                      // _buildButtons(),
                    ],
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
              text: 'Uploading...',
            ),
        ],
      ),
    );
  }
}
