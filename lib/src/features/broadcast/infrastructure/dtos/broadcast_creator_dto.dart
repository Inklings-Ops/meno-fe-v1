import 'package:freezed_annotation/freezed_annotation.dart';

part 'broadcast_creator_dto.freezed.dart';
part 'broadcast_creator_dto.g.dart';

@freezed
@JsonSerializable(
  explicitToJson: true,
  createFactory: false,
  includeIfNull: false,
)
class BroadcastCreatorDto with _$BroadcastCreatorDto {
  factory BroadcastCreatorDto({
    required String id,
    required String fullName,
    String? imageUrl,
  }) = _BroadcastCreatorDto;

  factory BroadcastCreatorDto.fromJson(Map<String, dynamic> json) =>
      _$BroadcastCreatorDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BroadcastCreatorDtoToJson(this);
}
