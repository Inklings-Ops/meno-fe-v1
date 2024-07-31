import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/bible/domain/entities/translation.dart';
import 'package:objectbox/objectbox.dart';

part 'translation_dto.freezed.dart';
part 'translation_dto.g.dart';

@Freezed(addImplicitFinal: false)
@JsonSerializable(createFactory: false)
class TranslationDto with _$TranslationDto {
  @Entity(realClass: TranslationDto)
  factory TranslationDto({
    required String name,
    required String abbreviation,
    @Id(assignable: true) int? id,
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
