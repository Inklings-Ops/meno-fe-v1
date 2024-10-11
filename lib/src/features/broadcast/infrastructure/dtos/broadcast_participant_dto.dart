import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/broadcast/domain/domain.dart';

part 'broadcast_participant_dto.freezed.dart';
part 'broadcast_participant_dto.g.dart';

@freezed
@JsonSerializable(
  explicitToJson: true,
  createFactory: false,
  includeIfNull: false,
)
class BroadcastParticipantDto with _$BroadcastParticipantDto {
  factory BroadcastParticipantDto({
    required String id,
    required String fullName,
    String? broadcastId,
    Role? role,
    String? bio,
    String? imageUrl,
    int? numberOfListeners,
    bool? isHostDisconnected,
    DateTime? disconnectedAt,
  }) = _BroadcastParticipantDto;

  factory BroadcastParticipantDto.fromJson(Map<String, dynamic> json) =>
      _$BroadcastParticipantDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BroadcastParticipantDtoToJson(this);
}

extension ParticipantDtoToDomain on BroadcastParticipantDto {
  BroadcastParticipant get toDomain => BroadcastParticipant(
        id: id,
        fullName: fullName,
        role: role,
        broadcastId: broadcastId,
        bio: bio,
        imageUrl: imageUrl,
        numberOfListeners: numberOfListeners,
        isHostDisconnected: isHostDisconnected,
        disconnectedAt: disconnectedAt,
      );
}

extension ParticipantToDto on BroadcastParticipant {
  BroadcastParticipantDto get toDto => BroadcastParticipantDto(
        id: id,
        fullName: fullName,
        role: role,
        broadcastId: broadcastId,
        bio: bio,
        imageUrl: imageUrl,
        numberOfListeners: numberOfListeners,
        isHostDisconnected: isHostDisconnected,
        disconnectedAt: disconnectedAt,
      );
}
