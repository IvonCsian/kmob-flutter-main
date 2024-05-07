import 'package:flutter/material.dart';
import 'package:kmob/ui/fragmentKasir/kupon/TabKlaimKuponKasirScreen.dart';
import 'package:kmob/ui/fragmentKasir/kupon/TabListVoucherRedeemScreen.dart';
import 'package:kmob/utils/constant.dart';

class KuponScreen extends StatefulWidget {
  @override
  _KuponScreenState createState() => _KuponScreenState();
}

class _KuponScreenState extends State<KuponScreen>
    with SingleTickerProviderStateMixin {
  TabController controller;
  @override
  void initState() {
    controller = new TabController(vsync: this, length: 4);
    super.initState();
  }

  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Voucher'),
    Tab(
      text: 'Kupon',
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
            new TabListVoucherRedeemScreen(),
            new TabKlaimKuponKasirScreen(),
          ],
        ),
      ),
    );
  }
}
