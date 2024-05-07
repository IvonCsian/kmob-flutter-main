import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kmob/common/functions/future.dart';
import 'package:kmob/common/platform/platformScaffold.dart';
import 'package:kmob/common/widgets/widget.dart';
import 'package:kmob/utils/constant.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';

class DaftarScreen extends StatefulWidget {
  DaftarScreen({Key key}) : super(key: key);

  @override
  _DaftarScreenState createState() => _DaftarScreenState();
}

class _DaftarScreenState extends State<DaftarScreen> {
  TextEditingController namaController = TextEditingController();
  TextEditingController noKtpController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController tglLahirController = TextEditingController();
  TextEditingController tempatLahirController = TextEditingController();
  TextEditingController pendidikanController = TextEditingController();
  TextEditingController noBadgeController = TextEditingController();
  TextEditingController statusPegawaiController = TextEditingController();
  TextEditingController jabatanController = TextEditingController();
  TextEditingController departemenController = TextEditingController();
  TextEditingController perusahaanController = TextEditingController();
  TextEditingController hpController = TextEditingController();
  TextEditingController alamatController = TextEditingController();

  String jnsKelaminController = 'L';
  String statusKawinController = 'BELUM';

  String ktpKawinController = '';
  String fotoKtpController = '';
  String fotoTtdController = '';
  String fotoSlipGajiController = '';
  String fotoPasController = '';

  TextEditingController byrSimpPokokController = TextEditingController();

  bool byrSimpWajibController = false;

  Map<String, String> jenisKelaminOptions = {
    'L': 'Laki-laki',
    'P': 'Perempuan'
  };

  Map<String, String> statusKawinOptions = {
    'BELUM': 'Belum Kawin',
    'SUDAH': 'Sudah Kawin'
  };

  bool _loading = false;

  String username;

  File ktpKawinFile;
  String ktpKawinError = '';

  File fotoKtpFile;
  String fotoKtpError = '';

  File fotoTtdFile;
  String fotoTtdError = '';

  File fotoSlipGajiFile;
  String fotoSlipGajiError = '';

  File fotoPasFile;
  String fotoPasError = '';

  // bool isSetuju = false;

  String namaError;
  String noKtpError;
  String emailError;
  String tglLahirError;
  String tempatLahirError;
  String jnsKelaminError;
  String statusKawinError;
  String pendidikanError;
  String noBadgeError;
  String statusPegawaiError;
  String jabatanError;
  String departemenError;
  String perusahaanError;
  String hpError;
  String alamatError;

  String byrSimpPokokError;

  BuildContext _context;

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

      imageFile = File(ximageFile.path);

      final prefs = await SharedPreferences.getInstance();

      username = prefs.getString('LastUser') ?? '';

      var controller = username + "_" + basename(imageFile.path);
      // var file = imageFile;
      // var error = '';

