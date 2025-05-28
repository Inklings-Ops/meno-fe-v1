part of 'my_profile_cubit.dart';

sealed class MyProfileState with EquatableMixin {
  const MyProfileState();

  @override
  List<Object?> get props => [];
}

final class MyProfileInitial extends MyProfileState {
  const MyProfileInitial();
}

final class MyProfileLoadInProgress extends MyProfileState {
  const MyProfileLoadInProgress();
}

final class MyProfileLoadSuccess extends MyProfileState {
  const MyProfileLoadSuccess(this.profile);
  final Profile profile;

  @override
  List<Object?> get props => [profile];
}

final class MyProfileLoadFailure extends MyProfileState {
  const MyProfileLoadFailure(this.exception);
  final ProfileException exception;

  @override
  List<Object?> get props => [exception];
}
