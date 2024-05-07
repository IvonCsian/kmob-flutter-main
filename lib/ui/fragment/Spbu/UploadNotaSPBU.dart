import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
// import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kmob/common/functions/format.dart';
import 'package:kmob/common/functions/future.dart';
import 'package:kmob/common/platform/platformScaffold.dart';
import 'package:kmob/common/widgets/widget.dart';
import 'package:kmob/utils/constant.dart';
// import 'package:progress_hud/progress_hud.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';

class TabEntriNotaSPBU extends StatefulWidget {
  const TabEntriNotaSPBU({Key key}) : super(key: key);

  @override
  State<TabEntriNotaSPBU> createState() => _TabEntriNotaSPBUState();
}

class _TabEntriNotaSPBUState extends State<TabEntriNotaSPBU> {
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Manual'),
    Tab(text: 'Otomatis'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        backgroundColor: Colors.white54,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: AppBar(
            backgroundColor: ColorPalette.warnaCorporate,
            bottom: TabBar(
              labelStyle: TextStyle(
                  color: Colors.white, fontSize: 14.0, fontFamily: "WorkSans"),
              tabs: myTabs,
            ),
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            new NotaSPBUManual(),
            new NotaSPBUOtomatis(),
          ],
        ),
      ),
    );
  }
}

class NotaSPBUManual extends StatefulWidget {
  const NotaSPBUManual({Key key}) : super(key: key);

  @override
  State<NotaSPBUManual> createState() => _NotaSPBUManualState();
}

class _NotaSPBUManualState extends State<NotaSPBUManual> {
  bool _loading = false;
  File fileNota;
  // String noNota = '';
  // String tglNota = '';
  // String jmlNota = '';

  bool adaKodeSPBU = false;

  TextEditingController txNoNota = TextEditingController();
  TextEditingController txTglNota = TextEditingController();
  TextEditingController txJmlNota = TextEditingController();

  String formattedAmount = '';

  String _errorTextNoNota;
  String _errorTextTglNota;
  String _errorTextJmlNota;
  String _errorImageFile = '';

  String username;
  File _imageFile;

  String outputText;

  String _filename;

  double maxspbu = 0;

  void formatUang(String value) {
    try {
      if (value == '') {
        value = '0';
      }
      _errorTextJmlNota = "";
      formattedAmount = formatCurrency(double.parse(value), 0);

      setState(() {});
    } catch (e) {
      setState(() {
        _errorTextJmlNota = "Diisi dengan angka saja";
      });
    }
  }

