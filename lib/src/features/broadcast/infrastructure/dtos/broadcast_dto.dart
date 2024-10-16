import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

part 'broadcast_dto.freezed.dart';
part 'broadcast_dto.g.dart';

@freezed
@JsonSerializable(
  explicitToJson: true,
  createFactory: false,
  includeIfNull: false,
)
class BroadcastDto with _$BroadcastDto {
  const factory BroadcastDto({
    required String id,
    required String title,
    String? description,
    String? broadcastToken,
    BroadcastStatus? status,
    BroadcastParticipantDto? creator,
    String? creatorId,
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
    String? creatorBio,
    String? creatorFullName,
    String? creatorImageUrl,
  }) = _BroadcastDto;

  factory BroadcastDto.fromJson(Map<String, dynamic> json) =>
      _$BroadcastDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BroadcastDtoToJson(this);
}

extension BroadcastDtoToDomain on BroadcastDto {
  Broadcast get toDomain {
    return Broadcast(
      id: Uid<Broadcast>.fromString(id),
      title: SingleLineString(title),
      description: BroadcastDescription(description),
      creatorId: creatorId,
      creator: creator != null
          ? BroadcastParticipant(id: creator!.id, fullName: creator!.fullName)
          : null,
      fullName: fullName,
      broadcastToken: broadcastToken,
      createdAt: createdAt,
      deleted: deleted,
      endTime: endTime,
      imageId: imageId,
      imageUrl: imageUrl,
      startTime: startTime,
      status: status,
      timeZone: timeZone,
      liveListeners: liveListeners,
      totalListeners: totalListeners,
      creatorBio: creatorBio,
      creatorFullName: creatorFullName,
      creatorImageUrl: creatorImageUrl,
    );
  }
}

extension BroadcastToDto on Broadcast {
  BroadcastDto get toDto {
    return BroadcastDto(
      id: id.getOr(),
      title: title.getOr(),
      description: description?.getOr(),
      creatorId: creatorId,
      creator: creator != null
          ? BroadcastParticipantDto(
              id: creator!.id,
              fullName: creator!.fullName,
            )
          : null,
      fullName: fullName,
      broadcastToken: broadcastToken,
      createdAt: createdAt,
      deleted: deleted,
      endTime: endTime,
      imageId: imageId,
      imageUrl: imageUrl,
      startTime: startTime,
      status: status,
      timeZone: timeZone,
      liveListeners: liveListeners,
      totalListeners: totalListeners,
      creatorBio: creatorBio,
      creatorFullName: creatorFullName,
      creatorImageUrl: creatorImageUrl,
    );
  }
}
