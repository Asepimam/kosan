import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:kosan_kan/domain/entities/user.dart';
import 'package:kosan_kan/domain/failures/failure.dart';
import 'package:kosan_kan/domain/repositories/user_repository.dart';

class UserUsecase {
  final UserRepository repository;
  UserUsecase(this.repository);

  Future<Either<Failure, User>> getUserDetails() {
    return repository.getUserDetails();
  }

  Future<Either<Failure, void>> updateUser(
    String firstName,
    String lastName,
    String phoneNumber,
  ) {
    return repository.updateUser(firstName, lastName, phoneNumber);
  }

  Future<Either<Failure, void>> updatePassword(
    String oldPassword,
    String newPassword,
    String confirmPassword,
  ) {
    return repository.updatePassword(oldPassword, newPassword, confirmPassword);
  }

  Future<Either<Failure, void>> updateProfilePicture(File imageFile) {
    return repository.updateProfilePicture(imageFile);
  }
}
