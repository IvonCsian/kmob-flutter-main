import 'package:flutter/material.dart';
import 'package:kmob/common/platform/platformScaffold.dart';
import 'package:kmob/common/widgets/MyAppBar.dart';
import 'package:kmob/utils/constant.dart';

class UploadNotaBerhasilScreen extends StatefulWidget {
  @override
  _UploadNotaBerhasilScreenState createState() =>
      _UploadNotaBerhasilScreenState();
}

class _UploadNotaBerhasilScreenState extends State<UploadNotaBerhasilScreen> {
  double maxWidth = 0;
  double maxHeight = 0;
  Widget _berhasil() {
    return Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
      child: Container(
        decoration: BoxDecoration(color: ColorPalette.green),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            decoration: new BoxDecoration(
                border: new Border(
                    right: new BorderSide(width: 1.0, color: Colors.white24))),
            child: Icon(Icons.info, color: Colors.white),
          ),
          title: Text(
            "Bukti transaksi SPBU berhasil diupload",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: Row(
            children: <Widget>[
              Icon(Icons.linear_scale, color: Colors.yellowAccent),
              Text("", style: TextStyle(color: Colors.white))
            ],
          ),
        ),
      ),
    );
  }

  Widget _petunjuk() {
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
                    "Informasi",
                    style: TextStyle(fontSize: 14.0, fontFamily: "NeoSansBold"),
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                  "Terima kasih.Bukti transaksi SPBU Anda berhasil diupload. Proses penyetoran sedang dalam proses verifikasi. Silahkan tekan tombol kembali untuk ke menu setoran atau klik tombol dibawah ini untuk menu beranda.",
                  textAlign: TextAlign.justify,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 30,
                  style: TextStyle(fontSize: 14.0, fontFamily: "NeoSans")),
              SizedBox(
                height: 40.0,
              ),
              new SizedBox(
                  width: double.infinity,

                  // height: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(ColorPalette.green)),
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/HomeScreen');
                    },
                    child: new Text(
                      'Kembali ke Menu Utama',
                      style: TextStyle(color: Colors.white),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    maxWidth = MediaQuery.of(context).size.width;
    maxHeight = MediaQuery.of(context).size.height >= 775.0
        ? MediaQuery.of(context).size.height
        : 775.0;
    return SafeArea(
      child: PlatformScaffold(
          // appBar: new MyAppBar(_selectedDrawerIndex),
          appBar: appBarDetail(context, "Berhasil Upload Bukti transaksi SPBU"),
          backgroundColor: Colors.grey[300],
          body: Container(
            width: maxWidth,
            height: maxHeight,
            margin: EdgeInsets.all(5.0),
            color: Colors.grey[200],
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _berhasil(),
                  _petunjuk(),
                ],
              ),
            ),
          )),
    );
  }
}
