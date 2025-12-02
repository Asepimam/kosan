import 'package:dartz/dartz.dart';
import 'package:kosan_kan/data/provider/api_client.dart';
import 'package:kosan_kan/domain/entities/refresh_token.dart';
import 'package:kosan_kan/domain/failures/failure.dart';
import 'package:kosan_kan/domain/repositories/refresh_token_repository.dart';

class RefreshTokenRepositoryImpl implements RefreshTokenRepository {
  final ApiClient apiClient;
  RefreshTokenRepositoryImpl(this.apiClient);
  @override
  Future<Either<Failure, RefreshToken>> refreshToken(
    String refreshToken,
  ) async {
    try {
      final data = {'refresh': refreshToken};
      final response = await apiClient.post('api/auth/refresh/', data: data);
      final refreshTokenResponse = RefreshToken.fromJson(response.data);
      final code = response.statusCode ?? 0;
      if (code >= 200 && code < 300) {
        return Right(refreshTokenResponse);
      } else {
        return Left(Failure('Failed to refresh token (status=$code)'));
      }
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
