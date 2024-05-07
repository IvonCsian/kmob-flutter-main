import 'package:flutter/material.dart';
import 'package:kmob/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future getToken() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  String getToken = preferences.getString("LastToken");
  return getToken;
}

getUser() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  String lastUser = preferences.getString("LastToken");
  return lastUser;
}

String tokens;
String urlCheck =
    APIConstant.urlBase + APIConstant.serverApi + "/Profile/isValidToken";
Map<String, String> get headers => {
      'Authorization': 'Bearer $tokens',
      'Content-Type': 'application/json',
    };

Future<bool> checkValidJson() async {
  bool isValidToken = false;
  final prefs = await SharedPreferences.getInstance();
  tokens = prefs.getString('LastToken') ?? '';

  debugPrint("lastToken: " + tokens);

  var response = await http.get(
    Uri.parse(urlCheck),
    headers: headers,
  );

  if (response.statusCode == 200) {
    isValidToken = true;
  }
  return isValidToken;
}

checkToken(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  tokens = prefs.getString('LastToken') ?? '';

  if (["", null, false, 0].contains(tokens)) {
    Navigator.of(context).pushReplacementNamed('/LoginScreen');
  } else {
    bool check = await checkValidJson();
    if (!check) {
      Navigator.of(context).pushReplacementNamed('/LoginScreen');
    }
    // Navigator.of(context).pushReplacementNamed('/HomeScreen');
  }
}
