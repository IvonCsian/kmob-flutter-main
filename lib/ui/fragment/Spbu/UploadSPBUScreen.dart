import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kmob/common/platform/platformScaffold.dart';
import 'package:kmob/common/widgets/MyAppBar.dart';
import 'package:kmob/model/bank_model.dart';
import 'package:kmob/ui/fragment/Spbu/UploadNotaBerhasilScreen.dart';
import 'package:kmob/utils/constant.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:progress_hud/progress_hud.dart';

class UploadSPBUScren extends StatefulWidget {
  // final String noNota;
  // final String tanggal;
  // final double nominal;

  const UploadSPBUScren({Key key
      // , this.noNota, this.tanggal, this.nominal
      })
      : super(key: key);

  @override
  _UploadSPBUScrenState createState() => _UploadSPBUScrenState();
}

class _UploadSPBUScrenState extends State<UploadSPBUScren> {
  String _filename;

  String _retrieveDataError;
  File _imageFile;
  BuildContext _context;
  bool _loading = false;
  double maxWidth = 0;
  double maxHeight = 0;
  dynamic _pickImageError;
  String _bukti;
  String username;

  String url =
      "" + APIConstant.urlBase + "" + APIConstant.serverApi + "nota/new";
  Map<String, String> get headers => {
        'Authorization': 'Bearer $tokens',
        'Content-Type': 'application/json',
      };

  @override
  void initState() {
    super.initState();
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

  void toggleProgressHUD() {
    setState(() {
      _loading = !_loading;
    });
  }

  @override
  void dispose() {
    super.dispose();
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
          appBar: appBarDetail(context, "Upload Struk Bukti Transaksi"),
          backgroundColor: Colors.grey[300],
          body: new Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[_petunjuk(), _uploadArea()],
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

  Widget _uploadArea() {
    return Container(
        width: maxWidth,
        height: _imageFile == null ? 250 : 620,
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
                      Text("Upload nota bukti transaksi SPBU",
                          style: TextStyle(
                              fontSize: 14.0, fontFamily: "NeoSansBold")),
                    ],
                  ),
                  new SizedBox(
                    height: 10.0,
                  ),
                  Text(
                      "Harap pastikan foto yang diupload dapat terbaca dengan jelas. Tidak Blur/Buram, Gelap atau susah terbaca",
                      textAlign: TextAlign.justify,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 30,
                      style: TextStyle(fontSize: 14.0, fontFamily: "NeoSans")),
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
                    child: new Text('Pilih Nota / Bukti Transaksi'),
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

  Text _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Future _getImage(String mode) async {
    try {
      File imageFile;
      XFile ximageFile;
      ImagePicker imagePicker = ImagePicker();

      switch (mode) {
        case 'camera':
          ximageFile = await imagePicker.pickImage(
              source: ImageSource.camera, maxHeight: 450.0, maxWidth: 450.0);
          break;
        case 'gallery':
          ximageFile = await imagePicker.pickImage(
              source: ImageSource.gallery, maxHeight: 450.0, maxWidth: 450.0);
          break;
        default:
      }

      imageFile = File(ximageFile.path);

      final prefs = await SharedPreferences.getInstance();

      username = prefs.getString('LastUser') ?? '';

      setState(() {
        _imageFile = imageFile;
        _filename = username + "_" + basename(imageFile.path);
      });
    } catch (e) {
      _pickImageError = e;
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
              'Upload Bukti Transaksi',
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

    // final StorageReference firebaseStorageRef =
    //     FirebaseStorage.instance.ref().child(_filename);
    // final StorageUploadTask task = firebaseStorageRef.putFile(_imageFile);
    // var downUrl = await (await task.onComplete).ref.getDownloadURL();
    // var url = downUrl.toString();
    // if (url != "") {
    //   _bukti = url;
    // }

    _uploadData();
  }

  //getdata area
  Future<void> _uploadData() async {
    Map<String, String> body = {
      // 'tanggal': widget.tanggal,
      // 'no_nota': widget.noNota,
      // 'nominal': widget.nominal.toString(),
      'tanggal': '',
      'no_nota': '',
      'nominal': ''.toString(),
      'bukti': _bukti
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
          MaterialPageRoute(builder: (context) => UploadNotaBerhasilScreen()),
          ModalRoute.withName("/HomeScreen"));
    } else if (response.statusCode == 401) {
      // Navigator.of(context).pushReplacementNamed('/LoginScreen');
    }
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
                  Text("Petunjuk",
                      style:
                          TextStyle(fontSize: 14.0, fontFamily: "NeoSansBold")),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Text("Silahkan upload bukti transaksi",
                  textAlign: TextAlign.justify,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 30,
                  style: TextStyle(fontSize: 14.0, fontFamily: "NeoSans")),
            ],
          ),
        ),
      ),
    );
  }
}
