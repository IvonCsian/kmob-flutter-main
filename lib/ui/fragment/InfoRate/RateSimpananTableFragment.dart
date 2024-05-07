import 'dart:convert';

import 'package:flutter/material.dart';

class RateSimpananTableFragment extends StatefulWidget {
  @override
  _RateSimpananTableFragmentState createState() =>
      _RateSimpananTableFragmentState();
}

class _RateSimpananTableFragmentState extends State<RateSimpananTableFragment> {
  @override
  Widget build(BuildContext context) {
    return Container();
    // var json = jsonDecode(jsonSample);
    //  return Container(
    //     child: new ListView(
    //   physics: ClampingScrollPhysics(),
    //   children: <Widget>[
    //     new Container(
    //     padding: EdgeInsets.all(16.0),
    //     child: Column(
    //             children: [
    //               JsonTable(
    //                 json,
    //                 showColumnToggle: true,
    //                 tableHeaderBuilder: (String header) {
    //                   return Container(
    //                     padding: EdgeInsets.symmetric(
    //                         horizontal: 8.0, vertical: 4.0),
    //                     decoration: BoxDecoration(
    //                         border: Border.all(width: 0.5),
    //                         color: Colors.grey[300]),
    //                     child: Text(
    //                       header,
    //                       textAlign: TextAlign.center,
    //                       style: Theme.of(context).textTheme.display1.copyWith(
    //                           fontWeight: FontWeight.w700,
    //                           fontSize: 14.0,
    //                           color: Colors.black87),
    //                     ),
    //                   );
    //                 },
    //                 tableCellBuilder: (value) {
    //                   return Container(
    //                     padding: EdgeInsets.symmetric(
    //                         horizontal: 4.0, vertical: 2.0),
    //                     decoration: BoxDecoration(
    //                         border: Border.all(
    //                             width: 0.5,
    //                             color: Colors.grey.withOpacity(0.5))),
    //                     child: Text(
    //                       value,
    //                       textAlign: TextAlign.center,
    //                       style: Theme.of(context).textTheme.display1.copyWith(
    //                           fontSize: 14.0, color: Colors.grey[900]),
    //                     ),
    //                   );
    //                 },
    //                 allowRowHighlight: true,
    //                 rowHighlightColor: Colors.yellow[500].withOpacity(0.7),
    //                 paginationRowCount: 4,
    //               ),
    //               SizedBox(
    //                 height: 40.0,
    //               ),
    //               Text("Simple table which creates table direclty from json")
    //             ],
    //           )
    //   ),
    //   ],
    // ));
  }

  String getPrettyJSONString(jsonObject) {
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    String jsonString = encoder.convert(json.decode(jsonObject));
    return jsonString;
  }
}
