import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/features/bible/domain/domain.dart';

part 'verses_cubit.freezed.dart';
part 'verses_state.dart';

@injectable
class VersesCubit extends Cubit<VersesState> {
  VersesCubit({required IBibleFacade facade})
      : _facade = facade,
        super(VersesState.initial());

  final IBibleFacade _facade;

  void initialize() async => getVerses();

  void getVerses({
    String book = 'Genesis',
    int chapter = 1,
    String translation = 'kjv',
  }) {
    final verses = _facade.getVerses(
      book: book,
      chapter: chapter,
      translation: translation,
    );

    emit(state.copyWith(verses: verses));
  }
}
