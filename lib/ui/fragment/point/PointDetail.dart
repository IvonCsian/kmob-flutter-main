import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kmob/common/functions/format.dart';
import 'package:kmob/common/platform/platformScaffold.dart';
import 'package:kmob/common/widgets/MyAppBar.dart';
import 'package:kmob/model/profile_model.dart';
import 'package:kmob/model/transaksi_model.dart';
import 'package:kmob/ui/fragment/point/pointRedeem.dart';
import 'package:kmob/utils/constant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PointDetail extends StatefulWidget {
  final ProfileModel profile;
  final String password;

  const PointDetail({Key key, this.profile, this.password}) : super(key: key);

  @override
  _PointDetailState createState() => _PointDetailState();
}

class _PointDetailState extends State<PointDetail> {
  bool isData = false;
  double saldo = 0;
  double maxWidth = 0;
  double maxHeight = 0;
  String barcode;

  String tanggalString = "*belum dipilih";
  String tanggal;
  DateTime dates;

  String tanggalStringEnd = "*belum dipilih";
  String tanggalEnd;
  ProfileModel profile;
  SharedPreferences sharedPreferences;
  double point = 0;
  DateTime datesEnd;
  List<TransaksiModel> _poromoList = [];
  String tokens;
  Map<String, String> get headers => {
        'Authorization': 'Bearer $tokens',
        'Content-Type': 'application/json',
      };

  @override
  void initState() {
    super.initState();
    fetchJson();
  }

  void persist(String value) {
    setState(() {
      tokens = value;
    });
    sharedPreferences?.setString('LastToken', value);
  }

  fetchJson() async {
    //get token
    SharedPreferences.getInstance().then((SharedPreferences sp) async {
      sharedPreferences = sp;
      tokens = sharedPreferences.getString('LastToken');
      // will be null if never previously saved
      if (tokens == null) {
        tokens = "";
        persist(tokens); // set an initial value
      } else {
        if (tokens != "") {
          var response = await http.get(
            Uri.parse(APIConstant.urlBase + APIConstant.serverApi + "/profile"),
            headers: headers,
          );

          if (response.statusCode == 200) {
            profile = new ProfileModel.fromJson(json.decode(response.body));
            setState(() {
              point = profile.yourpoint;
              isData = true;
            });
            setState(() {});
          } else if (response.statusCode == 401) {
            Navigator.of(context).pushReplacementNamed('/LoginScreen');
          } else {
            print(
                'Something went wrong. \nResponse Code : ${response.statusCode}');
          }
        }
      }
    });
  }

  //main build method
  Widget build(BuildContext context) {
    maxWidth = MediaQuery.of(context).size.width;
    maxHeight = MediaQuery.of(context).size.height >= 775.0
        ? MediaQuery.of(context).size.height
        : 775.0;
    return SafeArea(
      child: PlatformScaffold(
        appBar: appBarDetail(context, "Point K3PG"),
        backgroundColor: Colors.white,
        body: Container(
          child: new ListView(
            physics: ClampingScrollPhysics(),
            children: <Widget>[
              new Container(
                  color: Colors.white,
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: new Column(
                      children: <Widget>[
                        judul(),
                        SizedBox(
                          height: 16.0,
                        ),
                        menu(),
                        SizedBox(
                          height: 16.0,
                        ),
                        transaksi(),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget judul() {
    return Column(
      children: <Widget>[
        Center(
          child: Text(
            "Point anda saat ini : ",
            style: TextStyle(fontSize: 20.0, fontFamily: "NeoSans"),
          ),
        ),
        SizedBox(
          height: 8.0,
        ),
        Center(
          child: Text(
            formatCurrency(point),
            style: TextStyle(fontSize: 20.0, fontFamily: "NeoSans"),
          ),
        ),
      ],
    );
  }

  Widget menu() {
    return Container(
      decoration: new BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color(0xff3164bd), const Color(0xff295cb5)],
          ),
          borderRadius: new BorderRadius.all(new Radius.circular(20.0))),
      height: 60.0,
      padding: EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 0),
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PointRedeem(
                                  profile: profile,
                                )),
                        ModalRoute.withName("/HomeScreen"));
                  },
                  child: Column(
                    children: <Widget>[
                      new Container(
                        child: new Icon(
                          FontAwesomeIcons.gift,
                          color: Colors.white,
                          size: 18.0,
                        ),
                      ),
                      new Padding(
                        padding: EdgeInsets.only(top: 6.0),
                      ),
                      Center(
                        child: new Text(
                          "Redeem",
                          style: new TextStyle(
                              fontSize: 12.0,
                              color: Colors.white,
                              fontFamily: "WorkSansBold"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget transaksi() {
    return Container(
      padding: EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          new Text(
            "Transaksi",
            style: new TextStyle(fontFamily: "WorkSansBold", fontSize: 14.0),
          ),
          new Container(
              margin: EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  FutureBuilder(
                    future: fetchPromo(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return new Column(
                            children: snapshot.data.map<Widget>((data) {
                          return _rowPromo(data);
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
                ],
              )),
        ],
      ),
    );
  }

  String url =
      "" + APIConstant.urlBase + "" + APIConstant.serverApi + "Transaksi";
  Future<List<TransaksiModel>> fetchPromo() async {
    final prefs = await SharedPreferences.getInstance();
    tokens = prefs.getString('LastToken') ?? '';
    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var rest = data as List;
      _poromoList = rest
          .map<TransaksiModel>((json) => TransaksiModel.fromJson(json))
          .toList();
    } else if (response.statusCode == 401) {
      // Navigator.of(context).pushReplacementNamed('/LoginScreen');
    }
    return _poromoList;
  }

  Widget _rowPromo(TransaksiModel row) {
    // DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    return new Container(
        decoration: BoxDecoration(
            color: ColorPalette.grey,
            borderRadius: new BorderRadius.all(new Radius.circular(10.0))),
        margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
        padding:
            EdgeInsets.only(top: 20.0, bottom: 20.0, left: 5.0, right: 5.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "No referensi : " + row.fcode,
                      textAlign: TextAlign.left,
                      style: new TextStyle(
                          fontFamily: "WorkSansMedium", fontSize: 10.0),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text("Tanggal Transaksi : " + formatDate(row.fdate),
                            style: new TextStyle(
                                fontFamily: "WorkSansMedium", fontSize: 12.0)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Point : ",
                  style:
                      new TextStyle(fontFamily: "NeoSansBold", fontSize: 18.0),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  formatCurrency(row.pointkmob),
                  style:
                      new TextStyle(fontFamily: "NeoSansBold", fontSize: 25.0),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Nilai Transaksi : " + formatCurrency(row.fgrandtotal),
                  style: new TextStyle(fontFamily: "NeoSans", fontSize: 15.0),
                ),
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Anggota : " +
                      row.fcustkey.toString() +
                      " - " +
                      row.fcustname.toString() +
                      "",
                  style: new TextStyle(fontFamily: "NeoSans", fontSize: 12.0),
                ),
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            SizedBox(
              height: 5.0,
            ),
          ],
        ));
  }
}
