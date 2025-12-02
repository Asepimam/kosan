part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadProfile extends ProfileEvent {
  const LoadProfile();

  @override
  List<Object> get props => [];
}

class UpdateProfile extends ProfileEvent {
  final String firstName;
  final String lastName;
  final String phoneNumber;

  const UpdateProfile(this.firstName, this.lastName, this.phoneNumber);

  @override
  List<Object> get props => [firstName, lastName, phoneNumber];
}

class ChangePassword extends ProfileEvent {
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;

  const ChangePassword(
    this.currentPassword,
    this.newPassword,
    this.confirmPassword,
  );

  @override
  List<Object> get props => [currentPassword, newPassword, confirmPassword];
}

class UploadProfilePicture extends ProfileEvent {
  final File imageFile;

  const UploadProfilePicture(this.imageFile);

  @override
  List<Object> get props => [imageFile];
}
