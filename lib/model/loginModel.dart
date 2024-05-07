class LoginModel {
  final String userName;
  final String token;
  final String email;
  final String userId;
  final bool kasir;

  LoginModel(this.userName, this.token, this.email, this.userId, this.kasir);

  LoginModel.fromJson(Map<String, dynamic> json)
      : userName = json['user_id'],
        token = json['access_token'],
        email = json['user_id'],
        userId = json['user_id'],
        kasir = json['kasir'];

  Map<String, dynamic> toJson() => {
        'user_id': userName,
        'access_token': token,
        'kasir': kasir,
      };
}
