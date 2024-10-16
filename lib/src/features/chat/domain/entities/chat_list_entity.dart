import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/chat/chat.dart';

part 'chat_list_entity.freezed.dart';

@freezed
class ChatListEntity with _$ChatListEntity {
  factory ChatListEntity({
    required List<Chat?> chatMessages,
    required int totalItems,
    required int totalPages,
    required int currentPage,
  }) = _ChatListEntity;
}
