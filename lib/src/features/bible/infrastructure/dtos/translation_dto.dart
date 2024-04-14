import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:objectbox/objectbox.dart';

import '../../domain/entities/translation.dart';

part 'translation_dto.freezed.dart';
part 'translation_dto.g.dart';

@Freezed(addImplicitFinal: false)
@JsonSerializable(createFactory: false)
class TranslationDto with _$TranslationDto {
  @Entity(realClass: TranslationDto)
  factory TranslationDto({
    @Id(assignable: true) int? id,
    String? name,
    required String abbreviation,
  }) = _TranslationDto;

  TranslationDto._();

  factory TranslationDto.fromJson(Map<String, dynamic> json) =>
      _$TranslationDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TranslationDtoToJson(this);
}

extension TranslationDtoX on TranslationDto {
  Translation get toDomain {
    return Translation(
      id: id,
      name: name,
      abbreviation: abbreviation,
    );
  }
}
