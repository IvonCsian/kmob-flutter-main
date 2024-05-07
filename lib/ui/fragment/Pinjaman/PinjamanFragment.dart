import 'package:flutter/material.dart';
import 'package:kmob/ui/fragment/Pinjaman/TabPinjamanKKB.dart';
import 'package:kmob/ui/fragment/Pinjaman/TabPinjamanReguler.dart';
import 'package:kmob/utils/constant.dart';

class PinjamanFragment extends StatefulWidget {
  @override
  _PinjamanFragmentState createState() => _PinjamanFragmentState();
}

class _PinjamanFragmentState extends State<PinjamanFragment> {
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Reguler'),
    Tab(text: 'KKB'),
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
              tabs: myTabs,
            ),
          ),
        ),
        body: TabBarView(
          children: <Widget>[
          new TabPinjamanReguler(),
          new TabPinjamanKKB(),

        ],
        ),
      ),
    );
  }
}
