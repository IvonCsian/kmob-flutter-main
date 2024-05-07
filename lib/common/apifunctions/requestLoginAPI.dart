import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import 'package:kmob/common/functions/future.dart';
import 'package:kmob/common/functions/saveCurrentLogin.dart';
import 'package:kmob/common/functions/showDialogSingleButton.dart';
import 'dart:convert';
import 'package:kmob/model/loginModel.dart';
import 'package:kmob/utils/constant.dart';

Future<bool> requestLoginAPI(
    BuildContext context, String username, String password) async {
  String url = APIConstant.urlBase +
      APIConstant.serverApi +
      "Oauth2/PasswordCredentials";

  Map<String, String> body = {
    'grant_type': "password",
    'username': username,
    'password': password,
    'client_id': "k3pg-flutter",
    'client_secret': "53f6dcbba0f8a4aa824effc750d30a63"
  };

  final response = await executeRequest(
    url,
    body: body, method: RequestMethod.POST,
    // headers: {},
  );

  if (response.statusCode == 200) {
    final responseJson = json.decode(response.body);
    var user = new LoginModel.fromJson(responseJson);

    await saveCurrentLogin(responseJson);
    // Timer(Duration(seconds: 3), () {
    //   Navigator.of(context).pushReplacementNamed('/HomeScreen');
    // });
    if (user.kasir) {
      Navigator.of(context).pushReplacementNamed('/KasirScreen');
      return true;
    } else {
      Navigator.of(context).pushReplacementNamed('/HomeScreen');
      return true;
    }
  } else if (response.statusCode == 502) {
    showDialogSingleButton(
        context, "Check your connection", "please check your connection", "OK");
    return false;
  } else {
    showDialogSingleButton(
        context,
        "Unable to Login",
        "You may have supplied an invalid 'Username' / 'Password' combination. Please try again or contact your support representative.",
        "OK");
    return false;
  }
}
