import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meno_fe_v1/src/features/bible/bible.dart';

part 'translations_event.dart';
part 'translations_state.dart';

class TranslationsBloc extends Bloc<TranslationsEvent, TranslationsState> {
  TranslationsBloc({required IBibleFacade facade})
      : _facade = facade,
        super(const TranslationsState()) {
    on<TranslationsFetchRequested>(_onTranslationsFetchRequested);
    on<TranslationsUpdateRequested>(_onTranslationsUpdateRequested);
  }

  final IBibleFacade _facade;

  void _onTranslationsFetchRequested(
    TranslationsFetchRequested event,
    Emitter<TranslationsState> emit,
  ) {
    emit(
      state.copyWith(
        localTranslations: _facade.storedTranslations,
        remoteTranslations: _facade.otherTranslations,
      ),
    );
  }

  void _onTranslationsUpdateRequested(
    TranslationsUpdateRequested event,
    Emitter<TranslationsState> emit,
  ) {
    final localTranslations = List<Translation>.from(state.localTranslations);
    final remoteTranslations = List<Translation>.from(state.remoteTranslations);
    final updatedLocalTranslations = [...localTranslations, event.translation];
    final updatedRemoteTranslations = remoteTranslations
        .where((t) => t.abbreviation != event.translation.abbreviation)
        .toList();
    emit(
      state.copyWith(
        localTranslations: updatedLocalTranslations,
        remoteTranslations: updatedRemoteTranslations,
      ),
    );
  }
}
