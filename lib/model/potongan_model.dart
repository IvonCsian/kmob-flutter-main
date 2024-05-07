class PotonganModel {
  final String buktiPotga;
  final String tglPotga;
  final String nmPotga;
  final String nmPinjaman;
  final String noRefBukti;
  final int angsKe;
  final int tempoBln;
  final double jmlPokok;
  final int angsuran;
  final double jumlah;
  final String ket;
  final double saldoAkhir;

  PotonganModel(
      {this.buktiPotga,
      this.tglPotga,
      this.nmPotga,
      this.nmPinjaman,
      this.noRefBukti,
      this.angsKe,
      this.tempoBln,
      this.jmlPokok,
      this.angsuran,
      this.jumlah,
      this.ket,
      this.saldoAkhir});
  factory PotonganModel.fromJson(Map<String, dynamic> json) {
    return PotonganModel(
      buktiPotga: json['bukti_potga'] == null ? '' : json['bukti_potga'],
      tglPotga: json['tgl_potga'] == null ? '' : json['tgl_potga'],
      nmPotga: json['nm_potga'] == null ? '' : json['nm_potga'],
      nmPinjaman: json['nm_pinjaman'] == null ? '' : json['nm_pinjaman'],
      noRefBukti: json['no_ref_bukti'] == null ? '' : json['no_ref_bukti'],
      angsKe: json['angs_ke'] == null ? '' : int.parse(json['angs_ke']),
      tempoBln: json['tempo_bln'] == null ? '' : int.parse(json['tempo_bln']),
      jmlPokok:
          json['jml_pokok'] == null ? '' : double.parse(json['jml_pokok']),
      angsuran: json['angsuran'] == null ? '' : int.parse(json['angsuran']),
      jumlah: json['jumlah'] == null ? '' : double.parse(json['jumlah']),
      ket: json['ket'] == null ? '' : json['ket'],
      saldoAkhir:
          json['saldo_akhir'] == null ? '' : double.parse(json['saldo_akhir']),
    );
  }
}
