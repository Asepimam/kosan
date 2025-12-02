import 'package:dartz/dartz.dart';
import 'package:kosan_kan/domain/entities/refresh_token.dart';
import 'package:kosan_kan/domain/failures/failure.dart';

abstract class RefreshTokenRepository {
  Future<Either<Failure, RefreshToken>> refreshToken(String refreshToken);
}
