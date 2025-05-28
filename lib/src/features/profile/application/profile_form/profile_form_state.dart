part of 'profile_form_cubit.dart';

final class ProfileFormState with EquatableMixin {
  const ProfileFormState() : this._();

  const ProfileFormState._({
    this.profile,
    this.fullName,
    this.bio,
    this.avatar,
    this.status = FormStatus.initial,
    this.exception,
  });

  ProfileFormState withProfile(Profile profile) {
    return ProfileFormState._(
      profile: profile,
      fullName: profile.fullName,
      bio: profile.bio,
    );
  }

  ProfileFormState withFullName(String fullName) {
    return ProfileFormState._(
      profile: profile,
      fullName: SingleLineString(fullName),
      bio: bio,
      avatar: avatar,
    );
  }

  ProfileFormState withBio(String bio) {
    return ProfileFormState._(
      profile: profile,
      fullName: fullName,
      bio: MultiLineString(bio),
      avatar: avatar,
    );
  }

  ProfileFormState withAvatar(File avatar) {
    return ProfileFormState._(
      profile: profile,
      fullName: fullName,
      bio: bio,
      avatar: ImageFile(avatar),
    );
  }

  ProfileFormState withSubmissionLoading() {
    return ProfileFormState._(
      profile: profile,
      fullName: fullName,
      bio: bio,
      avatar: avatar,
      status: FormStatus.loading,
    );
  }

  ProfileFormState withSubmissionSuccess(Profile updatedProfile) {
    return ProfileFormState._(
      profile: updatedProfile,
      fullName: fullName,
      bio: bio,
      avatar: avatar,
      status: FormStatus.success,
    );
  }

  ProfileFormState withSubmissionFailure([ProfileException? exception]) {
    return ProfileFormState._(
      profile: profile,
      fullName: fullName,
      bio: bio,
      avatar: avatar,
      status: FormStatus.failure,
      exception: exception,
    );
  }

  final Profile? profile;
  final SingleLineString? fullName;
  final MultiLineString? bio;
  final ImageFile? avatar;
  final FormStatus status;
  final ProfileException? exception;

  bool get hasChanges {
    final nameHasChanges = profile?.fullName != fullName;
    final bioHasChanges = profile?.bio != bio;
    final avatarHasChanges = avatar != null;
    return nameHasChanges || bioHasChanges || avatarHasChanges;
  }

  @override
  List<Object?> get props =>
      [profile, fullName, bio, avatar, status, exception];
}
