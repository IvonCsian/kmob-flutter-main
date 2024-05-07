import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kmob/common/functions/format.dart';
import 'package:kmob/common/functions/future.dart';
import 'package:kmob/common/functions/ui.dart';
import 'package:kmob/common/platform/platformScaffold.dart';
import 'package:kmob/common/widgets/widget.dart';
import 'package:kmob/utils/constant.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';

class PengajuanPinjaman extends StatefulWidget {
  PengajuanPinjaman({Key key}) : super(key: key);

  @override
  _PengajuanPinjamanState createState() => _PengajuanPinjamanState();
}

class _PengajuanPinjamanState extends State<PengajuanPinjaman> {
  bool _loading = false;

  String nak;

  bool isPG = false;

  String username;

  BuildContext _context;

  String jangkaController = '';
  String _errorJangka;

  List<DropdownMenuItem> listTenorDefault = [
    const DropdownMenuItem(
      child: Text('[-pilih-]'),
      value: '',
    ),
  ];

  List<DropdownMenuItem> listTenor = [];

  TextEditingController txJmlPinjam = TextEditingController();
  String _errorTextJmlPinjam;
  String formattedJmlPinjam = 'Rp. 0';

  TextEditingController txJmlAngsuran = TextEditingController(text: '0');

  String formattedAngsuran = 'Rp. 0';

  final _debouncer = Debouncer(milliseconds: 1000);

  File fotoKtpFile;
  String fotoKtpController = '';
  String fotoKtpError = '';

  File fotoBuktiPotongFile;
  String fotoBuktiPotongController = '';
  String fotoBuktiPotongError = '';

  File fotoSlipGajiFile;
  String fotoSlipGajiController = '';
  String fotoSlipGajiError = '';

  File fotoMemoFile;
  String fotoMemoController = '';
  String fotoMemoError = '';

  void formatJmlPinjam(String value) {
    try {
      if (value.length < 5) {
        _errorTextJmlPinjam = "minimal 5 karakter";
      } else {
        if (value == '') {
          value = '0';
        }
        _errorTextJmlPinjam = null;
        formattedJmlPinjam = formatCurrency(double.parse(value), 0);

        _debouncer.run(() {
          debugPrint('Input jumlah selesai');

          getAngsuran();
        });
      }

      setState(() {});
    } catch (e) {
      setState(() {
        _errorTextJmlPinjam = "Diisi dengan angka saja";
      });
    }
  }

  void formatJmlAngsuran(String value) {
    try {
      formattedAngsuran = formatCurrency(double.parse(value), 0);
      // if (value.length < 5) {
      //   _errorTextJmlPinjam = "minimal 5 karakter";
      // } else {
      // if (value == '') {
      //   value = '0';
      // }
      // _errorTextJmlPinjam = null;

      // _debouncer.run(() {
      //   debugPrint('Input jumlah selesai');

      //   getAngsuran();
      // });
      // }

      setState(() {});
    } catch (e) {
      setState(() {
        // _errorTextJmlAngsuran = "Diisi dengan angka saja";
      });
    }
  }

  getTenor() async {
    listTenor = listTenorDefault;

    String url =
        APIConstant.urlBase + APIConstant.serverApi + "pinjaman/tenor_reguler";

    try {
      Response response = await executeRequest(url);

      if (response.statusCode == 200) {
        List<dynamic> dataTenor = jsonDecode(response.body);

        for (var element in dataTenor) {
          listTenor.add(DropdownMenuItem(
            child: Text(element['tahun']),
            value: element['tempo_bln'],
          ));
        }

        debugPrint(listTenor.toString());

        if (mounted) {
          setState(() {});
        }
      } else {
        if (mounted) {
          showInfoDialog(_context,
              title: 'Network Error', content: Text('Hubungi Adminstrator'));
        }
      }
    } catch (e) {
      if (mounted) {
        showInfoDialog(_context, title: 'Error', content: Text(e.toString()));
      }
    }
  }

