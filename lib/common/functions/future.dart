//getdata area
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kmob/model/nota_model.dart';
import 'package:kmob/model/rate_pinjaman_model.dart';
import 'package:kmob/model/rate_simpanan_model.dart';
import 'package:kmob/model/setoran_model.dart';
import 'package:kmob/model/simpanan_model.dart';
import 'package:kmob/model/voucher_model.dart';
import 'package:kmob/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

String tokens;

Map<String, String> get headers => {
      'Authorization': 'Bearer $tokens',
      'Content-Type': 'application/json',
    };

enum RequestMethod { GET, POST }

Future<http.Response> executeRequest(
  String url, {
  Map<String, String> headers,
  dynamic body,
  RequestMethod method = RequestMethod.GET,
}) async {
  http.Response response;

  final prefs = await SharedPreferences.getInstance();
  tokens = prefs.getString('LastToken') ?? '';

  // if (headers == null) {}
  headers = headers ??
      {
        'Authorization': 'Bearer $tokens',
        'Content-Type': 'application/json',
      };

  // if (body == null) {}
  body = body ?? {};

  debugPrint("url: " +
      url +
      ", method: " +
      method.toString() +
      ", headers: " +
      headers.toString() +
      ", body: " +
      body.toString());

  try {
    if (method == RequestMethod.GET) {
      response = await http.get(Uri.parse(url), headers: headers);
    } else {
      response = await http.post(Uri.parse(url),
          headers: headers, body: json.encode(body));
    }

    debugPrint('response.code: ' +
        response.statusCode.toString() +
        ', response body: ' +
        response.body.toString());

    return response;
    // if (response.statusCode == 200) {
    // } else if (response.statusCode == 401) {
    //   // throw ('Failed request: ${response.statusCode}');
    // }
  } catch (error) {
    // Tangani kesalahan seperti koneksi terputus, timeout, dsb.
    throw ('Error executing request: $error');
  }
}

Future<List<Simpanan2Model>> getDataSimpanan2(BuildContext context, bool header,
    [String param]) async {
  List<Simpanan2Model> list = [];

  String url = APIConstant.urlBase + APIConstant.serverApi;
  url = header
      ? url + "simpanan/ss2"
      : url + "simpanan/ss2_detail?noss2=" + param;
  final prefs = await SharedPreferences.getInstance();
  tokens = prefs.getString('LastToken') ?? '';
  final response = await http.get(Uri.parse(url), headers: headers);
  if (response.statusCode == 200) {
    var rest = json.decode(response.body) as List;
    list = rest
        .map<Simpanan2Model>((json) => Simpanan2Model.fromJson(json))
        .toList();
  } else if (response.statusCode == 204) {
  } else if (response.statusCode == 401) {
    Navigator.of(context).pushReplacementNamed('/LoginScreen');
  }
  return list;
}

//getdata area
Future<List<NotaModel>> getDataNota(BuildContext context) async {
  List<NotaModel> list = [];

  String url = APIConstant.urlBase + APIConstant.serverApi + "nota/data";

  debugPrint(url);

  final prefs = await SharedPreferences.getInstance();
  tokens = prefs.getString('LastToken') ?? '';
  final response = await http.get(Uri.parse(url), headers: headers);

  if (response.statusCode == 200) {
    var rest = json.decode(response.body) as List;
    list = rest.map<NotaModel>((json) => NotaModel.fromJson(json)).toList();
  } else if (response.statusCode == 204) {
  } else if (response.statusCode == 401) {
    Navigator.of(context).pushReplacementNamed('/LoginScreen');
  }
  return list;
}

//getdata area
Future<List<KreditModel>> getDataKredit(BuildContext context) async {
  List<KreditModel> list = [];

  String url = APIConstant.urlBase + APIConstant.serverApi + "Kredit/list";
  final prefs = await SharedPreferences.getInstance();
  tokens = prefs.getString('LastToken') ?? '';
  final response = await http.get(Uri.parse(url), headers: headers);
  if (response.statusCode == 200) {
    var rest = json.decode(response.body) as List;
    list = rest.map<KreditModel>((json) => KreditModel.fromJson(json)).toList();
  } else if (response.statusCode == 204) {
  } else if (response.statusCode == 401) {
    Navigator.of(context).pushReplacementNamed('/LoginScreen');
  }
  return list;
}

