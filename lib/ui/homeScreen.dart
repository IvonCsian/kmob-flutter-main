import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kmob/common/apifunctions/requestLogoutAPI.dart';
import 'package:kmob/common/functions/future.dart';
import 'package:kmob/model/profile_model.dart';
import 'package:kmob/ui/fragment/Administrasi/AdministrasiFragment.dart';
import 'package:kmob/ui/fragment/Bantuan/BantuanFragment.dart';
import 'package:kmob/ui/fragment/InfoRate/RatePinjamanFragment.dart';
import 'package:kmob/ui/fragment/InfoRate/RateSimpananFragment.dart';
import 'package:kmob/ui/fragment/ListSPBU/RiwayatSPBU.dart';
import 'package:kmob/ui/fragment/ListSetoran/FragmentListSetoran.dart';
import 'package:kmob/ui/fragment/PembayaranKredit/PembayaranKreditFragment.dart';
import 'package:kmob/ui/fragment/Pinjaman/PinjamanFragment.dart';
import 'package:kmob/ui/fragment/Rekening/SimpananFragment.dart';
import 'package:kmob/ui/fragment/Setoran/FragmentSetoran.dart';
import 'package:kmob/ui/fragment/Simulasi/SimulasiFragment.dart';
import 'package:kmob/ui/fragment/Spbu/UploadNotaSPBU.dart';
// import 'package:kmob/ui/fragment/Spbu/EntrySPBUScreen.dart';
// import 'package:kmob/ui/fragment/Spbu/UploadSPBUScreen.dart';
import 'package:kmob/ui/fragment/TentangFragment.dart';
import 'package:kmob/ui/fragment/Voucher/VoucherFragmentScreen.dart';
import 'package:kmob/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kmob/common/platform/platformScaffold.dart';
// import 'package:http/http.dart' as http;
import 'fragment/Home/HomeFragment.dart';
import 'package:url_launcher/url_launcher.dart';

//Let's define a DrawerItem data object
class DrawerItem {
  String key;
  String title;
  String subtitle;
  IconData icon;
  DrawerItem(this.key, this.title, this.subtitle, this.icon);
}

class HomeScreen extends StatefulWidget {
  //Let's define our drawer items, strings and images
  final drawerItems = [
    new DrawerItem("beranda", "Beranda", "Halaman Depan", Icons.home),
    new DrawerItem("simpanan", "Rekening Simpanan",
        "Informasi Rekening Simpanan", FontAwesomeIcons.moneyBill),
    new DrawerItem("pinjaman", "Rekening Pinjaman",
        "Informasi Rekening Pinjaman", FontAwesomeIcons.moneyCheck),
    new DrawerItem("setoran", "Setoran Tunai", "Setoran tunai ke rekening anda",
        FontAwesomeIcons.moneyBillWave),
    new DrawerItem("riwayatsetoran", "Riwayat Setoran",
        "Riwayat Setoran tunai ke rekening anda", FontAwesomeIcons.history),
    new DrawerItem("spbu", "Transaksi SPBU", "Klaim Transaksi SPBU Tunai",
        FontAwesomeIcons.gasPump),
    new DrawerItem("riwayatspbu", "Riwayat Transaksi SPBU",
        "Riwayat klaim transaksi SPBU Tunai", FontAwesomeIcons.history),
    new DrawerItem("voucher", "Voucher", "Kupon & Voucher Elektronik",
        FontAwesomeIcons.creditCard),
    // new DrawerItem("Simulasi Simpanan", "Simulasi rate simpanan sukarela",
    //     FontAwesomeIcons.calculator),
    new DrawerItem("infolain", "Informasi Produk & Jasa Lainnya",
        "Layanan K3PG lainnya", FontAwesomeIcons.productHunt),
    new DrawerItem("bantuan", "Bantuan", "Bantuan penggunaan aplikasi",
        FontAwesomeIcons.book),
    new DrawerItem("administrasi", "Administrasi",
        "Profil , Pengaturan, dan lain - lain", FontAwesomeIcons.cogs),
    new DrawerItem("homepage", "Homepage K3PG", "Halaman website K3PG",
        FontAwesomeIcons.chrome),
    new DrawerItem("tentang", "Tentang aplikasi",
        "Versi Aplikasi, Term and Condition", FontAwesomeIcons.infoCircle),
    new DrawerItem("keluar", "Keluar", "Log out dan keluar aplikasi",
        FontAwesomeIcons.signOutAlt),
  ];
  // final drawerItems = [
  //   new DrawerItem("beranda", "Beranda", "Halaman Depan", Icons.home),
  //   new DrawerItem("administrasi", "Administrasi",
  //       "Profil , Pengaturan, dan lain - lain", FontAwesomeIcons.cogs),
  //   new DrawerItem("homepage", "Homepage K3PG", "Halaman website K3PG",
  //       FontAwesomeIcons.chrome),
  //   new DrawerItem("tentang", "Tentang aplikasi",
  //       "Versi Aplikasi, Term and Condition", FontAwesomeIcons.infoCircle),
  //   new DrawerItem("keluar", "Keluar", "Log out dan keluar aplikasi",
  //       FontAwesomeIcons.signOutAlt),
  // ];
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String tokens;
  String appBarTitle;
  String username = "";
  String email = "";
  String photo;
  bool isData = false;
  SharedPreferences sharedPreferences;
  Map<String, String> get headers => {
        'Authorization': 'Bearer $tokens',
        'Content-Type': 'application/json',
      };
  ProfileModel profile;
  bool tokenReady;

