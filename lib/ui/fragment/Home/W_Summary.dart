import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kmob/common/functions/format.dart';
import 'package:kmob/common/functions/future.dart';
import 'package:kmob/model/profile_model.dart';
import 'package:kmob/ui/fragment/point/PointDetail.dart';
import 'package:kmob/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;

class HomeSummary extends StatefulWidget {
  @override
  _HomeSummaryState createState() => _HomeSummaryState();
}

class _HomeSummaryState extends State<HomeSummary> {
  String tokens;
  String url = APIConstant.urlBase + APIConstant.serverApi + "profile";

  SharedPreferences sharedPreferences;
  Map<String, String> get headers => {
        'Authorization': 'Bearer $tokens',
        'Content-Type': 'application/json',
      };
  ProfileModel profile;
  String nama = "", nak, tglMsk, nmPrsh, photo, nik;
  double plafon = 0;
  double plafonPakai = 0;
  double plafonSisa = 0;
  bool isData = false;
  double point = 0;
  double redeem = 0;
  double yourpoint = 0;

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
          var response = await executeRequest(
            url,
            // headers: headers,
          );
          // debugPrint("url: " + url + " header: " + headers.toString());

          if (response.statusCode == 200) {
            profile = new ProfileModel.fromJson(json.decode(response.body));
            if (mounted) {
              setState(() {
                nama = profile.nmAng;
                nak = profile.nak;
                nik = profile.noPeg;
                tglMsk = formatDate(profile.tglMsk.toString());
                nmPrsh = profile.nmPrsh;
                photo = profile.pathFoto;
                plafon = profile.plafon;
                plafonPakai = profile.plafonPakai;
                plafonSisa = profile.plafonSisa;
                yourpoint = profile.yourpoint;
                isData = true;
              });
            }

            // setState(() {});
          } else if (response.statusCode == 401) {
            if (mounted) {
              Navigator.of(context).pushReplacementNamed('/LoginScreen');
            }
          } else {
            print(
                'Something went wrong. \nResponse Code : ${response.statusCode}');
          }
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _checkTokenExist();
    Timer(Duration(seconds: 1), () {
      fetchJson();
    });
  }
  // if (tokens == null || tokens == "") {

  // } else {}

  _checkTokenExist() async {
    final prefs = await SharedPreferences.getInstance();
    tokens = prefs.getString('LastToken') ?? '';
    if (tokens == null) {
      Timer(Duration(seconds: 1), () {
        fetchJson();
      });
    } else {
      fetchJson();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        margin: EdgeInsets.all(10.0),
        height: 270.0,
        width: MediaQuery.of(context).size.width,
        decoration: new BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [const Color(0xff3164bd), const Color(0xff295cb5)],
            ),
            borderRadius: new BorderRadius.all(new Radius.circular(20.0))),
        child: !isData
            ? new Center(
                child: Center(
                child: SizedBox(
                    width: 40.0,
                    height: 40.0,
                    child: const CircularProgressIndicator()),
              ))
            : Column(
                children: <Widget>[
                  new Container(
                    padding: EdgeInsets.all(12.0),
                    decoration: new BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xff3164bd),
                            const Color(0xff295cb5)
                          ],
                        ),
                        borderRadius: new BorderRadius.only(
                            topLeft: new Radius.circular(20.0),
                            topRight: new Radius.circular(20.0))),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Flexible(
                            fit: FlexFit.tight,
                            child: Text("HAI " + nama,
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                                style: new TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.white,
                                    fontFamily: "WorkSansBold"))),
                        Row(
                          children: <Widget>[
                            new Text(
                              "Point Belanja: ",
                              style: new TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.white,
                                  fontFamily: "WorkSans"),
                            ),
                            new Text(
                              formatCurrency(yourpoint),
                              style: new TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.white,
                                  fontFamily: "WorkSansBold"),
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PointDetail(
                                              profile: profile,
                                            )),
                                    ModalRoute.withName("/HomeScreen"));
                              },
                              child: Column(
                                children: <Widget>[
                                  new Container(
                                    child: new Icon(
                                      FontAwesomeIcons.ellipsisV,
                                      color: Colors.white,
                                      size: 12.0,
                                    ),
                                  ),
                                  new Padding(
                                    padding: EdgeInsets.only(top: 7.0),
                                  ),
                                  Center(
                                    child: new Text(
                                      "More",
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
                      ],
                    ),
                  ),
                  new Padding(
                    padding:
                        EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
                    child: Container(
                      height: 190.0,
                      width: double.infinity,
                      child: Row(
                        children: <Widget>[
                          new ClipRRect(
                            borderRadius: new BorderRadius.circular(8.0),
                            child: new Image(
                              width: 100,
                              height: 170,
                              image: NetworkImage(photo),
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                nama,
                                style: TextStyle(
                                    fontFamily: 'WorkSans',
                                    color: Colors.white,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5.0),
                              Text(
                                "No Anggota (NAK) : " + nak,
                                style: TextStyle(
                                  fontFamily: 'WorkSans',
                                  color: Colors.white,
                                  fontSize: 12.0,
                                ),
                              ),
                              SizedBox(height: 5.0),
                              Text(
                                "No NIK : " + nik,
                                style: TextStyle(
                                  fontFamily: 'WorkSans',
                                  color: Colors.white,
                                  fontSize: 12.0,
                                ),
                              ),
                              SizedBox(height: 3.0),
                              Text(
                                "Perusahaan : \n" + nmPrsh,
                                style: TextStyle(
                                  fontFamily: 'WorkSans',
                                  color: Colors.white,
                                  fontSize: 12.0,
                                ),
                              ),
                              SizedBox(height: 3.0),
                              Text(
                                "Tanggal Masuk : \n" + tglMsk,
                                style: TextStyle(
                                  fontFamily: 'WorkSans',
                                  color: Colors.white,
                                  fontSize: 12.0,
                                ),
                              ),
                              SizedBox(height: 3.0),
                              Text(
                                "Plafon : " + formatCurrency(plafon),
                                style: TextStyle(
                                  fontFamily: 'WorkSans',
                                  color: Colors.white,
                                  fontSize: 12.0,
                                ),
                              ),
                              SizedBox(height: 3.0),
                              Text(
                                "Plafon terpakai : " +
                                    formatCurrency(plafonPakai),
                                style: TextStyle(
                                  fontFamily: 'WorkSans',
                                  color: Colors.white,
                                  fontSize: 12.0,
                                ),
                              ),
                              SizedBox(height: 3.0),
                              Text(
                                "Sisa Plafon : " + formatCurrency(plafonSisa),
                                style: TextStyle(
                                  fontFamily: 'WorkSans',
                                  color: Colors.white,
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ));
  }
}