  Future<void> _optionsDialogBox(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      _getImage("camera");
                    },
                    leading: Container(
                      padding: EdgeInsets.only(right: 12.0),
                      decoration: BoxDecoration(
                          border: Border(
                              right:
                                  BorderSide(width: 1.0, color: Colors.blue))),
                      child: Icon(Icons.camera_alt, color: Colors.blue),
                    ),
                    title: Text('Ambil Foto', style: TextStyle(fontSize: 18.0)),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      _getImage("gallery");
                    },
                    leading: Container(
                      padding: EdgeInsets.only(right: 12.0),
                      decoration: BoxDecoration(
                          border: Border(
                              right:
                                  BorderSide(width: 1.0, color: Colors.blue))),
                      child: Icon(Icons.image, color: Colors.blue),
                    ),
                    title: Text('Pilih Dari Media/Gallery',
                        style: TextStyle(fontSize: 18.0)),
                  )
                ],
              ),
            ),
          );
        });
  }

  Future _getImage(String mode) async {
    try {
      File imageFile;
      XFile ximageFile;

      setState(() {
        _loading = true;
      });
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

      final prefs = await SharedPreferences.getInstance();

      username = prefs.getString('LastUser') ?? '';

      imageFile = File(ximageFile.path);

      setState(() {
        _imageFile = imageFile;
        _filename = username + "_" + basename(imageFile.path);

        _loading = false;
      });

      debugPrint(_imageFile.toString());
    } catch (e) {
      _errorImageFile = e.toString();

      setState(() {
        _loading = false;
      });
    }
  }

  void _validateNoNota(String value) {
    final RegExp numericRegex = RegExp(r'^[0-9]+$'); //

    if (value.isEmpty || value.length > 20 || !numericRegex.hasMatch(value)) {
      _errorTextNoNota = 'Harus diisi angka saja (maksimal 20 karakter)';
    } else {
      _errorTextNoNota = null;
    }
    setState(() {});
  }

  void _validateTglNota(String value) {
    if (value.isEmpty) {
      _errorTextTglNota = 'Harus diisi';
    } else {
      _errorTextTglNota = null;
    }

    setState(() {});
  }

  void _validateJmlNota(String value) {
    final RegExp numericRegex = RegExp(
        r'^[0-9]+$'); // Ekspresi reguler untuk memeriksa apakah nilai hanya berisi angka

    double valueDouble;

    if (value.isNotEmpty) {
      try {
        valueDouble = double.parse(value);
      } catch (e) {
        _errorTextJmlNota = 'Harus berisi angka saja';
        setState(() {});
      }
    }

    if (value.isEmpty || !numericRegex.hasMatch(value)) {
      _errorTextJmlNota = 'Harus berisi angka saja';
    } else if (valueDouble > maxspbu) {
      debugPrint("jumlah lebih");

      _errorTextJmlNota = 'Jumlah lebih dari ' + formatCurrency(maxspbu);
    } else {
      _errorTextJmlNota = null;
    }

    setState(() {});
  }

  void _validateImageFile() {
    if (_imageFile != null) {
      _errorImageFile = '';
    } else {
      _errorImageFile = 'Bukti nota harus diupload';
    }

    setState(() {});
  }

  Future<void> _handleSubmit(BuildContext context) async {
    if (_loading) {
      return;
    }
    setState(() {
      _loading = true;
    });

    String noNota = txNoNota.text;
    String tglNota = txTglNota.text;
    String jmlNota = txJmlNota.text;

    _validateNoNota(noNota);
    _validateTglNota(tglNota);
    _validateJmlNota(jmlNota);
    _validateImageFile();

    if (_errorTextNoNota == null &&
        _errorTextTglNota == null &&
        _errorTextJmlNota == null &&
        _imageFile != null) {
      // Lakukan tindakan setelah validasi berhasil
      debugPrint('Nomor Nota: $noNota');
      debugPrint('Tanggal Nota: $tglNota');
      // Lakukan sesuatu, misalnya simpan data atau kirim data ke server

      bool konfirmasi = await confirmDialog(context,
          title: 'Konfirmasi', content: Text('Input sudah sesuai?'));

      if (!konfirmasi) {
        setState(() {
          _loading = false;
        });
        return;
      }

      final StorageReference firebaseStorageRef =
          FirebaseStorage.instance.ref().child(_filename);
      final StorageUploadTask task = firebaseStorageRef.putFile(_imageFile);
      var downUrl = await (await task.onComplete).ref.getDownloadURL();
      var urlBukti = downUrl.toString();

      // var urlBukti = '';

      debugPrint("url firestore: " + urlBukti);

      // if (urlBukti != "") {
      //   _bukti = urlBukti;
      // }

      String url = APIConstant.urlBase + APIConstant.serverApi + "nota/new";

      Map<String, String> body = {
        // 'tanggal': widget.tanggal,
        // 'no_nota': widget.noNota,
        // 'nominal': widget.nominal.toString(),
        'tanggal': txTglNota.text,
        'no_nota': txNoNota.text,
        'nominal': txJmlNota.text,
        'bukti': urlBukti
      };

      try {
        var response =
            await executeRequest(url, body: body, method: RequestMethod.POST);

        if (response.statusCode == 200) {
          Future.delayed(Duration(seconds: 1), () {
            setState(() {
              _loading = false;
            });

            showInfoDialog(
              context,
              title: 'Sukses',
              content: Text(
                  'Bukti transaksi SPBU Anda berhasil diupload. Proses penyetoran sedang dalam proses verifikasi.'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();

                      resetInput();
                      formatUang('');
                    },
                    child: Text('Ok'))
              ],
            );
          });
        } else if (response.statusCode == 401) {
          Navigator.of(context).pushReplacementNamed('/LoginScreen');
        }
      } catch (e) {
        setState(() {
          _loading = false;
        });

        showInfoDialog(
          context,
          title: 'Gagal',
          content: Text('Terjadi kesalahan teknis, hubungi administrator.'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();

                  resetInput();
                  formatUang('');
                },
                child: Text('Ok'))
          ],
        );
      }
    } else {
      setState(() {
        _loading = false;
      });

      showInfoDialog(
        context,
        title: 'Validasi Input',
        content: Text(
            'Ada kesalahan dalam pengisian form. Silakan periksa kembali.'),
      );

      // Tampilkan pesan kesalahan atau lakukan tindakan lain jika validasi gagal
    }
  }

  void resetInput() {
    setState(() {
      txNoNota.text = "";
      txTglNota.text = "";
      txJmlNota.text = "";
      _imageFile = null;
    });
  }

  Future<void> startState() async {
    var url = APIConstant.urlBase + APIConstant.serverApi + "/profile";

    var response = await executeRequest(url);

    var dataBody = jsonDecode(response.body);

    debugPrint("dataBody: " + dataBody.toString());

    maxspbu = double.parse(dataBody['akun']['max_spbu']);

    debugPrint("maxspbu: $maxspbu");

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    startState();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: "No Nota SPBU : ",
                                icon: Icon(FontAwesomeIcons.userTag,
                                    color: Colors.blue),
                                errorText: _errorTextNoNota,
                              ),
                              keyboardType: TextInputType.text,
                              controller: txNoNota,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: "Tanggal : ",
                                icon: Icon(FontAwesomeIcons.calendar,
                                    color: Colors.blue),
                                errorText: _errorTextTglNota,
                              ),
                              // keyboardType: TextInputType.datetime,
                              // validator: (String arg) {},
                              controller: txTglNota,
                              readOnly: true,
                              // initialValue: tglNota,
                              onTap: () async {
                                DateTime pickedDate =
                                    await DatePicker.showDatePicker(
                                  context,
                                  maxTime: DateTime.now(),
                                );

                                if (pickedDate != null) {
                                  String formattedDate =
                                      DateFormat('yyyy-MM-dd')
                                          .format(pickedDate);

                                  setState(() {
                                    txTglNota.text = formattedDate;
                                  });
                                }
                              },
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: "Jumlah : ",
                                icon: Icon(FontAwesomeIcons.moneyBill,
                                    color: Colors.blue),
                                errorText: _errorTextJmlNota,
                                counterText: formattedAmount,
                              ),
                              keyboardType: TextInputType.number,
                              controller: txJmlNota,
                              onChanged: (value) {
                                formatUang(value);
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text('Upload Nota SPBU:'),
                            tombol(
                              // backgroundColor: Colors.green,
                              onPressed: () {
                                _optionsDialogBox(context);
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    FontAwesomeIcons.upload,
                                    color: Colors.white,
                                    size: 15.0,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text('Upload Bukti'),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: _imageFile != null
                                  ? Image.file(_imageFile)
                                  : Container(
                                      height: 30,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[100]),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            _errorImageFile != ''
                                                ? _errorImageFile
                                                : 'silahkan upload bukti nota SPBU',
                                            style: TextStyle(
                                                color: _errorImageFile != ''
                                                    ? Colors.red
                                                    : Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                            // if (_errorImageFile != '')
                            //   Text(
                            //     _errorImageFile,
                            //     style: TextStyle(color: Colors.red),
                            //   ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                  "Harap pastikan foto yang diupload dapat terbaca dengan jelas. Tidak Blur/Buram, Gelap atau susah terbaca",
                                  textAlign: TextAlign.justify,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 30,
                                  style: TextStyle(
                                      fontSize: 12.0, fontFamily: "NeoSans")),
                            ),
                            Divider(),
                            tombol(
                                onPressed: () {
                                  _handleSubmit(context);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.save,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text('Simpan')
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
          if (_loading) loadingView(),
        ],
      ),
    );
  }
}

