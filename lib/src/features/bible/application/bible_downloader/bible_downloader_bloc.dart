// ignore_for_file: avoid_redundant_argument_values

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meno_fe_v1/src/core/exceptions/exceptions.dart';
import 'package:meno_fe_v1/src/features/bible/bible.dart';

part 'bible_downloader_event.dart';
part 'bible_downloader_state.dart';

class BibleDownloaderBloc
    extends Bloc<BibleDownloaderEvent, BibleDownloaderState> {
  BibleDownloaderBloc({
    required IBibleFacade facade,
  })  : _facade = facade,
        super(const BibleDownloaderState()) {
    on<BibleDownloadRequested>(_onDownloadBible);
    on<BibleCancelDownloadRequested>(_onCancelBibleDownload);
    on<_UpdateDownloadProgress>(_onUpdateProgress);
  }

  final IBibleFacade _facade;

  StreamSubscription<int>? _progressSubscription;

  Future<void> _onDownloadBible(
    BibleDownloadRequested event,
    Emitter<BibleDownloaderState> emit,
  ) async {
    if (state.downloading) return;
    late Either<BibleException, Translation> res;
    _progressSubscription = _facade.downloadBibleProgress.listen(
      (progress) => add(_UpdateDownloadProgress(progress)),
    );
    final translation = event.translation;
    emit(
      state.copyWith(
        progress: 0,
        option: none(),
        translation: translation,
        downloading: true,
      ),
    );
    res = await _facade.downloadBible(translation);
    emit(
      state.copyWith(
        option: optionOf(res),
        progress: 0,
        translation: null,
        downloading: false,
      ),
    );
  }

  void _onCancelBibleDownload(
    BibleCancelDownloadRequested event,
    Emitter<BibleDownloaderState> emit,
  ) {
    if (!state.downloading) return;
    _facade.cancelDownload();
    return emit(const BibleDownloaderState());
  }

  void _onUpdateProgress(
    _UpdateDownloadProgress event,
    Emitter<BibleDownloaderState> emit,
  ) {
    if (!state.downloading) return;
    emit(state.copyWith(progress: event.progress));
  }

  @override
  Future<void> close() async {
    await _progressSubscription?.cancel();
    _progressSubscription = null;
    await super.close();
  }
}
