import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../services/media_service.dart';
import '../../../auth/domain/domain.dart';

part 'profile_form_notifier.freezed.dart';
part 'profile_form_notifier.g.dart';
part 'profile_form_state.dart';

@riverpod
class ProfileFormNotifier extends _$ProfileFormNotifier {
  @override
  ProfileFormState build() => ProfileFormState.initial();

  void avatarChanged(bool fromGallery) async {
    final file =
        await ref.read(mediaServiceProvider).getImage(fromGallery: fromGallery);
    if (file != null) {
      final IAvatar iAvatar = IAvatar(File(file.path));
      state = state.copyWith(avatar: iAvatar);
    }
  }

  void bioChanged(String bio) {
    /// Creates a new `IBio` object from the given bio.
    final IBio iBio = IBio(bio);

    /// Updates the state with the new bio and clears the `option`.
    state = state.copyWith(bio: iBio);
  }

  void fullNameChanged(String fullName) {
    /// Creates a new `IFullName` object from the given fullName.
    final IFullName iFullName = IFullName(fullName);

    /// Updates the state with the new fullName and clears the `option`.
    state = state.copyWith(fullName: iFullName);
  }
}