class KeyValue {
  final String key;
  final String value;

  KeyValue(this.key, this.value);
}

//getdata area
Future<dynamic> getDataVoucher1(
  BuildContext context, {
  int limit,
  String id_status,
}) async {
  dynamic list;

  String url = APIConstant.urlBase + APIConstant.serverApi + "Voucher/newList";

  debugPrint(url);

  final prefs = await SharedPreferences.getInstance();
  tokens = prefs.getString('LastToken') ?? '';

  Map<String, dynamic> body = {
    "limit": "",
    "id_status": "",
  };

  if (limit != "") {
    body['limit'] = limit;
  }
  if (id_status != "") {
    body['id_status'] = id_status;
  }

  debugPrint(body.toString());

  final response = await http.post(Uri.parse(url),
      headers: headers, body: json.encode(body));

  if (response.statusCode == 200) {
    list = response.body;

    debugPrint(list);
  } else if (response.statusCode == 204) {
  } else if (response.statusCode == 401) {
    Navigator.of(context).pushReplacementNamed('/LoginScreen');
  }

  return list;
}

Future<String> getVoucherStatus(BuildContext context) async {
  String result;

  String url =
      APIConstant.urlBase + APIConstant.serverApi + "Voucher/statuslist";

  final response = await http.post(
    Uri.parse(url),
    headers: headers,
    // body: json.encode(body),
  );

  if (response.statusCode == 200) {
    // final List<dynamic> jsonData = json.decode(response.body);
    // return jsonData.cast<Map<String, String>>();
    return response.body;
  } else if (response.statusCode == 204) {
  } else if (response.statusCode == 401) {
    Navigator.of(context).pushReplacementNamed('/LoginScreen');
  }

  return result;
}

//getdata area
Future<List<CouponLogModel>> getDataCoupon(BuildContext context) async {
  List<CouponLogModel> list = [];

  String url = APIConstant.urlBase + APIConstant.serverApi + "Coupon/top10";
  final prefs = await SharedPreferences.getInstance();
  tokens = prefs.getString('LastToken') ?? '';
  final response = await http.post(Uri.parse(url), headers: headers);
  if (response.statusCode == 200) {
    var rest = json.decode(response.body) as List;
    list = rest
        .map<CouponLogModel>((json) => CouponLogModel.fromJson(json))
        .toList();
  } else if (response.statusCode == 204) {
  } else if (response.statusCode == 401) {
    Navigator.of(context).pushReplacementNamed('/LoginScreen');
  }
  return list;
}

//getdata area
Future<List<VoucherLogModel>> getDataVoucher2(BuildContext context) async {
  List<VoucherLogModel> list = [];

  String url = APIConstant.urlBase + APIConstant.serverApi + "Voucher/top10";
  final prefs = await SharedPreferences.getInstance();
  tokens = prefs.getString('LastToken') ?? '';
  final response = await http.post(Uri.parse(url), headers: headers);
  if (response.statusCode == 200) {
    var rest = json.decode(response.body) as List;
    list = rest
        .map<VoucherLogModel>((json) => VoucherLogModel.fromJson(json))
        .toList();
  } else if (response.statusCode == 204) {
  } else if (response.statusCode == 401) {
    Navigator.of(context).pushReplacementNamed('/LoginScreen');
  }
  return list;
}

//getdata area
Future<List<VoucherLogModel>> getDataVoucherLog(
    BuildContext context, String kodeVoucher) async {
  List<VoucherLogModel> list = [];

  String url = "" +
      APIConstant.urlBase +
      "" +
      APIConstant.serverApi +
      "Voucher/Log?kode_voucher=" +
      kodeVoucher;
  final prefs = await SharedPreferences.getInstance();
  tokens = prefs.getString('LastToken') ?? '';
  final response = await http.get(Uri.parse(url), headers: headers);
  if (response.statusCode == 200) {
    var rest = json.decode(response.body) as List;
    list = rest
        .map<VoucherLogModel>((json) => VoucherLogModel.fromJson(json))
        .toList();
  } else if (response.statusCode == 204) {
  } else if (response.statusCode == 401) {
    Navigator.of(context).pushReplacementNamed('/LoginScreen');
  }
  return list;
}

