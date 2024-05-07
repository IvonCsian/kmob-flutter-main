import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kmob/model/home_model.dart';
import 'package:kmob/utils/constant.dart';

class HomeMenu extends StatefulWidget {
  @override
  _HomeMenuState createState() => _HomeMenuState();
}

class _HomeMenuState extends State<HomeMenu> {
  List<K3PGService> _k3pgServiceList = [
    new K3PGService(
        image: FontAwesomeIcons.moneyBill,
        color: ColorPalette.menuRide,
        mode: "simpanan",
        title: "SIMPANAN"),
    new K3PGService(
        image: FontAwesomeIcons.moneyCheck,
        color: ColorPalette.menuCar,
        mode: "pinjaman",
        title: "PINJAMAN"),
    new K3PGService(
        image: FontAwesomeIcons.funnelDollar,
        color: ColorPalette.menuBluebird,
        mode: "ratesimpanan",
        title: "RATE SIMPANAN"),
    new K3PGService(
        image: FontAwesomeIcons.calculator,
        color: ColorPalette.menuFood,
        mode: "ratepinjaman",
        title: "RATE PINJAMAN"),
    new K3PGService(
        image: FontAwesomeIcons.tags,
        color: ColorPalette.menuSend,
        mode: "promosi",
        title: "PROMOSI"),
    new K3PGService(
        image: FontAwesomeIcons.cogs,
        color: Colors.black,
        mode: "administrasi",
        title: "ADMINISTRASI"),
    new K3PGService(
        image: FontAwesomeIcons.productHunt,
        color: Colors.pink,
        mode: "produkjasa",
        title: "PEMBAYARAN KREDIT"),
    new K3PGService(
        image: FontAwesomeIcons.book,
        color: Colors.orange[500],
        mode: "bantuan",
        title: "BANTUAN")
  ];
  @override
  void initState() {
    super.initState();
  }

  Widget _rowMenuService(K3PGService gojekService) {
    return new Container(
      child: InkWell(
        onTap: () {
          navigate(gojekService.mode);
        },
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
              decoration: new BoxDecoration(
                  border: Border.all(color: ColorPalette.grey200, width: 1.0),
                  borderRadius:
                      new BorderRadius.all(new Radius.circular(10.0))),
              padding: EdgeInsets.all(6.0),
              child: new Icon(
                gojekService.image,
                color: gojekService.color,
                size: 28.0,
              ),
            ),
            new Padding(
              padding: EdgeInsets.only(top: 6.0),
            ),
            Center(
              child: new Text(
                gojekService.title,
                style: new TextStyle(fontSize: 9.0, fontFamily: "WorkSansBold"),
              ),
            ),
          ],
        ),
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
            "MENU",
            style: new TextStyle(fontFamily: "WorkSansBold", fontSize: 14.0),
          ),
          new SizedBox(
              width: double.infinity,
              height: 200.0,
              child: new Container(
                  child: GridView.builder(
                      physics: ClampingScrollPhysics(),
                      itemCount: _k3pgServiceList.length,
                      gridDelegate:
                          new SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4),
                      itemBuilder: (context, position) {
                        return _rowMenuService(_k3pgServiceList[position]);
                      }))),
        ],
      ),
    );
  }

  void navigate(String mode) {
    switch (mode) {
      case "simpanan":
        break;
      case "pinjaman":
        break;
      case "ratesimpanan":
        break;
      case "simulasi":
        break;
      case "promosi":
        break;
      case "administrasi":
        break;
      case "produkjasa":
        break;
      case "bantuan":
        break;

        break;
      default:
    }
  }
}