      setState(() {
        switch (field) {
          case 'fotokawin':
            ktpKawinController = controller;
            ktpKawinFile = imageFile;
            ktpKawinError = '';
            break;
          case 'fotoktp':
            fotoKtpController = controller;
            fotoKtpFile = imageFile;
            fotoKtpError = '';
            break;
          case 'fotottd':
            fotoTtdController = controller;
            fotoTtdFile = imageFile;
            fotoTtdError = '';
            break;
          case 'fotoslipgaji':
            fotoSlipGajiController = controller;
            fotoSlipGajiFile = imageFile;
            fotoSlipGajiError = '';
            break;
          case 'fotopas':
            fotoPasController = controller;
            fotoPasFile = imageFile;
            fotoPasError = '';
            break;
          default:
        }

        _loading = false;
      });
    } catch (e) {
      debugPrint(e.toString());

      switch (field) {
        case 'fotokawin':
          ktpKawinController = '';
          ktpKawinFile = null;
          ktpKawinError = e.toString();
          break;
        case 'fotoktp':
          fotoKtpController = '';
          fotoKtpFile = null;
          fotoKtpError = e.toString();
          break;
        case 'fotottd':
          fotoTtdController = '';
          fotoTtdFile = null;
          fotoTtdError = e.toString();
          break;
        case 'fotoslipgaji':
          fotoSlipGajiController = '';
          fotoSlipGajiFile = null;
          fotoSlipGajiError = e.toString();
          break;
        case 'fotopas':
          fotoPasController = '';
          fotoPasFile = null;
          fotoPasError = e.toString();
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

    if (namaController.text.isEmpty) {
      // Jika namaController kosong, tampilkan pesan kesalahan
      namaError = 'Nama harus diisi';
    } else {
      // Reset pesan kesalahan jika namaController terisi
      namaError = null;
    }

    if (noKtpController.text.isEmpty) {
      // Jika namaController kosong, tampilkan pesan kesalahan
      noKtpError = 'No KTP harus diisi';
    } else if (!RegExp(r'^[0-9]+$').hasMatch(noKtpController.text)) {
      noKtpError = 'Input harus berupa angka';
    } else {
      noKtpError = null;
    }

    if (emailController.text.isEmpty) {
      emailError = 'Email harus diisi';
    } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
        .hasMatch(emailController.text)) {
      emailError = 'Masukkan email yang valid';
    } else {
      emailError = null;
    }

    // Validasi tglLahir
    if (tglLahirController.text.isEmpty) {
      tglLahirError = 'Tanggal Lahir harus diisi';
    } else {
      tglLahirError = null;
    }

    // Validasi tempatLahir
    if (tempatLahirController.text.isEmpty) {
      tempatLahirError = 'Tempat Lahir harus diisi';
    } else {
      tempatLahirError = null;
    }

    if (statusKawinController == 'SUDAH') {
      if (ktpKawinFile == null) {
        ktpKawinError = 'KTP Pasangan harus diunggah';
      } else {
        ktpKawinError = null;
      }
    } else {
      ktpKawinError = null;
    }

    // Validasi pendidikan
    if (pendidikanController.text.isEmpty) {
      pendidikanError = 'Pendidikan harus diisi';
    } else {
      pendidikanError = null;
    }

    // Validasi noBadge
    if (noBadgeController.text.isEmpty) {
      noBadgeError = 'Nomor Badge harus diisi';
    } else {
      noBadgeError = null;
    }

    // Validasi statusPegawai
    if (statusPegawaiController.text.isEmpty) {
      statusPegawaiError = 'Status Pegawai harus diisi';
    } else {
      statusPegawaiError = null;
    }

    // Validasi jabatan
    if (jabatanController.text.isEmpty) {
      jabatanError = 'Jabatan harus diisi';
    } else {
      jabatanError = null;
    }

    // Validasi departemen
    if (departemenController.text.isEmpty) {
      departemenError = 'Departemen harus diisi';
    } else {
      departemenError = null;
    }

    // Validasi perusahaan
    if (perusahaanController.text.isEmpty) {
      perusahaanError = 'Perusahaan harus diisi';
    } else {
      perusahaanError = null;
    }

    // Validasi hp
    if (hpController.text.isEmpty) {
      hpError = 'Nomor HP harus diisi';
    } else if (!RegExp(r'^[0-9]+$').hasMatch(hpController.text)) {
      hpError = 'Input harus angka';
    } else {
      hpError = null;
    }

    // Validasi alamat
    if (alamatController.text.isEmpty) {
      alamatError = 'Alamat harus diisi';
    } else {
      alamatError = null;
    }

    // Validasi fotoKtp
    if (fotoKtpFile == null) {
      fotoKtpError = 'Foto KTP harus diunggah';
    } else {
      fotoKtpError = null;
    }

    // Validasi fotoTtd
    if (fotoTtdFile == null) {
      fotoTtdError = 'Foto TTD harus diunggah';
    } else {
      fotoTtdError = null;
    }

    // Validasi fotoSlipGaji
    if (fotoSlipGajiFile == null) {
      fotoSlipGajiError = 'Foto Slip Gaji harus diunggah';
    } else {
      fotoSlipGajiError = null;
    }

    // Validasi fotoPas
    if (fotoPasFile == null) {
      fotoPasError = 'Foto Pas Foto harus diunggah';
    } else {
      fotoPasError = null;
    }

    if (byrSimpPokokController.text.isEmpty) {
      byrSimpPokokError = 'Bulan harus diisi';
    } else {
      byrSimpPokokError = null;
    }

    if (namaError != null ||
        noKtpError != null ||
        emailError != null ||
        tglLahirError != null ||
        tempatLahirError != null ||
        pendidikanError != null ||
        noBadgeError != null ||
        statusPegawaiError != null ||
        jabatanError != null ||
        departemenError != null ||
        perusahaanError != null ||
        hpError != null ||
        alamatError != null ||
        fotoKtpError != null ||
        fotoTtdError != null ||
        fotoSlipGajiError != null ||
        fotoPasError != null ||
        byrSimpPokokError != null ||
        !byrSimpWajibController) {
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

      // foto pasangan
      if (statusKawinController == 'SUDAH') {
        final StorageReference firebaseStorageRef =
            FirebaseStorage.instance.ref().child(ktpKawinController);
        final StorageUploadTask task = firebaseStorageRef.putFile(ktpKawinFile);
        var downUrl = await (await task.onComplete).ref.getDownloadURL();
        ktpKawinController = downUrl.toString();
      } else {
        ktpKawinController = '';
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

      // foto ttd
      firebaseStorageRef =
          FirebaseStorage.instance.ref().child(fotoTtdController);
      task = firebaseStorageRef.putFile(fotoTtdFile);
      downUrl = await (await task.onComplete).ref.getDownloadURL();
      fotoTtdController = downUrl.toString();

      // foto slip gaji
      firebaseStorageRef =
          FirebaseStorage.instance.ref().child(fotoSlipGajiController);
      task = firebaseStorageRef.putFile(fotoSlipGajiFile);
      downUrl = await (await task.onComplete).ref.getDownloadURL();
      fotoSlipGajiController = downUrl.toString();

      // foto pas foto
      firebaseStorageRef =
          FirebaseStorage.instance.ref().child(fotoPasController);
      task = firebaseStorageRef.putFile(fotoPasFile);
      downUrl = await (await task.onComplete).ref.getDownloadURL();
      fotoPasController = downUrl.toString();

      var dataHttp = {
        'nama': namaController.text,
        'no_ktp': noKtpController.text,
        'email': emailController.text,
        'tgl_lahir': tglLahirController.text,
        'tempat_lahir': tempatLahirController.text,
        'jns_kelamin': jnsKelaminController,
        'status_kawin': statusKawinController,
        'ktp_kawin':
            ktpKawinController, // Jika ktp_kawinController null, gunakan string kosong
        'pendidikan': pendidikanController.text,
        'no_bagde': noBadgeController.text,
        'status_pegawai': statusPegawaiController.text,
        'jabatan': jabatanController.text,
        'departemen': departemenController.text,
        'perusahaan': perusahaanController.text,
        'hp': hpController.text,
        'alamat': alamatController.text,
        'byr_simp_pokok': byrSimpPokokController.text,
        'byr_simp_wajib': byrSimpWajibController ? 'SETUJU' : '',
        // Sesuaikan dengan jenis data foto atau ubah ke base64 jika diperlukan
        'foto_ktp': fotoKtpController,
        'foto_ttd': fotoTtdController,
        'foto_slip_gaji': fotoSlipGajiController,
        'foto_pas': fotoPasController,
      };

      debugPrint('all input ok');
      debugPrint(dataHttp.toString());

      String url =
          APIConstant.urlBase + APIConstant.serverApi + "pendaftaran/new";

      try {
        var response = await executeRequest(url,
            body: dataHttp, method: RequestMethod.POST);

        if (response.statusCode == 200) {
          Future.delayed(Duration(seconds: 1), () {
            setState(() {
              _loading = false;
            });

            showInfoDialog(
              _context,
              title: 'Sukses',
              content: Text('Data berhasil dikirim. Silahkan cek email.'),
              actions: [
                TextButton(
                    onPressed: () {
                      _resetInput();

                      Navigator.of(_context).pop();
                    },
                    child: Text('Ok'))
              ],
            );
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

  startState() async {
    final prefs = await SharedPreferences.getInstance();

    username = prefs.getString('LastUser') ?? '';

    // await Permission.storage.isGranted;
    // await Permission.photos.status.isGranted;
    var permission = await Permission.storage.request();

    debugPrint(permission.toString());

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
        title: Text('Daftar Anggota'),
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
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: namaController,
                        decoration: InputDecoration(
                          labelText: 'Nama',
                          icon: Icon(Icons.person, color: Colors.blue),
                          errorText:
                              namaError, // Tambahkan errorText sesuai kebutuhan
                        ),
                      ),
                      TextFormField(
                        controller: noKtpController,
                        decoration: InputDecoration(
                          labelText: 'NIK/No. KTP',
                          icon: Icon(FontAwesomeIcons.addressCard,
                              color: Colors.blue),
                          errorText:
                              noKtpError, // Tambahkan errorText sesuai kebutuhan
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          icon: Icon(Icons.mail, color: Colors.blue),
                          errorText:
                              emailError, // Tambahkan errorText sesuai kebutuhan
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Tanggal Lahir : ",
                          icon: Icon(FontAwesomeIcons.calendar,
                              color: Colors.blue),
                          errorText:
                              tglLahirError, // Tambahkan errorText sesuai kebutuhan
                        ),
                        controller: tglLahirController,
                        readOnly: true,
                        onTap: () async {
                          DateTime pickedDate = await DatePicker.showDatePicker(
                            context,
                            maxTime: DateTime.now(),
                          );

                          if (pickedDate != null) {
                            String formattedDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);

                            setState(() {
                              tglLahirController.text = formattedDate;
                            });
                          }
                        },
                      ),
                      TextFormField(
                        controller: tempatLahirController,
                        decoration: InputDecoration(
                          labelText: 'Tempat Lahir',
                          icon: Icon(Icons.location_on, color: Colors.blue),
                          errorText:
                              tempatLahirError, // Tambahkan errorText sesuai kebutuhan
                        ),
                      ),
                      DropdownButtonFormField(
                        value: jnsKelaminController,
                        onChanged: (String value) {
                          debugPrint('jenis_kelamin:' + value);
                          setState(() {
                            jnsKelaminController = value;
                          });
                        },
                        items: jenisKelaminOptions.keys.map((String key) {
                          return DropdownMenuItem(
                            value: key,
                            child: Text(jenisKelaminOptions[key]),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'Jenis Kelamin',
                          icon: Icon(Icons.person, color: Colors.blue),
                        ),
                      ),
                      DropdownButtonFormField(
                        value: statusKawinController,
                        onChanged: (String value) {
                          debugPrint('status_kawin:' + value);
                          setState(() {
                            statusKawinController = value;
                          });
                        },
                        items: statusKawinOptions.keys.map((String key) {
                          return DropdownMenuItem(
                            value: key,
                            child: Text(statusKawinOptions[key]),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'Status Kawin',
                          icon: Icon(Icons.person, color: Colors.blue),
                        ),
                      ),
                      if (statusKawinController == 'SUDAH')
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Text('KTP Pasangan:'),
                            tombol(
                              // backgroundColor: Colors.green,
                              onPressed: () {
                                _optionsDialogBox(context, 'fotokawin');
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
                              child: ktpKawinFile != null
                                  ? Image.file(ktpKawinFile)
                                  : Container(
                                      height: 30,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[100]),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            ktpKawinError != ''
                                                ? ktpKawinError
                                                : 'silahkan upload foto',
                                            style: TextStyle(
                                                color: ktpKawinError != ''
                                                    ? Colors.red
                                                    : Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      TextFormField(
                        controller: pendidikanController,
                        decoration: InputDecoration(
                          labelText: 'Pendidikan',
                          icon: Icon(Icons.school, color: Colors.blue),
                          errorText:
                              pendidikanError, // Tambahkan errorText sesuai kebutuhan
                        ),
                      ),
                      TextFormField(
                        controller: noBadgeController,
                        decoration: InputDecoration(
                          labelText: 'Nomor Badge',
                          icon: Icon(FontAwesomeIcons.addressCard,
                              color: Colors.blue),
                          errorText:
                              noBadgeError, // Tambahkan errorText sesuai kebutuhan
                        ),
                      ),
                      TextFormField(
                        controller: statusPegawaiController,
                        decoration: InputDecoration(
                          labelText: 'Status Pegawai',
                          icon: Icon(FontAwesomeIcons.addressCard,
                              color: Colors.blue),
                          errorText:
                              statusPegawaiError, // Tambahkan errorText sesuai kebutuhan
                        ),
                      ),
                      TextFormField(
                        controller: jabatanController,
                        decoration: InputDecoration(
                          labelText: 'Jabatan',
                          icon: Icon(FontAwesomeIcons.addressCard,
                              color: Colors.blue),
                          errorText:
                              jabatanError, // Tambahkan errorText sesuai kebutuhan
                        ),
                      ),
                      TextFormField(
                        controller: departemenController,
                        decoration: InputDecoration(
                          labelText: 'Departemen',
                          icon: Icon(FontAwesomeIcons.addressCard,
                              color: Colors.blue),
                          errorText:
                              departemenError, // Tambahkan errorText sesuai kebutuhan
                        ),
                      ),
                      TextFormField(
                        controller: perusahaanController,
                        decoration: InputDecoration(
                          labelText: 'Perusahaan',
                          icon: Icon(FontAwesomeIcons.addressCard,
                              color: Colors.blue),
                          errorText:
                              perusahaanError, // Tambahkan errorText sesuai kebutuhan
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: hpController,
                        decoration: InputDecoration(
                          labelText: 'Nomor HP',
                          icon: Icon(Icons.phone_android, color: Colors.blue),
                          errorText:
                              hpError, // Tambahkan errorText sesuai kebutuhan
                        ),
                      ),
                      TextFormField(
                        controller: alamatController,
                        decoration: InputDecoration(
                          labelText: 'Alamat',
                          icon: Icon(FontAwesomeIcons.addressCard,
                              color: Colors.blue),
                          errorText:
                              alamatError, // Tambahkan errorText sesuai kebutuhan
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text('Foto KTP Anda:'),
                          tombol(
                            // backgroundColor: Colors.green,
                            onPressed: () {
                              _optionsDialogBox(context, 'fotoktp');
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
                                    decoration:
                                        BoxDecoration(color: Colors.grey[100]),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text('Foto Tanda Tangan:'),
                          tombol(
                            // backgroundColor: Colors.green,
                            onPressed: () {
                              _optionsDialogBox(context, 'fotottd');
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
                            child: fotoTtdFile != null
                                ? Image.file(fotoTtdFile)
                                : Container(
                                    height: 30,
                                    decoration:
                                        BoxDecoration(color: Colors.grey[100]),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          fotoTtdError != ''
                                              ? fotoTtdError
                                              : 'silahkan upload foto',
                                          style: TextStyle(
                                              color: fotoTtdError != ''
                                                  ? Colors.red
                                                  : Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text('Foto Slip Gaji:'),
                          tombol(
                            // backgroundColor: Colors.green,
                            onPressed: () {
                              _optionsDialogBox(context, 'fotoslipgaji');
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
                                    decoration:
                                        BoxDecoration(color: Colors.grey[100]),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text('Pas Foto:'),
                          tombol(
                            // backgroundColor: Colors.green,
                            onPressed: () {
                              _optionsDialogBox(context, 'fotopas');
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
                            child: fotoPasFile != null
                                ? Image.file(fotoPasFile)
                                : Container(
                                    height: 30,
                                    decoration:
                                        BoxDecoration(color: Colors.grey[100]),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          fotoPasError != ''
                                              ? fotoPasError
                                              : 'silahkan upload foto',
                                          style: TextStyle(
                                              color: fotoPasError != ''
                                                  ? Colors.red
                                                  : Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                          'Dengan ini kami mengajukan permohonan untuk menjadi anggota K3PG dan bersedia akan memenuhi kewajiban serta mentaati ketentuan yang berlaku di K3PG. Sanggup membayar Simpanan Pokok sesuai Anggaran Dasar yang berlaku sebesar Rp 250.000,00 (Dua ratus lima puluh lima ribu rupiah) dengan cara : *) 1 (satu) kali angsuran atau mulai bulan.......'),
                      TextFormField(
                        controller: byrSimpPokokController,
                        decoration: InputDecoration(
                          labelText: 'Bulan Bayar Simpanan Pokok',
                          errorText: byrSimpPokokError,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                          'Sanggup membayar simpanan wajib tiap bulan sebesar Rp. 50.000 (Lima Puluh Ribu Rupiah) dan membayar segala kewajiban di K3PG melalui potongan gaji setiap bulan sejak tercatat sebagai anggota K3PG. Demikian surat permohonan ini kami ajukan dengan sukarela dan penuh tanggung jawab.'),
                      Row(
                        children: [
                          Checkbox(
                            value: byrSimpWajibController,
                            onChanged: (bool value) {
                              setState(() {
                                byrSimpWajibController = value;
                              });
                              debugPrint('value check: ' + value.toString());
                            },
                          ),
                          GestureDetector(
                            child: Text('Setuju dengan Syarat dan Ketentuan'),
                            onTap: () {
                              setState(() {
                                byrSimpWajibController =
                                    !byrSimpWajibController;
                              });
                              debugPrint('value check text: ' +
                                  byrSimpWajibController.toString());
                            },
                          ),
                        ],
                      ),
                      if (!byrSimpWajibController)
                        Text(
                          'Anda harus setuju dengan Syarat dan Ketentuan.',
                          style: TextStyle(color: Colors.red),
                        ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          tombol(
                              child: Text('Kirim Data'),
                              onPressed: () {
                                _kirimData();
                              }),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
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

  void _resetInput() {
    namaController.text = "";
    emailController.text = "";
    tglLahirController.text = "";
    tempatLahirController.text = "";
    jnsKelaminController = 'L';
    statusKawinController = 'BELUM';
    pendidikanController.text = "";
    noBadgeController.text = "";
    statusPegawaiController.text = "";
    jabatanController.text = "";
    departemenController.text = "";
    perusahaanController.text = "";
    hpController.text = "";
    alamatController.text = "";
    byrSimpPokokController.text = "";
    byrSimpWajibController = false;
    ktpKawinController = '';
    ktpKawinFile = null;
    fotoKtpController = '';
    fotoKtpFile = null;
    fotoTtdController = '';
    fotoTtdFile = null;
    fotoSlipGajiController = '';
    fotoSlipGajiFile = null;
    fotoPasController = '';
    fotoPasFile = null;

    setState(() {});
  }
}
