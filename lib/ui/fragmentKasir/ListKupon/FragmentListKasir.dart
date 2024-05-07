import 'package:flutter/material.dart';
import 'package:kmob/utils/constant.dart';

import 'TabListRiwayatVoucherScreen.dart';
import 'TabRiwayatKuponScreen.dart';

class ListKuponScreen extends StatefulWidget {
  @override
  _ListKuponScreenState createState() => _ListKuponScreenState();
}

class _ListKuponScreenState extends State<ListKuponScreen>
    with SingleTickerProviderStateMixin {
  TabController controller;
  @override
  void initState() {
    controller = new TabController(vsync: this, length: 4);
    super.initState();
  }

  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Riwayat Voucher'),
    Tab(
      text: 'Riwayat Kupon',
    )
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
            new TabListRiwayatVoucherScreen(),
            new TabRiwayatKuponScreen(),
          ],
        ),
      ),
    );
  }
}
