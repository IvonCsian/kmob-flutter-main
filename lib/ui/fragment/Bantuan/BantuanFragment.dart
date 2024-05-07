import 'package:flutter/material.dart';
import 'package:kmob/utils/constant.dart';
import 'package:url_launcher/url_launcher.dart';

const String kTestString = 'Hello world!';

class BantuanFragment extends StatefulWidget {
  @override
  _BantuanFragmentState createState() => _BantuanFragmentState();
}

class _BantuanFragmentState extends State<BantuanFragment> {
  void whatsAppOpen() async {
    var whatsappUrl = "whatsapp://send?phone=+6285732456667text=HaiAdmin";
    await canLaunch(whatsappUrl)
        ? launch(whatsappUrl)
        : print(
            "open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");
  }

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
                      Text("Bantuan",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontFamily: "NeoSansBold")),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Untuk bantuan dapat menghubungi ",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontFamily: "NeoSansBold")),
                    ],
                  ),
                  Text("no WA : 085732456667",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontFamily: "NeoSansBold")),
                  new Center(
                      child: ElevatedButton(
                    child: Text("Buka WhatsApp"),
                    onPressed: () {
                      whatsAppOpen();
                    },
                  )),
                  SizedBox(height: 20.0),
                ],
              )),
        ));
  }
}
