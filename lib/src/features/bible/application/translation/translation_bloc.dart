import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/bible/bible.dart';

part 'translation_event.dart';
part 'translation_state.dart';
part 'translation_bloc.freezed.dart';

class TranslationBloc extends Bloc<TranslationEvent, TranslationState> {
  TranslationBloc() : super(TranslationState.initial()) {
    on<ChangeTranslation>(_onChange);
  }

  void _onChange(ChangeTranslation event, Emitter<TranslationState> emit) {
    emit(state.copyWith(translation: event.translation));
  }
}
