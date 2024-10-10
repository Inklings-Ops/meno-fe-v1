import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/features.dart';

part 'ended_broadcast_data_dto.freezed.dart';
part 'ended_broadcast_data_dto.g.dart';

@freezed
@JsonSerializable(
  explicitToJson: true,
  createFactory: false,
  includeIfNull: false,
)
class EndedBroadcastDataDto with _$EndedBroadcastDataDto {
  const factory EndedBroadcastDataDto({
    required BroadcastDto broadcastDetails,
    required BroadcastReasonDto reason,
  }) = _EndedBroadcastDataDto;

  factory EndedBroadcastDataDto.fromJson(Map<String, dynamic> json) =>
      _$EndedBroadcastDataDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$EndedBroadcastDataDtoToJson(this);
}

extension EndedBroadcastDataDtoToDomain on EndedBroadcastDataDto {
  EndedBroadcastData get toDomain => EndedBroadcastData(
        broadcastDetails: broadcastDetails.toDomain,
        reason: reason.toDomain,
      );
}

extension EndedBroadcastDataDtoToDto on EndedBroadcastData {
  EndedBroadcastDataDto get toDto => EndedBroadcastDataDto(
        broadcastDetails: broadcastDetails.toDto,
        reason: reason.toDto,
      );
}
