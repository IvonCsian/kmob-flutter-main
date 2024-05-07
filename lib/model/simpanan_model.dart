class SimpananAngModel {
  final String noSimpan;
  final String tglSimpan;
  final int noAng;
  final String noPeg;
  final String nmAng;
  final String nmPrsh;
  final String nmJnsSimpanan;
  final String nmJnsTransaksi;
  final String kreditDebet;
  final String plus;
  final double saldo;
  final double jumlah;
  final String updatedOn;

  SimpananAngModel(
      {this.noSimpan,
      this.plus,
      this.tglSimpan,
      this.noAng,
      this.noPeg,
      this.saldo,
      this.nmAng,
      this.nmPrsh,
      this.nmJnsSimpanan,
      this.nmJnsTransaksi,
      this.kreditDebet,
      this.jumlah,
      this.updatedOn});

  factory SimpananAngModel.fromJson(Map<String, dynamic> json) {
    return SimpananAngModel(
        noSimpan: json['no_simpan'] == null ? '' : json['no_simpan'],
        tglSimpan: json['tgl_simpan'] == null ? '' : json['tgl_simpan'],
        noAng: json['no_ang'] == null ? 0 : int.parse(json['no_ang']),
        noPeg: json['no_peg'] == null ? '' : json['no_peg'],
        nmAng: json['nm_ang'] == null ? '' : json['nm_ang'],
        nmPrsh: json['nm_prsh'] == null ? '' : json['nm_prsh'],
        nmJnsSimpanan:
            json['nm_jns_simpanan'] == null ? '' : json['nm_jns_simpanan'],
        nmJnsTransaksi:
            json['nm_jns_transaksi'] == null ? '' : json['nm_jns_transaksi'],
        kreditDebet: json['kredit_debet'] == null ? '' : json['kredit_debet'],
        plus: json['kredit_debet'] == null
            ? ''
            : json['kredit_debet'] == 'K' ? '+' : '-',
        jumlah: json['jumlah'] == null ? 0 : double.parse(json['jumlah']),
        saldo: json['saldo'] == null ? 0 : double.parse(json['saldo']),
        updatedOn: json['tgl_update'] == null ? '' : json['tgl_update']);
  }
}

class Simpanan2Model {
  final int id;
  final String noSs2;
  final int noAng;
  final String noSimpan;
  final String tglSimpan;
  final double jmlSimpanan;
  final int tempoBln;
  final double margin;
  final double jmlMargin;
  final String tglJt;
  final String status;
  final String tglUpdate;
  final double jmlDebet;
  final double jmlDenda;

  Simpanan2Model(
      {this.id,
      this.jmlDebet,
      this.jmlDenda,
      this.noSs2,
      this.noAng,
      this.noSimpan,
      this.tglSimpan,
      this.jmlSimpanan,
      this.tempoBln,
      this.margin,
      this.jmlMargin,
      this.tglJt,
      this.status,
      this.tglUpdate});

  factory Simpanan2Model.fromJson(Map<String, dynamic> json) {
    return Simpanan2Model(
        id: json['id'] == null ? '' : int.parse(json['id']),
        noSs2: json['no_ss2'] == null ? '' : json['no_ss2'],
        noAng: json['no_ang'] == null ? 0 : int.parse(json['no_ang']),
        noSimpan: json['no_simpan'] == null ? '' : json['no_simpan'],
        tglSimpan: json['tgl_simpan'] == null ? '' : json['tgl_simpan'],
        jmlSimpanan: json['jml_simpanan'] == null
            ? 0
            : double.parse(json['jml_simpanan']),
        jmlDebet:
            json['jml_debet'] == null ? 0 : double.parse(json['jml_debet']),
        jmlDenda:
            json['jml_denda'] == null ? 0 : double.parse(json['jml_denda']),
        tempoBln: json['tempo_bln'] == null ? 0 : int.parse(json['tempo_bln']),
        margin: json['margin'] == null ? 0 : double.parse(json['margin']),
        jmlMargin:
            json['jml_margin'] == null ? 0 : double.parse(json['jml_margin']),
        tglJt: json['tgl_jt'] == null ? '' : json['tgl_jt'],
        status: json['status'] == null ? '' : json['status'],
        tglUpdate: json['tgl_update'] == null ? '' : json['tgl_update']);
  }
}
