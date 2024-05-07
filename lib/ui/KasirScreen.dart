import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kmob/common/apifunctions/requestLogoutAPI.dart';
import 'package:kmob/ui/fragment/Simulasi/SimulasiFragment.dart';
import 'package:kmob/ui/fragmentKasir/kupon/KuponScreen.dart';
import 'package:kmob/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kmob/common/platform/platformScaffold.dart';

import 'fragmentKasir/ListKupon/FragmentListKasir.dart';

//Let's define a DrawerItem data object
class DrawerItem {
  String key;
  String title;
  String subtitle;
  IconData icon;
  DrawerItem(this.key, this.title, this.subtitle, this.icon);
}

class KasirScreen extends StatefulWidget {
  //Let's define our drawer items, strings and images
  final drawerItems = [
    new DrawerItem("formkupon", "Kupon & Voucher", "Transaksi Kupon & Voucher",
        Icons.card_giftcard),
    new DrawerItem("listkupon", "Riwayat Transaksi", "Riwayat Kupon & Voucher",
        Icons.card_giftcard),
    new DrawerItem("keluar", "Keluar", "Log out dan keluar aplikasi",
        FontAwesomeIcons.signOutAlt),
  ];
  @override
  _KasirScreenState createState() => _KasirScreenState();
}

class _KasirScreenState extends State<KasirScreen> {
  String appBarTitle;

  int _selectedDrawerIndex = 0;
  String callback = "";

  _getAppBar(int post) {
    String title = "";

    if (appBarTitle != null && appBarTitle != "") {
      title = "Kasir - " + appBarTitle;
    } else {
      title = "Kasir - " + widget.drawerItems[post].title;
    }

    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Container(
              padding: new EdgeInsets.only(right: 13.0),
              child: Text(
                "$title",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontFamily: "WorkSans"),
              ),
            ),
          ),
          ClipOval(
            child: Container(
              child: new Image.asset(
                'assets/img/logo.jpg',
                fit: BoxFit.contain,
                height: 35,
              ),
            ),
          )
        ],
      ),
      backgroundColor: ColorPalette.warnaCorporate,
      iconTheme: IconThemeData(color: Colors.white),
      elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 6.0,
    );
  }

  //Let's update the selectedDrawerItemIndex the close the drawer
  _onSelectItem(int index) {
    setState(() {
      _selectedDrawerIndex = index;
    });
    //we close the drawer
    if (index != (widget.drawerItems.length - 1)) {
      Navigator.of(context).pop();
    } else {
      requestLogoutAPI(context);
      Navigator.of(context).pushReplacementNamed('/LoginScreen');
    }
  }

  _saveCurrentRoute(String lastRoute) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('LastScreenRoute', lastRoute);
  }

  @override
  void initState() {
    super.initState();
    _saveCurrentRoute("/KasirScreen");
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildChild(int position) {
    String key = widget.drawerItems[position].key;
    String mode = callback == "" ? key : callback;
    callback = "";
    switch (mode) {
      //form kupon
      case "formkupon":
        return new KuponScreen();
      //form kupon
      case "listkupon":
        return new ListKuponScreen();
      //rekeningku pinjaman
      default:
        return new SimulasiFragment();
    }
  }

  Future<bool> _onWillPop() {
    if (_selectedDrawerIndex != 0) {
      setState(() {
        _selectedDrawerIndex = 0;
      });
    } else {
      return showDialog(
        context: context,
        builder: (context) {
          print("tes " + _selectedDrawerIndex.toString());
          return new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // drawerOptions.clear();

    List<int> divide = [1];
    List<Widget> drawerOptions = [];
    //Let's create drawer list items. Each will have an icon and text
    for (int i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];

      drawerOptions.add(new ListTile(
        leading: new Icon(d.icon),
        title: new Text(
          d.title,
          style: new TextStyle(fontFamily: "WorkSans", fontSize: 14.0),
        ),
        subtitle: new Text(
          d.subtitle,
          style: new TextStyle(color: Colors.grey[300], fontSize: 11.0),
        ),
        selected: i == _selectedDrawerIndex,
        onTap: () => _onSelectItem(i),
      ));
      if (divide.contains(i))
        drawerOptions.add(Divider(
          color: Colors.yellow,
        ));
    }

    return WillPopScope(
      child: SafeArea(
        child: PlatformScaffold(
          // appBar: new MyAppBar(_selectedDrawerIndex),
          appBar: _getAppBar(_selectedDrawerIndex),
          drawer: Drawer(
              child: Container(
            color: ColorPalette.warnaCorporate,
            child: ListTileTheme(
              iconColor: Colors.white,
              selectedColor: Colors.yellow[500],
              textColor: Colors.white,
              child: new ListView(
                children: <Widget>[
                  new UserAccountsDrawerHeader(
                    accountName: new Text("KASIR"),
                    accountEmail: new Text("K3PG"),
                    decoration: new BoxDecoration(
                        image: new DecorationImage(
                            image: new AssetImage("assets/img/header.jpg"),
                            fit: BoxFit.cover)),
                  ),
                  ...drawerOptions
                ],
              ),
            ),
          )),
          backgroundColor: Colors.white,
          body: _buildChild(_selectedDrawerIndex),
        ),
      ),
      onWillPop: _onWillPop,
    );
  }
}
