part of 'profile_form_cubit.dart';

@freezed
class ProfileFormState with _$ProfileFormState {
  factory ProfileFormState({
    required IFullName? fullName,
    required IBio? bio,
    required IAvatar? avatar,
    required bool loading,
    required bool hasChanges,
    required Option<Either<AuthException, Unit>> onEdited,
  }) = _ProfileFormState;

  factory ProfileFormState.initial() {
    return ProfileFormState(
      fullName: null,
      bio: null,
      avatar: null,
      loading: false,
      hasChanges: false,
      onEdited: none(),
    );
  }
}
