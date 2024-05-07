class PinjamanModel {
  final String noPinjam;
  final String tglPinjam;
  final double jmlPinjam;
  final int tempoBln;
  final double margin;
  final double jmlmargin;
  final double angsuran;
  final double jmlBiayaAdmin;
  final String nmPinjaman;
  final String stsLunas;
  final String blthLunas;

  PinjamanModel(
      {this.noPinjam,
      this.nmPinjaman,
      this.stsLunas,
      this.blthLunas,
      this.tglPinjam,
      this.jmlPinjam,
      this.tempoBln,
      this.jmlmargin,
      this.jmlBiayaAdmin,
      this.margin,
      this.angsuran});

  factory PinjamanModel.fromJson(Map<String, dynamic> json) {
    return PinjamanModel(
      noPinjam: json['no_pinjam'] == null ? '' : json['no_pinjam'],
      tglPinjam: json['tgl_pinjam'] == null ? '' : json['tgl_pinjam'],
      stsLunas: json['sts_lunas'] == null ? '' : json['sts_lunas']=="0"?"Belum Lunas":"Lunas",
      blthLunas: json['blth_lunas'] == null ? '' : json['blth_lunas'],
      nmPinjaman: json['tgl_pinjam'] == null ? '' : json['nm_pinjaman'],
      jmlPinjam:
          json['jml_pinjam'] == null ? '' : double.parse(json['jml_pinjam']),
      tempoBln: json['tempo_bln'] == null ? '' : int.parse(json['tempo_bln']),
      margin: json['margin'] == null ? '' : double.parse(json['margin']),
      angsuran: json['angsuran'] == null ? '' : double.parse(json['angsuran']),
      jmlmargin:
          json['jml_margin'] == null ? '' : double.parse(json['jml_margin']),
      jmlBiayaAdmin: json['jml_biaya_admin'] == null
          ? ''
          : double.parse(json['jml_biaya_admin']),
    );
  }
}
