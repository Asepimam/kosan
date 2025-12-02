part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthAuthenticated extends AuthState {
  final String accessToken;
  final String refreshToken;
  final User user;
  const AuthAuthenticated(this.accessToken, this.refreshToken, this.user);

  @override
  List<Object> get props => [accessToken, refreshToken, user];
}

final class AuthFailure extends AuthState {
  final String message;
  const AuthFailure(this.message);

  @override
  List<Object> get props => [message];
}

final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();

  @override
  List<Object> get props => [];
}

final class AuthRegistered extends AuthState {
  const AuthRegistered();

  @override
  List<Object> get props => [];
}

final class AuthRegisterFailure extends AuthState {
  final String message;
  const AuthRegisterFailure(this.message);

  @override
  List<Object> get props => [message];
}
