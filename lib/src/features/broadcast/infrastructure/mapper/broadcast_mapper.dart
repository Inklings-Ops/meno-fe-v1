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
      creator: participantToDomain(dto.creator)!,
      broadcastToken: dto.broadcastToken,
      createdAt: dto.createdAt,
      deleted: dto.deleted,
      endTime: dto.endTime,
      imageId: dto.imageId,
      imageUrl: dto.imageUrl,
      startTime: dto.startTime,
      status: dto.status,
      timeZone: dto.timeZone,
    );
  }

  BroadcastDto? broadcastToDto(Broadcast? domain) {
    if (domain == null) return null;
    return BroadcastDto(
      id: domain.id,
      title: domain.title.get()!,
      description: domain.description?.get(),
      creator: participantToDto(domain.creator)!,
      broadcastToken: domain.broadcastToken,
      createdAt: domain.createdAt,
      deleted: domain.deleted,
      endTime: domain.endTime,
      imageId: domain.imageId,
      imageUrl: domain.imageUrl,
      startTime: domain.startTime,
      status: domain.status,
      timeZone: domain.timeZone,
    );
  }

  JoinBroadcastEntity? joinBroadcastToDomain(JoinBroadcastDto? dto) {
    if (dto == null) return null;
    return JoinBroadcastEntity(broadcastToken: dto.broadcastToken);
  }

  JoinBroadcastDto? joinBroadcastToDto(JoinBroadcastEntity? domain) {
    if (domain == null) return null;
    return JoinBroadcastDto(broadcastToken: domain.broadcastToken);
  }
}
