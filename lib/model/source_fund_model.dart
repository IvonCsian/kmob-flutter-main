import 'dart:convert';

import 'package:kmob/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SourceFundModel {
  final int id;
  final String simpanan;
  final String abbrev;
  final int urut;

  SourceFundModel({this.id, this.simpanan, this.abbrev, this.urut});
  factory SourceFundModel.fromJson(Map<String, dynamic> json) {
    return SourceFundModel(
      id: json['id'] == null ? 0 : int.parse(json['id']),
      simpanan: json['perusahaan'] == null ? '' : json['perusahaan'],
      abbrev: json['abbrev'] == null ? '' : json['abbrev'],
      urut: json['urut'] == null ? 0 : int.parse(json['urut']),
    );
  }
}

String tokens;

String url =
    "" + APIConstant.urlBase + "" + APIConstant.serverApi + "perusahaan";
Map<String, String> get headers => {
      'Authorization': 'Bearer $tokens',
      'Content-Type': 'application/json',
    };

class PerusahaanViewModel {
  static List<SourceFundModel> banks;

  static Future loadBanks() async {
    try {
      // banks = new List<SourceFundModel>();
      banks = [];
      final prefs = await SharedPreferences.getInstance();
      tokens = prefs.getString('LastToken') ?? '';

      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        var rest = json.decode(response.body) as List;
        banks = rest
            .map<SourceFundModel>((json) => SourceFundModel.fromJson(json))
            .toList();
      } else if (response.statusCode == 401) {
        // Navigator.of(context).pushReplacementNamed('/LoginScreen');
      }
    } catch (e) {
      print(e);
    }
  }
}
