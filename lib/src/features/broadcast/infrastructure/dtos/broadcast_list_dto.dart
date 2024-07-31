import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/broadcast/domain/entities/broadcast_list_entity.dart';

import 'package:meno_fe_v1/src/features/broadcast/infrastructure/dtos/broadcast_dto.dart';

part 'broadcast_list_dto.freezed.dart';
part 'broadcast_list_dto.g.dart';

@freezed
@JsonSerializable(
  explicitToJson: true,
  createFactory: false,
  includeIfNull: false,
)
class BroadcastListDto with _$BroadcastListDto {
  factory BroadcastListDto({
    required List<BroadcastDto?> broadcasts,
    required int totalItems,
    required int totalPages,
    required int currentPage,
  }) = _BroadcastListDto;

  factory BroadcastListDto.fromJson(Map<String, dynamic> json) =>
      _$BroadcastListDtoFromJson(json);

  @override
  Map<String, Object?> toJson() => _$BroadcastListDtoToJson(this);
}

extension BListToDomainX on BroadcastListDto {
  BroadcastListEntity get toDomain {
    return BroadcastListEntity(
      broadcasts: broadcasts.map((b) => b?.toDomain).toList(),
      totalItems: totalItems,
      totalPages: totalPages,
      currentPage: currentPage,
    );
  }
}

extension BListToDtoX on BroadcastListEntity {
  BroadcastListDto get toDto {
    return BroadcastListDto(
      broadcasts: broadcasts.map((b) => b?.toDto).toList(),
      totalItems: totalItems,
      totalPages: totalPages,
      currentPage: currentPage,
    );
  }
}
