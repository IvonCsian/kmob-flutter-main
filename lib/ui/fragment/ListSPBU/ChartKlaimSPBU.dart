import 'dart:convert';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kmob/common/functions/format.dart';
import 'package:kmob/model/nota_model.dart';
import 'package:kmob/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

/// Sample linear data type.
class LinearSales {
  final String status;
  final int sales;

  LinearSales(this.status, this.sales);
}

class ChartKlaimSPBU extends StatefulWidget {
  @override
  _ChartKlaimSPBUState createState() => _ChartKlaimSPBUState();
}

class _ChartKlaimSPBUState extends State<ChartKlaimSPBU> {
  List<NotaChartModel> dataChart = [];
  String tokens;
  List<charts.Series> seriesList;

  String tanggalString = "*belum dipilih";
  String tanggal = "";
  DateTime dates;

  String tanggalStringEnd = "*belum dipilih";
  String tanggalEnd = "";
  DateTime datesEnd;

  bool animate;

  bool isFilter = false;
  bool isLoading = false;

  String url = "";

  Map<String, String> get headers => {
        'Authorization': 'Bearer $tokens',
        'Content-Type': 'application/json',
      };

  Future<void> fetchChart() async {
    final prefs = await SharedPreferences.getInstance();
    tokens = prefs.getString('LastToken') ?? '';

    url = APIConstant.urlBase + APIConstant.serverApi + "nota/chart1?var=test";

    debugPrint(url);

    if (tanggal != "" && tanggal != null) {
      url += "&tgl_awal=${tanggal}";
    }

    if (tanggalEnd != "" && tanggalEnd != null) {
      url += "&tgl_akhir=${tanggalEnd}";
    }

    debugPrint(url);

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      debugPrint(data.toString());

      var rest = data as List;
      dataChart = rest
          .map<NotaChartModel>((json) => NotaChartModel.fromJson(json))
          .toList();
      setState(() {
        seriesList = _createSampleData();

        // showingSections(dataChart);
        // buildRow(dataChart);
      });
    } else if (response.statusCode == 401) {
      Navigator.of(context).pushReplacementNamed('/LoginScreen');
    }

