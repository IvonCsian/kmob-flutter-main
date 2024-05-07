import 'dart:convert';
import 'package:badges/badges.dart' as badge;
import 'package:flutter/material.dart';
import 'package:kmob/common/functions/format.dart';
import 'package:kmob/common/platform/platformScaffold.dart';
import 'package:kmob/common/widgets/MyAppBar.dart';
import 'package:kmob/model/potongan_model.dart';
import 'package:kmob/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PotonganScreen extends StatefulWidget {
  final String noPinjam;
  final String nmPinjaman;

  const PotonganScreen({Key key, this.noPinjam, this.nmPinjaman})
      : super(key: key);

  @override
  _PotonganScreenState createState() => _PotonganScreenState();
}

class _PotonganScreenState extends State<PotonganScreen> {
  String tokens;
  String noPinjam = "";
  String saldo = "";
  String tglUpdate = "";
  List<PotonganModel> list = [];
  String url =
      "" + APIConstant.urlBase + "" + APIConstant.serverApi + "potongan/";
  Map<String, String> get headers => {
        'Authorization': 'Bearer $tokens',
        'Content-Type': 'application/json',
      };

  //getdata area
  Future<List<PotonganModel>> _getData(String param) async {
    String finalUrl;
    final prefs = await SharedPreferences.getInstance();
    tokens = prefs.getString('LastToken') ?? '';

    switch (widget.nmPinjaman) {
      case "KKB":
        finalUrl = url + "pinj_kkb?no_pinjam=" + param;

        break;
      default:
        finalUrl = url + "pinj_reg?no_pinjam=" + param;
        break;
    }
    print(url + param);
    final response = await http.get(Uri.parse(finalUrl), headers: headers);
    if (response.statusCode == 200) {
      var rest = json.decode(response.body) as List;
      list = rest
          .map<PotonganModel>((json) => PotonganModel.fromJson(json))
          .toList();
    } else if (response.statusCode == 401) {
      // Navigator.of(context).pushReplacementNamed('/LoginScreen');
    }
    return list;
  }

  Card headerArea() => Card(
        margin: EdgeInsets.all(10.0),
        elevation: 1.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(50.0))),
        child: Container(
            decoration: BoxDecoration(
                color: ColorPalette.warnaCorporate,
                borderRadius: new BorderRadius.all(new Radius.circular(20.0))),
            padding: EdgeInsets.all(5.0),
            // color: Color(0xFF015FFF),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("No Referensi :",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontFamily: "NeoSansBold")),
                  ],
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(widget.nmPinjaman + " - " + widget.noPinjam,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                            fontFamily: "NeoSans")),
                  ),
                ),
                SizedBox(height: 10.0),
              ],
            )),
      );
  Widget rowDataPotongan(PotonganModel row) {
    return new Container(
        decoration: BoxDecoration(
            color: ColorPalette.grey,
            borderRadius: new BorderRadius.all(new Radius.circular(10.0))),
        margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
        padding: EdgeInsets.only(top: 5.0, bottom: 20.0, left: 5.0, right: 5.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "No referensi : " + row.buktiPotga.toString(),
                      textAlign: TextAlign.left,
                      style: new TextStyle(
                          fontFamily: "WorkSansMedium", fontSize: 10.0),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text("Tanggal Potong : " + formatDate(row.tglPotga),
                            style: new TextStyle(
                                fontFamily: "WorkSansMedium", fontSize: 12.0)),
                      ],
                    ),
                  ],
                ),
                badge.Badge(
                  badgeColor: Colors.blue[600],
                  shape: badge.BadgeShape.square,
                  borderRadius: BorderRadius.circular(20),
                  toAnimate: false,
                  badgeContent: Text(
                      row.nmPotga.toString() + " - " + row.nmPinjaman,
                      style: new TextStyle(
                          fontFamily: "WorkSansMedium",
                          fontSize: 10.0,
                          color: Colors.white)),
                ),
              ],
            ),
            Divider(
              color: Colors.black87,
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Jumlah Potongan : ",
                  style:
                      new TextStyle(fontFamily: "NeoSansBold", fontSize: 18.0),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  formatCurrency(row.jumlah),
                  style:
                      new TextStyle(fontFamily: "NeoSansBold", fontSize: 25.0),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Angsuran ke : \n" + row.angsKe.toString(),
                  style: new TextStyle(fontFamily: "NeoSans", fontSize: 12.0),
                ),
                Text(
                  "Saldo Akhir : \n" + formatCurrency(row.saldoAkhir),
                  textAlign: TextAlign.right,
                  style: new TextStyle(fontFamily: "NeoSans", fontSize: 12.0),
                ),
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Tempo : \n" + row.tempoBln.toString() + " bulan",
                  style: new TextStyle(fontFamily: "NeoSans", fontSize: 12.0),
                ),
                Text(
                  "Pinjam : \n" + formatCurrency(row.jmlPokok),
                  textAlign: TextAlign.right,
                  style: new TextStyle(fontFamily: "NeoSans", fontSize: 12.0),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    noPinjam = widget.noPinjam;
    var listdeposito = Container(
        padding: EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new Container(
                margin: EdgeInsets.all(10.0),
                child: Column(children: <Widget>[
                  FutureBuilder(
                    future: _getData(widget.noPinjam),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        int i = 0;
                        return new Column(
                            children: snapshot.data.map<Widget>((data) {
                          i = i++;
                          return rowDataPotongan(data);
                        }).toList());
                      }
                      return Center(
                        child: SizedBox(
                            width: 40.0,
                            height: 40.0,
                            child: const CircularProgressIndicator()),
                      );
                    },
                  ),
                ]),
              )
            ]));

    return SafeArea(
      child: PlatformScaffold(
        // appBar: new MyAppBar(_selectedDrawerIndex),
        appBar: appBarDetail(context, "Riwayat Transaksi Potongan"),
        backgroundColor: Colors.white,
        body: Container(
          child: new ListView(
            physics: ClampingScrollPhysics(),
            children: <Widget>[
              new Container(
                  // padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                  color: Colors.white,
                  child: new Column(
                    children: <Widget>[
                      headerArea(),
                      listdeposito,
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
