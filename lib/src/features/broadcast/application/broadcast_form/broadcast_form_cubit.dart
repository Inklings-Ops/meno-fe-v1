import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/services/media_service.dart';

import '../../../auth/domain/domain.dart';
import '../../domain/domain.dart';

part 'broadcast_form_cubit.freezed.dart';
part 'broadcast_form_state.dart';

@lazySingleton
class BroadcastFormCubit extends Cubit<BroadcastFormState> {
  final IBroadcastFacade _facade;
  final MediaService _mediaService;

  BroadcastFormCubit({
    required IBroadcastFacade facade,
    required MediaService mediaService,
  })  : _facade = facade,
        _mediaService = mediaService,
        super(BroadcastFormState.initial());

  bool get isValid => state.title.isValid();

  void artworkChanged(bool fromGallery) async {
    final file = await _mediaService.getImage(fromGallery: fromGallery);
    if (file != null) {
      final IBroadcastArtwork iArtwork = IBroadcastArtwork(File(file.path));
      emit(state.copyWith(artwork: iArtwork));
    }
  }

  Future<void> create() async {
    if (!isValid) return;

    emit(state.copyWith(loading: true, option: none()));

    return await _facade
        .createBroadcast(
          title: state.title,
          description: state.description,
          artwork: state.artwork,
          cohosts: state.cohosts?.map((e) => e.id).toList(),
          timeZone: 'Africa/Abidjan',
        )
        .then((r) => emit(state.copyWith(loading: false, option: some(r))));
  }

  void descriptionChanged(String desc) {
    emit(state.copyWith(description: IBroadcastDescription(desc)));
  }

  void onRecordingChanged(bool? value) {
    emit(state.copyWith(shouldRecord: value ?? false));
  }

  void titleChanged(String title) {
    emit(state.copyWith(title: IBroadcastTitle(title)));
  }

  String? validateDescription(String? value) {
    return state.description?.value.fold(
      (error) => error.mapOrNull(
        descLengthExceeded: (_) => 'Description character length exceeded',
      ),
      (_) => null,
    );
  }

  String? validateTitle(String? value) {
    return state.title.value.fold(
      (error) => error.mapOrNull(empty: (_) => 'Broadcast title is required'),
      (_) => null,
    );
  }
}
