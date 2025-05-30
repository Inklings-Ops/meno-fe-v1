// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meno_fe_v1/src/features/bible/domain/entities/translation.dart';
import 'package:objectbox/objectbox.dart';

part 'translation_dto.g.dart';

@Entity()
@JsonSerializable()
final class TranslationDto with EquatableMixin {
  TranslationDto({
    required this.name,
    required this.abbreviation,
    this.downloaded = false,
    this.id,
  });

  factory TranslationDto.fromJson(Map<String, dynamic> json) =>
      _$TranslationDtoFromJson(json);

  @Id(assignable: true)
  int? id;

  final String name;
  final String abbreviation;
  final bool downloaded;

  @override
  List<Object?> get props => [name, abbreviation, id, downloaded];
  
  TranslationDto copyWith({
    String? name,
    String? abbreviation,
    int? id,
    bool? downloaded,
  }) {
    return TranslationDto(
      name: name ?? this.name,
      abbreviation: abbreviation ?? this.abbreviation,
      id: id ?? this.id,
      downloaded: downloaded ?? this.downloaded,
    );
  }

  Map<String, dynamic> toJson() => _$TranslationDtoToJson(this);
}

extension TranslationDtoX on TranslationDto {
  Translation get toDomain {
    return Translation(
      id: id,
      name: name,
      abbreviation: abbreviation,
      downloaded: downloaded,
    );
  }
}
