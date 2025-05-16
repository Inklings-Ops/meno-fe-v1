import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/bible/bible.dart';

part 'translations_event.dart';
part 'translations_state.dart';
part 'translations_bloc.freezed.dart';

class TranslationsBloc extends Bloc<TranslationsEvent, TranslationsState> {
  TranslationsBloc({required IBibleFacade facade})
      : _facade = facade,
        super(const TranslationsState()) {
    on<GetTranslations>(_onGetTranslations);
    on<UpdateTranslations>(_onUpdateTranslations);
  }

  final IBibleFacade _facade;

  void _onGetTranslations(
    GetTranslations event,
    Emitter<TranslationsState> emit,
  ) {
    emit(
      state.copyWith(
        localTranslations: _facade.storedTranslations,
        remoteTranslations: _facade.otherTranslations,
      ),
    );
  }

  void _onUpdateTranslations(
    UpdateTranslations event,
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
