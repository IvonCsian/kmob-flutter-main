class ProfileModel {
  final int id;
  final String email;
  final bool emailConfirm;
  final bool phoneConfirm;
  final String hp;
  final String ktp;
  final String badge;
  final String pathKtp;
  final String pathSelfie;
  final String pathFoto;
  final String perusahaan;
  final String pathBadge;
  final String nak;
  final String pathBuktiPotong;
  final String confirm;
  final String anggota;
  final String va;
  final String namaVa;
  final String ewalletId;
  final String ewalletName;
  final String ewalletUsername;
  final String ewalletMsisdn;
  final String ewalletEmail;
  final double ewalletSaldo;
  final double maxSpbu;
  final double point;
  final double redeem;
  final double yourpoint;
  final String noPeg;
  final String nmAng;
  final String almRmh;
  final String tlpHp;
  final String kdPrsh;
  final String nmPrsh;
  final String nmDep;
  final String nmBagian;
  final double plafon;
  final double plafonPakai;
  final double plafonSisa;
  final DateTime tglMsk;
  final DateTime tglUpdate;

  ProfileModel(
      {this.id,
      this.point, this.redeem, this.yourpoint, 
      this.ewalletName,
      this.ewalletSaldo,
      this.ewalletUsername,
      this.ewalletMsisdn,
      this.ewalletEmail,
      this.ewalletId,
      this.phoneConfirm,
      this.plafonPakai,
      this.plafonSisa,
      this.va,
      this.pathFoto,
      this.namaVa,
      this.email,
      this.emailConfirm,
      this.hp,
      this.ktp,
      this.badge,
      this.pathKtp,
      this.pathSelfie,
      this.perusahaan,
      this.pathBadge,
      this.nak,
      this.pathBuktiPotong,
      this.confirm,
      this.anggota,
      this.noPeg,
      this.nmAng,
      this.almRmh,
      this.tlpHp,
      this.kdPrsh,
      this.nmPrsh,
      this.nmDep,
      this.nmBagian,
      this.tglMsk,
      this.plafon,
      this.tglUpdate,
      this.maxSpbu});

  factory ProfileModel.fromJson(Map<String, dynamic> jsons) {
    Map<String, dynamic> json = jsons['akun'];
    return ProfileModel(
      point: jsons['point'] == null ? 0 : double.parse(jsons['point'].toString()),
      redeem: jsons['redeem'] == null ? 0 : double.parse(jsons['redeem'].toString()),
      yourpoint: jsons['yourpoint'] == null ? 0 : double.parse(jsons['yourpoint'].toString()),
      id: json['id'] == null ? 0 : int.parse(json['id']),
      email: json['email'] == null ? '' : json['email'],
      emailConfirm: json['email_confirm'] == null
          ? false
          : json['email_confirm'] == '1' ? true : false,
      phoneConfirm: json['phone_confirm'] == null
          ? false
          : json['phone_confirm'] == '1' ? true : false,
      hp: json['hp'] == null ? '' : json['hp'],
      ewalletId: json['ewallet_id'] == null ? '' : json['ewallet_id'],
      ewalletName: json['ewallet_name'] == null ? '' : json['ewallet_name'],
      ewalletEmail: json['ewallet_email'] == null ? '' : json['ewallet_email'],
      ewalletUsername:
          json['ewallet_username'] == null ? '' : json['ewallet_username'],
      ewalletMsisdn:
          json['ewallet_msisdn'] == null ? '' : json['ewallet_msisdn'],
      ewalletSaldo:
          json['ewallet_saldo'] == null ? 0 : double.parse(json['ewallet_saldo']),
      ktp: json['ktp'] == null ? '' : json['ktp'],
      badge: json['badge'] == null ? '' : json['badge'],
      pathKtp: json['path_ktp'] == null ? '' : json['path_ktp'],
      pathFoto: json['path_foto'] == null ? '' : json['path_foto'],
      pathSelfie: json['path_selfie'] == null ? '' : json['path_selfie'],
      perusahaan: json['perusahaan'] == null ? '' : json['perusahaan'],
      pathBadge: json['path_badge'] == null ? '' : json['path_badge'],
      nak: json['nak'] == null ? '' : json['nak'],
      maxSpbu: json['max_spbu'] == null ? 0 : double.parse(json['max_spbu']),
      pathBuktiPotong:
          json['path_buktipotong'] == null ? '' : json['path_buktipotong'],
      confirm: json['confirm'] == null ? '' : json['confirm'],
      va: json['va'] == null ? '' : json['va'],
      namaVa: json['nama_va'] == null ? '' : json['nama_va'],
      anggota: json['anggota'] == null ? '' : json['anggota'],
      noPeg: jsons['ang'] == null ? '' : jsons['ang']['no_peg'],
      nmAng: jsons['ang'] == null ? '' : jsons['ang']['nm_ang'],
      almRmh: jsons['ang'] == null ? '' : jsons['ang']['alm_rmh'],
      tlpHp: jsons['ang'] == null ? '' : jsons['ang']['tlp_hp'],
      kdPrsh: jsons['ang'] == null ? '' : jsons['ang']['kd_prsh'],
      nmPrsh: jsons['ang'] == null ? '' : jsons['ang']['nm_prsh'],
      nmDep: jsons['ang'] == null ? '' : jsons['ang']['nm_dep'],
      nmBagian: jsons['ang'] == null ? '' : jsons['ang']['nm_bagian'],
      tglMsk: jsons['ang']['tgl_msk'] == null
          ? DateTime.utc(1993, 2, 10)
          : DateTime.parse(jsons['ang']['tgl_msk']),
      plafon: jsons['ang'] == null ? 0 : double.parse(jsons['ang']['plafon']),
      plafonPakai:
          jsons['ang'] == null ? 0 : double.parse(jsons['ang']['plafon_pakai']),
      plafonSisa: jsons['ang'] == null
          ? 0
          : double.parse(jsons['ang']['plafon']) -
              double.parse(jsons['ang']['plafon_pakai']),
      tglUpdate: jsons['ang']['tgl_msk'] == null
          ? null
          : DateTime.parse(jsons['ang']['tgl_msk']),
    );
  }
}
