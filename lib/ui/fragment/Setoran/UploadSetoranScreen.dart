import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kmob/common/functions/format.dart';
import 'package:kmob/common/platform/platformScaffold.dart';
import 'package:kmob/common/widgets/MyAppBar.dart';
import 'package:kmob/model/bank_model.dart';
import 'package:kmob/model/profile_model.dart';
import 'package:kmob/ui/fragment/Setoran/UploadBerhasilScreen.dart';
import 'package:kmob/utils/constant.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:progress_hud/progress_hud.dart';

class UploadSetoranScreen extends StatefulWidget {
  final BankModel bank;
  final String rekening;
  final String nama;
  final String simpanan;
  final double nominal;
  final String jangka;

  const UploadSetoranScreen(
      {Key key,
      this.bank,
      this.nama,
      this.rekening,
      this.nominal,
      this.jangka,
      this.simpanan})
      : super(key: key);

  @override
  _UploadSetoranScreenState createState() => _UploadSetoranScreenState();
}

class _UploadSetoranScreenState extends State<UploadSetoranScreen> {
  bool _loading = false;

  BuildContext _context;
  double maxWidth = 0;
  double maxHeight = 0;
  File _imageFile;
  String _filename;
  dynamic _pickImageError;
  String _retrieveDataError;
  String _bukti;
  String tokens;
  String va;
  String url = APIConstant.urlBase + APIConstant.serverApi + "setoran/new";
  String urlProfile = APIConstant.urlBase + APIConstant.serverApi + "/profile";
  Map<String, String> get headers => {
        'Authorization': 'Bearer $tokens',
        'Content-Type': 'application/json',
      };

  ProfileModel profile;

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

  Future<void> getData() async {
    final prefs = await SharedPreferences.getInstance();
    tokens = prefs.getString('LastToken') ?? '';
    final response = await http.get(Uri.parse(urlProfile), headers: headers);
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON.
      profile = new ProfileModel.fromJson(json.decode(response.body));
      setState(() {
        va = profile.va;
      });
    } else {
      print('Something went wrosdng. \nResponse Code : ${response.statusCode}');
    }
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

      setState(() {
        _imageFile = File(imageFile.path);
        _filename = basename(imageFile.path);
      });
    } catch (e) {
      _pickImageError = e;
    }
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

  Text _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError);
      _retrieveDataError = null;
      return result;
    }
    return null;
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

  //getdata area
  Future<void> _uploadData() async {
    String simpanan = "";
    switch (widget.simpanan) {
      case "Sukarela 1":
        simpanan = "SS1";
        break;
      case "Sukarela 2":
        simpanan = "SS2";
        break;
      default:
        break;
    }
    Map<String, String> body = {
      'kodebank': widget.bank.idbank,
      'bank': widget.bank.nama,
      'rekening': widget.rekening,
      'nominal': widget.nominal.toString(),
      'bukti': _bukti,
      'nama': widget.nama,
      'simpanan': simpanan,
      'jangka': widget.jangka
    };

    final prefs = await SharedPreferences.getInstance();
    tokens = prefs.getString('LastToken') ?? '';
    final response = await http.post(Uri.parse(url),
        headers: headers, body: json.encode(body));

    if (response.statusCode == 200) {
      setState(() {
        _loading = false;
      });
      Navigator.pushAndRemoveUntil(
          _context,
          MaterialPageRoute(builder: (context) => UploadBerhasilScreen()),
          ModalRoute.withName("/HomeScreen"));
    } else if (response.statusCode == 401) {
      // Navigator.of(context).pushReplacementNamed('/LoginScreen');
    }
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
              'Upload bukti transfer',
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

  Widget _info() {
    return Container(
      width: maxWidth,
      height: 120,
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
                    "Informasi Rekening Pengirim",
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
                  Text("Nama Bank : "),
                  Text(widget.bank.nama)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("No Rekening : "),
                  Text(widget.rekening)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[Text("Nama Pemilik : "), Text(widget.nama)],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _petunjuk() {
    return Container(
      width: maxWidth,
      height: 200,
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
                  Text("Petunjuk Pembayaran",
                      style:
                          TextStyle(fontSize: 14.0, fontFamily: "NeoSansBold")),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                  "Silahkan melakukan pemindahan dana / transfer ke nomor rekening / virtual account K3PG berikut. Pastikan Nominal sama persis sampai di digit ratusan / satuan.",
                  textAlign: TextAlign.justify,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 30,
                  style: TextStyle(fontSize: 14.0, fontFamily: "NeoSans")),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Tipe Simpanan"),
                  Text(
                    "Simpanan " + widget.simpanan,
                    style: TextStyle(fontFamily: "NeoSansBold"),
                  )
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Total Pembayaran"),
                  Text(formatCurrency(widget.nominal))
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("No Rekening/Virtual Account :"),
                  Text(va == null ? '' : va)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[Text("Nama Penerima  K3PG")],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _uploadArea() {
    return Container(
        width: maxWidth,
        height: _imageFile == null ? 150 : 620,
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
                      Text("Upload bukti transfer / penyetoran",
                          style: TextStyle(
                              fontSize: 14.0, fontFamily: "NeoSansBold")),
                    ],
                  ),
                  new SizedBox(
                    height: 30.0,
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
                    child: new Text('Pilih Bukti Transfer'),
                  )
                ]))));
  }

  Widget areaBaru() {
    return Container(
        width: maxWidth,
        height: 150,
        color: Colors.grey[200],
        child: Card(
            elevation: 5.0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 8.0),
                child: Column(children: <Widget>[]))));
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
          appBar: appBarDetail(context, "Transfer & Upload Bukti Transfer"),
          backgroundColor: Colors.grey[300],
          body: new Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[_info(), _petunjuk(), _uploadArea()],
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
}
