class TransaksiModel {
  final String fcode;
  final String flokasi;
  final String fcustkey;
  final String fcustname;
  final double fgrandtotal;
  final String fdate;
  final String ftime;
  final double pointkmob;

  TransaksiModel({
    this.fcode,
    this.flokasi,
    this.fcustkey,
    this.fcustname,
    this.fgrandtotal,
    this.fdate,
    this.ftime,
    this.pointkmob,
  });

  factory TransaksiModel.fromJson(Map<String, dynamic> json) {
    return TransaksiModel(
      fcode: json['fcode'] == null ? '' : json['fcode'],
      flokasi: json['flokasi'] == null ? '' : json['flokasi'],
      fcustkey: json['fcustkey'] == null ? '' : json['fcustkey'],
      fcustname: json['fcustname'] == null ? '' : json['fcustname'],
      fgrandtotal:
          json['fgrand_total'] == null ? 0 : double.parse(json['fgrand_total']),
      pointkmob:
          json['pointkmob'] == null ? 0 : double.parse(json['pointkmob']),
      fdate: json['fdate'] == null ? '' : json['fdate'],
      ftime: json['ftime'] == null ? '' : json['ftime'],
    );
  }
}
