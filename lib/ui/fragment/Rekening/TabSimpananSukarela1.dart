import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kmob/common/functions/format.dart';
import 'package:kmob/common/functions/showDialogSingleButton.dart';
import 'package:kmob/common/widgets/MyAppBar.dart';
import 'package:kmob/model/profile_model.dart';
import 'package:kmob/model/simpanan_model.dart';
import 'package:kmob/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TabSimpananSukarela1 extends StatefulWidget {
  @override
  _TabSimpananSukarela1State createState() => _TabSimpananSukarela1State();
}

class _TabSimpananSukarela1State extends State<TabSimpananSukarela1> {
  @override
  void initState() {
    super.initState();

    // fetchJson();
    getDataHeader();
  }

  fetchJson() async {
    final prefs = await SharedPreferences.getInstance();
    tokens = prefs.getString('LastToken') ?? '';
    var response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      profile = new ProfileModel.fromJson(json.decode(response.body));
      setState(() {});
      Map<String, String> body = {'nak': profile.nak};
      var response2 = await http
          .post(Uri.parse(APIConstant.url + "ceksaldoanggota"),
              headers: headersewallet, body: json.encode(body))
          // ignore: missing_return
          .timeout(const Duration(seconds: 60), onTimeout: () {
        showDialogSingleButtonWithAction(
            _context,
            "Proses inquiry top up ewallet gagal",
            "Timeout",
            "OK",
            "/HomeScreen");
      });

      debugPrint(response2.statusCode.toString());

      if (response2.statusCode == 200) {
        final rv = json.decode(response2.body);

        debugPrint('cok ' + rv.toString());

        if (rv["code"] != null) {
          if (rv["code"] == 200) {
            final rvdata = rv["detail_data"];
            saldo = "Saldo anda : " +
                formatCurrency(double.parse(rvdata["totalsaldo"].toString()));
            setState(() {});
          } else {
            if (rv["msg"] != null) {
              showDialogSingleButton(context, "Error", rv["msg"], "OK");
            } else {
              showDialogSingleButton(
                  context, "Error", rv["response_message"], "OK");
            }
          }
        } else {
          showDialogSingleButton(
              context, "Error", "Contact Administrator", "OK");
        }
      } else if (response.statusCode == 401) {
        Navigator.of(context).pushReplacementNamed('/LoginScreen');
      } else {
        saldo = "Saldo anda : " + formatCurrency(0);

        debugPrint('ini fetchdata: ' + response.statusCode.toString());

        setState(() {});
      }
    } else {
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
    }
  }

  String url =
      "" + APIConstant.urlBase + "" + APIConstant.serverApi + "/profile";
  ProfileModel profile;
  BuildContext _context;
  String tokens;
  String saldo = "";
  String tglUpdate = "";
  List<SimpananAngModel> list = [];
  String urlHeader =
      "" + APIConstant.urlBase + "" + APIConstant.serverApi + "simpanan/ss1";
  String urlDetail = "" +
      APIConstant.urlBase +
      "" +
      APIConstant.serverApi +
      "simpanan/ss1_detail?limit=20";
  Map<String, String> get headers => {
        'Authorization': 'Bearer $tokens',
        'Content-Type': 'application/json',
      };
  Map<String, String> get headersewallet => {
        'x-key': "\$^DR&MYUTIL*EIU&Juk98onu98OI&KU(*OIU)d",
        'Content-Type': 'application/json',
        'app-id': "8A53A5C5-8B3D-4624-ACFA-C14945EC4F88"
      };
  //getdata area
  Future<List<SimpananAngModel>> _getData() async {
    final prefs = await SharedPreferences.getInstance();
    tokens = prefs.getString('LastToken') ?? '';
    final response = await http.get(Uri.parse(urlDetail), headers: headers);
    if (response.statusCode == 200) {
      var rest = json.decode(response.body) as List;
      list = rest
          .map<SimpananAngModel>((json) => SimpananAngModel.fromJson(json))
          .toList();
    } else if (response.statusCode == 204) {
    } else if (response.statusCode == 401) {
      Navigator.of(context).pushReplacementNamed('/LoginScreen');
    }
    return list;
  }

  getDataHeader() async {
    final prefs = await SharedPreferences.getInstance();
    tokens = prefs.getString('LastToken') ?? '';
    var response2 = await http.get(
      Uri.parse(urlHeader),
      headers: headers,
    );

    debugPrint(response2.statusCode.toString());

    if (response2.statusCode == 200) {
      debugPrint(json.decode(response2.body).toString());
      var dataSaldo = json.decode(response2.body);

      saldo = formatCurrency(double.parse(dataSaldo['saldo'].toString()));
      tglUpdate = dataSaldo['tgl_update'].toString();
      setState(() {});
    } else if (response2.statusCode == 204) {
      saldo = formatCurrency(0);
      var now = new DateTime.now();
      var formatter = new DateFormat('yyyy-MM-dd');
      String formattedDate = formatter.format(now);
      tglUpdate = formattedDate;
      setState(() {});
    } else if (response2.statusCode == 401) {
      Navigator.of(context).pushReplacementNamed('/LoginScreen');
    } else {
      print(
          ' ss1 . Something went wrong. \nResponse Code : ${response2.statusCode}');
    }
  }
  //end get data area

  Card savingHeaderArea() => Card(
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
                  height: 30.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Saldo :",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontFamily: "NeoSansBold")),
                  ],
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(saldo,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                            fontFamily: "NeoSans")),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                        "Data diambil pada tgl : " +
                            (tglUpdate == "" ? "" : formatDate(tglUpdate)),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                            fontFamily: "NeoSanslight")),
                  ),
                ),
                SizedBox(height: 20.0),
              ],
            )),
      );

  Widget _rowData(SimpananAngModel row, int i) {
    return new Container(
        decoration: BoxDecoration(
            color: ColorPalette.grey,
            borderRadius: new BorderRadius.all(new Radius.circular(10.0))),
        margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
        padding:
            EdgeInsets.only(top: 20.0, bottom: 20.0, left: 5.0, right: 5.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 5.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "No referensi : ",
                  style: new TextStyle(
                      fontFamily: "WorkSansMedium", fontSize: 8.0),
                ),
                SizedBox(),
                Text(
                  row.noSimpan,
                  style: new TextStyle(
                      fontFamily: "WorkSansMedium", fontSize: 8.0),
                )
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: <Widget>[
                Text(
                  row.nmJnsTransaksi,
                  style:
                      new TextStyle(fontFamily: "NeoSansBold", fontSize: 12.0),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  formatDate(row.tglSimpan),
                  style: new TextStyle(fontFamily: "NeoSans", fontSize: 12.0),
                ),
                Text(
                  "(" + row.plus + ") " + formatCurrency(row.jumlah),
                  style: new TextStyle(
                      fontFamily: "WorkSansMedium", fontSize: 12.0),
                )
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  "Saldo Akhir : ",
                  style: new TextStyle(
                      fontFamily: "NeoSans",
                      fontSize: 12.0,
                      color: Colors.grey),
                ),
                Text(
                  " " + formatCurrency(row.saldo),
                  textAlign: TextAlign.left,
                  style: new TextStyle(
                      fontFamily: "WorkSansMedium", fontSize: 12.0),
                ),
              ],
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    var savingDetailArea = Container(
        padding: EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(
                child: new Text(
                  "Transaksi Terakhir :",
                  style: new TextStyle(fontFamily: "NeoSans"),
                ),
              ),
              new Container(
                margin: EdgeInsets.all(12.0),
                child: Column(children: <Widget>[
                  FutureBuilder(
                    future: _getData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data != null) {
                          int i = 0;
                          return new Column(
                              children: snapshot.data.map<Widget>((data) {
                            i = i++;
                            return _rowData(data, i);
                          }).toList());
                        } else {
                          dataKosong();
                        }
                      } else {
                        dataKosong();
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
        child: new ListView(
      physics: ClampingScrollPhysics(),
      children: <Widget>[
        new Container(
            // padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
            color: Colors.white,
            child: new Column(
              children: <Widget>[
                savingHeaderArea(),
                savingDetailArea,
              ],
            )),
      ],
    ));
  }
}
