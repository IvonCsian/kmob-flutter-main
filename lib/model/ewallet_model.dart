class EwalletRegisterModel {
  final String code;
  final String description;
  final String msg;

  EwalletRegisterModel({this.code, this.description, this.msg});

  factory EwalletRegisterModel.fromJson(Map<String, dynamic> json) {
    return EwalletRegisterModel(
      code: json['status'] == null ? json['code'] : json['status']['code'],
      description:
          json['status'] == null ? json['msg'] : json['status']['description'],
    );
  }
}

class EwalletTransactionModel {
  String description;
  double debit;
  double credit;
  double charge;
  double commission;
  String transactionDate;
  String noRefferenceTrx;
  String noreff;
  String name;
  String mode;
  DateTime transcationDateValue;
  EwalletTransactionModel({
    this.description,
    this.debit,
    this.charge,
    this.commission,
    this.transactionDate,
    this.noRefferenceTrx,
    this.noreff,
    this.name,
    this.mode,
    this.credit,
    this.transcationDateValue,
  });

  factory EwalletTransactionModel.fromJson(Map<String, dynamic> json) {
    return new EwalletTransactionModel(
      description:
          json['description'] == null ? "" : json['description']['_text'],
      mode: json['debit'] != null
          ? "DEBIT"
          : json['credit'] != null ? "CREDIT" : "",
      debit: json['debit'] == null
          ? 0
          : json['debit']['_text'] == null
              ? 0
              : double.parse(json['debit']['_text']),
      credit: json['credit'] == null
          ? 0
          : json['credit']['_text'] == null
              ? 0
              : double.parse(json['credit']['_text']),
      charge: json['charge'] == null
          ? 0
          : json['charge']['_text'] == null
              ? 0
              : double.parse(json['charge']['_text']),
      commission: json['commission'] == null
          ? 0
          : json['commission']['_text'] == null
              ? 0
              : double.parse(json['commission']['_text']),
      transactionDate:
          json['description'] == null ? "" : json['transactionDate']['_text'],
      transcationDateValue: json['transactionDate'] == null
          ? DateTime.now()
          : DateTime.parse(json['transactionDate']['_text'].substring(0, 8) +
              'T' +
              json['transactionDate']['_text'].substring(8)),
      noRefferenceTrx: json['noRefferenceTrx'] == null
          ? ""
          : json['noRefferenceTrx']['_text'],
      noreff: json['noreff'] == null ? "" : json['noreff']['_text'],
      name: json['name'] == null ? "" : json['name']['_text'],
    );
  }
}

class EwalletPaymentReserved {
  final String reserved1;
  final String reserved4;
  final String reserved6;
  final String reserved7;
  final String reserved8;
  final String reserved9;
  final String reserved11;
  final String reserved12;
  final String reserved14;
  final String reserved15;
  final String reserved16;
  final String reserved17;
  final String reserved18;
  final String reserved19;
  final String reserved21;
  final String reserved22;
  final String reference;
  final String amountPay;

  EwalletPaymentReserved(
      {this.reserved1,
      this.amountPay,
      this.reserved4,
      this.reserved6,
      this.reserved7,
      this.reserved8,
      this.reserved9,
      this.reserved11,
      this.reserved12,
      this.reserved14,
      this.reserved15,
      this.reserved16,
      this.reserved17,
      this.reserved18,
      this.reserved19,
      this.reserved21,
      this.reserved22,
      this.reference});
}
