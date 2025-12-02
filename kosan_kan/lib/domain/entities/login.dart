class Login {
  final String refreshToken;
  final String accessToken;

  Login({required this.refreshToken, required this.accessToken});

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      refreshToken: json['refresh'] as String,
      accessToken: json['access'] as String,
    );
  }
}
