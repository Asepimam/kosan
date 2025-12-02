import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:kosan_kan/data/provider/api_client.dart';
import 'package:kosan_kan/domain/entities/user.dart';
import 'package:kosan_kan/domain/failures/failure.dart';
import 'package:kosan_kan/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final ApiClient apiClient;
  UserRepositoryImpl(this.apiClient);
  @override
  Future<Either<Failure, User>> getUserDetails() async {
    try {
      final response = await apiClient.get('api/users/profile/');
      final userResponse = User.fromJson(response.data);
      log('User details fetched: ${userResponse.toString()}');
      final code = response.statusCode ?? 0;
      if (code >= 200 && code < 300) {
        return Right(userResponse);
      } else {
        log('getUserDetails failed: status=$code data=${response.data}');
        return Left(Failure('Failed to fetch user details (status=$code)'));
      }
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updatePassword(
    String oldPassword,
    String newPassword,
    String confirmPassword,
  ) async {
    try {
      final data = {
        'current_password': oldPassword,
        'new_password': newPassword,
        'confirm_password': confirmPassword,
      };
      final response = await apiClient.post(
        'api/users/change-password/',
        data: data,
      );
      final code = response.statusCode ?? 0;
      if (code >= 200 && code < 300) {
        return const Right(null);
      }
      log('updatePassword failed: status=$code data=${response.data}');
      return Left(Failure('Failed to update password (status=$code)'));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateProfilePicture(File imageFile) async {
    try {
      final response = await apiClient.put(
        'api/users/change-profile-picture/',
        data: FormData.fromMap({
          'profile_picture': await MultipartFile.fromFile(imageFile.path),
        }),
      );
      final code = response.statusCode ?? 0;
      if (code >= 200 && code < 300) {
        return Right<Failure, void>(null);
      }
      log('updateProfilePicture failed: status=$code data=${response.data}');
      return Left<Failure, void>(
        Failure('Failed to update profile picture (status=$code)'),
      );
    } catch (e) {
      return Left<Failure, void>(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateUser(
    String firstName,
    String lastName,
    String phoneNumber,
  ) async {
    try {
      final data = {
        'first_name': firstName,
        'last_name': lastName,
        'phone_number': phoneNumber,
      };
      final response = await apiClient.put(
        'api/users/change-profile/',
        data: data,
      );
      final code = response.statusCode ?? 0;
      if (code >= 200 && code < 300) {
        return Right<Failure, void>(null);
      }
      log('updateUser failed: status=$code data=${response.data}');
      return Left<Failure, void>(
        Failure('Failed to update user (status=$code)'),
      );
    } catch (e) {
      return Left<Failure, void>(Failure(e.toString()));
    }
  }
}
