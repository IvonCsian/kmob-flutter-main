import 'package:flutter/material.dart';
import 'package:kmob/utils/constant.dart';

const String kTestString = 'Hello world!';

class SimulasiFragment extends StatefulWidget {
  @override
  _SimulasiFragmentState createState() => _SimulasiFragmentState();
}

class _SimulasiFragmentState extends State<SimulasiFragment> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200.0,
        child: Card(
          margin: EdgeInsets.all(10.0),
          elevation: 1.0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50.0))),
          child: Container(
              decoration: BoxDecoration(
                  color: ColorPalette.warnaCorporate,
                  borderRadius:
                      new BorderRadius.all(new Radius.circular(20.0))),
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
                      Text("Pengembangan selanjutnya",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontFamily: "NeoSansBold")),
                    ],
                  ),
                  SizedBox(height: 20.0),
                ],
              )),
        ));
  }
}
