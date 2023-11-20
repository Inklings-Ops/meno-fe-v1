part of 'profile_form_notifier.dart';

@freezed
class ProfileFormState with _$ProfileFormState {
  factory ProfileFormState({
    IFullName? fullName,
    IBio? bio,
    IAvatar? avatar,
  }) = _ProfileFormState;

  factory ProfileFormState.initial() {
    return ProfileFormState(
      fullName: null,
      bio: null,
      avatar: null,
    );
  }
}
