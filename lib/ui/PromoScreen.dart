import 'package:flutter/material.dart';
import 'package:kmob/common/platform/platformScaffold.dart';
import 'package:kmob/common/widgets/MyAppBar.dart';
import 'package:kmob/model/home_model.dart';

class PromoScreen extends StatefulWidget {
  final Promo param;
  const PromoScreen({Key key, this.param}) : super(key: key);

  @override
  _PromoScreenState createState() => _PromoScreenState();
}

class _PromoScreenState extends State<PromoScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PlatformScaffold(
        // appBar: new MyAppBar(_selectedDrawerIndex),
        appBar: appBarDetail(context, "Detail Berita"),
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
                            widget.param.title,
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
                              widget.param.image,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        Text(widget.param.content,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                fontSize: 14.0, fontFamily: "NeoSans")),
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
