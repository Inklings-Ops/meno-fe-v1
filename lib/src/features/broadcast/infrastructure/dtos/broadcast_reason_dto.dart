import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/features.dart';

part 'broadcast_reason_dto.freezed.dart';
part 'broadcast_reason_dto.g.dart';

@freezed
@JsonSerializable(
  explicitToJson: true,
  createFactory: false,
  includeIfNull: false,
)
class BroadcastReasonDto with _$BroadcastReasonDto {
  factory BroadcastReasonDto({
    required String type,
    required String message,
  }) = _BroadcastReasonDto;

  factory BroadcastReasonDto.fromJson(Map<String, dynamic> json) =>
      _$BroadcastReasonDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BroadcastReasonDtoToJson(this);
}

extension BroadcastReasonDtoToDomain on BroadcastReasonDto {
  BroadcastReason get toDomain => BroadcastReason(
        type: type,
        message: message,
      );
}

extension BroadcastReasonDtoToDto on BroadcastReason {
  BroadcastReasonDto get toDto => BroadcastReasonDto(
        type: type,
        message: message,
      );
}
