import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kmob/common/functions/future.dart';
import 'package:kmob/common/widgets/MyAppBar.dart';
import 'package:kmob/model/voucher_model.dart';
import 'package:kmob/utils/constant.dart';

class TabListVoucher1Screen extends StatefulWidget {
  @override
  _TabListVoucher1ScreenState createState() => _TabListVoucher1ScreenState();
}

class _TabListVoucher1ScreenState extends State<TabListVoucher1Screen> {
  String tokens;
  String saldo = "";
  String tglUpdate = "";
  int limit = 10;
  int count = 0;
  String _selectedStatus = "";
  Map<String, dynamic> _voucherData;

  // Data statis
  List<dynamic> dropdownItems = [];

  bool loading = true;

  @override
  initState() {
    // TODO: implement initState
    super.initState();

    // _futureData = getDataVoucher1(context, limit: limit);

    initAsyncData();

    // if (mounted) {
    setState(() {});
    // }
  }

  initAsyncData() async {
    var asyncData0 =
        await getDataVoucher1(context, limit: limit, id_status: '');

    _voucherData = json.decode(asyncData0);

    count = _voucherData['count'];

    var asyncData1 = await getVoucherStatus(context);

    var decodedData1 = json.decode(asyncData1.toString());

    debugPrint(decodedData1.toString());

    dropdownItems = decodedData1;

    loading = false;

    setState(() {});
  }

  getVoucher() async {
    setState(() {
      loading = true;
    });

    var asyncData0 = await getDataVoucher1(context,
        limit: limit, id_status: _selectedStatus);

    _voucherData = json.decode(asyncData0);

    count = _voucherData['count'];

    if (count < limit) {
      limit = count;
    }

    loading = false;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var listdeposito = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      // padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
      child: SingleChildScrollView(
        child: Column(
          // physics: scro,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text('Status: '),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedStatus,
                      onChanged: (String newValue) {
                        setState(() {
                          _selectedStatus = newValue;
                        });
                      },
                      items: [
                        DropdownMenuItem(
                          child: Text('SEMUA'),
                          value: '',
                        ),
                        ...dropdownItems.map((item) {
                          return DropdownMenuItem<String>(
                            value: item['id'],
                            child: Text(
                              item['status'],
                              style: TextStyle(overflow: TextOverflow.clip),
                              maxLines: 1,
                            ),
                          );
                        })
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      limit = 10;

                      getVoucher();
                    });
                  },
                  child: Text('Tampilkan')),
            ),
            if (loading) CircularProgressIndicator(),
            if (!loading && count < 1)
              Center(
                child: Text('Data Voucher Tidak Ditemukan'),
              ),
            if (!loading)
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  // scrollDirection: ,
                  itemCount: _voucherData['data'].length,
                  itemBuilder: (context, i) {
                    VoucherModel listVoucher =
                        VoucherModel.fromJson(_voucherData['data'][i]);

                    return rowDataVoucher1(
                        listVoucher, context, (i + 1).toString());
                  }),
            if (!loading)
              if (limit < count)
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        limit += 10;

                        getVoucher();
                      });
                    },
                    child: Text('Load more'),
                  ),
                ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );

    return APIConstant.mode == "PROD"
        ? listdeposito
        : SizedBox(
            height: 10,
          );
  }
}
