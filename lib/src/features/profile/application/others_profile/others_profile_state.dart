part of 'others_profile_cubit.dart';

sealed class OthersProfileState with EquatableMixin {
  const OthersProfileState();

  @override
  List<Object?> get props => [];
}

final class OthersProfileInitial extends OthersProfileState {
  const OthersProfileInitial();
}

final class OthersProfileLoadInProgress extends OthersProfileState {
  const OthersProfileLoadInProgress();
}

final class OthersProfileLoadSuccess extends OthersProfileState {
  const OthersProfileLoadSuccess(this.profile);
  final Profile profile;

  @override
  List<Object?> get props => [profile];
}

final class OthersProfileLoadFailure extends OthersProfileState {
  const OthersProfileLoadFailure(this.exception);
  final ProfileException exception;

  @override
  List<Object?> get props => [exception];
}
