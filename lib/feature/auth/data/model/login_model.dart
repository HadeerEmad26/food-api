class LoginModel {
  final String token;
  final String message;

  LoginModel({
    required this.token,
    required this.message,
  });

  //named constructor

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      token: json['token'],
      message: json['message'],
    );
  }
}
