import 'package:flutter/material.dart';
import 'package:kmob/model/loginModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

saveCurrentLogin(Map responseJson) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  var user;
  if ((responseJson != null && responseJson.isNotEmpty)) {
    user = LoginModel.fromJson(responseJson).userName;
  } else {
    user = "";
  }
  var token = (responseJson != null && responseJson.isNotEmpty)
      ? LoginModel.fromJson(responseJson).token
      : "";
  var email = (responseJson != null && responseJson.isNotEmpty)
      ? LoginModel.fromJson(responseJson).email
      : "";
  var pk = (responseJson != null && responseJson.isNotEmpty)
      ? LoginModel.fromJson(responseJson).userId
      : "";

  debugPrint("token sekarang: " + token);

  await preferences.setString(
      'LastUser', (user != null && user.length > 0) ? user : "");
  await preferences.setString(
      'LastToken', (token != null && token.length > 0) ? token : "");
  await preferences.setString(
      'LastEmail', (email != null && email.length > 0) ? email : "");
  await preferences.setString(
      'LastUserId', (pk != null && pk.length > 0) ? pk : "");
}
