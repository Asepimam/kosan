class User {
  // final int id;
  final String userName;
  final String email;
  final String? phoneNumber;
  final String? firstName;
  final String? lastName;
  final String? profilePicture;

  User({
    // required this.id,
    required this.userName,
    required this.email,
    this.phoneNumber,
    this.firstName,
    this.lastName,
    this.profilePicture,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      // id: json['id'] as int,
      userName: json['user_name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phone_number'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      profilePicture: json['profile_picture'] as String?,
    );
  }
}
