import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kmob/common/widgets/MyAppBar.dart';
import 'package:kmob/common/widgets/widget.dart';
import 'package:kmob/model/pinjaman_model.dart';
import 'package:kmob/ui/PengajuanPinjaman.dart';
import 'package:kmob/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TabPinjamanReguler extends StatefulWidget {
  @override
  _TabPinjamanRegulerState createState() => _TabPinjamanRegulerState();
}

class _TabPinjamanRegulerState extends State<TabPinjamanReguler> {
  String tokens;
  String saldo = "";
  String tglUpdate = "";
  List<PinjamanModel> list = [];
  String url = APIConstant.urlBase + APIConstant.serverApi + "pinjaman/reg";
  Map<String, String> get headers => {
        'Authorization': 'Bearer $tokens',
        'Content-Type': 'application/json',
      };

  //getdata area
  Future<List<PinjamanModel>> _getData() async {
    final prefs = await SharedPreferences.getInstance();
    tokens = prefs.getString('LastToken') ?? '';

    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      var rest = json.decode(response.body) as List;
      list = rest
          .map<PinjamanModel>((json) => PinjamanModel.fromJson(json))
          .toList();
    } else if (response.statusCode == 401) {
      // Navigator.of(context).pushReplacementNamed('/LoginScreen');
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    var listdeposito = Container(
        padding: EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                "Pinjaman Reguler Anda",
                style: TextStyle(fontFamily: "NeoSansBold"),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                child: Column(children: <Widget>[
                  FutureBuilder(
                    future: _getData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        int i = 0;
                        return Column(
                            children: snapshot.data.map<Widget>((data) {
                          i = i++;
                          return rowDataPinjaman(data, context);
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

    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ListView(
          physics: ClampingScrollPhysics(),
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              child: tombol(
                child: Text('Pengajuan Pembiayaan Reguler'),
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (builder) {
                    return PengajuanPinjaman();
                  }));
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                // padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    listdeposito,
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
