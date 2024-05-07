import 'package:flutter/material.dart';

class ColorPalette {
  static Color green = Color.fromARGB(255, 69, 170, 74);
  static Color ditarik = Color.fromRGBO(202, 255, 199, 1);
  static Color grey = Color.fromARGB(255, 242, 242, 242);
  static Color grey200 = Color.fromARGB(100, 242, 242, 242);
  static Color menuRide = Color(0xffe99e1e);
  static Color menuCar = Color(0xff14639e);
  static Color menuBluebird = Color(0xff2da5d9);
  static Color menuFood = Color(0xffec1d27);
  static Color menuSend = Color(0xff8dc53e);
  static Color menuDeals = Color(0xfff43f24);
  static Color menuPulsa = Color(0xff72d2a2);
  static Color menuOther = Color(0xffa6a6a6);
  static Color menuShop = Color(0xff0b945e);
  static Color menuMart = Color(0xff68a9e3);
  static Color menuTix = Color(0xffe86f16);
  static Color warnaCorporate = Color(0xff3164bd); //const Color(0xff295cb5)];
}

class APIConstant {
  static String applicationId = "k3pg-flutter";

  // static  String urlBase = "http://192.168.137.1:8080/k3pg-api/"; //local

  /* server */
  static String urlBase = "http://35.197.136.216/"; /* server */
  //static String serverApi = "api-kmob/"; /* server - dev */
  static String serverApi = "api/"; /* server - prod */

  /* local */
  // static String urlBase = "http://192.168.8.222/"; /* local */
  // static String serverApi = "kmob-api/"; /* local */

  // static String mode = "DEV";
  static String mode = "PROD";

  static String url = mode == "DEV"
      ? "http://35.197.136.216/ewalletdev/"
      : "http://35.197.136.216/ewallet/";
}
