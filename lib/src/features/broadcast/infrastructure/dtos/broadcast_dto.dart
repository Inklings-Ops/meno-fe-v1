import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meno_fe_v1/src/features/broadcast/domain/domain.dart';
import 'package:meno_fe_v1/src/features/broadcast/infrastructure/dtos/dtos.dart';
import 'package:meno_fe_v1/src/shared/value_objects/value_objects.dart';

part 'broadcast_dto.g.dart';

@JsonSerializable()
class BroadcastDto with EquatableMixin {
  const BroadcastDto({
    required this.id,
    required this.title,
    required this.description,
    this.status = BroadcastStatus.inactive,
    this.broadcastToken,
    this.creatorId,
    this.creator,
    this.fullName,
    this.imageUrl,
    this.startTime,
    this.endTime,
    this.createdAt,
    this.deleted,
    this.liveListeners,
    this.totalListeners,
    this.creatorFullName,
    this.creatorBio,
    this.creatorImageUrl,
  });

  factory BroadcastDto.fromJson(Map<String, dynamic> json) =>
      _$BroadcastDtoFromJson(json);

  Map<String, dynamic> toJson() => _$BroadcastDtoToJson(this);

  final String id;
  final String title;
  final String description;
  final BroadcastStatus status;
  final String? broadcastToken;
  final String? creatorId;
  final ParticipantDto? creator;
  final String? fullName;
  final String? imageUrl;
  final DateTime? startTime;
  final DateTime? endTime;
  final DateTime? createdAt;
  final dynamic deleted;
  final int? liveListeners;
  final int? totalListeners;
  final String? creatorFullName;
  final String? creatorBio;
  final String? creatorImageUrl;

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        broadcastToken,
        status,
        creatorId,
        creator,
        fullName,
        imageUrl,
        startTime,
        endTime,
        createdAt,
        deleted,
        liveListeners,
        totalListeners,
        creatorFullName,
        creatorBio,
        creatorImageUrl,
      ];

  @override
  bool? get stringify => true;
}

extension BroadcastToDomainX on BroadcastDto {
  Broadcast get toDomain {
    return Broadcast(
      id: ID.fromString(id),
      title: SingleLineString(title),
      description: MultiLineString(description),
      status: status,
      broadcastToken: broadcastToken,
      creatorId: creatorId == null ? null : ID.fromString(creatorId!),
      creator: creator?.toDomain,
      fullName: fullName == null ? null : SingleLineString(fullName!),
      imageUrl: imageUrl,
      startTime: startTime,
      endTime: endTime,
      createdAt: createdAt,
      deleted: deleted,
      liveListeners: liveListeners,
      totalListeners: totalListeners,
      creatorFullName:
          creatorFullName == null ? null : SingleLineString(creatorFullName!),
      creatorBio: creatorBio == null ? null : MultiLineString(creatorBio!),
      creatorImageUrl: creatorImageUrl,
    );
  }
}

extension BroadcastToDtoX on Broadcast {
  BroadcastDto get toDto {
    return BroadcastDto(
      id: id.getOrCrash(),
      title: title.getOrCrash(),
      description: description.getOrCrash(),
      status: status,
      broadcastToken: broadcastToken,
      creatorId: creatorId?.getOrNull(),
      creator: creator?.toDto,
      fullName: fullName?.getOrNull(),
      imageUrl: imageUrl,
      startTime: startTime,
      endTime: endTime,
      createdAt: createdAt,
      deleted: deleted,
      liveListeners: liveListeners,
      totalListeners: totalListeners,
      creatorFullName: creatorFullName?.getOrNull(),
      creatorBio: creatorBio?.getOrNull(),
      creatorImageUrl: creatorImageUrl,
    );
  }
}
