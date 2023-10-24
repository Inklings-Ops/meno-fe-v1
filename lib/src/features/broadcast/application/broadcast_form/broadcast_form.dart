import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../services/media_service.dart';
import '../../../auth/domain/domain.dart';
import '../../domain/domain.dart';

part 'broadcast_form.freezed.dart';
part 'broadcast_form.g.dart';
part 'broadcast_form_state.dart';

@riverpod
class BroadcastForm extends _$BroadcastForm {
  @override
  BroadcastFormState build() => BroadcastFormState.initial();

  void artworkChanged(bool fromGallery) async {
    final file =
        await ref.read(mediaServiceProvider).getImage(fromGallery: fromGallery);
    if (file != null) {
      final IBroadcastArtwork iArtwork = IBroadcastArtwork(File(file.path));
      state = state.copyWith(artwork: iArtwork, option: none());
    }
  }

  void descriptionChanged(String desc) {
    final IBroadcastDescription iDesc = IBroadcastDescription(desc);
    state = state.copyWith(description: iDesc, option: none());
  }

  void onRecordingChanged(bool? value) {
    if (value != null) {
      state = state.copyWith(recordingEnabled: value, option: none());
    }
  }

  void titleChanged(String title) {
    final IBroadcastTitle iTitle = IBroadcastTitle(title);
    state = state.copyWith(title: iTitle, option: none());
  }

  String? validateTitle(String? value) {
    return state.title.value.fold(
      (error) => error.mapOrNull(empty: (_) => 'Broadcast title is required'),
      (_) => null,
    );
  }

  String? validateDescription(String? value) {
    return state.description?.value.fold(
      (error) => error.mapOrNull(
        descLengthExceeded: (_) => 'Description character length exceeded',
      ),
      (_) => null,
    );
  }
}
