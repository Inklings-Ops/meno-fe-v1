import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/domain.dart';

part 'translations_cubit.freezed.dart';
part 'translations_state.dart';

@injectable
class TranslationsCubit extends Cubit<TranslationsState> {
  TranslationsCubit({required IBibleFacade facade})
      : _facade = facade,
        super(TranslationsState.initial());

  final IBibleFacade _facade;

  Future<void> changeTranslation(Translation translation) async {
    emit(state.copyWith(selectedTranslation: translation));
  }

  Future<void> getOnlineTranslations() async {
    final onlineTranslations = await _facade.onlineTranslations;
    final offlineTranslations = state.offlineTranslations;

    final combinedTranslations = [
      ...onlineTranslations,
      ...offlineTranslations
    ];

    final translations = combinedTranslations
        .where((translation) => !offlineTranslations.contains(translation))
        .toList();

    emit(state.copyWith(onlineTranslations: translations));
  }

  void getOfflineTranslations() {
    final translations = _facade.offlineTranslations;
    emit(state.copyWith(offlineTranslations: translations));
  }

  void initialize() async {
    getOfflineTranslations();
    await getOnlineTranslations();
  }
}
