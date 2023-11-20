import 'package:freezed_annotation/freezed_annotation.dart';

import 'broadcast_dto.dart';

part 'join_broadcast_dto.freezed.dart';
part 'join_broadcast_dto.g.dart';

@freezed
@JsonSerializable(
  explicitToJson: true,
  createFactory: false,
  includeIfNull: false,
)
class JoinBroadcastDto with _$JoinBroadcastDto {
  factory JoinBroadcastDto({
    required String broadcastToken,
    required BroadcastDto broadcast,
  }) = _JoinBroadcastDto;

  factory JoinBroadcastDto.fromJson(Map<String, dynamic> json) =>
      _$JoinBroadcastDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$JoinBroadcastDtoToJson(this);
}
