class SetoranModel {
  final String id;
  final String tanggal;
  final String bank;
  final String rekening;
  final String nama;
  final double nominal;
  final String bukti;
  final String status;
  final String jangka;
  final String kodeStatus;
  final String keterangan;

  SetoranModel(
      {this.tanggal,
      this.id,
      this.bank,
      this.rekening,
      this.nama,
      this.nominal,
      this.bukti,
      this.keterangan,
      this.jangka,this.kodeStatus,
      this.status});
  factory SetoranModel.fromJson(Map<String, dynamic> json) {
    return SetoranModel(
      id: json['id'] == null ? '' : json['id'],
      tanggal: json['tanggal'] == null ? '' : json['tanggal'],
      bank: json['bank'] == null ? '' : json['bank'],
      rekening: json['rekening'] == null ? '' : json['rekening'],
      nominal: json['nominal'] == null ? 0 : double.parse(json['nominal']),
      bukti: json['bukti'] == null ? '' : json['bukti'],
      status: json['status'] == null ? '' : json['status'],
      jangka: json['jangka'] == null ? '' : json['jangka'],
      kodeStatus: json['kode_status'] == null ? '' : json['kode_status'],
      keterangan: json['keterangan'] == null ? '' : json['keterangan'],
    );
  }
}
