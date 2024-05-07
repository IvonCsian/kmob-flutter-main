import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kmob/utils/constant.dart';

class ReusableWidgets {
  static getAppBar(BuildContext context, String title) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "K3PG - $title",
            style: TextStyle(
                color: ColorPalette.warnaCorporate,
                fontSize: 16.0,
                fontFamily: "WorkSansSemiBold"),
          ),
          new Image.asset(
            'assets/img/logok3pg.png',
            fit: BoxFit.contain,
            height: 16,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: ColorPalette.warnaCorporate),
      elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 6.0,
    );
  }
}

Widget tombol({Widget child, VoidCallback onPressed, Color backgroundColor}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: backgroundColor ?? Colors.blue,
    ),
    onPressed: onPressed,
    child: child,
  );
}

Widget loadingView() {
  return Stack(
    children: [
      Container(
        color: Colors.transparent,
      ),
      Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: EdgeInsets.all(20.0),
          // color: Colors.black.withOpacity(0.4),
          // alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20.0),
              Text(
                'Loading...',
                style: TextStyle(fontSize: 18.0, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

void showInfoDialog(BuildContext context,
    {String title, Widget content, List<Widget> actions}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title ?? 'Judul'),
        content: content ?? Text('Info'),
        actions: actions ??
            <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
      );
    },
  );
}

Future<bool> confirmDialog(context,
    {String title, Widget content, List<Widget> actions}) async {
  // Completer<bool> result = Completer<bool>();

  return await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title ?? 'Judul'),
        content: content ?? Text('Info'),
        actions: actions ??
            <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text('Yes'),
              ),
            ],
      );
    },
  );

  // return result.future;
}
