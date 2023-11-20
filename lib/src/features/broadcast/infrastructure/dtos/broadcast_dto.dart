import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/broadcast_status.dart';
import 'participant_dto.dart';

part 'broadcast_dto.freezed.dart';
part 'broadcast_dto.g.dart';

@freezed
@JsonSerializable(
  explicitToJson: true,
  createFactory: false,
  includeIfNull: false,
)
class BroadcastDto with _$BroadcastDto {
  factory BroadcastDto({
    required String id,
    required String title,
    String? description,
    String? broadcastToken,
    BroadcastStatus? status,
    ParticipantDto? creator,
    String? fullName,
    String? imageId,
    String? imageUrl,
    String? timeZone,
    DateTime? startTime,
    DateTime? endTime,
    DateTime? createdAt,
    dynamic deleted,
    int? liveListeners,
    int? totalListeners,
  }) = _BroadcastDto;

  factory BroadcastDto.fromJson(Map<String, dynamic> json) =>
      _$BroadcastDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BroadcastDtoToJson(this);
}
