import 'package:freezed_annotation/freezed_annotation.dart';

import 'broadcast_dto.dart';

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
