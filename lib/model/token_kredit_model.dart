class TokenKreditModel {
  final int id;
  final String noAng;
  final String expired;
  final String updatedon;
  final String token;
  final double nominal;
  final String notransaksi;
  final String updatedby;
  final String useddate;
  final String cicilan;

  TokenKreditModel(
      {this.id,
      this.noAng,
      this.cicilan,
      this.expired,
      this.updatedon,
      this.token,
      this.nominal,
      this.notransaksi,
      this.updatedby,
      this.useddate});

  factory TokenKreditModel.fromJson(Map<String, dynamic> json) {
    return TokenKreditModel(
      id: json['id'] == null ? 0 : int.parse(json['id']),
      noAng: json['noAng'] == null ? '' : json['noAng'],
      expired: json['expired'] == null ? '' : json['expired'],
      updatedon: json['updatedon'] == null ? '' : json['updatedon'],
      token: json['token'] == null ? 0 : json['token'],
      nominal: json['nominal'] == null ? '' : double.parse(json['nominal']),
      notransaksi: json['notransaksi'] == null ? '' : json['notransaksi'],
      updatedby: json['updatedby'] == null ? '' : json['updatedby'],
      useddate: json['useddate'] == null ? '' : json['useddate'],
      cicilan: json['cicilan'] == null ? '' : json['cicilan'],
    );
  }
}
