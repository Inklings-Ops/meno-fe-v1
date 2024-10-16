part of 'my_profile_cubit.dart';

@freezed
class MyProfileState with _$MyProfileState {
  const factory MyProfileState.loading() = MyProfileLoadInProgress;
  const factory MyProfileState.success(Profile profile) = MyProfileLoaded;
  const factory MyProfileState.failure(AuthException exception) =
      MyProfileFailed;
}
