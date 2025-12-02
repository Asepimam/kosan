import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kosan_kan/data/local/auth_local.dart';
import 'package:kosan_kan/domain/entities/user.dart';
import 'package:kosan_kan/domain/usecases/auth_usecase.dart';
import 'package:kosan_kan/domain/usecases/user_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthLocal authLocal;
  final AuthUsecase authUsecase;
  final UserUsecase userUsecase;
  AuthBloc(this.authLocal, this.authUsecase, this.userUsecase)
    : super(AuthInitial()) {
    on<LoginRequested>(_loginRequested);
    on<LogoutRequested>(_logoutRequested);
    on<RegisterRequested>(_registerRequested);
    on<UpdateAuthenticatedUser>(_updateAuthenticatedUser);
  }

  Future<void> _updateAuthenticatedUser(
    UpdateAuthenticatedUser event,
    Emitter<AuthState> emit,
  ) async {
    // If currently authenticated, update the in-memory user while keeping tokens
    final current = state;
    if (current is AuthAuthenticated) {
      emit(
        AuthAuthenticated(
          current.accessToken,
          current.refreshToken,
          event.user,
        ),
      );
    }
  }

  Future<void> _loginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    // first check API availability
    emit(AuthLoading());

    final result = await authUsecase.signIn(event.username, event.password);
    await result.fold(
      (failure) async {
        emit(AuthFailure(failure.details));
      },
      (success) async {
        try {
          final accessToken = success.accessToken;
          final refreshToken = success.refreshToken;
          await authLocal.saveAuthToken(accessToken, refreshToken);
          final userResult = await userUsecase.getUserDetails();
          print('Fetching user details after login...');
          await userResult.fold(
            (failure) async {
              emit(AuthFailure(failure.details));
            },
            (user) async {
              print('User fetched: ${user}');
              emit(AuthAuthenticated(accessToken, refreshToken, user));
            },
          );
        } catch (e) {
          emit(AuthFailure(e.toString()));
        }
      },
    );
  }

  Future<void> _logoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await authLocal.clearAuthToken();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _registerRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await authUsecase.register(
      event.username,
      event.phoneNumber,
      event.email,
      event.password,
    );
    await result.fold(
      (failure) async {
        emit(AuthRegisterFailure(failure.details));
      },
      (success) async {
        try {
          emit(const AuthRegistered());
        } catch (e) {
          emit(const AuthRegisterFailure('An unknown error occurred'));
        }
      },
    );
  }
}