class NotaSPBUOtomatis extends StatefulWidget {
  const NotaSPBUOtomatis({Key key}) : super(key: key);

  @override
  State<NotaSPBUOtomatis> createState() => _NotaSPBUOtomatisState();
}

class _NotaSPBUOtomatisState extends State<NotaSPBUOtomatis> {
  bool _loading = false;
  // File fileNota;
  String noNota = '';
  String tglNota = '';
  String jmlNota = '';

  bool adaKodeSPBU = false;

  TextEditingController txNoNota = TextEditingController(text: '');
  TextEditingController txTglNota = TextEditingController(text: '');
  TextEditingController txJmlNota = TextEditingController(text: '');

  String _errorTextNoNota;
  String _errorTextTglNota;
  String _errorTextJmlNota;
  String _errorImageFile = '';

  String username;
  File _imageFile = null;
  String _filename;

  // var _pickImageError;
  // String _filename;
  // var _pickedImage;

  String outputText;

  double maxspbu = 0;

  var formattedAmount;

  BuildContext _context;

  void formatUang(String value) {
    try {
      if (value == '') {
        value = '0';
      }
      _errorTextJmlNota = "";
      formattedAmount = formatCurrency(double.parse(value), 0);

      setState(() {});
    } catch (e) {
      setState(() {
        _errorTextJmlNota = "Diisi dengan angka saja";
      });
    }
  }

