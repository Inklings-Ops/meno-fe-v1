import 'package:meno_fe_v1/src/features/bible/infrastructure/dtos/dtos.dart';

TranslationDto handleFullTranslations(String abb) => switch (abb) {
      'asv' =>
        TranslationDto(abbreviation: abb, name: 'American Standard Version'),
      'ylt' =>
        TranslationDto(abbreviation: abb, name: "Young's Literal Translation"),
      'esv' =>
        TranslationDto(abbreviation: abb, name: 'English Standard Version'),
      'nkjv' =>
        TranslationDto(abbreviation: abb, name: 'New King James Version'),
      'amp' => TranslationDto(abbreviation: abb, name: 'Amplified Bible'),
      'niv' =>
        TranslationDto(abbreviation: abb, name: 'New International Version'),
      'kjv' => TranslationDto(abbreviation: abb, name: 'King James Version'),
      _ => TranslationDto(abbreviation: abb, name: 'Unknown Version'),
    };
