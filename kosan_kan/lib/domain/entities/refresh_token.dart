class RefreshToken {
  final String accesToken;
  final String refreshToken;
  RefreshToken(this.accesToken, this.refreshToken);

  factory RefreshToken.fromJson(Map<String, dynamic> json) {
    return RefreshToken(
      json['access_token'] as String,
      json['refresh_token'] as String,
    );
  }
}
