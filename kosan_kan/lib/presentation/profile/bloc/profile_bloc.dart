import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kosan_kan/domain/entities/user.dart';
import 'package:kosan_kan/domain/usecases/user_usecase.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  UserUsecase userUsecase;
  ProfileBloc(this.userUsecase) : super(ProfileInitial()) {
    on<LoadProfile>(_profileLoaded);
    on<UpdateProfile>(_updateProfile);
    on<ChangePassword>(_changePassword);
    on<UploadProfilePicture>(_uploadProfilePicture);
  }

  Future<void> _profileLoaded(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    final user = await userUsecase.getUserDetails();
    await user.fold(
      (failure) async {
        emit(ProfileError(failure.details));
      },
      (userData) async {
        try {
          emit(ProfileLoaded(userData));
        } catch (e) {
          emit(ProfileError(e.toString()));
        }
      },
    );
  }

  Future<void> _updateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    final result = await userUsecase.updateUser(
      event.firstName,
      event.lastName,
      event.phoneNumber,
    );

    await result.fold(
      (failure) async {
        emit(ProfileError(failure.details));
      },
      (success) async {
        // update succeeded - reload fresh profile and emit it
        final userResult = await userUsecase.getUserDetails();
        await userResult.fold(
          (failure) async {
            emit(ProfileError(failure.details));
          },
          (userData) async {
            emit(ProfileLoaded(userData));
          },
        );
      },
    );
  }

  Future<void> _changePassword(
    ChangePassword event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    final result = await userUsecase.updatePassword(
      event.currentPassword,
      event.newPassword,
      event.confirmPassword,
    );
    await result.fold(
      (failure) async {
        emit(ProfileError(failure.details));
      },
      (success) async {
        emit(PasswordChanged());
      },
    );
  }

  Future<void> _uploadProfilePicture(
    UploadProfilePicture event,
    Emitter<ProfileState> emit,
  ) async {
    final result = await userUsecase.updateProfilePicture(event.imageFile);
    await result.fold(
      (failure) async {
        emit(ProfileError(failure.details));
      },
      (success) async {
        emit(ProfilePictureUploaded());
      },
    );
  }
}
