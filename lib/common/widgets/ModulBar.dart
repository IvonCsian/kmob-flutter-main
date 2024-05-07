import 'package:flutter/material.dart';

class ModulBar extends StatelessWidget {
  final double height;

  const ModulBar({Key key, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        new Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue, Colors.blue[600]],
            ),
          ),
          height: height,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Masukkan nominal setoran anda",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontFamily: "NeoSansLight")),
          ],
        ),
      ],
    );
  }
}
