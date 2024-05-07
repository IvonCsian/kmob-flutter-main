
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kmob/common/functions/saveLogout.dart';
import 'package:kmob/model/loginModel.dart';

Future<LoginModel> requestLogoutAPI(BuildContext context) async {
  //kmob pakai oauth2 
  saveLogout();
  Navigator.of(context).pushReplacementNamed('/LoginScreen');
  return null;
}