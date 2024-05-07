import 'dart:convert';

import 'package:kmob/model/profile_model.dart';
import 'package:http/http.dart' as http;
import 'package:kmob/utils/constant.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

String tokens;

Map<String, String> get headers => {
      'Authorization': 'Bearer $tokens',
      'Content-Type': 'application/json',
    };

Future<ProfileModel> fetchSummary() async {
  final prefs = await SharedPreferences.getInstance();
  tokens = prefs.getString('LastToken') ?? '';

  String url =
      "" + APIConstant.urlBase + "" + APIConstant.serverApi + "/profile";
  final response = await http.get(Uri.parse(url), headers: headers);
  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    return ProfileModel.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}
