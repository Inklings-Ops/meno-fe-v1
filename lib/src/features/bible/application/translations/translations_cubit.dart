import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/bible/domain/domain.dart';
import 'package:rxdart/rxdart.dart';

part 'translations_cubit.freezed.dart';

part 'translations_state.dart';

class TranslationsCubit extends Cubit<TranslationsState> {
  TranslationsCubit({required IBibleFacade facade})
      : _facade = facade,
        super(TranslationsState.initial());

  final IBibleFacade _facade;

  final _downloadProgress = BehaviorSubject<double>.seeded(0);

  Stream<double> get downloadProgress => _downloadProgress.stream;

  Future<void> changeTranslation(Translation translation) async {
    emit(state.copyWith(selectedTranslation: translation));
  }

  Future<void> getTranslations() async {
    final allTranslations = await _facade.onlineTranslations();
    final offlineTranslations = state.offlineTranslations;

    final combinedTranslations = [...allTranslations, ...offlineTranslations];

    final translations = combinedTranslations
        .where((translation) => !offlineTranslations.contains(translation))
        .toList();

    emit(state.copyWith(onlineTranslations: translations));
  }

  void getOfflineTranslations() {
    final translations = _facade.offlineTranslations;
    emit(state.copyWith(offlineTranslations: translations));
  }

  Future<void> cancel(bool value) async {
    await _facade.sync(
      translation: state.selectedTranslation.abbreviation.toLowerCase(),
      cancel: CancelToken()..cancel(),
    );

    emit(
      state.copyWith(
        cancelDownload: value,
        loading: false,
        downloadProgress: 0,
      ),
    );
  }

  // Future<void> init() async {
  //   getOfflineTranslations();
  //   await getTranslations();
  // }

  Future<void> downloadTranslation(Translation translation) async {
    final previousTranslation = state.selectedTranslation;

    emit(state.copyWith(loading: true, selectedTranslation: translation));

    final response = await _facade.sync(
      translation: translation.abbreviation.toLowerCase(),
      onProgress: (int actualBytes, int totalBytes) {
        final progress = actualBytes / totalBytes * 100;
        _downloadProgress.add(progress);
        emit(state.copyWith(downloadProgress: progress));
      },
    );

    response.fold(
      (failure) => emit(
        state.copyWith(
          downloadOption: some(response),
          downloadProgress: 0,
          loading: false,
          cancelDownload: false,
          selectedTranslation: previousTranslation,
        ),
      ),
      (success) {
        final offlineTranslations = [...state.offlineTranslations, success];

        final oOnlineTranslations = state.onlineTranslations
            .where((t) => t.abbreviation != success.abbreviation)
            .toList();

        emit(
          state.copyWith(
            onlineTranslations: oOnlineTranslations,
            offlineTranslations: offlineTranslations,
            selectedTranslation: success,
            downloadProgress: 0,
            loading: false,
            cancelDownload: false,
          ),
        );
      },
    );
  }
}
