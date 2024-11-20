import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:meno_fe_v1/src/features/bible/bible.dart';

part 'trans_event.dart';

part 'trans_state.dart';

part 'trans_bloc.freezed.dart';

class TransBloc extends Bloc<TransEvent, TransState> {
  TransBloc({required IBibleFacade facade})
      : _facade = facade,
        super(TransState.initial()) {
    on<ChangeTranslation>(_onChange);
    on<GetTranslations>(_onGet);
    on<CancelTranslationDownload>(_onCancel);
    on<DownloadTranslation>(_onDownload);
    on<_UpdateProgress>(_onUpdateProgress);

    add(const GetTranslations());
  }

  final IBibleFacade _facade;

  StreamSubscription<double?>? _subscription;

  void _onChange(ChangeTranslation event, Emitter<TransState> emit) {
    emit(state.copyWith(selectedTranslation: event.translation));
  }

  void _onGet(GetTranslations event, Emitter<TransState> emit) {
    final storedTranslations = _facade.storedTranslations;
    final otherTranslations = _facade.otherTranslations;
    emit(
      state.copyWith(
        storedTranslations: storedTranslations,
        otherTranslations: otherTranslations,
      ),
    );
  }

  void _onCancel(CancelTranslationDownload event, Emitter<TransState> emit) {
    if (!state.downloading) return;
    _facade.cancelBibleDownload(event.translation.abbreviation);
    _subscription = null;
    emit(state.copyWith(downloadProgress: 0, downloading: false));
  }

  void _onUpdateProgress(_UpdateProgress event, Emitter<TransState> emit) {
    emit(state.copyWith(downloadProgress: event.progress));
  }

  Future<void> _onDownload(
    DownloadTranslation event,
    Emitter<TransState> emit,
  ) async {
    final trans = event.translation;
    emit(state.copyWith(downloading: true, downloadingTranslation: trans));

    final fOrT = await _facade.downloadBible(trans.abbreviation);

    _subscription = _facade.downloadBibleProgress.listen(
      (progress) => add(_UpdateProgress(progress ?? 0)),
    );

    emit(
      fOrT.fold(
        (failure) => state.copyWith(
          downloadOption: some(fOrT),
          downloading: false,
          downloadingTranslation: null,
        ),
        (translation) => state.copyWith(
          downloadOption: some(fOrT),
          downloading: false,
          selectedTranslation: translation,
          downloadingTranslation: null,
        ),
      ),
    );

    _subscription = null;
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    _subscription = null;
    await super.close();
  }
}
