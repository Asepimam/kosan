import 'package:dartz/dartz.dart';
import 'package:kosan_kan/domain/entities/login.dart';
import 'package:kosan_kan/domain/failures/failure.dart';

abstract class AuthRepository {
  Future<Either<Failure, Login>> signIn(String userName, String password);
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, Login>> register(
    String userName,
    String email,
    String password,
    String phoneNumber,
  );
}
