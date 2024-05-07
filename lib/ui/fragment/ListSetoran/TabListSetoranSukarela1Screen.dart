import 'package:flutter/material.dart';
import 'package:kmob/common/functions/future.dart';
import 'package:kmob/common/widgets/MyAppBar.dart';
import 'package:kmob/model/setoran_model.dart';

class TabListSetoranSukarela1Screen extends StatefulWidget {
  @override
  _TabListSetoranSukarela1ScreenState createState() =>
      _TabListSetoranSukarela1ScreenState();
}

class _TabListSetoranSukarela1ScreenState
    extends State<TabListSetoranSukarela1Screen> {
  String tokens;
  String saldo = "";
  String tglUpdate = "";
  List<SetoranModel> list = [];
  @override
  Widget build(BuildContext context) {
    var listdeposito = Container(
        padding: EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new Container(
                margin: EdgeInsets.all(10.0),
                child: Column(children: <Widget>[
                  FutureBuilder(
                    future: getDataSetoran1(context),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        int i = 0;
                        return new Column(
                            children: snapshot.data.map<Widget>((data) {
                          i = i++;
                          return rowDataSetoran1(data, context);
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
        child: new ListView(
      physics: ClampingScrollPhysics(),
      children: <Widget>[
        new Container(
            // padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
            color: Colors.white,
            child: new Column(
              children: <Widget>[
                listdeposito,
              ],
            )),
      ],
    ));
  }
}
