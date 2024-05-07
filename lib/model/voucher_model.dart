class VoucherModel {
  final String kodeVoucher;
  final String nak;
  final int idTipe;
  final String batch;
  final String keterangan;
  final int splittable;
  final double nominal;
  final double nominalTerpakai;
  final String validFrom;
  final String validTo;
  final int idStatus;
  final String insertedDate;
  final String insertedFrom;
  final String insertedBy;
  final String tipe;
  final String voucherstatus;

  VoucherModel(
      {this.kodeVoucher,
      this.nak,
      this.idTipe,
      this.batch,
      this.keterangan,
      this.splittable,
      this.nominal,
      this.nominalTerpakai,
      this.validFrom,
      this.validTo,
      this.idStatus,
      this.insertedDate,
      this.insertedFrom,
      this.insertedBy,
      this.tipe,
      this.voucherstatus});

  factory VoucherModel.fromJson(Map<String, dynamic> json) {
    // check status
    // String temp = (json['status'] == null ? '' : json['status']);
    // String tempIdStatus = (json['id_status'] == null ? '0' : json['id_status']);

    // DateTime t = DateTime.parse(
    //     (json['valid_to'] == null ? '1900-01-01 00:00:00' : json['valid_to']));

    // if ((tempIdStatus == '3' || tempIdStatus == '4') &&
    //     t.compareTo(DateTime.now()) < 0) {
    //   // if( temp =='Valid'){
    //   temp = 'Expired';
    // }

    return VoucherModel(
      kodeVoucher: json['kode_voucher'] == null ? '' : json['kode_voucher'],
      nak: json['nak'] == null ? '' : json['nak'],
      idTipe: json['id_tipe'] == null ? 0 : int.parse(json['id_tipe']),
      batch: json['batch'] == null ? '' : json['batch'],
      keterangan: json['keterangan'] == null ? '' : json['keterangan'],
      splittable:
          json['splittable'] == null ? 0 : int.parse(json['splittable']),
      nominal: json['nominal'] == null ? 0 : double.parse(json['nominal']),
      nominalTerpakai: json['nominal_terpakai'] == null
          ? 0
          : double.parse(json['nominal_terpakai']),
      validFrom: json['valid_from'] == null ? '' : json['valid_from'],
      validTo: json['valid_to'] == null ? '' : json['valid_to'],
      idStatus: json['id_status'] == null ? 0 : int.parse(json['id_status']),
      //idStatus: int.parse(tempIdStatus),
      insertedDate: json['Inserted_date'] == null ? '' : json['Inserted_date'],
      insertedFrom: json['Inserted_from'] == null ? '' : json['Inserted_from'],
      insertedBy: json['Inserted_by'] == null ? '' : json['Inserted_by'],
      tipe: json['tipe'] == null ? '' : json['tipe'],
      voucherstatus: json['status'] == null ? '' : json['status'],
      //voucherstatus: temp,
    );
  }
}

class VoucherLogModel {
  final String kodeVoucher;
  final String nak;
  final int idTipe;
  final double nilaiTransaksi;
  final String insertedDate;
  final String insertedFrom;
  final String insertedBy;
  final int id;
  final String remark;
  final String tipe;
  final String nmPrsh;
  final String statusCancel;
  final String nmAng;

  VoucherLogModel(
      {this.kodeVoucher,
      this.nak,
      this.idTipe,
      this.nilaiTransaksi,
      this.insertedDate,
      this.insertedFrom,
      this.insertedBy,
      this.id,
      this.remark,
      this.nmPrsh,
      this.statusCancel,
      this.nmAng,
      this.tipe});

  factory VoucherLogModel.fromJson(Map<String, dynamic> json) {
    return VoucherLogModel(
      kodeVoucher: json['kode_voucher'] == null ? '' : json['kode_voucher'],
      nak: json['nak'] == null ? '' : json['nak'],
      tipe: json['tipe'] == null ? '' : json['tipe'],
      remark: json['remark'] == null ? '' : json['remark'],
      idTipe: json['id_tipe'] == null ? 0 : int.parse(json['id_tipe']),
      id: json['id'] == null ? 0 : int.parse(json['id']),
      nilaiTransaksi: json['nilai_transaksi'] == null
          ? 0
          : double.parse(json['nilai_transaksi']),
      insertedDate: json['inserted_date'] == null ? '' : json['inserted_date'],
      insertedFrom: json['inserted_from'] == null ? '' : json['inserted_from'],
      insertedBy: json['inserted_by'] == null ? '' : json['inserted_by'],
      nmPrsh: json['nm_prsh'] == null ? '' : json['nm_prsh'],
      statusCancel: json['status_cancel'] == null ? '' : json['status_cancel'],
      nmAng: json['nm_ang'] == null ? '' : json['nm_ang'],
    );
  }
}

