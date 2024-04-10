import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../services/media_service.dart';
import '../../../auth/domain/domain.dart';
import '../../domain/domain.dart';

part 'profile_form_cubit.freezed.dart';
part 'profile_form_state.dart';

@lazySingleton
class ProfileFormCubit extends Cubit<ProfileFormState> {
  final IProfileFacade _facade;
  final MediaService _media;

  ProfileFormCubit({
    required IProfileFacade facade,
    required MediaService media,
  })  : _facade = facade,
        _media = media,
        super(ProfileFormState.initial());

  bool? get isValid =>
      state.fullName?.isValid() == true || state.bio?.isValid() == true;

  void avatarChanged(bool fromGallery) async {
    final file = await _media.getImage(fromGallery: fromGallery);
    if (file != null) {
      emit(state.copyWith(avatar: IAvatar(File(file.path)), hasChanges: true));
    }
  }

  void bioChanged(String bio) {
    /// Updates the state with the new bio and clears the `option`.
    emit(state.copyWith(bio: IBio(bio), hasChanges: true));
  }

  Future<void> editProfile() async {
    if (!state.hasChanges) return;

    emit(state.copyWith(loading: true, onEdited: none()));

    final result = await _facade.editProfile(
      avatar: state.avatar,
      bio: state.bio,
      fullName: state.fullName,
    );

    emit(state.copyWith(
      loading: false,
      onEdited: some(result),
      hasChanges: false,
    ));
  }

  void fullNameChanged(String fullName) {
    /// Updates the state with the new fullName and clears the `option`.
    emit(state.copyWith(fullName: IFullName(fullName), hasChanges: true));
  }
}
