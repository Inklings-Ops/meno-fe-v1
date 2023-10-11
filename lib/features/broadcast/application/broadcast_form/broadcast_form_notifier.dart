import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:injectable/injectable.dart';

import '../../../../injector/injector.dart';
import '../../../../services/media_service.dart';
import '../../../auth/domain/domain.dart';
import '../../domain/domain.dart';

part 'broadcast_form_notifier.freezed.dart';
part 'broadcast_form_state.dart';

final broadcastFormProvider = StateNotifierProvider.autoDispose<
    BroadcastFormNotifier, BroadcastFormState>(
  (ref) => di<BroadcastFormNotifier>(),
);

@Injectable()
class BroadcastFormNotifier extends StateNotifier<BroadcastFormState> {
  final IBroadcastFacade _broadcastFacade;
  final MediaService _mediaService;

  BroadcastFormNotifier(
    this._broadcastFacade,
    this._mediaService,
  ) : super(BroadcastFormState.initial());

  void artworkChanged(bool fromGallery) async {
    final file = await _mediaService.getImage(fromGallery: fromGallery);

    if (file != null) {
      final IBroadcastArtwork iArtwork = IBroadcastArtwork(File(file.path));
      state = state.copyWith(artwork: iArtwork, option: none());
    }
  }

  Future<void> createPressed() async {
    Either<BroadcastException, Broadcast> r;

    final isTitleValid = state.title.isValid();

    if (isTitleValid) {
      state = state.copyWith(loading: true, option: none());

      r = await _broadcastFacade.createBroadcast(
        title: state.title,
        description: state.description,
        artwork: state.artwork,
        cohosts: state.cohosts?.map((e) => e.id).toList(),
        timeZone: 'Africa/Abidjan',
      );

      state = state.copyWith(
        loading: false,
        showError: false,
        option: some(r),
      );
    }

    state = state.copyWith(loading: false, showError: true, option: none());
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
