import 'package:bloc/bloc.dart';
import 'package:meno_fe_v1/src/features/bible/domain/domain.dart';

class VersesCubit extends Cubit<List<Verse>> {
  VersesCubit({required IBibleFacade facade})
      : _facade = facade,
        super(const []);

  final IBibleFacade _facade;

  void getVerses({
    required String book,
    required int chapter,
    required String translation,
  }) {
    final verses = _facade.getVerses(
      book: book,
      chapter: chapter,
      translation: translation,
    );

    emit(verses);
  }
}