  void persist(String value) {
    // setState(() {
    // });

    tokens = value;
    sharedPreferences?.setString('LastToken', value);
  }

  Future<void> getData() async {
    //get token
    SharedPreferences.getInstance().then((SharedPreferences sp) async {
      sharedPreferences = sp;
      tokens = sharedPreferences.getString('LastToken');
      debugPrint('Last Token: ' + tokens);
      // will be null if never previously saved
      if (["", null, false, 0].contains(tokens)) {
        tokens = "";
        persist(tokens); // set an initial value
      } else {
        if (tokens != "") {
          String url = APIConstant.urlBase + APIConstant.serverApi + "profile";

          // debugPrint(url);

          final response = await executeRequest(url);
          //  http.get(Uri.parse(url), headers: headers);

          if (response.statusCode == 200) {
            // If the call to the server was successful, parse the JSON.
            profile = new ProfileModel.fromJson(json.decode(response.body));
            username = profile.nmAng;
            email = profile.email;
            photo = profile.pathFoto;
            isData = true;

            if (mounted) {
              setState(() {});
            }
          } else if (response.statusCode == 401) {
            if (mounted) {
              Navigator.of(context).pushReplacementNamed('/LoginScreen');
            }
          } else {
            print(
                'Something went wrosdng. \nResponse Code : ${response.statusCode}');
          }
        }
      }
    });
  }

  int _selectedDrawerIndex = 0;
  String callback = "";

  _getAppBar(int post) {
    String title = "";

    if (appBarTitle != null && appBarTitle != "") {
      title = "K3PG - " + appBarTitle;
    } else {
      title = "K3PG - " + widget.drawerItems[post].title;
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
    // setState(() => _selectedDrawerIndex = index);
    if (index == 12) {
      // _launchURL();
    }

    if (index == 11) {
      _launchURL();
      // } else if (index == 11) {
      //   _aboutApps();
    }

    setState(() {
      _selectedDrawerIndex = index;

      // if (index == 11) {
      //   _launchURL();
      //   // } else if (index == 11) {
      //   //   _aboutApps();
      // } else {
      //   _selectedDrawerIndex = index;
      // }
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

    Timer(Duration(seconds: 3), () {
      this.getData();
      _saveCurrentRoute("/HomeScreen");
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildChild(int position) {
    String key = widget.drawerItems[position].key;
    String mode = callback == "" ? key : callback;
    callback = "";
    appBarTitle = "";
    switch (mode) {
      //home
      case "beranda":
        return new HomeFragment(onMenuSelect: (String menu) {
          print(menu);
          switch (menu) {
            case "ratesimpanan":
              appBarTitle = "Rate Simpanan";
              break;
            case "ratepinjaman":
              appBarTitle = "Rate Pinjaman";
              break;
            case "administrasi":
              appBarTitle = "Administrasi";
              break;
            case "produkjasa":
              appBarTitle = "Pembayaran Kredit";
              break;
            case "bantuan":
              appBarTitle = "Bantuan";
              break;
            default:
          }
          if (menu != null) {
            setState(() {
              callback = menu;
            });
          }
        });
        break;
      //rekeningku simpanan
      case "simpanan":
        return new SimpananFragment();
      //rekeningku pinjaman
      case "pinjaman":
        return new PinjamanFragment();
      //setoran
      case "setoran":
        return new FragmentSetoran();
      //riwayat setoran
      case "riwayatsetoran":
        return new FragmentListSetoran();
      //form klaim spbu
      case "spbu":
        return new TabEntriNotaSPBU();
      // return new EntrySPBUScreen();
      //riwayat klaim spbu
      case "riwayatspbu":
        return new RiwayatSPBU();
      //bantuan
      case "bantuan":
        return new BantuanFragment();
      //Administrasi
      case "administrasi":
        return new AdministrasiFragment();
        // requestLogoutAPI(context);
        // Navigator.of(context).pushReplacementNamed('/LoginScreen');
        break;
      case "tentang":
        return new TentangFragment();
      case "ratesimpanan":
        return new RateSimpananFragment();
      // return new RateSimpananTableFragment();
      case "ratepinjaman":
        return new RatePinjamanFragment();
      case "produkjasa":
        return new PembayaranKreditFragment();
      case "voucher":
        return new VoucherFragment();
      default:
        return new SimulasiFragment();
    }
  }

  _launchURL() async {
    const url = 'https://k3pg.co.id/';
    try {
      await launch(url);
    } catch (e) {
      throw 'Could not launch $url: $e';
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

    List<int> divide = [0, 2, 4, 6, 7, 9];
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
                    !isData
                        ? new Center(
                            child: Center(
                            child: SizedBox(
                                width: 40.0,
                                height: 40.0,
                                child: const CircularProgressIndicator()),
                          ))
                        : new UserAccountsDrawerHeader(
                            accountName: new Text(username),
                            accountEmail: new Text(email),
                            currentAccountPicture: new CircleAvatar(
                              backgroundImage: new NetworkImage(photo),
                            ),
                            decoration: new BoxDecoration(
                                image: new DecorationImage(
                                    image:
                                        new AssetImage("assets/img/header.jpg"),
                                    fit: BoxFit.cover)),
                          ),
                    ...drawerOptions
                  ],
                ),
              ),
            ),
          ),
          backgroundColor: Colors.white,
          body: _buildChild(_selectedDrawerIndex),
        ),
      ),
      onWillPop: _onWillPop,
    );
  }
}
