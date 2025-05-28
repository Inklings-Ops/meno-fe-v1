import 'package:bloc/bloc.dart';
import 'package:meno_fe_v1/src/features/bible/bible.dart';

class TranslationBloc extends Cubit<Translation> {
  TranslationBloc() : super(_kjv);

  void onTranslationChanged(Translation translation) => emit(translation);
}

const _kjv = Translation(abbreviation: 'kjv', name: 'King James Version');
