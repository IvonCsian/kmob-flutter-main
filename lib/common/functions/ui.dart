import 'dart:async';

import 'package:flutter/material.dart';

void fieldFocusChange(
    BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}

void showInSnackBar(String value, BuildContext context) {
  // FocusScope.of(context).requestFocus(new FocusNode());
  // _scaffoldKey.currentState?.removeCurrentSnackBar();
  // _scaffoldKey.currentState.showSnackBar(new SnackBar(
  //   content: new Text(
  //     value,
  //     textAlign: TextAlign.center,
  //     style: TextStyle(
  //         color: Colors.white, fontSize: 16.0, fontFamily: "WorkSansSemiBold"),
  //   ),
  //   backgroundColor: ColorPalette.warnaCorporate,
  //   duration: Duration(seconds: 3),
  // ));

  final snackBar = SnackBar(content: Text('Yay! A SnackBar!'));
// Find the Scaffold in the widget tree and use it to show a SnackBar.

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
