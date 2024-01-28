part of 'my_profile_bloc.dart';

@freezed
class MyProfileEvent with _$MyProfileEvent {
  const factory MyProfileEvent.fetch() = _FetchProfileData;
}