import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/services/media_service.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

part 'broadcast_form_cubit.freezed.dart';
part 'broadcast_form_state.dart';

@lazySingleton
class BroadcastFormCubit extends Cubit<BroadcastFormState> {
  BroadcastFormCubit({
    required IBroadcastFacade facade,
    required MediaService mediaService,
  })  : _facade = facade,
        _mediaService = mediaService,
        super(BroadcastFormState.initial());

  final IBroadcastFacade _facade;
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

  Future<void> create() async {
    late Either<BroadcastException, Broadcast> fOrB;
    emit(state.copyWith(loading: true, option: none()));
    if (state.title.isValid && (state.description?.isValid ?? false)) {
      fOrB = await _facade.createBroadcast(
        title: state.title,
        description: state.description,
        artwork: state.artwork,
        cohosts: state.cohosts?.map((user) => user.id.getOr()).toList(),
        timeZone: 'Africa/Abidjan',
      );
    }
    emit(state.copyWith(loading: false, option: optionOf(fOrB)));
  }
}
