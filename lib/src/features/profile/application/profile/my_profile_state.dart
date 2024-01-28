part of 'my_profile_bloc.dart';

@freezed
class MyProfileState with _$MyProfileState {
  const factory MyProfileState.loading() = _Loading;
  const factory MyProfileState.success(Profile profile) = _Success;
  const factory MyProfileState.failure([String? reason]) = _Failure;
}
