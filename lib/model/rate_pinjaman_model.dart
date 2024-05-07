class RatePinjamanModel {
  final int id;
  final String jenis;
  final String tenor;
  final String margin;
  final int urut;

  RatePinjamanModel({this.id, this.jenis, this.tenor, this.margin, this.urut});

  
  factory RatePinjamanModel.fromJson(Map<String, dynamic> json) {
    return RatePinjamanModel(
      id: json['id'] == null ? 0 : int.parse(json['id']),
      jenis: json['jenis'] == null ? '' : json['jenis'],
      tenor: json['tenor'] == null ? '' : json['tenor'],
      margin: json['margin'] == null ? '' : json['margin'],
      urut: json['urut'] == null ? 0 : int.parse(json['urut'])
    );
  }


}
