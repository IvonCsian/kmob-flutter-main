import 'package:flutter/material.dart';
import 'package:kmob/ui/fragment/ListSetoran/TabListSetoranSukarela1Screen.dart';
import 'package:kmob/ui/fragment/ListSetoran/TabListSetoranSukarela2Screen.dart';
import 'package:kmob/utils/constant.dart';

class FragmentListSetoran extends StatefulWidget {
  @override
  _FragmentListSetoranState createState() => _FragmentListSetoranState();
}

class _FragmentListSetoranState extends State<FragmentListSetoran>
    with SingleTickerProviderStateMixin {
  TabController controller;
  @override
  void initState() {
    controller = new TabController(vsync: this, length: 4);
    super.initState();
  }

  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Riwayat Setoran Sukarela 1'),
    Tab(text: 'Riwayat Setoran Sukarela 2'),
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
            new TabListSetoranSukarela1Screen(),
            new TabListSetoranSukarela2Screen(),
          ],
        ),
      ),
    );
  }
}
