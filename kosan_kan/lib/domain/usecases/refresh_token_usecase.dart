import 'package:dartz/dartz.dart';
import 'package:kosan_kan/domain/entities/refresh_token.dart';
import 'package:kosan_kan/domain/failures/failure.dart';
import 'package:kosan_kan/domain/repositories/refresh_token_repository.dart';

class RefreshTokenUsecase {
  final RefreshTokenRepository repository;

  RefreshTokenUsecase(this.repository);
  Future<Either<Failure, RefreshToken>> refreshToken(String refreshToken) {
    return repository.refreshToken(refreshToken);
  }
}
