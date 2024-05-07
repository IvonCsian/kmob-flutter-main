
import 'package:flutter/material.dart';
import 'package:kmob/common/platform/platformScaffold.dart';
import 'package:kmob/common/widgets/MyAppBar.dart';

class PanduanTopUp extends StatefulWidget {
  @override
  _PanduanTopUpState createState() => _PanduanTopUpState();
}

class _PanduanTopUpState extends State<PanduanTopUp> {
  double maxWidth = 0;
  double maxHeight = 0;

  //main build method
  Widget build(BuildContext context) {
    maxWidth = MediaQuery.of(context).size.width;
    maxHeight = MediaQuery.of(context).size.height >= 775.0
        ? MediaQuery.of(context).size.height
        : 775.0;
    return SafeArea(
      child: PlatformScaffold(
        appBar: appBarDetail(context, "Panduan Top Up"),
        backgroundColor: Colors.white,
        body: Container(
          child: new ListView(
            physics: ClampingScrollPhysics(),
            children: <Widget>[
              new Container(
                  // padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                  color: Colors.white,
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: new Column(
                      children: <Widget>[
                        Center(
                          child: Text(
                            "Top Up Saldo eWallet K3PG melalui Bank powered by JakOnePay",
                            style: TextStyle(
                                fontSize: 20.0, fontFamily: "NeoSans"),
                          ),
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        // new PhotoView(
                        //   imageProvider: NetworkImage(
                        //     widget.param.image,
                        //   ),
                        // ),
                        new ClipRRect(
                          borderRadius: new BorderRadius.circular(8.0),
                          child: new Image(
                            width: double.infinity,
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              "https://images.squarespace-cdn.com/content/v1/59a14544d55b41551e0b745a/1521267091114-QVJZ99YF5B5727MUE3RP/ke17ZwdGBToddI8pDm48kIg64Nvzn4WHfz1yuICgmzBZw-zPPgdn4jUwVcJE1ZvWQUxwkmyExglNqGp0IvTJZamWLI2zvYWH8K3-s_4yszcp2ryTI0HqTOaaUohrI8PIujaYuyuV0IdzdO773wYELmgJs5UlPjS-K_s4cPf-mbQKMshLAGzx4R3EDFOm1kBS/jakone_mobile_mudah-06.jpg?format=1000w",
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        // Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum",
                        //     textAlign: TextAlign.justify,
                        //     style: TextStyle(
                        //         fontSize: 14.0, fontFamily: "NeoSans")),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