    // return dataChart;
  }

  /// Create one series with sample hard coded data.
  List<charts.Series<NotaChartModel, String>> _createSampleData() {
    return [
      charts.Series<NotaChartModel, String>(
        id: 'Sales',
        domainFn: (NotaChartModel sales, _) => sales.status,
        measureFn: (NotaChartModel sales, _) => sales.qty,
        colorFn: (NotaChartModel sales, _) => sales.color,
        data: dataChart,
        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: (NotaChartModel row, _) =>
            '${row.status}: ${formatCurrency(row.qty)}',
      )
    ];
  }

  @override
  void initState() {
    super.initState();

    this.fetchChart();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // A Separate Function called from itemBuilder
  Widget buildBody(BuildContext ctxt, int index) {
    return Text(
        dataChart[index].status + " : " + formatCurrency(dataChart[index].qty));
  }

  Widget getTextWidgets(List<NotaChartModel> item) {
    // List<Widget> list = List<Widget>();
    List<Widget> list = [];

    for (var i = 0; i < item.length; i++) {
      list.add(
          Text(dataChart[i].status + " : " + formatCurrency(dataChart[i].qty)));
    }
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: list);
  }

  @override
  Widget build(BuildContext context) {
    animate = false;

    return seriesList == null
        ? Container()
        : isLoading
            ? tampilanLoading()
            : Stack(
                children: [
                  SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Column(
                      children: <Widget>[
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: <Widget>[
                        //     InkWell(
                        //       onTap: () {
                        //         tampilkanModalBottom(context);
                        //       },
                        //       child: Column(
                        //         children: <Widget>[
                        //           Container(
                        //             child: Icon(
                        //               FontAwesomeIcons.filter,
                        //               color: Colors.blue,
                        //               size: 18.0,
                        //             ),
                        //           ),
                        //           Padding(
                        //             padding: EdgeInsets.only(top: 6.0),
                        //           ),
                        //           Center(
                        //             child: Text(
                        //               "Filter",
                        //               style: TextStyle(
                        //                   fontSize: 12.0,
                        //                   color: Colors.blue,
                        //                   fontFamily: "WorkSansBold"),
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height:
                              MediaQuery.of(context).size.height / 2 >= 400.0
                                  ? MediaQuery.of(context).size.height / 2
                                  : 400.0,
                          child: charts.PieChart(seriesList,
                              animate: animate,
                              behaviors: [],
                              // [
                              //   charts.InitialSelection(
                              //     selectedDataConfig: [
                              //       charts.SeriesDatumConfig('Sales', 0),
                              //     ],
                              //   ),
                              //   charts.DatumLegend(
                              //     // Positions for "start" and "end" will be left and right respectively
                              //     // for widgets with a build context that has directionality ltr.
                              //     // For rtl, "start" and "end" will be right and left respectively.
                              //     // Since this example has directionality of ltr, the legend is
                              //     // positioned on the right side of the chart.
                              //     position: charts.BehaviorPosition.bottom,
                              //     // By default, if the position of the chart is on the left or right of
                              //     // the chart, [horizontalFirst] is set to false. This means that the
                              //     // legend entries will grow as rows first instead of a column.
                              //     horizontalFirst: false,
                              //     // This defines the padding around each legend entry.
                              //     cellPadding:
                              //         EdgeInsets.only(right: 4.0, bottom: 4.0),

                              //     // Configure the measure value to be shown by default in the legend.
                              //     legendDefaultMeasure:
                              //         charts.LegendDefaultMeasure.firstValue,
                              //   ),
                              // ],
                              defaultRenderer: charts.ArcRendererConfig(
                                  arcWidth: 150,
                                  arcRendererDecorators: [
                                    charts.ArcLabelDecorator()
                                  ])),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        isFilter
                            ? Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Periode: ' +
                                          tanggalString +
                                          " - " +
                                          tanggalStringEnd),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  )
                                ],
                              )
                            : SizedBox(
                                height: 0,
                              ),
                        Container(
                            // padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                            color: Colors.white,
                            child: getTextWidgets(dataChart)),
                        SizedBox(
                          height: 100,
                        )
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                tampilkanModalBottom(context);
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    FontAwesomeIcons.filter,
                                    color: Colors.white,
                                    size: 10.0,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text('Filter'),
                                ],
                              ),
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20))),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ],
              );
    // return Container(
    //     child: ListView(
    //   physics: ClampingScrollPhysics(),
    //   children: <Widget>[

    //   ],
    // ));
  }

  Widget tampilanLoading() => Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(
            height: 15,
          ),
          Text('Mohon Tunggu'),
        ],
      ));

  Future<Null> tampilkanModalBottom(BuildContext context) {
    return showModalBottomSheet<Null>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
          return SingleChildScrollView(
            child: Form(
                // key: _formKey,
                autovalidateMode: AutovalidateMode.always,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 8.0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 3.0),
                            child: Text(
                              "Filter Transaksi",
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                color: Colors.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w700,
                              ),
                            )),
                        Row(
                          children: <Widget>[
                            Icon(FontAwesomeIcons.calendar, color: Colors.blue),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text("Tanggal Awal : "),
                            Text("$tanggalString "),
                            SizedBox(
                              width: 50,
                              child: MaterialButton(
                                color: Colors.blue,
                                onPressed: () {
                                  DatePicker.showDatePicker(context,
                                      showTitleActions: true,
                                      maxTime: DateTime.now(),
                                      onConfirm: (date) {
                                    dates = date;
                                    tanggal = DateFormat("yyyy-MM-dd")
                                        .format(dates)
                                        .toString();

                                    debugPrint(tanggal.toString());

                                    setModalState(() {
                                      tanggalString = formatDateNew(
                                          date.toString(),
                                          format: "dd/mmm/yyyy");
                                    });
                                  },
                                      currentTime: DateTime.now(),
                                      locale: LocaleType.id);
                                },
                                child: Icon(FontAwesomeIcons.caretSquareDown,
                                    color: Colors.white),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Icon(FontAwesomeIcons.calendar, color: Colors.blue),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text("Tanggal Akhir : "),
                            Text("$tanggalStringEnd "),
                            SizedBox(
                              width: 50,
                              child: MaterialButton(
                                color: Colors.blue,
                                onPressed: () {
                                  DatePicker.showDatePicker(context,
                                      showTitleActions: true,
                                      maxTime: DateTime.now(),
                                      onConfirm: (date) {
                                    datesEnd = date;

                                    tanggalEnd = DateFormat("yyyy-MM-dd")
                                        .format(datesEnd)
                                        .toString();

                                    debugPrint(tanggalEnd);

                                    setModalState(() {
                                      tanggalStringEnd = formatDateNew(
                                          date.toString(),
                                          format: "dd/mmm/yyyy");
                                    });
                                  },
                                      currentTime: DateTime.now(),
                                      locale: LocaleType.id);
                                },
                                child: Icon(FontAwesomeIcons.caretSquareDown,
                                    color: Colors.white),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ElevatedButton(
                              onPressed: () {
                                tanggalString = "*belum dipilih";
                                tanggal = "";

                                dates = null;

                                tanggalStringEnd = "*belum dipilih";
                                tanggalEnd = "";

                                datesEnd = null;

                                isFilter = false;

                                setModalState(() {});

                                setState(() {});

                                fetchChart();
                              },
                              child: Text('Reset'),
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20))),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _validateInputs();
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    FontAwesomeIcons.filter,
                                    color: Colors.white,
                                    size: 10.0,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text('Filter'),
                                ],
                              ),
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20))),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  elevation: 2.0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                )),
          );
        });
      },
    );
  }

  _validateInputs() {
    debugPrint(tanggal.toString() + " " + tanggalEnd.toString());

    if (tanggal == "" ||
        tanggal == null ||
        tanggalEnd == "" ||
        tanggalEnd == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Validasi'),
          content: Text('Tanggal awal dan akhir harus diisi'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Ok'),
            ),
          ],
        ),
      );
    } else {
      isFilter = true;
      isLoading = true;

      if (mounted) {
        setState(() {});
      }

      fetchChart();

      Future.delayed(Duration(seconds: 1), () {
        isLoading = false;

        if (mounted) {
          setState(() {});
        }
      });
    }

    // if (_formKey.currentState.validate() &&
    //     !(["", null, false, 0].contains(tanggal)) &&
    //     !(["", null, false, 0].contains(tanggalEnd))) {
    //   _formKey.currentState.save();
    //   Navigator.of(context).pop();
    //   setState(() {});
    // } else {
    //   if ((["", null, false, 0].contains(tanggal))) {
    //     showDialog(
    //       context: context,
    //       builder: (context) => AlertDialog(
    //         title: Text('Validasi'),
    //         content: Text('Mohon isi tanggal Awal Transaksi'),
    //         actions: <Widget>[
    //           TextButton(
    //             onPressed: () => Navigator.of(context).pop(false),
    //             child: Text('Ok'),
    //           ),
    //         ],
    //       ),
    //     );
    //   }
    //   if ((["", null, false, 0].contains(tanggalEnd))) {
    //     showDialog(
    //       context: context,
    //       builder: (context) => AlertDialog(
    //         title: Text('Validasi'),
    //         content: Text('Mohon isi tanggal Akhir Transaksi'),
    //         actions: <Widget>[
    //           TextButton(
    //             onPressed: () => Navigator.of(context).pop(false),
    //             child: Text('Ok'),
    //           ),
    //         ],
    //       ),
    //     );
    //   }
    // }
  }
}
