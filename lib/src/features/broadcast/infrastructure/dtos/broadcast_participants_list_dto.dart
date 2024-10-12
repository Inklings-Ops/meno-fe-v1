import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

part 'broadcast_participants_list_dto.freezed.dart';
part 'broadcast_participants_list_dto.g.dart';

@freezed
@JsonSerializable(
  explicitToJson: true,
  createFactory: false,
  includeIfNull: false,
)
class BroadcastParticipantsListDto with _$BroadcastParticipantsListDto {
  factory BroadcastParticipantsListDto({
    required List<BroadcastParticipantDto> broadcastListeners,
    required int totalItems,
    required int totalPages,
    required int currentPage,
  }) = _BroadcastParticipantsListDto;

  factory BroadcastParticipantsListDto.fromJson(Map<String, dynamic> json) =>
      _$BroadcastParticipantsListDtoFromJson(json);

  @override
  Map<String, Object?> toJson() => _$BroadcastParticipantsListDtoToJson(this);
}

extension BPListToDomainX on BroadcastParticipantsListDto {
  BroadcastParticipantsListEntity get toDomain {
    return BroadcastParticipantsListEntity(
      broadcastListeners: broadcastListeners.map((b) => b.toDomain).toList(),
      totalItems: totalItems,
      totalPages: totalPages,
      currentPage: currentPage,
    );
  }
}

extension BPListToDtoX on BroadcastParticipantsListEntity {
  BroadcastParticipantsListDto get toDto {
    return BroadcastParticipantsListDto(
      broadcastListeners: broadcastListeners.map((b) => b.toDto).toList(),
      totalItems: totalItems,
      totalPages: totalPages,
      currentPage: currentPage,
    );
  }
}