  getAngsuran() async {
    if (txJmlPinjam.text == '' || jangkaController == '') {
      return false;
    }

    setState(() {
      formattedAngsuran = 'menghitung ...';
    });

    String url = APIConstant.urlBase +
        APIConstant.serverApi +
        "pinjaman/hitung_angsuran_reguler";

    Map dataPost = {
      "tempo_bln": jangkaController,
      "jml_pinjam": txJmlPinjam.text,
    };

    try {
      Response response =
          await executeRequest(url, method: RequestMethod.POST, body: dataPost);

      if (response.statusCode == 200) {
        var dataResponse = response.body;

        txJmlAngsuran.text = double.parse(dataResponse).round().toString();
        formatJmlAngsuran(dataResponse);

        if (mounted) {
          setState(() {});
        }
      } else {
        if (mounted) {
          showInfoDialog(_context,
              title: 'Network Error', content: Text('Hubungi Adminstrator'));
        }
      }
    } catch (e) {
      if (mounted) {
        showInfoDialog(_context, title: 'Error', content: Text(e.toString()));
      }
    }
  }

  Future<void> _optionsDialogBox(BuildContext context, field) {
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
                      _getImage("camera", field);
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
                      _getImage("gallery", field);
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

  Future _getImage(String mode, String field) async {
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
          PermissionStatus status = await Permission.photos.request();

          debugPrint(status.toString());

          if (status.isGranted) {
            debugPrint('permission granted');
          }

          if (status.isPermanentlyDenied) {
            debugPrint('permanen disable');
            openAppSettings();
          }

          ximageFile = await imagePicker.pickImage(
              source: ImageSource.gallery, maxHeight: 450.0, maxWidth: 450.0);
          break;
        default:
      }

      if (ximageFile == null) {
        return false;
      }

      imageFile = File(ximageFile.path);

      final prefs = await SharedPreferences.getInstance();

      username = prefs.getString('LastUser') ?? '';

      var controller = username + "_" + basename(imageFile.path);
      // var file = imageFile;
      // var error = '';

      setState(() {
        switch (field) {
          case 'fotoktp':
            fotoKtpFile = imageFile;
            fotoKtpController = controller;
            fotoKtpError = '';
            break;
          case 'fotobuktipotong':
            fotoBuktiPotongFile = imageFile;
            fotoBuktiPotongController = controller;
            fotoBuktiPotongError = '';
            break;
          case 'fotoslipgaji':
            fotoSlipGajiFile = imageFile;
            fotoSlipGajiController = controller;
            fotoSlipGajiError = '';
            break;
          case 'fotomemo':
            fotoMemoFile = imageFile;
            fotoMemoController = controller;
            fotoMemoError = '';
            break;
          default:
        }

        _loading = false;
      });
    } catch (e) {
      debugPrint(e.toString());

      switch (field) {
        case 'fotoktp':
          fotoKtpFile = null;
          fotoKtpController = '';
          fotoKtpError = e.toString();
          break;
        case 'fotobuktipotong':
          fotoBuktiPotongFile = null;
          fotoBuktiPotongController = '';
          fotoBuktiPotongError = e.toString();
          break;
        case 'fotoslipgaji':
          fotoSlipGajiFile = null;
          fotoSlipGajiController = '';
          fotoSlipGajiError = e.toString();
          break;
        case 'fotomemo':
          fotoMemoFile = null;
          fotoMemoController = '';
          fotoMemoError = e.toString();
          break;
        default:
      }

      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _kirimData() async {
    if (_loading) {
      return;
    }

    setState(() {
      _loading = true;
    });

    if (jangkaController.isEmpty) {
      // Jika namaController kosong, tampilkan pesan kesalahan
      _errorJangka = 'Jangka harus dipilih';
    } else {
      // Reset pesan kesalahan jika namaController terisi
      _errorJangka = null;
    }

    if (txJmlPinjam.text.isEmpty) {
      // Jika namaController kosong, tampilkan pesan kesalahan
      _errorTextJmlPinjam = 'Nama harus diisi';
    } else if (txJmlPinjam.text.length < 5) {
      // Jika namaController kosong, tampilkan pesan kesalahan
      _errorTextJmlPinjam = 'minimal 5 karakter';
    } else {
      // Reset pesan kesalahan jika namaController terisi
      _errorTextJmlPinjam = null;
    }

    if (fotoKtpFile == null) {
      fotoKtpError = 'Foto KTP harus diupload';
    } else {
      fotoKtpError = null;
    }

    // Validasi fotobuktipotong
    if (fotoBuktiPotongFile == null) {
      fotoBuktiPotongError = 'Foto Bukti Potong harus diupload';
    } else {
      fotoBuktiPotongError = null;
    }

    // Validasi fotoSlipGaji
    if (fotoSlipGajiFile == null) {
      fotoSlipGajiError = 'Foto Slip Gaji harus diupload';
    } else {
      fotoSlipGajiError = null;
    }

    // Validasi memo
    if (isPG) {
      fotoMemoError = null;
    } else {
      if (fotoMemoFile == null) {
        fotoMemoError = 'Foto Memo harus diupload';
      } else {
        fotoMemoError = null;
      }
    }

    if (_errorTextJmlPinjam != null ||
        _errorJangka != null ||
        fotoKtpError != null ||
        fotoBuktiPotongError != null ||
        fotoSlipGajiError != null ||
        fotoMemoError != null) {
      showInfoDialog(_context,
          title: 'Validasi Input',
          content: Text(
              'Ada kesalahan dalam pengisian form. Silakan periksa kembali.'));

      setState(() {
        _loading = false;
      });
    } else {
      bool konfirmasi = await confirmDialog(_context,
          title: 'Konfirmasi', content: Text('Input sudah sesuai?'));

      if (!konfirmasi) {
        setState(() {
          _loading = false;
        });
        return;
      }

      StorageReference firebaseStorageRef;
      StorageUploadTask task;
      var downUrl;

      // foto ktp
      firebaseStorageRef =
          FirebaseStorage.instance.ref().child(fotoKtpController);
      task = firebaseStorageRef.putFile(fotoKtpFile);
      downUrl = await (await task.onComplete).ref.getDownloadURL();
      fotoKtpController = downUrl.toString();
      // fotoKtpController = '';

      // foto slipgaji
      firebaseStorageRef =
          FirebaseStorage.instance.ref().child(fotoSlipGajiController);
      task = firebaseStorageRef.putFile(fotoSlipGajiFile);
      downUrl = await (await task.onComplete).ref.getDownloadURL();
      fotoSlipGajiController = downUrl.toString();
      // fotoSlipGajiController = '';

      // foto bukti potong
      firebaseStorageRef =
          FirebaseStorage.instance.ref().child(fotoBuktiPotongController);
      task = firebaseStorageRef.putFile(fotoBuktiPotongFile);
      downUrl = await (await task.onComplete).ref.getDownloadURL();
      fotoBuktiPotongController = downUrl.toString();
      // fotoBuktiPotongController = '';

      if (isPG == false) {
        // foto memo
        firebaseStorageRef =
            FirebaseStorage.instance.ref().child(fotoMemoController);
        task = firebaseStorageRef.putFile(fotoMemoFile);
        downUrl = await (await task.onComplete).ref.getDownloadURL();
        fotoMemoController = downUrl.toString();

        // fotoMemoController = '';
      } else {
        fotoMemoController = '';
      }

      var dataHttp = {
        'tempo_bln': jangkaController,
        'jml_pinjam': txJmlPinjam.text,
        'no_ang': nak,
        'foto_ktp': fotoKtpController,
        'foto_bukti_potong': fotoBuktiPotongController,
        'foto_slip_gaji': fotoSlipGajiController,
        'foto_memo': fotoMemoController,
        // 'angsuran': txJmlAngsuran.text,
      };

      String url = APIConstant.urlBase +
          APIConstant.serverApi +
          "pinjaman/add_pinj_reguler";

      try {
        var response = await executeRequest(url,
            body: dataHttp, method: RequestMethod.POST);

        if (response.statusCode == 200) {
          Future.delayed(Duration(seconds: 1), () {
            setState(() {
              _loading = false;
            });

            var responseData = jsonDecode(response.body);

            debugPrint(responseData['status'].toString());

            if (!responseData['status']) {
              showInfoDialog(
                _context,
                title: 'Error',
                content: Text(responseData['msg']),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(_context).pop();
                      },
                      child: Text('Ok'))
                ],
              );

              // return;
            } else {
              showInfoDialog(
                _context,
                title: 'Sukses',
                content:
                    Text('Pengajuan berhasil dikirim dan segera kami proses.'),
                actions: [
                  TextButton(
                      onPressed: () {
                        _resetInput();

                        Navigator.of(_context).pop();
                      },
                      child: Text('Ok'))
                ],
              );
            }
          });
        } else if (response.statusCode == 401) {
          Navigator.of(_context).pushReplacementNamed('/LoginScreen');
        } else {
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

                    _resetInput();
                  },
                  child: Text('Ok'))
            ],
          );
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

                  _resetInput();
                },
                child: Text('Ok'))
          ],
        );
      }
    }
  }

  void _resetInput() {
    jangkaController = '';
    _errorJangka = null;

    txJmlPinjam.text = "";
    formattedJmlPinjam = 'Rp. 0';
    _errorTextJmlPinjam = null;

    txJmlAngsuran.text = "0";
    formattedAngsuran = 'Rp. 0';

    fotoKtpFile = null;
    fotoBuktiPotongFile = null;
    fotoSlipGajiFile = null;
    fotoMemoFile = null;

    fotoKtpController = '';
    fotoBuktiPotongController = '';
    fotoSlipGajiController = '';
    fotoMemoController = '';

    fotoKtpError = '';
    fotoBuktiPotongError = '';
    fotoSlipGajiError = '';
    fotoMemoError = '';

    setState(() {});
  }

  getProfile() async {
    String url = APIConstant.urlBase + APIConstant.serverApi + "profile";

    try {
      var response = await executeRequest(
        url,
      );

      var responseData = json.decode(response.body);

      nak = responseData['akun']['nak'];
      // String kd_prsh = "P01";
      String kd_prsh = responseData['ang']['kd_prsh'];

      if (kd_prsh == 'P01') {
        isPG = true;
      }

      debugPrint('nak=' + nak);

      if (mounted) {
        setState(() {});
      }
    } catch (e) {}
  }

  startState() async {
    final prefs = await SharedPreferences.getInstance();

    username = prefs.getString('LastUser') ?? '';

    // await Permission.storage.isGranted;
    // await Permission.photos.status.isGranted;
    var permission = await Permission.storage.request();

    debugPrint(permission.toString());

    getProfile();

    getTenor();

    // namaController.text = "John Doe";
    // emailController.text = "john.doe@example.com";
    // tglLahirController.text = "1990-01-01";
    // tempatLahirController.text = "City";
    // pendidikanController.text = "Bachelor's Degree";
    // noBadgeController.text = "123456";
    // statusPegawaiController.text = "Active";
    // jabatanController.text = "Software Engineer";
    // departemenController.text = "Engineering";
    // perusahaanController.text = "ABC Company";
    // hpController.text = "1234567890";
    // alamatController.text = "123 Main St, City, Country";
    // byrSimpPokokController.text = 'Februari';
    // byrSimpWajibController = true;
  }

  @override
  void initState() {
    super.initState();

    startState();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;

    return PlatformScaffold(
      appBar: AppBar(
        title: Text('Pengajuan Pinjaman Reguler'),
        backgroundColor: ColorPalette.warnaCorporate,
      ),
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Column(
                    children: [
                      // SizedBox(
                      //   height: 10,
                      // ),
                      Row(
                        children: [
                          Text('Simulasi Angsuran'),
                        ],
                      ),
                      TextFormField(
                        controller: txJmlAngsuran,
                        decoration: InputDecoration(
                          labelText: "Jumlah Angsuran Per Bulan : ",
                          icon: Icon(FontAwesomeIcons.moneyBill,
                              color: Colors.blue),
                          // errorText: _errorTextJmlPinjam,
                          counterText: formattedAngsuran,
                        ),
                        readOnly: true,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DropdownButtonFormField(
                        value: jangkaController,
                        onChanged: (value) {
                          setState(() {
                            jangkaController = value;
                          });

                          if (value != '') {
                            getAngsuran();
                          }
                        },
                        items: listTenor,
                        decoration: InputDecoration(
                          labelText: 'Jangka Waktu',
                          icon: Icon(Icons.calendar_month, color: Colors.blue),
                          errorText: _errorJangka,
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Jumlah Pinjam : ",
                          icon: Icon(FontAwesomeIcons.moneyBill,
                              color: Colors.blue),
                          errorText: _errorTextJmlPinjam,
                          counterText: formattedJmlPinjam,
                        ),
                        keyboardType: TextInputType.number,
                        controller: txJmlPinjam,
                        onChanged: (value) {
                          formatJmlPinjam(value);
                        },
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Text('Foto Slip Gaji:'),
                            tombol(
                              // backgroundColor: Colors.green,
                              onPressed: () {
                                _optionsDialogBox(_context, 'fotoslipgaji');
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
                                  Text('Upload Foto'),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: fotoSlipGajiFile != null
                                  ? Image.file(fotoSlipGajiFile)
                                  : Container(
                                      height: 30,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[100]),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            fotoSlipGajiError != ''
                                                ? fotoSlipGajiError
                                                : 'silahkan upload foto',
                                            style: TextStyle(
                                                color: fotoSlipGajiError != ''
                                                    ? Colors.red
                                                    : Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Text('Foto Bukti Potong:'),
                            tombol(
                              // backgroundColor: Colors.green,
                              onPressed: () {
                                _optionsDialogBox(_context, 'fotobuktipotong');
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
                                  Text('Upload Foto'),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: fotoBuktiPotongFile != null
                                  ? Image.file(fotoBuktiPotongFile)
                                  : Container(
                                      height: 30,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[100]),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            fotoBuktiPotongError != ''
                                                ? fotoBuktiPotongError
                                                : 'silahkan upload foto',
                                            style: TextStyle(
                                                color:
                                                    fotoBuktiPotongError != ''
                                                        ? Colors.red
                                                        : Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Text('Foto KTP Anda:'),
                            tombol(
                              // backgroundColor: Colors.green,
                              onPressed: () {
                                _optionsDialogBox(_context, 'fotoktp');
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
                                  Text('Upload Foto'),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: fotoKtpFile != null
                                  ? Image.file(fotoKtpFile)
                                  : Container(
                                      height: 30,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[100]),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            fotoKtpError != ''
                                                ? fotoKtpError
                                                : 'silahkan upload foto',
                                            style: TextStyle(
                                                color: fotoKtpError != ''
                                                    ? Colors.red
                                                    : Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                      if (isPG == false)
                        SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Text('Foto Memo Perusahaan:'),
                              tombol(
                                // backgroundColor: Colors.green,
                                onPressed: () {
                                  _optionsDialogBox(_context, 'fotomemo');
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
                                    Text('Upload Foto'),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: fotoMemoFile != null
                                    ? Image.file(fotoMemoFile)
                                    : Container(
                                        height: 30,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[100]),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              fotoMemoError != ''
                                                  ? fotoMemoError
                                                  : 'silahkan upload foto',
                                              style: TextStyle(
                                                  color: fotoMemoError != ''
                                                      ? Colors.red
                                                      : Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: tombol(
                            child: Text('Ajukan Pinjaman'),
                            onPressed: () {
                              _kirimData();
                              // _resetInput();
                            }),
                      ),
                      // SizedBox(
                      //   width: double.infinity,
                      //   child: tombol(
                      //       child: Text('Reset'),
                      //       onPressed: () {
                      //         // _kirimData();
                      //         _resetInput();
                      //       }),
                      // ),
                      // SizedBox(
                      //   height: 20,
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_loading) loadingView(),
        ],
      ),
    );
  }
}
