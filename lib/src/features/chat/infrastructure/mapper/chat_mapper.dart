import '../../domain/domain.dart';
import '../dtos/chat_dto.dart';

class ChatMapper {
  Chat? chatToDomain(ChatDto? dto) {
    if (dto == null) return null;
    return Chat(
      id: dto.id,
      content: IChatContent(dto.content),
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
      senderId: dto.senderId,
      broadcastId: dto.broadcastId,
    );
  }

  ChatDto? chatToDto(Chat? domain) {
    if (domain == null) return null;
    return ChatDto(
      id: domain.id,
      content: domain.content.get()!,
      createdAt: domain.createdAt,
      updatedAt: domain.updatedAt,
      senderId: domain.senderId,
      broadcastId: domain.broadcastId,
    );
  }
}
