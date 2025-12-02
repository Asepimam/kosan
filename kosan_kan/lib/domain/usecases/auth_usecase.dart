import 'package:dartz/dartz.dart';
import 'package:kosan_kan/domain/entities/login.dart';
import 'package:kosan_kan/domain/failures/failure.dart';
import 'package:kosan_kan/domain/repositories/auth_repository.dart';

class AuthUsecase {
  final AuthRepository repository;
  AuthUsecase(this.repository);

  Future<Either<Failure, Login>> signIn(String userName, String password) {
    return repository.signIn(userName, password);
  }

  Future<Either<Failure, void>> signOut() {
    return repository.signOut();
  }

  Future<Either<Failure, Login>> register(
    String userName,
    String email,
    String password,
    String phoneNumber,
  ) {
    return repository.register(userName, email, password, phoneNumber);
  }
}
