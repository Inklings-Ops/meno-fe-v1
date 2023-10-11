import 'package:injectable/injectable.dart';

import '../../domain/domain.dart';
import '../dtos/dtos.dart';

@singleton
class BroadcastMapper {
  BroadcastCreator? broadcastCreatorToDomain(BroadcastCreatorDto? dto) {
    if (dto == null) return null;
    return BroadcastCreator(
      id: dto.id,
      fullName: dto.fullName,
      imageUrl: dto.imageUrl,
    );
  }

  BroadcastCreatorDto? broadcastCreatorToDto(BroadcastCreator? domain) {
    if (domain == null) return null;
    return BroadcastCreatorDto(
      id: domain.id,
      fullName: domain.fullName,
      imageUrl: domain.imageUrl,
    );
  }

  Broadcast? broadcastToDomain(BroadcastDto? dto) {
    if (dto == null) return null;
    return Broadcast(
      id: dto.id,
      title: IBroadcastTitle(dto.title),
      description: IBroadcastDescription(dto.description),
      creator: broadcastCreatorToDomain(dto.creator)!,
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
      creator: broadcastCreatorToDto(domain.creator)!,
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
