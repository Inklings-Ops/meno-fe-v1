part of 'others_profile_cubit.dart';

@freezed
class OthersProfileState with _$OthersProfileState {
  const factory OthersProfileState.loading() = OthersProfileLoadInProgress;
  const factory OthersProfileState.success(Profile profile) = OthersProfileLoaded;
  const factory OthersProfileState.failure(AuthException exception) = OthersProfileFailed;

}
