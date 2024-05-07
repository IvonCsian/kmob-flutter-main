import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kmob/common/functions/future.dart';
import 'package:kmob/model/home_model.dart';
import 'package:kmob/ui/PromoScreen.dart';
import 'package:kmob/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;

class HomePromo extends StatefulWidget {
  @override
  _HomePromoState createState() => _HomePromoState();
}

class _HomePromoState extends State<HomePromo> {
  List<Promo> _poromoList = [];
  String tokens;
  String url = APIConstant.urlBase + APIConstant.serverApi + "News";
  Map<String, String> get headers => {
        'Authorization': 'Bearer $tokens',
        'Content-Type': 'application/json',
      };
  Future<List<Promo>> fetchPromo() async {
    final prefs = await SharedPreferences.getInstance();
    tokens = prefs.getString('LastToken') ?? '';

    final response = await executeRequest(url);
    // http.get(Uri.parse(url), headers: headers);

    // debugPrint(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var rest = data as List;
      _poromoList = rest.map<Promo>((json) => Promo.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      // Navigator.of(context).pushReplacementNamed('/LoginScreen');
    }
    return _poromoList;
  }

  Widget _rowPromo(Promo promo) {
    return new Container(
      height: 320.0,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            margin: EdgeInsets.only(bottom: 16.0),
            width: double.infinity,
            height: 1.0,
            color: ColorPalette.grey200,
          ),
          new ClipRRect(
            borderRadius: new BorderRadius.circular(8.0),
            child: FadeInImage.assetNetwork(
              height: 172.0,
              width: double.infinity,
              fit: BoxFit.fitWidth,
              placeholder: 'assets/img/loading.gif',
              image: promo.image,
            ),
          ),
          new Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),
          new Text(
            promo.title,
            style: new TextStyle(fontFamily: "WorkSansBold", fontSize: 12.0),
          ),
          new Padding(
            padding: EdgeInsets.only(top: 5.0),
          ),
          new Text(
            promo.content,
            maxLines: 2,
            softWrap: true,
            style: new TextStyle(
              color: Colors.grey,
              fontSize: 11.0,
              fontFamily: "WorkSans",
            ),
          ),
          new Padding(
            padding: EdgeInsets.only(top: 5.0),
          ),
          new Container(
            alignment: Alignment.centerRight,
            child: new MaterialButton(
              color: ColorPalette.green,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PromoScreen(param: promo)),
                );
              },
              child: new Text(
                promo.button,
                style: new TextStyle(
                    color: Colors.white, fontFamily: "NeoSans", fontSize: 12.0),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          new Text(
            "PROMO",
            style: new TextStyle(fontFamily: "WorkSansBold", fontSize: 14.0),
          ),
          new Text(
            "Promo K3PG",
            style: new TextStyle(fontFamily: "WorkSansBold", fontSize: 10.0),
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
                  new Container(
                    alignment: Alignment.centerRight,
                    child: new MaterialButton(
                      minWidth: double.infinity,
                      color: ColorPalette.green,
                      onPressed: () {},
                      child: new Text(
                        "Lihat berita lainnya",
                        style: new TextStyle(
                            color: Colors.white,
                            fontFamily: "NeoSans",
                            fontSize: 12.0),
                      ),
                    ),
                  )
                ],
              )),
        ],
      ),
    );
  }
}