//getdata area
Future<List<SetoranModel>> getDataSetoran1(BuildContext context) async {
  List<SetoranModel> list = [];

  String url = "" +
      APIConstant.urlBase +
      "" +
      APIConstant.serverApi +
      "Setoran/ss1?simpanan=ss1";
  final prefs = await SharedPreferences.getInstance();
  tokens = prefs.getString('LastToken') ?? '';
  final response = await http.get(Uri.parse(url), headers: headers);
  if (response.statusCode == 200) {
    var rest = json.decode(response.body) as List;
    list =
        rest.map<SetoranModel>((json) => SetoranModel.fromJson(json)).toList();
  } else if (response.statusCode == 204) {
  } else if (response.statusCode == 401) {
    Navigator.of(context).pushReplacementNamed('/LoginScreen');
  }
  return list;
}

//getdata area
Future<List<RateSimpananModel>> getDataRateSimpanan(
    BuildContext context) async {
  List<RateSimpananModel> list = [];

  String url = APIConstant.urlBase + APIConstant.serverApi + "Rate/simpanan";
  final prefs = await SharedPreferences.getInstance();
  tokens = prefs.getString('LastToken') ?? '';
  final response = await http.get(Uri.parse(url), headers: headers);
  if (response.statusCode == 200) {
    var rest = json.decode(response.body) as List;
    list = rest
        .map<RateSimpananModel>((json) => RateSimpananModel.fromJson(json))
        .toList();
  } else if (response.statusCode == 204) {
  } else if (response.statusCode == 401) {
    Navigator.of(context).pushReplacementNamed('/LoginScreen');
  }
  return list;
}

//getdata area
Future<dynamic> getDataRateSimpananTable(BuildContext context) async {
  String url = APIConstant.urlBase + APIConstant.serverApi + "Rate/simpanan";
  final prefs = await SharedPreferences.getInstance();
  tokens = prefs.getString('LastToken') ?? '';
  final response = await http.get(Uri.parse(url), headers: headers);
  if (response.statusCode == 200) {
  } else if (response.statusCode == 204) {
  } else if (response.statusCode == 401) {
    Navigator.of(context).pushReplacementNamed('/LoginScreen');
  }
  return json.decode(response.body);
}

Future<List<RatePinjamanModel>> getDataRatePinjaman(
    BuildContext context) async {
  List<RatePinjamanModel> list = [];

  String url = APIConstant.urlBase + APIConstant.serverApi + "Rate/pinjaman";
  final prefs = await SharedPreferences.getInstance();
  tokens = prefs.getString('LastToken') ?? '';
  final response = await http.get(Uri.parse(url), headers: headers);
  if (response.statusCode == 200) {
    var rest = json.decode(response.body) as List;
    list = rest
        .map<RatePinjamanModel>((json) => RatePinjamanModel.fromJson(json))
        .toList();
  } else if (response.statusCode == 204) {
  } else if (response.statusCode == 401) {
    Navigator.of(context).pushReplacementNamed('/LoginScreen');
  }
  return list;
}

//getdata area
Future<List<SetoranModel>> getDataSetoran2(BuildContext context) async {
  List<SetoranModel> list = [];

  String url = "" +
      APIConstant.urlBase +
      "" +
      APIConstant.serverApi +
      "Setoran/ss1?simpanan=ss2";
  final prefs = await SharedPreferences.getInstance();
  tokens = prefs.getString('LastToken') ?? '';
  final response = await http.get(Uri.parse(url), headers: headers);
  if (response.statusCode == 200) {
    var rest = json.decode(response.body) as List;
    list =
        rest.map<SetoranModel>((json) => SetoranModel.fromJson(json)).toList();
  } else if (response.statusCode == 204) {
  } else if (response.statusCode == 401) {
    Navigator.of(context).pushReplacementNamed('/LoginScreen');
  }
  return list;
}