class CouponModel {
  final String kodeCoupon;
  final int idTipe;
  final double nominal;
  final double nominalTerpakai;
  final String insertedDate;
  final String insertedFrom;
  final String insertedBy;
  final String keterangan;
  final String tipe;
  final String validFrom;
  final String validTo;
  final int idStatus;
  final String voucherstatus;
  final String redeemFrom;
  final String redeemDate;
  final int splittable;

  CouponModel(
      {this.redeemFrom,
      this.splittable,
      this.redeemDate,
      this.kodeCoupon,
      this.idTipe,
      this.nominal,
      this.nominalTerpakai,
      this.insertedDate,
      this.insertedFrom,
      this.insertedBy,
      this.keterangan,
      this.tipe,
      this.validFrom,
      this.validTo,
      this.idStatus,
      this.voucherstatus});

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      kodeCoupon: json['kode_coupon'] == null ? '' : json['kode_coupon'],
      idTipe: json['id_tipe'] == null ? 0 : int.parse(json['id_tipe']),
      splittable: json['splitable'] == null ? 0 : int.parse(json['splitable']),
      nominal: json['nominal'] == null ? 0 : double.parse(json['nominal']),
      nominalTerpakai: json['nominal_terpakai'] == null
          ? 0
          : double.parse(json['nominal_terpakai']),
      insertedDate: json['Inserted_date'] == null ? '' : json['Inserted_date'],
      insertedFrom: json['Inserted_from'] == null ? '' : json['Inserted_from'],
      validFrom: json['valid_from'] == null ? '' : json['valid_from'],
      validTo: json['valid_to'] == null ? '' : json['valid_to'],
      insertedBy: json['Inserted_by'] == null ? '' : json['Inserted_by'],
      keterangan: json['keterangan'] == null ? '' : json['keterangan'],
      tipe: json['tipe'] == null ? '' : json['tipe'],
      voucherstatus: json['status'] == null ? '' : json['status'],
      //voucherstatus: 'asdasd',
      redeemFrom: json['redeem_from'] == null ? '' : json['redeem_from'],
      redeemDate: json['redeem_date'] == null ? '' : json['redeem_date'],
      idStatus: json['id_status'] == null ? 0 : int.parse(json['id_status']),
    );
  }
}

class CouponLogModel {
  final String kodeCoupon;
  final String tipe;
  final int idTipe;
  final double nilaiTransaksi;
  final String insertedDate;
  final String insertedFrom;
  final String insertedBy;
  final String remark;
  final String statusCancel;

  CouponLogModel({
    this.kodeCoupon,
    this.idTipe,
    this.nilaiTransaksi,
    this.insertedDate,
    this.insertedFrom,
    this.insertedBy,
    this.remark,
    this.tipe,
    this.statusCancel,
  });

  factory CouponLogModel.fromJson(Map<String, dynamic> json) {
    return CouponLogModel(
      kodeCoupon: json['kode_coupon'] == null ? '' : json['kode_coupon'],
      idTipe: json['id_tipe'] == null ? 0 : int.parse(json['id_tipe']),
      nilaiTransaksi: json['nilai_transaksi'] == null
          ? 0
          : double.parse(json['nilai_transaksi']),
      insertedDate: json['inserted_date'] == null ? '' : json['inserted_date'],
      insertedFrom: json['inserted_from'] == null ? '' : json['inserted_from'],
      insertedBy: json['Inserted_by'] == null ? '' : json['Inserted_by'],
      remark: json['remark'] == null ? '' : json['remark'],
      tipe: json['tipe'] == null ? '' : json['tipe'],
      statusCancel: json['status_cancel'] == null ? '' : json['status_cancel']
    );
  }
}
