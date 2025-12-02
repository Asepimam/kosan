part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileLoaded extends ProfileState {
  final User profile;

  const ProfileLoaded(this.profile);

  @override
  List<Object> get props => [profile];
}

final class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object> get props => [message];
}

final class ProfileUpdated extends ProfileState {
  const ProfileUpdated();

  @override
  List<Object> get props => [];
}

final class PasswordChanged extends ProfileState {
  const PasswordChanged();

  @override
  List<Object> get props => [];
}

final class ProfilePictureUploaded extends ProfileState {
  const ProfilePictureUploaded();

  @override
  List<Object> get props => [];
}
