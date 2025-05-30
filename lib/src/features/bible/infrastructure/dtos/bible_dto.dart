// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:meno_fe_v1/src/features/bible/domain/entities/bible.dart';
import 'package:meno_fe_v1/src/features/bible/infrastructure/dtos/verse_dto.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
final class BibleDto with EquatableMixin {
  BibleDto({required this.translation, required this.verses});

  @Id()
  int? id;

  @Unique()
  final String translation;

  final ToMany<VerseDto> verses;

  @override
  List<Object?> get props => [translation, verses, id];
}

extension BibleDtoX on BibleDto {
  Bible get toDomain {
    return Bible(
      id: id,
      translation: translation,
      verses: verses.map((verse) => verse.toDomain).toList(),
    );
  }
}
