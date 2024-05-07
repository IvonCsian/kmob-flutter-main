import 'package:flutter/material.dart';
import 'package:kmob/common/functions/future.dart';
import 'package:kmob/common/widgets/MyAppBar.dart';

class TabSimpananSukarela2 extends StatefulWidget {
  @override
  _TabSimpananSukarela2State createState() => _TabSimpananSukarela2State();
}

class _TabSimpananSukarela2State extends State<TabSimpananSukarela2> {
  @override
  Widget build(BuildContext context) {
    var listdeposito = Container(
        padding: EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new Text(
                "Simpanan Sukarela 2 :",
                style: new TextStyle(fontFamily: "NeoSansBold"),
              ),
              new Container(
                margin: EdgeInsets.all(10.0),
                child: Column(children: <Widget>[
                  FutureBuilder(
                    future: getDataSimpanan2(context,true),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        int i = 0;
                        return new Column(
                            children: snapshot.data.map<Widget>((data) {
                          i = i++;
                          return rowDataSimpanan2(data, context, true);
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
