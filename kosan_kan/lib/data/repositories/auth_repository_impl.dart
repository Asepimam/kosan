import 'package:dartz/dartz.dart';
import 'package:kosan_kan/data/provider/api_client.dart';
import 'package:kosan_kan/domain/entities/login.dart';
import 'package:kosan_kan/domain/failures/failure.dart';
import 'package:kosan_kan/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient apiClient;
  AuthRepositoryImpl(this.apiClient);

  @override
  Future<Either<Failure, Login>> signIn(
    String userName,
    String password,
  ) async {
    try {
      final response = await apiClient.post(
        'api/auth/login/',
        data: {'username': userName, 'password': password},
      );
      final loginResponse = Login.fromJson(response.data);
      if (response.statusCode == 200) {
        return Right(loginResponse);
      } else {
        return Left(Failure('Login failed'));
      }
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Login>> register(
    String userName,
    String email,
    String password,
    String phoneNumber,
  ) async {
    try {
      final response = await apiClient.post(
        'api/auth/register',
        data: {'user_name': userName, 'email': email, 'password': password},
      );
      final registerResponse = Login.fromJson(response.data);
      if (response.statusCode == 200) {
        return Right(registerResponse);
      } else {
        return Left(Failure('Registration failed'));
      }
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      final response = await apiClient.post('api/auth/logout');
      if (response.statusCode == 200) {
        return Right(null);
      } else {
        return Left(Failure('Sign out failed'));
      }
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
