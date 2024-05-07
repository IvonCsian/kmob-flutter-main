import 'package:flutter/material.dart';
import 'package:kmob/ui/fragment/Rekening/TabSimpananSukarela1.dart';
import 'package:kmob/ui/fragment/Rekening/TabSimpananSukarela2.dart';
import 'package:kmob/utils/constant.dart';
class SimpananFragment extends StatefulWidget {
  @override
  _SimpananFragmentState createState() => _SimpananFragmentState();
}

class _SimpananFragmentState extends State<SimpananFragment> with SingleTickerProviderStateMixin {
  TabController controller;
@override
  void initState() {
    controller = new TabController(vsync:this,length:4);
    super.initState();
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Sukarela 1'),
    Tab(text: 'Sukarela 2'),
    // Tab(text: 'Syariah'),
  ];

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
          new TabSimpananSukarela1(),
          new TabSimpananSukarela2(),
        ],
        ),
      ),
    );
  }
}
