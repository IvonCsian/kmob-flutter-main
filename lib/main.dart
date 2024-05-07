import 'package:flutter/material.dart';
import 'package:kmob/ui/KasirScreen.dart';
import 'package:kmob/ui/homeScreen.dart';
import 'package:kmob/ui/loginScreen.dart';
import 'package:kmob/ui/splashScreen.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "K3PG Apps",
      routes: <String, WidgetBuilder>{
        "/HomeScreen": (BuildContext context) => HomeScreen(),
        "/KasirScreen": (BuildContext context) => KasirScreen(),
        "/LoginScreen": (BuildContext context) => LoginScreen(),
      },
      home: SplashScreen(),
    );
  }
}
