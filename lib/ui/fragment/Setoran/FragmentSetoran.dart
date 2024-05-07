import 'package:flutter/material.dart';
import 'package:kmob/ui/fragment/Setoran/SetoranSS1Screen.dart';
import 'package:kmob/ui/fragment/Setoran/SetoranSS2Screen.dart';
import 'package:kmob/utils/constant.dart';

class FragmentSetoran extends StatefulWidget {
  @override
  _FragmentSetoranState createState() => _FragmentSetoranState();
}

class SetoranNavigasi {
  String title;
  String subtitle;
  String mode;

  SetoranNavigasi(String s, String t, String mode) {
    this.title = s;
    this.subtitle = t;
    this.mode = mode;
  }
}

class _FragmentSetoranState extends State<FragmentSetoran> {
  List<SetoranNavigasi> litems = [
    SetoranNavigasi('Setoran SS 1', 'Penyetoran Ke Simpanan Sukarela 1', "ss1"),
    SetoranNavigasi('Setoran SS 2', 'Penyetoran/pembukaan Simpanan Sukarela 2 (Berjangka)', "ss2"),
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _makeCard(SetoranNavigasi param) {
    return Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: ColorPalette.warnaCorporate),
        child: _makeListTile(param),
      ),
    );
  }

  Widget _makeListTile(SetoranNavigasi param) {
    return ListTile(
        onTap: () => _onSelectItem(param.mode),
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: new BoxDecoration(
              border: new Border(
                  right: new BorderSide(width: 1.0, color: Colors.white24))),
          child: Icon(Icons.add_circle, color: Colors.white),
        ),
        title: Text(
          param.title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
                  param.subtitle,
                  textAlign: TextAlign.justify,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 30,
                  style: TextStyle(fontSize: 14.0, color: Colors.white)),
        trailing:
            Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0));
  }

  @override
  Widget build(BuildContext context) {
    final makeBody = Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: 2,
        itemBuilder: (BuildContext context, int index) {
          SetoranNavigasi setoranNavigasi = litems[index];
          return _makeCard(setoranNavigasi);
        },
      ),
    );

    return makeBody;
  }

  _onSelectItem(String mode) {
    //navigate
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        switch (mode) {
          case "ss1":
            return SetoranSS1Screen();
            break;
          case "ss2":
            return SetoranSS2Screen();
            break;
          default:
        }
        
      }),
    );
  }
}
