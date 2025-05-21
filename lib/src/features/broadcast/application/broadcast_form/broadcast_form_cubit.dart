import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/services/media_service.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

part 'broadcast_form_state.dart';

class BroadcastFormCubit extends Cubit<BroadcastFormState> {
  BroadcastFormCubit({
    required MediaService mediaService,
  })  : _mediaService = mediaService,
        super(
          BroadcastFormState(
            title: SingleLineString(''),
            description: BroadcastDescription(''),
          ),
        );

  final MediaService _mediaService;

  Future<void> artworkChanged({bool fromGallery = true}) async {
    final file = await _mediaService.getImage(fromGallery: fromGallery);
    if (file != null) {
      emit(state.copyWith(artwork: BroadcastArtwork(File(file.path))));
    }
  }

  void descriptionChanged(String desc) {
    emit(state.copyWith(description: BroadcastDescription(desc)));
  }

  void onRecordingChanged(bool value) {
    emit(state.copyWith(shouldRecord: value));
  }

  void titleChanged(String title) {
    emit(state.copyWith(title: SingleLineString(title)));
  }
}