  Future<void> _optionsDialogBox(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
                child: ListBody(
              children: <Widget>[
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    _getImage("camera");
                  },
                  leading: Container(
                    padding: EdgeInsets.only(right: 12.0),
                    decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(width: 1.0, color: Colors.blue))),
                    child: Icon(Icons.camera_alt, color: Colors.blue),
                  ),
                  title: Text('Ambil Foto', style: TextStyle(fontSize: 18.0)),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    _getImage("gallery");
                  },
                  leading: Container(
                    padding: EdgeInsets.only(right: 12.0),
                    decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(width: 1.0, color: Colors.blue))),
                    child: Icon(Icons.image, color: Colors.blue),
                  ),
                  title: Text('Pilih Dari Media/Gallery',
                      style: TextStyle(fontSize: 18.0)),
                )
              ],
            )),
          );
        });
  }

  Future _getImage(String mode) async {
    setState(() {
      _loading = true;
    });

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

      // setState(() {
      //   _imageFile = imageFile;
      //   _filename = username + "_" + basename(imageFile.path);
      // });

      imageFile = File(ximageFile.path);

      debugPrint(_imageFile.toString());

      performOCR(imageFile);
    } catch (e) {
      debugPrint(e.toString());
      showInfoDialog(_context,
          title: 'Validasi Input',
          content: Text('Terjadi kesalahan ulangi lagi'));
    }

    setState(() {
      _loading = false;
    });
  }

  Future<void> performOCR(File imageFile) async {
    adaKodeSPBU = false;

    if (imageFile == null) return;

    final inputImage = InputImage.fromFile(imageFile);
    TextRecognizer textRecognizer = TextRecognizer();

    final recognisedText = await textRecognizer.processImage(inputImage);

    outputText = "";

    Match matchNoTrans;
    Match matchWaktu;
    Match matchjmlnota;
    Match matchjmlnota0;
    Match matchjmlnota1;

    String noTrans;
    String waktuFormatted;
    int harga;

    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        outputText += "${line.text}";

        debugPrint(line.text);

        RegExp regex = RegExp(r'\b5461101\b');
        if (regex.hasMatch(line.text)) {
          adaKodeSPBU = true;
        }

        RegExp regexNoTrans = RegExp(r'No\. Trans: (\d+)');
        matchNoTrans = regexNoTrans.firstMatch(line.text);

        if (matchNoTrans != null) {
          noTrans = matchNoTrans.group(1);

          debugPrint('Nomor Transaksi: $noTrans');

          // txNoNota.text = noTrans;
        }
        // else {
        // debugPrint('No. Trans tidak ditemukan.');
        // }

        RegExp regexWaktu = RegExp(r'ktu: (\d{2}/\d{2}/\d{4})');

        matchWaktu = regexWaktu.firstMatch(line.text);

        if (matchWaktu != null) {
          String waktuString = matchWaktu.group(1);
          DateTime waktu = DateFormat('dd/MM/yyyy').parse(waktuString);

          waktuFormatted = DateFormat('yyyy-MM-dd').format(waktu);

          // txTglNota.text = waktuFormatted;

          debugPrint('String "Waktu": $waktuString');
          debugPrint('Tanggal dalam format baru: $waktuFormatted');
        }

        RegExp regexJmlNota = RegExp(
            r'Total\sHarga:\sRp[.,]?\s?(\d{1,3}(?:[,.]\d{3})*(?:,\d{1,2})?)');

        matchjmlnota = regexJmlNota.firstMatch(line.text);

        if (matchjmlnota != null) {
          String hargaString = matchjmlnota.group(1);

          harga = int.parse(hargaString.replaceAll(RegExp(r'[,.]'), ''));

          // txJmlNota.text = harga.toString();

          debugPrint('String Harga: $hargaString');
          debugPrint('Harga (tanpa koma atau titik): $harga');
        }

        RegExp regexJmlNota0 = RegExp(
            r'Total\sHarga\s:\sRp[.,]?\s?(\d{1,3}(?:[,.]\d{3})*(?:,\d{1,2})?)');

        matchjmlnota0 = regexJmlNota0.firstMatch(line.text);

        if (matchjmlnota0 != null) {
          String hargaString = matchjmlnota0.group(1);
          harga = int.parse(hargaString.replaceAll(RegExp(r'[,.]'), ''));

          // txJmlNota.text = harga.toString();

          debugPrint('String Harga: $hargaString');
          debugPrint('Harga (tanpa koma atau titik): $harga');
        }

        RegExp regexJmlNota1 = RegExp(
            r'Total\sHarga\sRp[.,]?\s?(\d{1,3}(?:[,.]\d{3})*(?:,\d{1,2})?)');

        matchjmlnota1 = regexJmlNota1.firstMatch(line.text);

        if (matchjmlnota1 != null) {
          String hargaString = matchjmlnota1.group(1);
          harga = int.parse(hargaString.replaceAll(RegExp(r'[,.]'), ''));

          // txJmlNota.text = harga.toString();

          debugPrint('String Harga: $hargaString');
          debugPrint('Harga (tanpa koma atau titik): $harga');
        }
      }
    }

    if (adaKodeSPBU) {
      final prefs = await SharedPreferences.getInstance();

      username = prefs.getString('LastUser') ?? '';

      _imageFile = imageFile;
      _filename = username + "_" + basename(imageFile.path);

      debugPrint(_filename);

      txNoNota.text = noTrans;
      txTglNota.text = waktuFormatted;
      txJmlNota.text = harga.toString();

      setState(() {});
    } else {
      showInfoDialog(
        _context,
        title: 'Validasi Input',
        content: Text('Kode SPBU tidak benar, ulangi upload bukti'),
      );

      _imageFile = null;

      setState(() {});
    }

    debugPrint(outputText);
  }

  void _validateNoNota(String value) {
    final RegExp numericRegex = RegExp(r'^[0-9]+$'); //

    if (value.isEmpty || value.length > 20 || !numericRegex.hasMatch(value)) {
      _errorTextNoNota = 'Harus diisi angka saja (maksimal 20 karakter)';
    } else {
      _errorTextNoNota = null;
    }

    setState(() {});
  }

  void _validateTglNota(String value) {
    if (value.isEmpty) {
      _errorTextTglNota = 'Harus diisi';
    } else {
      _errorTextTglNota = null;
    }

    setState(() {});
  }

  void _validateJmlNota(String value) {
    final RegExp numericRegex = RegExp(
        r'^[0-9]+$'); // Ekspresi reguler untuk memeriksa apakah nilai hanya berisi angka

    double valueDouble;

    if (value.isNotEmpty) {
      try {
        valueDouble = double.parse(value);
      } catch (e) {
        setState(() {
          _errorTextJmlNota = 'Harus berisi angka saja';
        });
      }
    }

    if (value.isEmpty || !numericRegex.hasMatch(value)) {
      _errorTextJmlNota = 'Harus berisi angka saja';
    } else if (valueDouble > maxspbu) {
      debugPrint("jumlah lebih");

      _errorTextJmlNota = 'Jumlah lebih dari ' + formatCurrency(maxspbu);
    } else {
      _errorTextJmlNota = null;
    }

    setState(() {});
  }

  void _validateImageFile() {
    if (_imageFile != null) {
      _errorImageFile = '';
    } else {
      _errorImageFile = 'Bukti nota harus diupload';
    }

    setState(() {});
  }

  Future<void> _handleSubmit() async {
    if (_loading) {
      return;
    }
    setState(() {
      _loading = true;
    });

    String noNota = txNoNota.text;
    String tglNota = txTglNota.text;
    String jmlNota = txJmlNota.text;

    _validateNoNota(noNota);
    _validateTglNota(tglNota);
    _validateJmlNota(jmlNota);
    _validateImageFile();

    if (_errorTextNoNota == null &&
        _errorTextTglNota == null &&
        _errorTextJmlNota == null &&
        _imageFile != null) {
      // Lakukan tindakan setelah validasi berhasil
      debugPrint('Nomor Nota: $noNota');
      debugPrint('Tanggal Nota: $tglNota');
      // Lakukan sesuatu, misalnya simpan data atau kirim data ke server

      bool konfirmasi = await confirmDialog(_context,
          title: 'Konfirmasi', content: Text('Input sudah sesuai?'));

      if (!konfirmasi) {
        setState(() {
          _loading = false;
        });
        return;
      }

      final StorageReference firebaseStorageRef =
          FirebaseStorage.instance.ref().child(_filename);
      final StorageUploadTask task = firebaseStorageRef.putFile(_imageFile);
      var downUrl = await (await task.onComplete).ref.getDownloadURL();
      var urlBukti = downUrl.toString();

      // var urlBukti = '';

      debugPrint("url firestore: " + urlBukti);

      // if (urlBukti != "") {
      //   _bukti = urlBukti;
      // }

      String url = APIConstant.urlBase + APIConstant.serverApi + "nota/new/oto";

      Map<String, String> body = {
        // 'tanggal': widget.tanggal,
        // 'no_nota': widget.noNota,
        // 'nominal': widget.nominal.toString(),
        'tanggal': txTglNota.text,
        'no_nota': txNoNota.text,
        'nominal': txJmlNota.text,
        'bukti': urlBukti
      };

      try {
        var response =
            await executeRequest(url, body: body, method: RequestMethod.POST);

        if (response.statusCode == 200) {
          Future.delayed(Duration(seconds: 1), () {
            setState(() {
              _loading = false;
            });

            showInfoDialog(
              _context,
              title: 'Sukses',
              content: Text(
                  'Bukti transaksi SPBU Anda berhasil diupload dan diverifikasi.'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(_context).pop();

                      resetInput();
                      formatUang('');
                    },
                    child: Text('Ok'))
              ],
            );
          });
        } else if (response.statusCode == 401) {
          Navigator.of(_context).pushReplacementNamed('/LoginScreen');
        }
      } catch (e) {
        setState(() {
          _loading = false;
        });

        showInfoDialog(
          _context,
          title: 'Gagal',
          content: Text('Terjadi kesalahan teknis, hubungi administrator.'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(_context).pop();

                  resetInput();
                  formatUang('');
                },
                child: Text('Ok'))
          ],
        );
      }
    } else {
      setState(() {
        _loading = false;
      });

      showInfoDialog(
        _context,
        title: 'Validasi Input',
        content: Text(
            'Ada kesalahan dalam pengisian form. Silakan periksa kembali.'),
      );

      // Tampilkan pesan kesalahan atau lakukan tindakan lain jika validasi gagal
    }
  }

  void resetInput() {
    setState(() {
      txNoNota.text = "";
      txTglNota.text = "";
      txJmlNota.text = "";
      _imageFile = null;
    });
  }

  Future<void> startState() async {
    var url = APIConstant.urlBase + APIConstant.serverApi + "/profile";

    var response = await executeRequest(url);

    var dataBody = jsonDecode(response.body);

    debugPrint("dataBody: " + dataBody.toString());

    maxspbu = double.parse(dataBody['akun']['max_spbu']);

    debugPrint("maxspbu: $maxspbu");

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();

    startState();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;

    debugPrint('image gambar: ' + _imageFile.toString());

    return PlatformScaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          SingleChildScrollView(
            // physics: NeverScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text('Upload Nota SPBU'),
                            ),
                            tombol(
                              // backgroundColor: Colors.green,
                              onPressed: () {
                                _optionsDialogBox(context);
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    FontAwesomeIcons.upload,
                                    color: Colors.white,
                                    size: 15.0,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text('Upload Bukti'),
                                ],
                              ),
                            ),
                            Divider(),
                            Text(
                                "Harap pastikan foto yang diupload dapat terbaca dengan jelas. Tidak Blur/Buram, Gelap atau susah terbaca",
                                textAlign: TextAlign.justify,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 30,
                                style: TextStyle(
                                    fontSize: 14.0, fontFamily: "NeoSans"))
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: _imageFile == null
                                  ? Container(
                                      height: 30,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[100]),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            (_errorImageFile != '')
                                                ? _errorImageFile
                                                : 'Upload gambar untuk input otomatis',
                                            style: TextStyle(
                                                color: _errorImageFile != ''
                                                    ? Colors.red
                                                    : Colors.black),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Image.file(_imageFile),
                            ),
                            // Text('No. Nota'),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: "No Nota SPBU : ",
                                icon: Icon(FontAwesomeIcons.userTag,
                                    color: Colors.blue),
                                errorText: _errorTextNoNota,
                              ),
                              keyboardType: TextInputType.text,
                              controller: txNoNota,
                              readOnly: true,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: "Tanggal : ",
                                icon: Icon(FontAwesomeIcons.calendar,
                                    color: Colors.blue),
                                errorText: _errorTextTglNota,
                                // border: InputBorder.none,
                              ),
                              // keyboardType: TextInputType.datetime,
                              // validator: (String arg) {},
                              controller: txTglNota,
                              readOnly: true,
                              // initialValue: tglNota,
                              onTap: () async {
                                // DateTime pickedDate =
                                //     await DatePicker.showDatePicker(
                                //   context,
                                //   maxTime: DateTime.now(),
                                // );

                                // if (pickedDate != null) {
                                //   String formattedDate =
                                //       DateFormat('yyyy-MM-dd')
                                //           .format(pickedDate);

                                //   setState(() {
                                //     txTglNota.text = formattedDate;
                                //   });
                                // }
                              },
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: "Jumlah : ",
                                icon: Icon(FontAwesomeIcons.moneyBill,
                                    color: Colors.blue),
                                errorText: _errorTextJmlNota,
                                counterText: formattedAmount,
                              ),
                              keyboardType: TextInputType.number,
                              controller: txJmlNota,
                              onChanged: ((value) {
                                formatUang(value);
                              }),
                              readOnly: true,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            tombol(
                                onPressed: () {
                                  _handleSubmit();
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.save,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text('Simpan')
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
          if (_loading) loadingView()
        ],
      ),
    );
  }
}
