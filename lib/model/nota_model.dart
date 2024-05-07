import 'package:charts_flutter/flutter.dart' as charts;

class KreditModel {
  final String id;
  final String noAng;
  final double nominal;
  final String cicilan;
  final String notransaksi;
  final String useddate;
  final String username;
  final String firstName;
  final String lastName;

  KreditModel(
      {this.id,
      this.noAng,
      this.nominal,
      this.cicilan,
      this.notransaksi,
      this.useddate,
      this.username,
      this.firstName,
      this.lastName});

  factory KreditModel.fromJson(Map<String, dynamic> json) {
    return KreditModel(
      id: json['id'] == null ? '' : json['id'],
      noAng: json['no_ang'] == null ? '' : json['no_ang'],
      nominal: json['nominal'] == null ? 0 : double.parse(json['nominal']),
      cicilan: json['cicilan'] == null ? '' : json['cicilan'],
      notransaksi: json['notransaksi'] == null ? '' : json['notransaksi'],
      useddate: json['useddate'] == null ? '' : json['useddate'],
      username: json['username'] == null ? '' : json['username'],
      firstName: json['first_name'] == null ? '' : json['first_name'],
      lastName: json['lastName'] == null ? '' : json['lastName'],
    );
  }
}

class NotaModel {
  final String id;
  final String noAng;
  final String tanggal;
  final String noNota;
  final double nominal;
  final String bukti;
  final String status;
  final String keterangan;
  final String updatedon;
  final String periodeKlaim;
  final String kodeStatus;

  NotaModel(
      {this.id,
      this.noAng,
      this.tanggal,
      this.noNota,
      this.nominal,
      this.bukti,
      this.status,
      this.keterangan,
      this.updatedon,
      this.periodeKlaim,
      this.kodeStatus});
  factory NotaModel.fromJson(Map<String, dynamic> json) {
    return NotaModel(
      id: json['id'] == null ? '' : json['id'],
      noAng: json['no_ang'] == null ? '' : json['no_ang'],
      tanggal: json['tanggal'] == null ? '' : json['tanggal'],
      noNota: json['no_nota'] == null ? '' : json['no_nota'],
      nominal: json['nominal'] == null ? 0 : double.parse(json['nominal']),
      bukti: json['bukti'] == null ? '' : json['bukti'],
      status: json['status'] == null ? '' : json['status'],
      keterangan: json['keterangan'] == null ? '' : json['keterangan'],
      updatedon: json['updatedon'] == null ? '' : json['updatedon'],
      periodeKlaim: json['periode_klaim'] == null ? '' : json['periode_klaim'],
      kodeStatus: json['kode_status'] == null ? '' : json['kode_status'],
    );
  }
}

class NotaChartModel {
  final String id;
  final String kodeStatus;
  final String status;
  final double qty;
  final charts.Color color;

  NotaChartModel({this.id, this.kodeStatus, this.status, this.qty, this.color});
  factory NotaChartModel.fromJson(Map<String, dynamic> json) {
    return NotaChartModel(
        id: json['id'] == null ? '' : json['id'],
        kodeStatus: json['kode_status'] == null ? '' : json['kode_status'],
        status: json['status'] == null ? '' : json['status'],
        color: json['kode_status'] == null
            ? charts.MaterialPalette.blue.shadeDefault
            : json['kode_status'] == 'submit'
                ? charts.MaterialPalette.yellow.shadeDefault
                : json['kode_status'] == 'proses'
                    ? charts.MaterialPalette.yellow.shadeDefault
                    : json['kode_status'] == 'manual'
                        ? charts.MaterialPalette.yellow.shadeDefault
                        : json['kode_status'] == 'Terverifikasi'
                            ? charts.MaterialPalette.green.shadeDefault
                            : json['kode_status'] == 'Decline'
                                ? charts.MaterialPalette.red.shadeDefault
                                : charts.MaterialPalette.green.shadeDefault,
        qty: json['qty'] == null ? 0 : double.parse(json['qty']));
  }
}
