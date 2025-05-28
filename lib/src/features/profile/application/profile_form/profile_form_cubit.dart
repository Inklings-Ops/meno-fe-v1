import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meno_fe_v1/src/core/exceptions/exceptions.dart';
import 'package:meno_fe_v1/src/features/profile/domain/domain.dart';
import 'package:meno_fe_v1/src/services/media_service.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

part 'profile_form_state.dart';

class ProfileFormCubit extends Cubit<ProfileFormState> {
  ProfileFormCubit({
    required IProfileFacade facade,
    required MediaService media,
  })  : _facade = facade,
        _media = media,
        super(const ProfileFormState());
  final IProfileFacade _facade;
  final MediaService _media;

  void initializeWithProfile(Profile? profile) {
    if (profile == null) {
      emit(state.withSubmissionFailure(const NoProfileFoundException()));
    } else {
      emit(state.withProfile(profile));
    }
  }

  void fullNameChanged(String fullName) => emit(state.withFullName(fullName));

  void bioChanged(String bio) => emit(state.withBio(bio));

  Future<void> avatarChanged({bool fromGallery = true}) async {
    final file = await _media.getImage(fromGallery: fromGallery);
    if (file != null) emit(state.withAvatar(File(file.path)));
  }

  Future<void> editProfile() async {
    if (!state.hasChanges && state.profile == null) return;

    emit(state.withSubmissionLoading());

    final profile = state.profile!;

    final result = await _facade.editProfile(
      id: profile.id,
      fullName: state.fullName == profile.fullName ? null : state.fullName,
      bio: state.bio == profile.bio ? null : state.bio,
      image: state.avatar,
    );

    emit(
      result.fold(
        state.withSubmissionFailure,
        state.withSubmissionSuccess,
      ),
    );
  }
}
