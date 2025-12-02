part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  final String username;
  final String password;

  const LoginRequested(this.username, this.password);

  @override
  List<Object> get props => [username, password];
}

class ForgetPasswordRequested extends AuthEvent {
  final String email;

  const ForgetPasswordRequested(this.email);

  @override
  List<Object> get props => [email];
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();

  @override
  List<Object> get props => [];
}

class RegisterRequested extends AuthEvent {
  final String username;
  final String phoneNumber;
  final String email;
  final String password;

  const RegisterRequested(
    this.username,
    this.phoneNumber,
    this.email,
    this.password,
  );
  @override
  List<Object> get props => [username, phoneNumber, email, password];
}

class UpdateAuthenticatedUser extends AuthEvent {
  final User user;

  const UpdateAuthenticatedUser(this.user);

  @override
  List<Object> get props => [user];
}
