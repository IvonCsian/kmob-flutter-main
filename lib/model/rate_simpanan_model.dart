class RateSimpananModel {
  final int id;
  final String simpanan;
  final String tenor;
  final String sukubunga;
  final String nominal;
  final int urut;

  RateSimpananModel(
      {this.id,
      this.simpanan,
      this.tenor,
      this.sukubunga,
      this.urut,
      this.nominal});

  factory RateSimpananModel.fromJson(Map<String, dynamic> json) {
    return RateSimpananModel(
        id: json['id'] == null ? 0 : int.parse(json['id']),
        simpanan: json['simpanan'] == null ? '' : json['simpanan'],
        tenor: json['tenor'] == null ? '' : json['tenor'],
        sukubunga: json['sukubunga'] == null ? '' : json['sukubunga'],
        nominal: json['nominal'] == null ? '' : json['nominal'],
        urut: json['urut'] == null ? 0 : int.parse(json['urut']));
  }
}
