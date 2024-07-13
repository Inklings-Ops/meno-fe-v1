import 'package:injectable/injectable.dart';

import '../../domain/domain.dart';
import '../dtos/dtos.dart';

@singleton
class BroadcastMapper {
  Participant? participantToDomain(ParticipantDto? dto) {
    if (dto == null) return null;
    return Participant(
      id: dto.id,
      fullName: dto.fullName,
      imageUrl: dto.imageUrl,
      isCreator: dto.isCreator,
      isCohost: dto.isCohost,
    );
  }

  ParticipantDto? participantToDto(Participant? domain) {
    if (domain == null) return null;
    return ParticipantDto(
      id: domain.id,
      fullName: domain.fullName,
      imageUrl: domain.imageUrl,
      isCreator: domain.isCreator,
      isCohost: domain.isCohost,
    );
  }

  Broadcast? broadcastToDomain(BroadcastDto? dto) {
    if (dto == null) return null;
    return Broadcast(
      id: dto.id,
      title: IBroadcastTitle(dto.title),
      description: IBroadcastDescription(dto.description),
      creatorId: dto.creatorId,
      creator: participantToDomain(dto.creator),
      fullName: dto.fullName,
      broadcastToken: dto.broadcastToken,
      createdAt: dto.createdAt,
      deleted: dto.deleted,
      endTime: dto.endTime,
      imageId: dto.imageId,
      imageUrl: dto.imageUrl,
      startTime: dto.startTime,
      status: dto.status,
      timeZone: dto.timeZone,
      liveListeners: dto.liveListeners,
      totalListeners: dto.totalListeners,
    );
  }

  BroadcastDto? broadcastToDto(Broadcast? domain) {
    if (domain == null) return null;
    return BroadcastDto(
      id: domain.id,
      title: domain.title.get()!,
      description: domain.description?.get(),
      creatorId: domain.creatorId,
      creator: participantToDto(domain.creator),
      fullName: domain.fullName,
      broadcastToken: domain.broadcastToken,
      createdAt: domain.createdAt,
      deleted: domain.deleted,
      endTime: domain.endTime,
      imageId: domain.imageId,
      imageUrl: domain.imageUrl,
      startTime: domain.startTime,
      status: domain.status,
      timeZone: domain.timeZone,
      liveListeners: domain.liveListeners,
      totalListeners: domain.totalListeners,
    );
  }

  JoinBroadcastEntity? joinBroadcastToDomain(JoinBroadcastDto? dto) {
    if (dto == null) return null;
    return JoinBroadcastEntity(
      broadcastToken: dto.broadcastToken,
      broadcast: broadcastToDomain(dto.broadcast)!,
    );
  }

  JoinBroadcastDto? joinBroadcastToDto(JoinBroadcastEntity? domain) {
    if (domain == null) return null;
    return JoinBroadcastDto(
      broadcastToken: domain.broadcastToken,
      broadcast: broadcastToDto(domain.broadcast)!,
    );
  }
}
