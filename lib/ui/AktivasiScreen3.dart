import 'dart:convert';
import 'dart:io';

import 'package:badges/badges.dart' as badge;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kmob/common/platform/platformScaffold.dart';
import 'package:kmob/common/widgets/MyAppBar.dart';
import 'package:kmob/model/perusahaan_model.dart';
import 'package:kmob/ui/AktivasiScreenFinish.dart';
import 'package:kmob/utils/constant.dart';
import 'package:http/http.dart' as http;
import 'package:progress_hud/progress_hud.dart';

class AktivasiScreen3 extends StatefulWidget {
  final PerusahaanModel perusahaan;
  final String nik;
  final String nak;
  final String email;
  final String hp;
  final String token;
  final String password;
  final String pathKartuAnggota;
  final String pathKTPIdCard;

  const AktivasiScreen3(
      {Key key,
      this.perusahaan,
      this.nik,
      this.nak,
      this.email,
      this.hp,
      this.token,
      this.password,
      this.pathKartuAnggota,
      this.pathKTPIdCard})
      : super(key: key);

  @override
  _AktivasiScreen3State createState() => _AktivasiScreen3State();
}

class _AktivasiScreen3State extends State<AktivasiScreen3> {
  bool _loading = false;

  BuildContext _context;
  double maxWidth = 0;
  double maxHeight = 0;
  File _imageFile;
  String _filename;
  dynamic _pickImageError;
  String _retrieveDataError;
  String _namaAnggota = "";
  String _nmPerusahaan = "";

  String _bukti;

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
                    _uploadKartuAnggotaArea(),
                    _summaryArea()
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

  Widget _uploadKartuAnggotaArea() {
    return Container(
        width: maxWidth,
        height: _imageFile == null ? 120 : 530,
        color: Colors.grey[200],
        child: Card(
            elevation: 5.0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 8.0),
                child: Column(children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Upload Foto Diri",
                          style: TextStyle(
                              fontSize: 14.0, fontFamily: "NeoSansBold")),
                    ],
                  ),
                  new SizedBox(
                    height: 10.0,
                  ),
                  Center(
                      child: Platform.isAndroid
                          ? FutureBuilder<void>(
                              future: retrieveLostData(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<void> snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.none:
                                  case ConnectionState.waiting:
                                    return const Text(
                                      'You have not yet picked an image.',
                                      textAlign: TextAlign.center,
                                    );
                                  case ConnectionState.done:
                                    return _previewImage();
                                  default:
                                    if (snapshot.hasError) {
                                      return Text(
                                        'Pick image/video error: ${snapshot.error}}',
                                        textAlign: TextAlign.center,
                                      );
                                    } else {
                                      return const Text(
                                        'You have not yet picked an image.',
                                        textAlign: TextAlign.center,
                                      );
                                    }
                                }
                              },
                            )
                          : _previewImage()),
                  ElevatedButton(
                    onPressed: () {
                      _optionsDialogBox(_context);
                    },
                    child: new Text('Pilih foto diri'),
                  )
                ]))));
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

  Future<void> retrieveLostData() async {
    ImagePicker imagePicker = ImagePicker();
    final LostDataResponse response = await imagePicker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (File(response.file.path) != null) {
      setState(() {
        _imageFile = File(response.file.path);
      });
    } else {
      _retrieveDataError = response.exception.code;
    }
  }

  Future _getImage(String mode) async {
    try {
      var imageFile;
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

      setState(() {
        _imageFile = imageFile;
        // _filename = basename(imageFile.path);
        _filename = "verifikasi_fotodiri_" + widget.nak + "_" + widget.nik;
      });
    } catch (e) {
      _pickImageError = e;
    }
  }

  Text _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Widget _previewImage() {
    final Text retrieveError = _getRetrieveErrorWidget();

    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFile != null) {
      return Column(
        children: <Widget>[
          Image.file(_imageFile, width: double.infinity, height: 370),
          SizedBox(
            height: 10.0,
          ),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(ColorPalette.green)),
            onPressed: () {
              _doUpload();
            }
            // showInSnackBar("SignUp button pressed", _context);
            ,
            child: new Text(
              'Upload foto diri',
              style: new TextStyle(color: Colors.white),
            ),
          )
        ],
      );
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }

  Future<void> _doUpload() async {
    setState(() {
      _loading = true;
    });
    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(_filename);
    final StorageUploadTask task = firebaseStorageRef.putFile(_imageFile);
    var downUrl = await (await task.onComplete).ref.getDownloadURL();
    var url = downUrl.toString();
    if (url != "") {
      _bukti = url;
      _uploadData();
    }
  }

  //getdata area
  Future<void> _uploadData() async {
    setState(() {
      _loading = false;
    });
    Navigator.push(
      _context,
      MaterialPageRoute(
          builder: (context) => AktivasiScreenFinish(
              perusahaan: widget.perusahaan,
              nik: widget.nik,
              nak: widget.nak,
              email: widget.email,
              hp: widget.hp,
              token: widget.token,
              password: widget.password,
              pathKartuAnggota: widget.pathKartuAnggota,
              pathKTPIdCard: widget.pathKTPIdCard,
              pathFotoDiri: _bukti)),
    );
  }

  Widget _summaryArea() {
    return Container(
      width: maxWidth,
      height: 500,
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
      height: 220,
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
                "Silahkan upload beberapa dokumen dibawah ini untuk kelengkapan aktivasi",
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text("3. Foto Diri", textAlign: TextAlign.left),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
