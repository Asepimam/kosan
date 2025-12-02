import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:kosan_kan/domain/entities/user.dart';
import 'package:kosan_kan/domain/failures/failure.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> getUserDetails();
  Future<Either<Failure, void>> updateUser(
    String firstName,
    String lastName,
    String phoneNumber,
  );
  Future<Either<Failure, void>> updatePassword(
    String oldPassword,
    String newPassword,
    String confirmPassword,
  );
  Future<Either<Failure, void>> updateProfilePicture(File imageFile);
}
