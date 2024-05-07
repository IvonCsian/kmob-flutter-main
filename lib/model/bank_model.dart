import 'dart:convert';

import 'package:kmob/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class BankModel {
  final String idbank;
  final String nama;
  final String tipe;

  BankModel({this.idbank, this.nama, this.tipe});
  factory BankModel.fromJson(Map<String, dynamic> json) {
    return BankModel(
      idbank: json['idbank'] == null ? '' : json['idbank'],
      nama: json['nama'] == null ? '' : json['nama'],
      tipe: json['tipe'] == null ? '' : json['tipe'],
    );
  }
}

String tokens;

String url = "" + APIConstant.urlBase + "" + APIConstant.serverApi + "bank";
Map<String, String> get headers => {
      'Authorization': 'Bearer $tokens',
      'Content-Type': 'application/json',
    };

class BankModelViewModel {
  static List<BankModel> banks;

  static Future loadBanks() async {
    try {
      banks = [];
      // banks = new List<BankModel>();
      final prefs = await SharedPreferences.getInstance();
      tokens = prefs.getString('LastToken') ?? '';

      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        var rest = json.decode(response.body) as List;
        banks =
            rest.map<BankModel>((json) => BankModel.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        // Navigator.of(context).pushReplacementNamed('/LoginScreen');
      }
    } catch (e) {
      print(e);
    }
  }
}
