import 'package:flutter/material.dart';
import 'package:kmob/ui/fragment/Voucher/TabListVoucher1Screen.dart';
import 'package:kmob/utils/constant.dart';

import 'TabKlaimKuponScreen.dart';

class SetoranNavigasi {
  String title;
  String subtitle;
  String mode;

  SetoranNavigasi(String s, String t, String mode) {
    this.title = s;
    this.subtitle = t;
    this.mode = mode;
  }
}

class VoucherFragment extends StatefulWidget {
  @override
  _VoucherFragmentState createState() => _VoucherFragmentState();
}

class _VoucherFragmentState extends State<VoucherFragment>
    with SingleTickerProviderStateMixin {
  TabController controller;
  @override
  void initState() {
    controller = new TabController(vsync: this, length: 4);
    super.initState();
  }

  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Daftar Voucher'),
    Tab(text: 'Klaim Kupon'),
  ];
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        backgroundColor: Colors.white54,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: AppBar(
            backgroundColor: ColorPalette.warnaCorporate,
            bottom: TabBar(
              labelStyle: TextStyle(
                  color: Colors.white, fontSize: 14.0, fontFamily: "WorkSans"),
              tabs: myTabs,
            ),
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            new TabListVoucher1Screen(),
            new TabKlaimKuponScreen(),
          ],
        ),
      ),
    );
  }
}
